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

init_guest = ->
  ev.init()
  input.init()
  operation.init()
  preview.init()
  preview.set_color 'black'
  gamestate.init()
  board.init()
  effect.init()
  network.init()

  ev.hook 'gametick', on_gametick

window.game.init_guest = init_guest