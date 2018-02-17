on_gametick = (evt) ->
  if gamestate.to_next_state()
    game.render_gametick()
    while gamestate.cache_size() > 5
      gamestate.to_next_state()
      game.render_gametick()

init_observer = ->
  ev.init()
  gamestate.init()
  battleground.init()
  effect.init()
  
  ev.hook 'gametick', on_gametick

window.game.init_observer = init_observer