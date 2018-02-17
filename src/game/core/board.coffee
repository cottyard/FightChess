class Board
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

    @is_battle_board ?= false

    if @is_battleground
      @hook

  set_out_board: ->
    w = 'white'
    b = 'black'
    @place_piece new piece.Piece w, 'king', king_spawn_coord[w], this
    @place_piece new piece.Piece b, 'king', king_spawn_coord[b], this
    @spawn w
    @spawn w
    @spawn w
    @spawn b
    @spawn b
    @spawn b

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
    @place_piece (new piece.Piece color, 'pawn'), 
                 [(calc.randint [1, 8]), spawn_row[color]]

  is_battleground: ->
    @is_battleground

  clone: ->
    brd = new Board()
    for [[i, j], piece] from @all_pieces()
      brd.place_piece piece.clone()
    brd

  @hook: ->
    ev.hook 'assist_round_begin', @on_assist_round_begin
    ev.hook 'assist_round_end', @on_assist_round_end
    ev.hook 'attack_round_begin', @on_attack_round_begin
    ev.hook 'attack_round_end', @on_attack_round_end
    ev.hook 'recover_round', @on_recover_round

  @unhook: ->
    ev.unhook 'assist_round_begin', @on_assist_round_begin
    ev.unhook 'assist_round_end', @on_assist_round_end
    ev.unhook 'attack_round_begin', @on_attack_round_begin
    ev.unhook 'attack_round_end', @on_attack_round_end
    ev.unhook 'recover_round', @on_recover_round

  on_assist_round_begin: =>
    for [coord, p] from all_pieces()
      p.shield_total = p.shield_total_born
      p.shield_heal = p.shield_heal_born
      moves = rule.move.valid_moves p.type, p.color, coord, this
      for def_coord in moves.defensive
        astee = get_piece def_coord
        ev.trigger 'battle_assist', {
          aster: p, 
          astee: astee,
          coord_from: coord, 
          coord_to: def_coord,
          enhancement: p.assistance
        }

  on_assist_round_end: =>
    for [coord, p] from all_pieces()
      p.adjust_shield()

  on_attack_round_begin: =>
    for [coord, p] from all_pieces()
      if p.attack_cd_ticks > 0
        continue
      moves = rule.move.valid_moves p.type, p.color, coord, this
      if moves.offensive.length is 0
        continue
      for atk_coord in moves.offensive
        target = get_piece atk_coord
        ev.trigger 'battle_attack', {
          atker: p, 
          atkee: target,
          coord_from: coord, 
          coord_to: atk_coord,
          damage: p.attack
        }
      p.activate_attack_cd()

  on_attack_round_end: =>
    for [coord, p] from all_pieces()
      p.reduce_attack_cd()

  on_recover_round: =>
    for [coord, p] from all_pieces()
      p.recover_shield()
      p.reduce_move_cd()

  move_to: (from_coord, to_coord) ->
    if not @is_occupied from_coord
      return

    p = @get_piece from_coord
    @place_piece p, to_coord
    @lift_piece from_coord

    p.activate_move_cd()
    
    try_promoting p, to_coord
    try_transforming p, to_coord

##################################################

      # ev.trigger 'piece_hurt', {
      #   piece: @, 
      #   coord: @coordinate
      # }

# can_move: ->
#   @move_cd_ticks is 0

try_promoting: (piece, coord) ->
  if p.type is not 'pawn'
    return
  if (p.color is 'white' and coord[1] is 1) or
     (p.color is 'black' and coord[1] is 8)
    p.change_type 'super_pawn'
    p.activate_move_cd()

transform_column = ['rook', 'knight', 'bishop', 'queen', 'queen', 'bishop', 'knight', 'rook']
try_transforming: (piece, coord) ->
  if p.type is not 'super_pawn'
    return
  if (@color is 'white' and coord[1] is 8) or
     (@color is 'black' and coord[1] is 1)
    p.change_type transform_column[coord[0] - 1]
    p.activate_move_cd()

# die: ->
#   return unless @is_onboard()
#   board.instance.lift_piece @coordinate
#   @coordinate = null
#   @unhook_actions()
#   ev.trigger 'piece_die', {
#     piece: @,
#     coord: @coordinate
#   }

window.board = {
  Board
}
