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

init = ->
  init_cvs 'background'
  init_cvs 'static'
  init_cvs 'animate'

  ui.cvs_bounding_rect = cvs.animate.getBoundingClientRect()
  
  set_canvas_attr cvs.background, 1, settings.cvs_size
  set_canvas_attr cvs.static, 2, settings.cvs_size
  set_canvas_attr cvs.animate, 3, settings.cvs_size

  ctx.static.font = settings.piece_font
  ctx.animate.font = settings.piece_font

  paint.background ctx.background, settings.cvs_size
  
  ui.info = document.getElementById 'info'
  ui.player_id = document.getElementById 'player_id'
  ui.opponent_id = document.getElementById 'opponent_id'
  ui.login_button = document.getElementById 'login'
  ui.challenge_button = document.getElementById 'challenge'

window.ui = {
  init,
  cvs,
  ctx,
  cvs_bounding_rect: null,
  info: null,
  player_id: null,
  opponent_id: null,
  login_button: null,
  challenge_button: null
}