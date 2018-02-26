on_gametick = (evt) ->
  game.ai_think_round battleground.instance
  game.move_round battleground.instance
  game.assist_round battleground.instance
  game.recover_round battleground.instance
  game.attack_round battleground.instance
  game.end_of_rounds battleground.instance
  game.render_gametick()

on_gametick_game_end = (evt) ->
  game.render_gametick()

end_game = (evt) ->
  ev.unhook 'gametick', on_gametick
  ev.hook 'gametick', on_gametick_game_end
  gamestate.end_game evt.result, evt.player
  preview.disable()


end_game = (evt) ->
  ev.unhook 'gametick', on_gametick
  ev.hook 'gametick', on_gametick_game_end
  gamestate.end_game evt.result, evt.player
  preview.disable()

start_game = ->
  console.log 'game starts from state:', gamestate.current()
  init_demo()
  gamestate.start_game 'white'
  game.start()

init_demo = ->
  game.stop()

  ev.init()
  input.init()
  operation.init()
  preview.init()
  preview.set_color 'white'
  battleground.init()
  battle.init()
  effect.init()

  ev.hook 'gametick', on_gametick
  ev.hook 'move_round_begin', operation.handle_cached_operations
  ev.hook 'game_end', end_game
  ev.hook 'game_start', start_game

  ai.init()
  ai.activate 'black'

window.game.init_demo = init_demo