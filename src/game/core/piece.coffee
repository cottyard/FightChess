class Piece
  constructor: (@color, @type) ->
    @retrieve_basic_info()
    @initialize_state_info()
    
  retrieve_basic_info: ->
    ability = rule.ability[@type]
    
    @attack = ability['atk']
    @attack_cd = ability['atk_cd']
    @assistance = ability['ast']
    @hp_total = ability['hp']
    @shield_total_born = ability['shield']
    @shield_heal_born = ability['shield_heal']
    @move_cd = ability['move_cd']
    @heal = ability['heal']
    @hp_heal_born = ability['self_heal']

  initialize_state_info: ->
    @hp = @hp_total
    @hp_heal = @hp_heal_born
    @shield = @shield_total = @shield_total_born
    @shield_heal = @shield_heal_born
    @attack_cd_ticks = 0
    @move_cd_ticks = 0

  info: ->
    """hp: #{Math.ceil @hp}/#{@hp_total} (+#{(@hp_heal*10).toFixed(0)})
       shield: #{Math.floor @shield}/#{@shield_total} (+#{(@shield_heal*10).toFixed(0)})
    """

  inflict: (damage) ->
    if @shield >= damage
      @shield -= damage
      false
    else
      damage -= @shield
      @shield = 0
      @hp -= damage
      true

  assist: (assistance, heal) ->
    @shield_total += assistance[0]
    @shield_heal += assistance[1]
    @hp_heal += heal

  activate_attack_cd: ->
    @attack_cd_ticks = @attack_cd

  reduce_attack_cd: ->
    if @attack_cd_ticks > 0
      @attack_cd_ticks--

  adjust_shield: ->
    if @shield > @shield_total
      @shield = @shield_total

  recover_shield: ->
    @shield += @shield_heal
    @adjust_shield()

  recover_hp: ->
    @hp += @hp_heal
    @adjust_hp()

  adjust_hp: ->
    if @hp > @hp_total
      @hp = @hp_total

  reset_assisted_abilities: ->
    @shield_total = @shield_total_born
    @shield_heal = @shield_heal_born
    @hp_heal = @hp_heal_born

  activate_move_cd: ->
    @move_cd_ticks = @move_cd

  reduce_move_cd: ->
    if @move_cd_ticks > 0
      @move_cd_ticks--

  can_move: ->
    return true
    @move_cd_ticks is 0

  is_dead: ->
    @hp <= 0

  clone: ->
    p = new Piece @color, @type
    p.hp = @hp
    p.shield = @shield
    p.shield_total = @shield_total
    p.shield_heal = @shield_heal
    p.attack_cd_ticks = @attack_cd_ticks
    p.move_cd_ticks = @move_cd_ticks
    p

  equals: (another) ->
    @type is another.type and @color is another.color

  change_type: (type) ->
    @type = type
    @retrieve_basic_info()
    @initialize_state_info()

serialization_attributes = [
  'color', 'type', 'hp', 'hp_heal', 'sd', 'sd_total', 'sd_heal', 'atk_cd', 'mv_cd', 'coord_x', 'coord_y']

serialize = (piece, [coord_x, coord_y]) ->
  piece_obj =
    color: if piece.color is 'white' then 0 else 1
    type: (a for a of rule.ability).indexOf piece.type
    hp: calc.wrap_float_for_arraybuffer piece.hp
    hp_heal: calc.wrap_float_for_arraybuffer piece.hp_heal
    sd: calc.wrap_float_for_arraybuffer piece.shield
    sd_total: calc.wrap_float_for_arraybuffer piece.shield_total
    sd_heal: calc.wrap_float_for_arraybuffer piece.shield_heal
    atk_cd: piece.attack_cd_ticks
    mv_cd: piece.move_cd_ticks
    coord_x: coord_x
    coord_y: coord_y
  
  calc.obj_to_arraybuffer piece_obj

deserialize = (buffer) ->
  piece_obj = {}
  for a in serialization_attributes
    piece_obj[a] = null
  
  calc.arraybuffer_to_obj buffer, piece_obj
  
  color = if piece_obj.color is 0 then 'white' else 'black'
  type = (a for a of rule.ability)[piece_obj.type]

  piece = new Piece color, type
  piece.hp = calc.unwrap_float_from_arraybuffer piece_obj.hp
  piece.hp_heal = calc.unwrap_float_from_arraybuffer piece_obj.hp_heal
  piece.shield = calc.unwrap_float_from_arraybuffer piece_obj.sd
  piece.shield_total = calc.unwrap_float_from_arraybuffer piece_obj.sd_total
  piece.shield_heal = calc.unwrap_float_from_arraybuffer piece_obj.sd_heal
  piece.attack_cd_ticks = piece_obj.atk_cd
  piece.move_cd_ticks = piece_obj.mv_cd
  coord_x = piece_obj.coord_x
  coord_y = piece_obj.coord_y
  [piece, [coord_x, coord_y]]

window.piece = {
  Piece,
  
  serialize,
  deserialize,
  serialization_attributes,
  serialization_size: serialization_attributes.length * 2
}