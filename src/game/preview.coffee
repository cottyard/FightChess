# piece move preview

previewing = no
previewing_piece = null
previewing_coord = [-1, -1]

in_previewing_condition = ->
  board.instance.is_occupied(previewing_coord) and
  piece.piece_equal board.instance.get_piece(previewing_coord), previewing_piece

preview = (evt) ->
  if not in_previewing_condition()
    abort_preview()
    return
  paint.mark_grid ui.ctx.static, previewing_coord 
  moves = previewing_piece.valid_moves()
  for mr in moves.regular
    paint.mark_grid ui.ctx.static, mr, shape.style_green_tp
  for mo in moves.offensive
    paint.mark_grid ui.ctx.static, mo, shape.style_red_tp
  for mo in moves.defensive
    paint.mark_grid ui.ctx.static, mo, shape.style_blue_tp

abort_preview = ->
  ev.unhook 'render', preview
  ev.unhook 'render', paint_previewing_piece
  ev.unhook 'mousemove', paint_previewing_piece
  shape.clear_canvas ui.ctx.animate
  previewing = no

launch_preview = ->
  ev.hook 'render', preview
  ev.hook 'render', paint_previewing_piece
  ev.hook 'mousemove', paint_previewing_piece
  previewing = yes

last_mouse_position = null

update_mouse_position = (evt) ->
  last_mouse_position = evt.pos

paint_previewing_piece = (evt) ->
  if not in_previewing_condition()
    return
  shape.clear_canvas ui.ctx.animate
  shape.set_style ui.ctx.animate, shape.style_tp
  paint.piece_at ui.ctx.animate, previewing_piece, last_mouse_position 
  ui.cvs.animate.style.cursor = "pointer"

# view piece info

view_info_coord = [1, 1]

view_info = (evt) ->
  cursor = "auto"
  if board.instance.is_occupied view_info_coord
    ui.info.value = board.instance.get_piece(view_info_coord).info()
    if board.instance.get_piece(view_info_coord).can_move()
      cursor = "pointer"
  else
    ui.info.value = ''
  ui.cvs.animate.style.cursor = cursor

# input operation handlers

on_pick = (evt) ->
  return unless board.instance.is_occupied(evt.coord) and 
                board.instance.get_piece(evt.coord).can_move()
  previewing_piece = board.instance.get_piece evt.coord
  previewing_coord = evt.coord
  launch_preview()

on_drop = (evt) ->
  return unless previewing
  moves = previewing_piece.valid_moves().regular
  if calc.coord_one_of(evt.coord, moves)
    ev.trigger 'op_movepiece', {piece: previewing_piece, coord_to: evt.coord}
  abort_preview()

on_hover = (evt) ->
  view_info_coord = evt.coord

# raw input handlers, raw input -> input operation

on_mousedown = (evt) ->
  coord = calc.pos_to_coord evt.pos
  ev.trigger 'pick', {coord}

on_mouseup = (evt) ->
  coord = calc.pos_to_coord evt.pos
  ev.trigger 'drop', {coord}

hovering_coord = [-1, -1]

on_mousemove = (evt) ->
  coord = calc.pos_to_coord evt.pos
  ev.trigger 'hover', {coord} unless calc.coord_equal hovering_coord, coord
  hovering_coord = coord

init = ->
  ev.hook 'mousedown', on_mousedown
  ev.hook 'mouseup', on_mouseup
  ev.hook 'mousemove', on_mousemove
  ev.hook 'mousemove', update_mouse_position
  ev.hook 'pick', on_pick
  ev.hook 'drop', on_drop
  ev.hook 'hover', on_hover
  
  ev.hook 'render', view_info

window.preview = {
  init
}