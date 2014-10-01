get_mouse_pos = (evt) ->
  mouse_x = evt.clientX - game.cvs_bounding_rect.left - settings.cvs_border_width 
  mouse_y = evt.clientY - game.cvs_bounding_rect.top - settings.cvs_border_width 
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
  game.cvs.animate.addEventListener "mousedown", on_user_mousedown, false
  game.cvs.animate.addEventListener "mouseup", on_user_mouseup, false
  game.cvs.animate.addEventListener "mousemove", on_user_mousemove, false

window.input = {
  init
}