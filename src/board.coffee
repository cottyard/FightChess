class Board
  piece_arrangement = ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook']
  constructor: ->
    @board = (
      (null for j in [1..8]) for i in [1..8]
    )
    
    for x in [1..8]
      @place_piece new piece.Piece 'white', 'pawn', [x, 7], @
      @place_piece new piece.Piece 'white', piece_arrangement[x - 1], [x, 8], @

    for x in [1..8]
      @place_piece new piece.Piece 'black', 'pawn', [x, 2], @
      @place_piece new piece.Piece 'black', piece_arrangement[x - 1], [x, 1], @

  is_occupied: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1]?

  get_piece: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1]

  lift_piece: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1] = null

  place_piece: (piece) ->
    [coord_x, coord_y] = piece.coordinate
    @board[coord_x - 1][coord_y - 1] = piece

paint_pieces_on_board = (ctx) ->
  shape.clear_canvas ctx
  for i in [1..8]
    for j in [1..8]
      continue unless board.chess_board.is_occupied [i, j]
      paint.piece ctx, board.chess_board.get_piece [i, j]

picking_piece = null

on_pick = (evt) ->
  return unless board.chess_board.is_occupied evt.coord
  picking_piece = board.chess_board.get_piece evt.coord
  paint.mark_grid game.ctx.static, evt.coord
  moves = picking_piece.valid_moves()
  for mr in moves.regular
    paint.mark_grid game.ctx.static, mr, shape.style_green_tp
  for mo in moves.offensive
    paint.mark_grid game.ctx.static, mo, shape.style_red_tp

on_drop = (evt) ->
  moves = picking_piece.valid_moves()
  if calc.coord_one_of(evt.coord, moves.regular) or calc.coord_one_of(evt.coord, moves.offensive)
    picking_piece.move_to evt.coord
  picking_piece = null
  paint_pieces_on_board game.ctx.static
  shape.clear_canvas game.ctx.animate

on_hover = (evt) ->
  game.textarea.value = "#{evt.coord}"
  if picking_piece or board.chess_board.is_occupied evt.coord
    game.cvs.animate.style.cursor = "pointer"
  else
    game.cvs.animate.style.cursor = "default"

on_mousedown = (evt) ->
  coord = calc.pos_to_coord evt.pos
  ev.trigger 'pick', {coord}

on_mouseup = (evt) ->
  return unless picking_piece
  coord = calc.pos_to_coord evt.pos
  ev.trigger 'drop', {coord}

hovering_coord = [-1, -1]

on_mousemove = (evt) ->
  coord = calc.pos_to_coord evt.pos
  ev.trigger 'hover', {coord} unless calc.coord_equal hovering_coord, coord
  hovering_coord = coord

  return unless picking_piece
  shape.clear_canvas game.ctx.animate
  shape.set_style game.ctx.animate, shape.style_tp
  paint.piece_at game.ctx.animate, picking_piece, evt.pos

init = ->
  board.chess_board = new Board()
  paint_pieces_on_board game.ctx.static
  
  ev.hook 'mousedown', on_mousedown
  ev.hook 'mouseup', on_mouseup
  ev.hook 'mousemove', on_mousemove
  ev.hook 'pick', on_pick
  ev.hook 'drop', on_drop
  ev.hook 'hover', on_hover

window.board = {
  init,
  chess_board: null,
  paint_pieces_on_board
}