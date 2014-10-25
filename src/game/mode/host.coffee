on_gametick = (evt) ->
  game.move_round()
  game.assist_round()
  game.recover_round()
  game.attack_round()
  gamestate.send_current_state()
  game.render_gametick()

init_host = ->
  ev.init()
  input.init()
  operation.init()
  preview.init()
  preview.set_color 'white'
  board.init()
  battle.init()
  effect.init()
  network.init()

  ev.hook 'gametick', on_gametick
  ev.hook 'move_round_begin', operation.handle_cached_operations

window.game.init_host = init_host