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

  clean_up_board: ->
    for i in [1..8]
      for j in [1..8]
        if @is_occupied [i, j]
          @get_piece([i, j])
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
    @place_piece new piece.Piece color, 'pawn', [(calc.randint [1, 8]), spawn_row[color]]

  is_battleground: ->
    @is_battleground

  clone: ->
    brd = new Board()
    for i in [1..8]
      for j in [1..8]
        if @is_occupied [i, j]
          brd.place_piece (@get_piece [i, j]).clone()
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
    @shield_total = @shield_total_born
    @shield_heal = @shield_heal_born
    for coord in @valid_moves().defensive
      astee = board.instance.get_piece coord
      ev.trigger 'battle_assist', {
        aster: @, 
        astee: astee,
        coord_from: @coordinate, 
        coord_to: coord,
        enhancement: @assistance
      }

  on_assist_round_end: =>
    if @shield > @shield_total
      @shield = @shield_total

  on_attack_round_begin: =>
    return if @attack_cd_ticks > 0 or @valid_moves().offensive.length is 0
    for coord in @valid_moves().offensive
      target = board.instance.get_piece coord
      ev.trigger 'battle_attack', {
        atker: @, 
        atkee: target,
        coord_from: @coordinate, 
        coord_to: coord,
        damage: calc.randint @attack
      }
    @attack_cd_ticks = @attack_cd

  on_attack_round_end: =>
    if @attack_cd_ticks > 0
      @attack_cd_ticks--

  on_recover_round: =>
    @shield += @shield_heal
    if @shield > @shield_total
      @shield = @shield_total
    @move_cd_ticks-- if @move_cd_ticks > 0



##################################################


      # ev.trigger 'piece_hurt', {
      #   piece: @, 
      #   coord: @coordinate
      # }

move_to: (new_coord) ->
  board.instance.lift_piece @coordinate if @is_onboard()
  @coordinate = new_coord
  board.instance.place_piece @
  @move_cd_ticks = @move_cd
  if @type is 'pawn'
    @try_promoting()
  if @type is 'super_pawn'
    @try_transforming()

can_move: ->
  @move_cd_ticks is 0

try_promoting: (coord) ->
  if (@color is 'white' and @coordinate[1] is 1) or
     (@color is 'black' and @coordinate[1] is 8)
    @type = 'super_pawn'
    @retrieve_basic_info()
    @initialize_state_info()
    @move_cd_ticks = @move_cd

transform_column = ['rook', 'knight', 'bishop', 'queen', 'queen', 'bishop', 'knight', 'rook']
try_transforming: (coord) ->
  if (@color is 'white' and @coordinate[1] is 8) or
     (@color is 'black' and @coordinate[1] is 1)
    @type = transform_column[@coordinate[0] - 1]
    @retrieve_basic_info()
    @initialize_state_info()
    @move_cd_ticks = @move_cd

valid_moves: (board_instance = board.instance)->
  rule.move.strategies[@type] @color, @coordinate, board_instance

die: ->
  return unless @is_onboard()
  board.instance.lift_piece @coordinate
  @coordinate = null
  @unhook_actions()
  ev.trigger 'piece_die', {
    piece: @,
    coord: @coordinate
  }