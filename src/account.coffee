init = ->
  ui.login_button.onclick = on_login_clicked
  ui.challenge_button.onclick = on_challenge_clicked

on_login_clicked = ->
  id = ui.player_id.value
  return unless id
  ui.player_id.readOnly = true
  ui.set_button_text ui.login_button, 'logging in...'
  ui.disable_button ui.login_button
  network.login id, on_login_succeeded

on_challenge_clicked = ->
  id = ui.opponent_id.value
  return unless id
  ui.opponent_id.readOnly = true
  ui.set_button_text ui.challenge_button, 'sending request...'
  ui.disable_button ui.challenge_button
  network.connect id, on_challenge_accepted

on_login_succeeded = ->
  ui.set_button_text ui.login_button, 'logged in'
  ui.enable_button ui.challenge_button
  network.wait on_challenged

on_login_failed = ->

on_challenge_accepted = ->
  ui.set_button_text ui.challenge_button, 'challenge was accepted'
  game.stop()
  game.init_observer()
  game.start()

on_challenge_failed = ->

on_challenged = (challenger_id) ->
  ui.opponent_id.readOnly = true
  ui.opponent_id.value = challenger_id
  ui.disable_button ui.challenge_button
  ui.set_button_text ui.challenge_button, 'challenged you'

window.account = {
  init
}