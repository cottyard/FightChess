sync_up_gamestate = ->
  gamestate.to_next_state()
  if gamestate.to_next_state()
    while gamestate.cache_size() > 5
      gamestate.to_next_state()

on_gametick = (evt) ->
  operation.send_cached_operations()
  sync_up_gamestate()
  game.render_gametick()

init_guest = ->
  ev.init()
  input.init()
  operation.init()
  preview.init()
  gamestate.init()
  board.init()
  effect.init()
  network.init()

  ev.hook 'gametick', on_gametick

window.game.init_guest = init_guest