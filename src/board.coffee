# game constants

cvs_border_width = 3
cvs_size = 400
grid_size = cvs_size / 8
piece_font = "40px Courier New"

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

draw_background = (ctx, size) ->
  ctx.save()
  util.set_style ctx, util.style_brown
  for x in [0...size ] by grid_size
    for y in [0...size ] by grid_size
      if (x + y) / grid_size % 2 isnt 0
        util.rectangle ctx, x, y, grid_size, grid_size, yes
  ctx.restore()

set_canvas_attr = (cvs, z_index, size) ->
  cvs.style.border = "solid #000 #{cvs_border_width}px"
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
  
  set_canvas_attr cvs_background, 1, cvs_size
  set_canvas_attr cvs_static, 2, cvs_size
  set_canvas_attr cvs_animate, 3, cvs_size

  ctx_static.font = piece_font
  ctx_animate.font = piece_font
  
  draw_background ctx_background, cvs_size

# location

hoop = (num, [range_lower, range_upper]) ->
  num = range_lower if num < range_lower
  num = range_upper if num > range_upper
  num

coord_to_pos = ([x, y]) ->
  pos_x = grid_size * (x - 0.5)
  pos_y = grid_size * (y - 0.5)
  [pos_x, pos_y]

pos_to_coord = ([x, y]) ->
  coord_x = hoop x // grid_size + 1, [1, 8]
  coord_y = hoop y // grid_size + 1, [1, 8]
  [coord_x, coord_y]

# drawing pieces

piece_drawing_types =
  black:
    pawn: '\u265F'
    knight: '\u265E'
    bishop: '\u265D'
    rook: '\u265C'
    queen: '\u265B'
    king: '\u265A'
  white:
    pawn: '\u2659'
    knight: '\u2658'
    bishop: '\u2657'
    rook: '\u2656'
    queen: '\u2655'
    king: '\u2654'

draw_piece = (ctx, piece) ->
  [pos_x, pos_y] = coord_to_pos piece.coordinate
  color = piece.color
  type = piece.type

  util.text ctx, piece_drawing_types[color][type], pos_x - grid_size / 2 + 5, pos_y - grid_size / 2 + 40

draw_all_pieces = (ctx) ->
  util.clear_canvas ctx_static
  for i in [1..8]
      for j in [1..8]
        continue unless chess_board.is_occupied [i, j]
        draw_piece ctx, chess_board.get_piece [i, j]

# mouse

get_mouse_pos = (evt) ->
  mouse_x = evt.clientX - cvs_bounding_rect.left - cvs_border_width
  mouse_y = evt.clientY - cvs_bounding_rect.top - cvs_border_width
  [mouse_x, mouse_y]

get_coordinate = (evt) ->
  pos_to_coord get_mouse_pos evt

picking_piece = null

on_mousedown = (evt) ->
  coord = get_coordinate evt
  picking_piece = chess_board.get_piece coord

on_mouseup = (evt) ->
  return unless picking_piece
  coord = get_coordinate evt
  picking_piece.move_to coord
  picking_piece = null
  draw_all_pieces ctx_static

on_mousemove = (evt) ->
  coord = pos_to_coord get_mouse_pos evt
  textarea.value = "#{coord}"

# api

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