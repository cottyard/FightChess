state_buf = 0

sync_up_gamestate = ->
  suceeded = no
  while gamestate.cache_size() > state_buf
    suceeded = gamestate.to_next_state()
  suceeded

on_gametick = (evt) ->
  operation.send_cached_operations()
  if sync_up_gamestate()
    game.render_gametick()
    state_buf -= 0.1 if state_buf > 1
  else
    state_buf += 1 if state_buf < 5

end_game = (evt) ->
  preview.disable()
  gamestate.end_game evt.result, evt.player

start_game = ->
  preview.set_color 'black'
  gamestate.start_game 'black'

init_guest = ->
  game.stop()

  ev.init()
  input.init()
  operation.init()
  preview.init()
  gamestate.init()
  battleground.init()
  effect.init()
  network.init()

  ev.hook 'gametick', on_gametick
  ev.hook 'game_end', end_game
  ev.hook 'game_start', start_game

window.game.init_guest = init_guest