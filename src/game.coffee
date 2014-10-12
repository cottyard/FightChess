# queue of user operation

queue = []

handle_operation_queue = ->
  while queue.length > 0
    handle_operation(queue.shift())

handle_operation = (op_evt) ->
  # need some validation on the operation
  op_evt.piece.move_to op_evt.coord_to

on_gametick = (evt) ->
  # handle game operations in queue
  handle_operation_queue()
  # trigger 'fight'
  ev.trigger 'render', {}
  
on_render = (evt) ->
  shape.clear_canvas ui.ctx.static
  paint.board ui.ctx.static

on_game_operations = (evt) ->
  queue.push evt

init = ->
  ev.hook 'gametick', on_gametick
  ev.hook 'render', on_render
  ev.hook 'op_movepiece', on_game_operations

next_tick = ->
  ev.trigger 'gametick', {}

start = ->
  setInterval next_tick, 100

window.game = {
  init,
  start
}