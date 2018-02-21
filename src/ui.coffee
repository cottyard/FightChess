ctx =
  animate: null
  static: null
  background: null

cvs =
  animate: null
  static: null
  background: null

init_cvs = (name) ->
  cvs[name] = document.getElementById name
  ctx[name] = cvs[name].getContext '2d'

set_canvas_attr = (cvs, z_index, size) ->
  cvs.style.border = "solid #000 #{settings.cvs_border_width}px"
  cvs.style.position = "absolute"
  cvs.style['z-index'] = "#{z_index}"

  cvs.width = cvs.height = size

set_button_text = (button, text) ->
  button.innerHTML = text

disable_button = (button) ->
  button.disabled = 'disabled'

enable_button = (button) ->
  button.disabled = undefined

message_timeout_obj = null
show_message = (message) ->
  ui.message.innerHTML = message
  clearTimeout message_timeout_obj
  message_timeout_obj = setTimeout (-> ui.message.innerHTML = ''), 5000

init = ->
  init_cvs 'background'
  init_cvs 'static'
  init_cvs 'animate'

  ui.cvs_bounding_rect = ->
   cvs.animate.getBoundingClientRect()
  
  set_canvas_attr cvs.background, 1, settings.cvs_size
  set_canvas_attr cvs.static, 2, settings.cvs_size
  set_canvas_attr cvs.animate, 3, settings.cvs_size

  ctx.static.font = settings.piece_font
  ctx.animate.font = settings.piece_font

  paint.background ctx.background, settings.cvs_size
  
  ui.info = document.getElementById 'info'
  ui.message = document.getElementById 'message'
  ui.player_id = document.getElementById 'player_id'
  ui.opponent_id = document.getElementById 'opponent_id'
  ui.login_button = document.getElementById 'login'
  ui.challenge_button = document.getElementById 'challenge'
  ui.spawntime = document.getElementById 'spawntime'
  ui.gamestat = document.getElementById 'gamestat'
  ui.startgame = document.getElementById 'startgame'

  ui.ai_interval = document.getElementById 'ai_interval'
  ui.ai = document.getElementById 'ai'

  ui.startgame.onclick = ->
    ev.trigger 'game_start', {}

window.ui = {
  init,
  
  set_button_text,
  disable_button,
  enable_button,

  show_message,
  
  cvs,
  ctx,
  cvs_bounding_rect: null,
  info: null,
  message: null,
  player_id: null,
  opponent_id: null,
  login_button: null,
  challenge_button: null,
  spawntime: null,
  gamestat: null,
  startgame: null,
  ai_interval: null,
  ai: null
}