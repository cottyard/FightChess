class Piece
  constructor: (@color, @type, @coordinate, @board) ->

  move_to: (new_coord) ->
    @board.lift_piece @coordinate if @is_onboard()
    @coordinate = new_coord
    @board.place_piece @ if new_coord?

  is_onboard: ->
    @coordinate?
    
window.piece = {
  Piece
}