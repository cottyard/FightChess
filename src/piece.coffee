class Piece
  constructor: (@color, @type, @coordinate, @board) ->
    ability = rule.ability[@type]
    
    @attack = ability['atk']
    @attack_cd = ability['atk_cd']
    @assistance = ability['ast']
    @hp_total = ability['hp']
    @shield_total = ability['shield']
    @shield_heal = ability['shield_heal']
    @move_cd = ability['move_cd']

    @hp = 80 #@hp_total
    @shield = 1 #@shield_total
    @attack_cd_ticks = 0
    @move_cd_ticks = 0

  move_to: (new_coord) ->
    @board.lift_piece @coordinate if @is_onboard()
    @coordinate = new_coord
    @board.place_piece @ if new_coord?

  valid_moves: ->
    rule.move.strategies[@type] @color, @coordinate, @board

  is_onboard: ->
    @coordinate?
    
window.piece = {
  Piece
}