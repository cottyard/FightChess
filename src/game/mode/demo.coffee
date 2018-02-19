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
  preview.disable()
  if evt.result is 'draw'
    ui.gamestat.value = 'draw!'
  else if evt.result is 'win'
    ui.gamestat.value = evt.player + ' wins!'
  else
    ui.gamestat.value = 'game ended with unknown status'

init_demo = ->
  ev.init()
  input.init()
  operation.init()
  preview.init()
  preview.set_color 'white'
  battleground.init()
  battle.init()
  effect.init()
  network.init()

  ev.hook 'gametick', on_gametick
  ev.hook 'move_round_begin', operation.handle_cached_operations
  ev.hook 'game_end', end_game

  ai.init()
  ai.activate 'black'

window.game.init_demo = init_demo