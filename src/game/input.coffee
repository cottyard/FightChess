get_mouse_pos = (evt) ->
  mouse_x = evt.clientX - ui.cvs_bounding_rect().left - settings.cvs_border_width 
  mouse_y = evt.clientY - ui.cvs_bounding_rect().top - settings.cvs_border_width 
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
  ui.cvs.animate.addEventListener "mousedown", on_user_mousedown
  ui.cvs.animate.addEventListener "mouseup", on_user_mouseup
  ui.cvs.animate.addEventListener "mousemove", on_user_mousemove

  ui.cvs.animate.addEventListener "touchstart", on_touch
  ui.cvs.animate.addEventListener "touchmove", on_touch
  ui.cvs.animate.addEventListener "touchend", on_touch
  #ui.cvs.animate.addEventListener "touchcancel", on_touch

on_touch = (evt) ->
  touches = evt.changedTouches
  first = touches[0]
  type = ""

  switch evt.type
    when "touchstart"
      type = "mousedown"
    when "touchmove"
      type = "mousemove"    
    when "touchend"
      type = "mouseup"

    # initMouseEvent(type, canBubble, cancelable, view, clickCount, 
    #                screenX, screenY, clientX, clientY, ctrlKey, 
    #                altKey, shiftKey, metaKey, button, relatedTarget);

  simulated = document.createEvent "MouseEvent"
  simulated.initMouseEvent \
    type, true, true, window, 1, \
    first.screenX, first.screenY, \
    first.clientX, first.clientY, false, \
    false, false, false, 0, null

  first.target.dispatchEvent simulated
  evt.preventDefault()

window.input = {
  init
}