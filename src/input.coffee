get_mouse_pos = (evt) ->
  mouse_x = evt.clientX - ui.cvs_bounding_rect.left - settings.cvs_border_width 
  mouse_y = evt.clientY - ui.cvs_bounding_rect.top - settings.cvs_border_width 
  [mouse_x, mouse_y]

on_user_mousedown = (evt) ->
  pos = get_mouse_pos evt
  ev.trigger 'mousedown', {pos}

on_user_mouseup = (evt) ->
  pos = get_mouse_pos evt
  ev.trigger 'mouseup', {pos}

on_user_mousemove = (evt) ->
  pos = get_mouse_pos evt
  ev.trigger 'mousemove', {pos}

init = ->
  ui.cvs.animate.addEventListener "mousedown", on_user_mousedown, false
  ui.cvs.animate.addEventListener "mouseup", on_user_mouseup, false
  ui.cvs.animate.addEventListener "mousemove", on_user_mousemove, false

window.input = {
  init
}