on_gametick = (evt) ->
  game.move_round battleground.instance
  game.assist_round battleground.instance
  game.recover_round battleground.instance
  game.attack_round battleground.instance
  game.end_of_rounds battleground.instance
  gamestate.send_current_state()
  game.render_gametick()

on_gametick_game_end = (evt) ->
  gamestate.send_current_state()
  game.render_gametick()

end_game = (evt) ->
  ev.unhook 'gametick', on_gametick
  ev.hook 'gametick', on_gametick_game_end
  gamestate.end_game evt.result, evt.player
  preview.disable()

start_game = ->
  console.log 'game starts from state:', gamestate.current_gamestate.state
  switch gamestate.current_gamestate.state
    when 'ready'
      do_start()
    else
      init_host()
      do_start()

do_start = ->
  gamestate.start_game 'white'
  game.start()
  
init_host = ->
  game.stop()

  ui.startgame.hidden = false
  ev.init()
  input.init()
  operation.init()
  preview.init()
  preview.set_color 'white'
  gamestate.init()
  battleground.init()
  battle.init()
  effect.init()
  network.init()

  ev.hook 'gametick', on_gametick
  ev.hook 'move_round_begin', operation.handle_cached_operations
  ev.hook 'game_end', end_game
  ev.hook 'game_start', start_game

window.game.init_host = init_host