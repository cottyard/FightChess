cvs_border_width = 3
cvs_size = 400
grid_size = cvs_size / 8

cvs = null
ctx = null

cvs_background = null
ctx_background = null

cvs_bounding_rect = null

draw_board = (ctx, size) ->
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
  cvs.style['z-index'] = "#{z_index}"
  cvs.width = cvs.height = size

piece =
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

piece_arrangement = [
  'rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook'
]

coord_to_pos = (x, y) ->
  console.log x, y
  pos_x = grid_size * (x - 1) + 5
  pos_y = grid_size * (y - 1) + 40
  console.log pos_x, pos_y
  [pos_x, pos_y]

draw_piece = (piece, coord_x, coord_y) ->
  [pos_x, pos_y] = coord_to_pos coord_x, coord_y
  util.text ctx, piece, pos_x, pos_y

draw_pieces = ->
  for x in [1..8]
    draw_piece piece.white.pawn, x, 7
    draw_piece piece.white[piece_arrangement[x - 1]], x, 8
  
  for x in [1..8]
    draw_piece piece.black.pawn, x, 2
    draw_piece piece.black[piece_arrangement[x - 1]], x, 1
    
start = ->
  cvs = document.getElementById 'cream'
  ctx = cvs.getContext '2d'
  cvs_bounding_rect = cvs.getBoundingClientRect()
  
  cvs_background = document.getElementById 'board'
  ctx_background = cvs_background.getContext '2d'
  
  set_canvas_attr cvs_background, 1, cvs_size
  set_canvas_attr cvs, 2, cvs_size
  
  ctx.font = "40px Courier New"
    
  draw_board ctx_background, cvs_size
  draw_pieces()
  

  cvs.addEventListener "mousedown", on_mousedown, false
  cvs.addEventListener "mouseup", on_mouseup, false
  cvs.addEventListener "mousemove", on_mousemove, false
  

get_mouse_pos = (evt) ->
  mouse_x = evt.clientX - cvs_bounding_rect.left - cvs_border_width
  mouse_y = evt.clientY - cvs_bounding_rect.top - cvs_border_width
  [mouse_x, mouse_y]

down_pos = []
drawing = no

on_mousedown = (evt) ->
  down_pos = get_mouse_pos evt
  drawing = yes
  
on_mouseup = (evt) ->
  drawing = no
  util.clear_canvas ctx, cvs
  pos = get_mouse_pos evt
  util.set_style ctx_background, util.style_red_tp
  util.arrow ctx_background, down_pos[0], down_pos[1], pos[0], pos[1]
  
on_mousemove = (evt) ->
  return unless drawing
  util.clear_canvas ctx, cvs
  pos = get_mouse_pos evt
  util.arrow ctx, down_pos[0], down_pos[1], pos[0], pos[1]

window.board = {
  start
}