cvs_border_width = 3
cvs_size = 400

cvs = null
ctx = null

cvs_background = null
ctx_background = null

cvs_bounding_rect = null

draw_board = (ctx, size) ->
  grid_len = size  / 8
  ctx.save()
  util.set_style ctx, util.style_brown
  for x in [0...size ] by grid_len
    for y in [0...size ] by grid_len
      if (x + y) / grid_len % 2 isnt 0
        util.rectangle ctx, x, y, grid_len, grid_len, yes
  ctx.restore()

set_canvas_attr = (cvs, z_index, size) ->
  cvs.style.border = "solid #000 #{cvs_border_width}px"
  cvs.style.position = "absolute"
  cvs.style.left = "10px"
  cvs.style.top = "10px"
  cvs.style['z-index'] = "#{z_index}"
  cvs.width = cvs.height = size

start = ->
  cvs = document.getElementById 'cream'
  cvs_background = document.getElementById 'board'
  
  set_canvas_attr cvs_background, 1, cvs_size
  set_canvas_attr cvs, 2, cvs_size
  
  ctx_background = cvs_background .getContext '2d'
  draw_board ctx_background, cvs_size

  ctx = cvs.getContext '2d'
  cvs_bounding_rect = cvs.getBoundingClientRect()

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