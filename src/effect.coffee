class Assist
  constructor: (@coord_from, @coord_to) ->
  render: (ctx) ->
    [[x, y], [to_x, to_y]] = calc.shrink_segment calc.coord_to_pos(@coord_from), calc.coord_to_pos(@coord_to)
    shape.arrow ctx, x, y, to_x, to_y

effects_assist = []

on_battle_assist = (evt) ->
  effects_assist.push new Assist evt.coord_from, evt.coord_to
  
render_all = ->
  ctx = ui.ctx.static
  shape.save_style ctx
  shape.set_style ctx, shape.style_blue_tp
  for e in effects_assist
    e.render ctx
  shape.restore_style ctx
  effects_assist = []

init = ->
  ev.hook 'battle_assist', on_battle_assist
  ev.hook 'render', render_all

window.effect = {
  init
}