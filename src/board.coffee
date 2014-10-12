class Board
  piece_arrangement = ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook']
  constructor: ->
    @board = (
      (null for j in [1..8]) for i in [1..8]
    )
    
    for x in [1..8]
      @place_piece new piece.Piece 'white', 'pawn', [x, 7], @
      @place_piece new piece.Piece 'white', piece_arrangement[x - 1], [x, 8], @

    for x in [1..8]
      @place_piece new piece.Piece 'black', 'pawn', [x, 2], @
      @place_piece new piece.Piece 'black', piece_arrangement[x - 1], [x, 1], @

  is_occupied: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1]?

  get_piece: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1]

  lift_piece: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1] = null

  place_piece: (piece) ->
    [coord_x, coord_y] = piece.coordinate
    @board[coord_x - 1][coord_y - 1] = piece

init = ->
  board.chess_board = new Board()

window.board = {
  init,
  chess_board: null
}