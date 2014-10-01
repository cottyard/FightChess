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
  cvs.style.cursor = "pointer"
  cvs.style['z-index'] = "#{z_index}"

  cvs.width = cvs.height = size

init_all = ->
  init_cvs 'background'
  init_cvs 'static'
  init_cvs 'animate'

  game.cvs_bounding_rect = cvs.animate.getBoundingClientRect()
  
  set_canvas_attr cvs.background, 1, settings.cvs_size
  set_canvas_attr cvs.static, 2, settings.cvs_size
  set_canvas_attr cvs.animate, 3, settings.cvs_size

  ctx.static.font = settings.piece_font
  ctx.animate.font = settings.piece_font

  paint.background ctx.background, settings.cvs_size
  
  game.textarea = document.getElementById 'mousepos'

window.game = {
  init_all,
  cvs,
  ctx,
  cvs_bounding_rect: null,
  textarea: null
}