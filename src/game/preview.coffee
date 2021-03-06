# piece move preview

previewing = no
previewing_piece = null
previewing_coord = [-1, -1]
previewing_dropping_coord = [-1, -1]
previewing_color = null

preview_condition = ->
  battleground.instance.is_occupied(previewing_coord) and
  battleground.instance.get_piece(previewing_coord).equals previewing_piece

preview = (evt) ->
  if not preview_condition()
    abort_preview()
    return
  paint.mark_grid ui.ctx.static, previewing_coord 
  moves = battleground.instance.get_moves previewing_coord
  for mr in moves.regular
    paint.mark_grid ui.ctx.static, mr, shape.style_green_tp
  for mo in moves.offensive
    paint.mark_grid ui.ctx.static, mo, shape.style_red_tp
  for mo in moves.defensive
    paint.mark_grid ui.ctx.static, mo, shape.style_blue_tp
  destination_coord = battleground.instance.get_destination previewing_coord
  if destination_coord?
    paint.mark_destination ui.ctx.static, previewing_coord, destination_coord
  unless calc.coord_equal previewing_dropping_coord, previewing_coord
    paint.mark_grid ui.ctx.static, previewing_dropping_coord, shape.style_dark_green

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
  if not preview_condition()
    return
  shape.clear_canvas ui.ctx.animate
  shape.set_style ui.ctx.animate, shape.style_tp
  if last_mouse_position?
    paint.piece_at_pos ui.ctx.animate, previewing_piece, last_mouse_position 
  ui.cvs.animate.style.cursor = "pointer"

# view piece info

view_info_coord = [1, 1]

view_info = (evt) ->
  cursor = "auto"
  if battleground.instance.is_occupied view_info_coord
    ui.info.value = battleground.instance.get_piece(view_info_coord).info()
    if pick_condition.check view_info_coord
      cursor = "pointer"
  else
    ui.info.value = ''
  ui.cvs.animate.style.cursor = cursor

# view game status

view_spawntime = ->
  #return unless previewing_color?
  msg = []
  for p in ['white', 'black']
    ticks = battleground.instance.spawn_cd[p]
    secs = (ticks - 1) // 10 + 1
    msg.push "#{p} spawns: #{secs} secs"
  ui.spawntime.value = msg.join '\n'

# input operation handlers

default_pick_condition = (coord) -> 
  battleground.instance.is_occupied(coord) and 
  battleground.instance.get_piece(coord).can_move()

get_pick_condition = (color) ->
  (coord) ->
    default_pick_condition(coord) and
    battleground.instance.get_piece(coord).color is color

pick_condition = 
  check: default_pick_condition

set_color = (color) ->
  if not color?
    pick_condition = default_pick_condition
  else
    pick_condition.check = get_pick_condition color
    previewing_color = color

disable = () ->
  pick_condition =
    check: (coord) -> false

on_pick = (evt) ->
  return unless pick_condition.check evt.coord
  previewing_piece = battleground.instance.get_piece evt.coord
  previewing_coord = evt.coord
  launch_preview()

on_drop = (evt) ->
  return unless previewing
  moves = battleground.instance.get_valid_regular_moves previewing_coord
  if calc.coord_one_of evt.coord, moves
    ev.trigger 'op_movepiece', {
      piece: previewing_piece, 
      coord_from: previewing_coord, 
      coord_to: evt.coord
    }
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
  if previewing
    previewing_dropping_coord = calc.pos_to_coord evt.pos
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
  ev.hook 'render', view_spawntime

window.preview = {
  init,
  set_color,
  disable
}