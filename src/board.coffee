cvs_animate = null
ctx_animate = null

cvs_static = null
ctx_static = null

cvs_background = null
ctx_background = null

cvs_bounding_rect = null

textarea = null

# chess board

chess_board = null

class Board
  constructor: ->
    @board = (
      (null for j in [1..8]) for i in [1..8]
    )

  is_occupied: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1]?

  get_piece: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1]

  lift_piece: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1] = null

  place_piece: (piece) ->
    [coord_x, coord_y] = piece.coordinate
    @board[coord_x - 1][coord_y - 1] = piece

# chess piece

piece_arrangement = ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook']

class Piece
  constructor: (@color, @type, @coordinate, @board) ->

  move_to: (new_coord) ->
    @board.lift_piece @coordinate if @is_onboard()
    @coordinate = new_coord
    @board.place_piece @ if new_coord?

  is_onboard: ->
    @coordinate?


# canvas

set_canvas_attr = (cvs, z_index, size) ->
  cvs.style.border = "solid #000 #{settings.cvs_border_width }px"
  cvs.style.position = "absolute"
  cvs.style.cursor = "pointer"
  cvs.style['z-index'] = "#{z_index}"

  cvs.width = cvs.height = size

init_all_canvas = ->
  cvs_background = document.getElementById 'background'
  ctx_background = cvs_background.getContext '2d'

  cvs_static = document.getElementById 'static'
  ctx_static = cvs_static.getContext '2d'

  cvs_animate = document.getElementById 'animate'
  ctx_animate = cvs_animate.getContext '2d'

  cvs_bounding_rect = cvs_animate.getBoundingClientRect()
  
  set_canvas_attr cvs_background, 1, settings.cvs_size
  set_canvas_attr cvs_static, 2, settings.cvs_size
  set_canvas_attr cvs_animate, 3, settings.cvs_size

  ctx_static.font = settings.piece_font
  ctx_animate.font = settings.piece_font
  
  paint.background ctx_background, settings.cvs_size

# mouse

get_mouse_pos = (evt) ->
  mouse_x = evt.clientX - cvs_bounding_rect.left - settings.cvs_border_width 
  mouse_y = evt.clientY - cvs_bounding_rect.top - settings.cvs_border_width 
  [mouse_x, mouse_y]

get_coordinate = (evt) ->
  calc.pos_to_coord get_mouse_pos evt

picking_piece = null

on_mousedown = (evt) ->
  return if picking_piece
  coord = get_coordinate evt
  picking_piece = chess_board.get_piece coord
  [pos_x, pos_y] = get_mouse_pos evt

on_mouseup = (evt) ->
  return unless picking_piece
  coord = get_coordinate evt
  picking_piece.move_to coord
  picking_piece = null
  draw_all_pieces ctx_static
  shape.clear_canvas ctx_animate

on_mousemove = (evt) ->
  coord = calc.pos_to_coord get_mouse_pos evt
  textarea.value = "#{coord}"
  return unless picking_piece
  shape.clear_canvas ctx_animate
  shape.set_style ctx_animate, shape.style_tp
  paint.piece_at ctx_animate, picking_piece, get_mouse_pos evt

# api

draw_all_pieces = (ctx) ->
  shape.clear_canvas ctx_static
  for i in [1..8]
      for j in [1..8]
        continue unless chess_board.is_occupied [i, j]
        paint.piece ctx, chess_board.get_piece [i, j]

start = ->
  init_all_canvas()
  chess_board = new Board()

  for x in [1..8]
    chess_board.place_piece new Piece 'white', 'pawn', [x, 7], chess_board
    chess_board.place_piece new Piece 'white', piece_arrangement[x - 1], [x, 8], chess_board
  
  for x in [1..8]
    chess_board.place_piece new Piece 'black', 'pawn', [x, 2], chess_board
    chess_board.place_piece new Piece 'black', piece_arrangement[x - 1], [x, 1], chess_board

  draw_all_pieces ctx_static

  textarea = document.getElementById 'mousepos'

  cvs_animate.addEventListener "mousedown", on_mousedown, false
  cvs_animate.addEventListener "mouseup", on_mouseup, false
  cvs_animate.addEventListener "mousemove", on_mousemove, false


window.board = {
  start
}