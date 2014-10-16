init = ->
  ui.login_button.onclick = on_login
  ui.challenge_button.onclick = on_challenge

on_login = ->
  id = ui.player_id.value
  return unless id
  ui.player_id.readOnly = true
  ui.login_button.innerHTML = 'logging in...'
  ui.login_button.disabled = 'disabled'
  network.login id, on_login_succeeded

on_challenge = ->
  id = ui.opponent_id.value
  return unless id
  ui.opponent_id.readOnly = true
  ui.challenge_button.innerHTML = 'sending request...'
  ui.challenge_button.disabled = 'disabled'
  network.connect id, on_challenge_accepted

on_login_succeeded = ->
  ui.login_button.innerHTML = 'logged in'
  ui.challenge_button.disabled = undefined
  network.wait on_challenged

on_login_failed = ->

on_challenge_accepted = ->
  ui.challenge_button.innerHTML = 'challenge was accepted'

on_challenge_failed = ->

on_challenged = (challenger_id) ->
  ui.opponent_id.readOnly = true
  ui.opponent_id.value = challenger_id
  ui.challenge_button.disabled = 'disabled'
  ui.challenge_button.innerHTML = 'challenged you'

window.account = {
  init
}