state_queue = []

to_next_state = ->
  if not state_queue.length > 0
    return false
  set_state state_queue.shift()
  true

get_state = ->
  board: board.get_state()
  effect: effect.get_state()

set_state = (state) ->
  board.set_state state.board
  effect.set_state state.effect

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