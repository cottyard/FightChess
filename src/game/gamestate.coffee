state_queue = []
current_gamestate = null

to_next_state = ->
  if not state_queue.length > 0
    return false
  data = state_queue.shift()
  set_state data.boardstate
  if data.gamestate.state is 'end' and gamestate.current_gamestate.state isnt 'end'
    ev.trigger_now 'game_end', {
      result: data.gamestate.result,
      player: data.gamestate.player
    }
  if data.gamestate.state is 'ongoing' and gamestate.current_gamestate.state isnt 'ongoing'
    ev.trigger_now 'game_start', {}
  true

get_state = ->
  battleground: battleground.get_state()
  effect: effect.get_state()

set_state = (state) ->
  battleground.set_state state.battleground
  effect.set_state state.effect

on_network_gamestate_in = (evt) ->
  state_queue.push evt

send_current_state = ->
  state = get_state()
  ev.trigger_now 'network_out_gamestate', { boardstate: state, gamestate: gamestate.current_gamestate }

send_game_end = (evt) ->
  ev.trigger_now 'network_out_gamestate', { }

cache_size = ->
  state_queue.length

end_game = (result, player) ->
  return unless gamestate.current_gamestate.state is 'ongoing'

  color = gamestate.current_gamestate.color
  console.log result
  if player?
    console.log 'by', player

  gamestate.current_gamestate =
    state: 'end'
    result: result
    player: player

  switch result
    when 'draw'
      ui.gamestat.value = 'draw!'
    when 'win'
      if player is color
        ui.gamestat.value = 'you are victorious!'
      else
        ui.gamestat.value = 'you are defeated'
    else
      ui.gamestat.value = 'game ended with unknown status'

  ui.set_button_text ui.startgame, "start game"

start_game = (color) ->
  console.log "starting with #{color}"
  gamestate.current_gamestate =
    state: 'ongoing'
    color: color

  ui.gamestat.value = "playing #{color}"
  ui.set_button_text ui.startgame, "restart game"

get_gamestate = ->
  if gamestate.current_gamestate?
    return gamestate.current_gamestate.state
  null

init = ->
  ev.hook 'network_in_gamestate', on_network_gamestate_in
  ui.gamestat.value = "waiting for start"
  gamestate.current_gamestate =
    state: 'ready'
  ui.set_button_text ui.startgame, "start game"

window.gamestate = {
  init,
  current: get_gamestate,
  get_state,
  set_state,
  to_next_state,
  cache_size,
  send_current_state,
  start_game,
  end_game
}