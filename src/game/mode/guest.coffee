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

on_gametick_game_end = (evt) ->
  if sync_up_gamestate()
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

init_guest = ->
  ev.init()
  input.init()
  operation.init()
  preview.init()
  preview.set_color 'black'
  gamestate.init()
  battleground.init()
  effect.init()
  network.init()

  ev.hook 'gametick', on_gametick
  ev.hook 'game_end', end_game

window.game.init_guest = init_guest