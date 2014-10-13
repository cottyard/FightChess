class Assist
  constructor: (@coord_from, @coord_to) ->
  render: (ctx) ->
    [[x, y], [to_x, to_y]] = calc.shrink_segment calc.coord_to_pos(@coord_from), calc.coord_to_pos(@coord_to)
    shape.save_style ctx
    shape.set_style ctx, shape.style_blue_tp
    shape.arrow ctx, x, y, to_x, to_y
    shape.restore_style ctx

class Attack
  constructor: (@coord_from, @coord_to) ->
    @transparency = 1

  render: (ctx) ->
    [[x, y], [to_x, to_y]] = calc.shrink_segment calc.coord_to_pos(@coord_from), calc.coord_to_pos(@coord_to)
    shape.save_style ctx
    shape.set_style ctx, "rgba(255, 0, 0, #{@transparency})"
    ctx.lineWidth = 3
    shape.arrow ctx, x, y, to_x, to_y, 10
    shape.restore_style ctx
    @transparency -= 0.2
    if @transparency >= 0.2 then yes else no

effects_assist = []
effects_attack = []

on_battle_assist = (evt) ->
  effects_assist.push new Assist evt.coord_from, evt.coord_to

on_battle_attack = (evt) ->
  effects_attack.push new Attack evt.coord_from, evt.coord_to

render_all = ->
  ctx = ui.ctx.static
  for e in effects_assist
    e.render ctx
  effects_assist = []
  for e, i in effects_attack
    to_be_continued = e.render ctx
    delete effects_attack[i] unless to_be_continued
  effects_attack = effects_attack.filter (e) -> e?

init = ->
  ev.hook 'battle_assist', on_battle_assist
  ev.hook 'battle_attack', on_battle_attack
  ev.hook 'render', render_all

window.effect = {
  init
}