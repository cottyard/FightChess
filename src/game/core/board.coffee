class Board
  players = ['white', 'black']

  spawn_row = {
    white: 7,
    black: 2
  }

  king_spawn_coord = {
    white: [5, 8],
    black: [5, 1]
  }

  constructor: (@is_battleground) ->
    @board = (
      (null for j in [1..8]) for i in [1..8]
    )

    @destination = (
      (null for j in [1..8]) for i in [1..8]
    )

    @spawn_cd = {
      white: 0,
      black: 0
    }
    
    @is_battleground ?= false

    if @is_battleground
      @hook()

  set_out_board: ->
    for p in players
      @place_piece (new piece.Piece p, 'king'), king_spawn_coord[p]
      @spawn p
      @spawn p
      @activate_spawn_cd p

  count_piece: (type, color) ->
    count = 0
    for [coord, p] from @all_pieces()
      if p.type is type and p.color is color
        count++
    count

  count_pieces: ->
    count = {}
    for p in players
      count[p] = 0
    for [coord, p] from @all_pieces()
      count[p.color]++
    count

  activate_spawn_cd: (color) ->
    @spawn_cd[color] = rule.spawn.spawn_cd @count_pieces()[color]

  reduce_spawn_cd: ->
    for p in players
      if @spawn_cd[p] > 0
        @spawn_cd[p]--

  all_pieces: ->
    for i in [1..8]
      for j in [1..8]
        if @is_occupied [i, j]
          yield [[i, j], @get_piece [i, j]]

  clean_up_board: ->
    for [[i, j], piece] from @all_pieces()
      @lift_piece [i, j]

  get_piece: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1]

  lift_piece: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1] = null

  place_piece: (piece, [coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1] = piece

  is_occupied: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1]?

  spawn: (color) ->
    spawn_cols = []
    row = spawn_row[color]
    for col in [1..8]
      spawn_cols.push col if not @is_occupied [col, row]
    return false unless spawn_cols.length > 0
    @place_piece (new piece.Piece color, 'pawn'), 
                 [spawn_cols[(calc.randint [0, spawn_cols.length - 1])], row]
    true

  is_battleground: ->
    @is_battleground

  clone: ->
    brd = new Board()
    for [coord, piece] from @all_pieces()
      brd.place_piece piece.clone(), coord
    brd

  hook: ->
    ev.hook 'assist_round_begin', @on_assist_round_begin
    ev.hook 'assist_round_end', @on_assist_round_end
    ev.hook 'attack_round_begin', @on_attack_round_begin
    ev.hook 'attack_round_end', @on_attack_round_end
    ev.hook 'recover_round', @on_recover_round
    ev.hook 'move_round_end', @on_move_round_end

  unhook: ->
    ev.unhook 'assist_round_begin', @on_assist_round_begin
    ev.unhook 'assist_round_end', @on_assist_round_end
    ev.unhook 'attack_round_begin', @on_attack_round_begin
    ev.unhook 'attack_round_end', @on_attack_round_end
    ev.unhook 'recover_round', @on_recover_round
    ev.unhook 'move_round_end', @on_move_round_end

  on_assist_round_begin: =>
    for [coord, p] from @all_pieces()
      p.reset_assisted_abilities()
      moves = rule.move.valid_moves p.type, p.color, coord, this
      for def_coord in moves.defensive
        astee = @get_piece def_coord
        ev.trigger 'battle_assist', {
          aster: p, 
          astee: astee,
          coord_from: coord, 
          coord_to: def_coord,
          assistance: p.assistance,
          heal: p.heal
        }

  on_assist_round_end: =>
    for [coord, p] from @all_pieces()
      p.adjust_shield()

  on_attack_round_begin: =>
    for [coord, p] from @all_pieces()
      if p.attack_cd_ticks > 0
        continue
      moves = rule.move.valid_moves p.type, p.color, coord, this
      if moves.offensive.length is 0
        continue
      for atk_coord in moves.offensive
        target = @get_piece atk_coord
        ev.trigger 'battle_attack', {
          atker: p, 
          atkee: target,
          coord_from: coord, 
          coord_to: atk_coord,
          damage: p.attack
        }
      p.activate_attack_cd()

  on_attack_round_end: =>
    for [coord, p] from @all_pieces()
      if p.is_dead()
        @lift_piece coord
        ev.trigger 'piece_die', {
          piece: p,
          coord: coord
        }
      else
        p.reduce_attack_cd()

  on_recover_round: =>
    for [coord, p] from @all_pieces()
      p.recover_shield()
      p.recover_hp()
      p.reduce_move_cd()

  on_move_round_end: =>
    @reduce_spawn_cd()
    for p in players
      if @spawn_cd[p] is 0
        count = @count_pieces()[p]
        continue if count >= 16 
        if @spawn p
          @activate_spawn_cd p

  get_valid_regular_moves: (coord) ->
    return rule.move.empty_moves unless @is_occupied coord
    p = @get_piece coord
    return rule.move.empty_moves unless p.can_move()
    return (rule.move.valid_moves p.type, p.color, coord, this).regular

  get_moves: (coord) ->
    return rule.move.empty_moves unless @is_occupied coord
    p = @get_piece coord
    return rule.move.valid_moves p.type, p.color, coord, this

  move_to: (from_coord, to_coord) ->
    return unless @is_occupied from_coord
    return if @is_occupied to_coord

    p = @get_piece from_coord
    @place_piece p, to_coord
    @lift_piece from_coord

    p.activate_move_cd()
    
    try_promoting p, to_coord
    try_transforming p, to_coord

  get_destination: (coord) ->
    null

try_promoting = (piece, coord) ->
  return unless piece.type is 'pawn'
  if (piece.color is 'white' and coord[1] is 1) or
     (piece.color is 'black' and coord[1] is 8)
    piece.change_type 'super_pawn'
    piece.activate_move_cd()

transform_column = ['rook', 'knight', 'bishop', 'queen', 'cannon', 'bishop', 'knight', 'rook']
try_transforming = (piece, coord) ->
  return unless piece.type is 'super_pawn'
  if (piece.color is 'white' and coord[1] is 8) or
     (piece.color is 'black' and coord[1] is 1)
    piece.change_type transform_column[coord[0] - 1]
    piece.activate_move_cd()

serialize = (board) ->
  serialized_pieces = []
  for [coord, p] from board.all_pieces()
    serialized_pieces.push piece.serialize p, coord
  buffer = new ArrayBuffer(serialized_pieces.length * piece.serialization_size + 4)
  p = 0
  for sp in serialized_pieces
    calc.write_buf_to_buf sp, buffer, 0, p, piece.serialization_size
    p += piece.serialization_size
  calc.write_to_buffer buffer, p, board.spawn_cd['white']
  calc.write_to_buffer buffer, p + 2, board.spawn_cd['black']
  buffer

deserialize = (buffer, board) ->
  board.clean_up_board()
  piece_count = (buffer.byteLength - 4) / piece.serialization_size
  for i in [0...piece_count]
    sp = new ArrayBuffer piece.serialization_size
    calc.write_buf_to_buf buffer, sp, i * piece.serialization_size, 0, piece.serialization_size
    [p, coord] = piece.deserialize sp
    board.place_piece p, coord
  board.spawn_cd['white'] = calc.read_from_buffer buffer, buffer.byteLength - 4
  board.spawn_cd['black'] = calc.read_from_buffer buffer, buffer.byteLength - 2

window.board = {
  Board,
  serialize,
  deserialize
}
