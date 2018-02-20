init = ->
  ui.login_button.onclick = on_login_clicked
  ui.challenge_button.onclick = on_challenge_clicked

set_ui_state_logging_in = ->
  ui.player_id.readOnly = true
  ui.set_button_text ui.login_button, 'logging in...'
  ui.disable_button ui.login_button

set_ui_state_after_log_in = ->
  ui.player_id.readOnly = true
  ui.set_button_text ui.login_button, 'logged in'
  ui.enable_button ui.challenge_button

set_ui_state_before_log_in = ->
  ui.player_id.readOnly = false
  ui.set_button_text ui.login_button, 'log in'
  ui.enable_button ui.login_button

set_ui_state_challenging = ->
  ui.opponent_id.readOnly = true
  ui.set_button_text ui.challenge_button, 'sending request...'
  ui.disable_button ui.challenge_button

set_ui_state_after_challenge = ->
  ui.opponent_id.readOnly = true
  ui.set_button_text ui.challenge_button, 'challenge accepted'

set_ui_state_before_challenge = ->
  ui.opponent_id.readOnly = false
  ui.set_button_text ui.challenge_button, 'challenge'
  ui.enable_button ui.challenge_button

on_login_clicked = ->
  id = ui.player_id.value
  return unless id
  set_ui_state_logging_in()
  network.login id, on_login_succeeded, on_login_failed

on_challenge_clicked = ->
  id = ui.opponent_id.value
  return unless id
  set_ui_state_challenging()
  network.connect id, on_challenge_accepted, on_challenge_failed

on_login_succeeded = ->
  set_ui_state_after_log_in()
  network.wait on_challenged

on_login_failed = ->
  set_ui_state_before_log_in()
  ui.show_message 'login failed'

on_challenge_accepted = ->
  set_ui_state_after_challenge()
  game.init_guest()
  game.start()

on_challenge_failed = ->
  set_ui_state_before_challenge()
  ui.show_message 'challenge failed'

on_challenged = (challenger_id) ->
  ui.opponent_id.readOnly = true
  ui.opponent_id.value = challenger_id
  ui.disable_button ui.challenge_button
  ui.set_button_text ui.challenge_button, 'challenged you'
  game.init_host()

window.account = {
  init
}