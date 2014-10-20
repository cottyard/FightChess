state_queue = []

to_next_state = ->
  if not state_queue.length > 0
    return false
  set_state state_queue.shift()
  true

get_state = ->
  calc.to_string {
    board_state: board.get_state()
    effect_state: effect.get_state()
  }

set_state = (str) ->
  state = calc.from_string str
  board.set_state state.board_state
  effect.set_state state.effect_state

on_network_gamestate_in = (evt) ->
  state_queue.push evt.gamestate

send_current_state = ->
  state = get_state()
  ev.trigger_now 'network_out_gamestate', {gamestate: state}

cache_size = ->
	state_queue.length

init = ->
	ev.hook 'network_in_gamestate', on_network_gamestate_in

window.gamestate = {
	init,
  get_state,
  set_state,
  to_next_state,
  cache_size,
  send_current_state
}