# queue of user operation

operation_queue = []

handle_operation_queue = ->
  while operation_queue.length > 0
    handle_operation(operation_queue.shift())

handle_operation = (op_evt) ->
  # need some validation on the operation
  # and convert the operations to battle_move evt??
  op_evt.piece.move_to op_evt.coord_to

on_gametick = (evt) ->
  ev.trigger 'move_round', {}
  ev.trigger 'move_round_end', {}
  ev.trigger 'assist_round_begin', {}
  ev.trigger 'assist_round', {}
  ev.trigger 'assist_round_end', {}
  ev.trigger 'recover_round_begin', {}
  ev.trigger 'recover_round', {}
  ev.trigger 'recover_round_end', {}
  ev.trigger 'attack_round_begin', {}
  ev.trigger 'attack_round', {}
  ev.trigger 'attack_round_end', {}
  shape.clear_canvas ui.ctx.static
  ev.trigger 'render', {}
  ev.trigger 'move_round_begin', {}
  
on_render = (evt) ->
  paint.board ui.ctx.static

on_game_operation = (evt) ->
  operation_queue.push evt

init = ->
  ev.hook 'gametick', on_gametick
  ev.hook 'render', on_render
  ev.hook 'op_movepiece', on_game_operation
  ev.hook 'move_round', handle_operation_queue

next_tick = ->
  ev.trigger 'gametick', {}

start = ->
  setInterval next_tick, 100

window.game = {
  init,
  start
}