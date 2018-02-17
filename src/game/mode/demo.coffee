on_gametick = (evt) ->
  #game.ai_think_round()
  game.move_round battleground.instance
  game.assist_round battleground.instance
  game.recover_round battleground.instance
  game.attack_round battleground.instance
  #gamestate.send_current_state()
  game.render_gametick()

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

  ai.init()
  ai.activate 'black'

window.game.init_demo = init_demo