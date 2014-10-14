class Piece
  constructor: (@color, @type, @coordinate, @board) ->
    ability = rule.ability[@type]
    
    @attack = ability['atk']
    @attack_cd = ability['atk_cd']
    @assistance = ability['ast']
    @hp_total = ability['hp']
    @shield_total_born = ability['shield']
    @shield_heal_born = ability['shield_heal']
    @move_cd = ability['move_cd']

    @hp = @hp_total
    @shield = @shield_total = @shield_total_born
    @shield_heal = @shield_heal_born
    @attack_cd_ticks = 0
    @move_cd_ticks = 0

    ev.hook 'assist_round_begin', @on_assist_round_begin
    ev.hook 'assist_round_end', @on_assist_round_end
    ev.hook 'attack_round_begin', @on_attack_round_begin
    ev.hook 'attack_round_end', @on_attack_round_end
    ev.hook 'recover_round', @on_recover_round

  move_to: (new_coord) ->
    @board.lift_piece @coordinate if @is_onboard()
    @coordinate = new_coord
    @board.place_piece @ if new_coord?

  valid_moves: ->
    rule.move.strategies[@type] @color, @coordinate, @board

  is_onboard: ->
    @coordinate?

  on_assist_round_begin: =>
    @shield_total = @shield_total_born
    @shield_heal = @shield_heal_born
    for coord in @valid_moves().defensive
      astee = @board.get_piece coord
      ev.trigger 'battle_assist', {
        aster: @, 
        astee: astee,
        coord_from: @coordinate, 
        coord_to: coord,
        enhancement: @assistance
      }

  on_assist_round_end: =>
    if @shield > @shield_total
      @shield = @shield_total

  on_attack_round_begin: =>
    return if @attack_cd_ticks > 0 or @valid_moves().offensive.length is 0
    for coord in @valid_moves().offensive
      target = @board.get_piece coord
      ev.trigger 'battle_attack', {
        atker: @, 
        atkee: target,
        coord_from: @coordinate, 
        coord_to: coord,
        damage: calc.randint @attack
      }
    @attack_cd_ticks = @attack_cd

  on_attack_round_end: =>
    if @attack_cd_ticks > 0
      @attack_cd_ticks--

  on_recover_round: =>
    @shield += @shield_heal
    if @shield > @shield_total
      @shield = @shield_total
    
  inflict: (damage) ->
    return unless @is_onboard()
    if @shield >= damage
      @shield -= damage
    else
      damage -= @shield
      @shield = 0
      @hp -= damage
      ev.trigger 'piece_hurt', {
        piece: @, 
        coord: @coordinate
      }
    if @hp <= 0
      @die()

  enhance: (assistance) ->
    @shield_total += assistance[0]
    @shield_heal += assistance[1]
    
  recover: (hp) ->
  
  die: ->
    return unless @is_onboard()
    @board.lift_piece @coordinate
    @coordinate = null
    ev.unhook 'assist_round_begin', @on_assist_round_begin
    ev.unhook 'assist_round_end', @on_assist_round_end
    ev.unhook 'attack_round_begin', @on_attack_round_begin
    ev.unhook 'attack_round_end', @on_attack_round_end
    ev.unhook 'recover_round', @on_recover_round
    ev.trigger 'piece_die', {
      piece: @,
      coord: @coordinate
    }
  
  info: ->
    """hp: #{Math.floor @hp}/#{@hp_total}
       shield: #{Math.floor @shield}/#{@shield_total} (#{@shield_heal})
    """
  
window.piece = {
  Piece
}