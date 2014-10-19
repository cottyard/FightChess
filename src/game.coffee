# processes

move_round = ->
  ev.trigger_now 'move_round_begin', {}
  ev.trigger_now 'move_round', {}
  ev.trigger_now 'move_round_end', {}

assist_round = ->
  ev.trigger_now 'assist_round_begin', {}
  ev.trigger_now 'assist_round', {}
  ev.trigger_now 'assist_round_end', {}
  
recover_round = ->
  ev.trigger_now 'recover_round_begin', {}
  ev.trigger_now 'recover_round', {}
  ev.trigger_now 'recover_round_end', {}
  
attack_round = ->
  ev.trigger_now 'attack_round_begin', {}
  ev.trigger_now 'attack_round', {}
  ev.trigger_now 'attack_round_end', {}
  
render_gametick = ->
  shape.clear_canvas ui.ctx.static
  ev.trigger_now 'render', {}

broadcast_gamestate = ->
  state = gamestate.get_state()
  ev.trigger_now 'network_out', {data: state}

# handlers
operation_queue = [] # queue of user operation

handle_operation_queue = ->
  while operation_queue.length > 0
    handle_operation(operation_queue.shift())

handle_operation = (op_evt) ->
  return unless op_evt.piece.is_onboard()
  moves = op_evt.piece.valid_moves()
  if calc.coord_one_of op_evt.coord_to, moves.regular
    ev.trigger 'battle_move', {piece: op_evt.piece, coord_to: op_evt.coord_to}

gamestate_queue = []

next_gamestate = ->
  if not gamestate_queue.length > 0
    return false
  game_state = gamestate_queue.shift()
  gamestate.set_state game_state
  true

on_gametick_demo_mode = (evt) ->
  move_round()
  assist_round()
  recover_round()
  attack_round()
  broadcast_gamestate()
  render_gametick()

on_gametick_observer_mode = (evt) ->
  if next_gamestate()
    render_gametick()
    while gamestate_queue.length > 5
      next_gamestate()
      render_gametick()

on_render = (evt) ->
  paint.board ui.ctx.static

on_game_operation = (evt) ->
  operation_queue.push evt

on_network_in = (evt) ->
  gamestate_queue.push evt.data

init_all_modules = ->
  ev.init()
  
  input.init()
  preview.init()
  
  board.init()
  
  battle.init()
  effect.init()

init_demo = ->
  init_all_modules()
  ev.hook 'gametick', on_gametick_demo_mode
  ev.hook 'render', on_render
  ev.hook 'op_movepiece', on_game_operation
  ev.hook 'move_round_begin', handle_operation_queue

init_observer = ->
  ev.init()
  effect.init()
  
  ev.hook 'gametick', on_gametick_observer_mode
  ev.hook 'render', on_render
  ev.hook 'network_in', on_network_in

next_tick = ->
  ev.trigger 'gametick', {}

game_loop_obj = null
start = ->
  game_loop_obj = setInterval next_tick, 100

stop = ->
  clearInterval game_loop_obj

window.game = {
  init_demo,
  init_observer,
  start,
  stop
}