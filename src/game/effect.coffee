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

assist_byte_spec =
    from_x: 1
    from_y: 1
    to_x: 1
    to_y: 1

attack_byte_spec =
    from_x: 1
    from_y: 1
    to_x: 1
    to_y: 1
    tp: 1

hurt_byte_spec =
    x: 1
    y: 1
    tp: 1

get_state = ->
  serialized_assist = []
  for e in effects_assist
    e_obj =
      from_x: e.coord_from[0]
      from_y: e.coord_from[1]
      to_x: e.coord_to[0]
      to_y: e.coord_to[1]
    serialized_assist.push calc.obj_to_arraybuffer e_obj, assist_byte_spec

  serialized_attack = []
  for e in effects_attack
    e_obj =
      from_x: e.coord_from[0]
      from_y: e.coord_from[1]
      to_x: e.coord_to[0]
      to_y: e.coord_to[1]
      tp: Math.floor e.transparency * 10
    serialized_attack.push calc.obj_to_arraybuffer e_obj, attack_byte_spec

  serialized_hurt = []
  for e in effects_hurt
    e_obj =
      x: e.coord[0]
      y: e.coord[1]
      tp: Math.floor e.transparency * 10
    serialized_hurt.push calc.obj_to_arraybuffer e_obj, hurt_byte_spec

  {
    assist: serialized_assist,
    attack: serialized_attack,
    hurt: serialized_hurt
  }

set_state = (state) ->
  serialized_assist = state.assist
  effects_assist = []
  for se in serialized_assist
    e_obj = calc.arraybuffer_to_obj se, assist_byte_spec
    effects_assist.push new Assist [e_obj.from_x, e_obj.from_y], [e_obj.to_x, e_obj.to_y]

  serialized_attack = state.attack
  effects_attack = []
  for se in serialized_attack
    e_obj = calc.arraybuffer_to_obj se, attack_byte_spec
    atk = new Attack [e_obj.from_x, e_obj.from_y], [e_obj.to_x, e_obj.to_y]
    atk.transparency = e_obj.tp / 10
    effects_attack.push atk

  serialized_hurt = state.hurt
  effects_hurt = []
  for se in serialized_hurt
    e_obj = calc.arraybuffer_to_obj se, hurt_byte_spec
    hrt = new Hurt [e_obj.x, e_obj.y]
    hrt.transparency = e_obj.tp / 10
    effects_hurt.push hrt

window.effect = {
  init,
  get_state,
  set_state
}