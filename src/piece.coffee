class Piece
  constructor: (@color, @type, @coordinate, @board) ->
    @strategy

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