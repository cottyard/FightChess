# queue of user operation

operation_queue = []

handle_operation_queue = ->
  while operation_queue.length > 0
    handle_operation(operation_queue.shift())

handle_operation = (op_evt) ->
  return unless op_evt.piece.is_onboard()
  moves = op_evt.piece.valid_moves()
  if calc.coord_one_of op_evt.coord_to, moves.regular
    ev.trigger 'battle_move', {piece: op_evt.piece, coord_to: op_evt.coord_to}

on_gametick = (evt) ->
  ev.trigger 'move_round_begin', {}
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

on_render = (evt) ->
  paint.board ui.ctx.static

on_game_operation = (evt) ->
  operation_queue.push evt

init = ->
  ev.hook 'gametick', on_gametick
  ev.hook 'render', on_render
  ev.hook 'op_movepiece', on_game_operation
  ev.hook 'move_round_begin', handle_operation_queue

next_tick = ->
  ev.trigger 'gametick', {}

start = ->
  setInterval next_tick, 100

window.game = {
  init,
  start
}