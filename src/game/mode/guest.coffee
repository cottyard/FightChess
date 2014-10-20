on_gametick = (evt) ->
  operation.send_cached_operations()
  if gamestate.to_next_state()
    game.render_gametick()
    while gamestate.cache_size() > 5
      gamestate.to_next_state()
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