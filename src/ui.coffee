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

enable = (btn) ->
  btn.style.display = ''
  btn.disabled = false

disable = (btn) ->
  btn.style.display = ''
  btn.disabled = true

hide = (btn) ->
  btn.style.display = 'none'

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
  
  for w of widgets
    ui[w] = document.getElementById w

  ui.startgame.onclick = ->
    ev.trigger 'game_start', {}

widgets = {
  'info',
  'message',
  'player_id',
  'opponent_id',
  'login_button',
  'challenge_button',
  'spawntime',
  'gamestat',
  'startgame',
  'radio_host',
  'radio_guest',
  'local_offer_btn',
  'local_answer_btn',
  'p2p_status',
  'p2p_paste',
  'p2p_panel',
  'p2p_panel_ctrl',
  'ai_panel',
  'account_panel'
}

window.ui = {
  init,
  
  set_button_text,
  disable_button,
  enable_button,

  enable,
  disable,
  hide,

  show_message,
  
  cvs,
  ctx,
  cvs_bounding_rect: null,

  ai_interval: null,
  ai: null
}