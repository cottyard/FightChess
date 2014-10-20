class Assist
  constructor: (@coord_from, @coord_to) ->
  render: (ctx) ->
    [[x, y], [to_x, to_y]] = calc.shrink_segment calc.coord_to_pos(@coord_from), calc.coord_to_pos(@coord_to)
    shape.save_style ctx
    shape.set_style ctx, shape.style_blue_tp
    shape.arrow ctx, x, y, to_x, to_y
    shape.restore_style ctx
    
  next_frame: ->
    no

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
    
  next_frame: ->
    @transparency -= 0.2
    if @transparency >= 0.2 then yes else no

class Hurt
  constructor: (@coord) ->
    @transparency = 0.3

  render: (ctx) ->
    shape.save_style ctx
    shape.set_style ctx, "rgba(255, 0, 0, #{@transparency})"
    [x, y] = calc.coord_to_pos @coord
    shape.rectangle ctx, \
      x - settings.half_grid_size, y - settings.half_grid_size, \
      settings.grid_size, settings.grid_size, yes
    shape.restore_style ctx
    
  next_frame: ->
    @transparency -= 0.1
    if @transparency >= 0.1 then yes else no

effects_assist = []
effects_attack = []
effects_hurt = []

on_battle_assist = (evt) ->
  effects_assist.push new Assist evt.coord_from, evt.coord_to

on_battle_attack = (evt) ->
  effects_attack.push new Attack evt.coord_from, evt.coord_to

on_piece_hurt = (evt) ->
  effects_hurt.push new Hurt evt.coord

render_effects = (ctx, effects) ->
  for e, i in effects
    e.render ctx
    to_be_continued = e.next_frame()
    effects[i] = null unless to_be_continued
  effects.filter (e) -> e?

render_all = ->
  ctx = ui.ctx.static
  effects_assist = render_effects ctx, effects_assist
  effects_attack = render_effects ctx, effects_attack
  effects_hurt = render_effects ctx, effects_hurt

init = ->
  ev.hook 'battle_assist', on_battle_assist
  ev.hook 'battle_attack', on_battle_attack
  ev.hook 'piece_hurt', on_piece_hurt
  ev.hook 'render', render_all

get_state = ->
  calc.to_string {
    assist: effects_assist,
    attack: effects_attack,
    hurt: effects_hurt
  }

set_state = (str) ->
  state = calc.from_string str
  effects_assist = (calc.set_type e, Assist for e in state.assist)
  effects_attack = (calc.set_type e, Attack for e in state.attack)
  effects_hurt = (calc.set_type e, Hurt for e in state.hurt)

window.effect = {
  init,
  get_state,
  set_state
}