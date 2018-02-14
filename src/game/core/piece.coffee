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

  initialize_state_info: ->
    @hp = @hp_total
    @shield = @shield_total = @shield_total_born
    @shield_heal = @shield_heal_born
    @attack_cd_ticks = 0
    @move_cd_ticks = 0

  info: ->
    """hp: #{Math.ceil @hp}/#{@hp_total}
       shield: #{Math.floor @shield}/#{@shield_total} (#{@shield_heal.toFixed(1)})
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

  assist: (assistance) ->
    @shield_total += assistance[0]
    @shield_heal += assistance[1]

  heal: (hp) ->
    @hp += hp
    if @hp > @hp_total
      @hp = @hp_total

  is_dead: ->
    @hp <= 0

  clone: ->
    new Piece @color, @type

  equals: (another) ->
    @type == another.type and @color == another.color

byte_spec = 
  color: 1
  type: 1
  hp: 2
  sd: 2
  sd_total: 2
  sd_heal: 1
  atk_cd: 1
  mv_cd: 1

serialization_btyes = 11

serialize_piece = (piece) ->
  piece_obj =
    color: if piece.color is 'white' then 0 else 1
    type: (a for a of rule.ability).indexOf piece.type
    hp: calc.wrap_float_for_arraybuffer piece.hp
    sd: calc.wrap_float_for_arraybuffer piece.shield
    sd_total: calc.wrap_float_for_arraybuffer piece.shield_total
    sd_heal: calc.wrap_float_for_arraybuffer piece.shield_heal
    atk_cd: piece.attack_cd_ticks
    mv_cd: piece.move_cd_ticks
  
  calc.obj_to_arraybuffer piece_obj, byte_spec

deserialize_piece = (buffer) ->
  piece_obj = calc.arraybuffer_to_obj buffer, byte_spec

  color = if piece_obj.color is 0 then 'white' else 'black'
  type = (a for a of rule.ability)[piece_obj.type]

  piece = new Piece color, type
  piece.hp = calc.unwrap_float_from_arraybuffer piece_obj.hp
  piece.shield = calc.unwrap_float_from_arraybuffer piece_obj.sd
  piece.shield_total = calc.unwrap_float_from_arraybuffer piece_obj.sd_total
  piece.shield_heal = calc.unwrap_float_from_arraybuffer piece_obj.sd_heal
  piece.attack_cd_ticks = piece_obj.atk_cd
  piece.move_cd_ticks = piece_obj.mv_cd
  piece

window.piece = {
  Piece,
  
  serialize_piece,
  deserialize_piece,
  serialization_btyes
}