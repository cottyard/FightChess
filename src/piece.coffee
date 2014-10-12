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
        coord_to: astee.coordinate,
        enhancement: @assistance
      }

  on_assist_round_end: =>
    if @shield > @shield_total 
      @shield = @shield_total

  inflict: (hp_damage) ->

  enhance: (shield) ->
  
  recover: (hp) ->
  
  die: ->
    if @is_onboard()
      @board.lift_piece @coordinate
      @coordinate = [-1, -1]
  
  info: ->
    """hp: #{@hp}/#{@hp_total}
       shield: #{@shield}/#{@shield_total} (#{@shield_heal})
    """
  
window.piece = {
  Piece
}