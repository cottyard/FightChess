# chess board

class Board
  constructor: ->
    @board = (
      (null for j in [1..8]) for i in [1..8]
    )

  is_occupied: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1]?

  get_piece: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1]

  lift_piece: ([coord_x, coord_y]) ->
    @board[coord_x - 1][coord_y - 1] = null

  place_piece: (piece) ->
    [coord_x, coord_y] = piece.coordinate
    @board[coord_x - 1][coord_y - 1] = piece

# chess piece

piece_arrangement = ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook']

class Piece
  constructor: (@color, @type, @coordinate, @board) ->

  move_to: (new_coord) ->
    @board.lift_piece @coordinate if @is_onboard()
    @coordinate = new_coord
    @board.place_piece @ if new_coord?

  is_onboard: ->
    @coordinate?

paint_pieces_on_board = (ctx) ->
  shape.clear_canvas ctx
  for i in [1..8]
    for j in [1..8]
      continue unless board.chess_board.is_occupied [i, j]
      paint.piece ctx, board.chess_board.get_piece [i, j]

init = ->
  board.chess_board = new Board()

  for x in [1..8]
    board.chess_board.place_piece new Piece 'white', 'pawn', [x, 7], board.chess_board
    board.chess_board.place_piece new Piece 'white', piece_arrangement[x - 1], [x, 8], board.chess_board

  for x in [1..8]
    board.chess_board.place_piece new Piece 'black', 'pawn', [x, 2], board.chess_board
    board.chess_board.place_piece new Piece 'black', piece_arrangement[x - 1], [x, 1], board.chess_board

  paint_pieces_on_board game.ctx.static

window.board = {
  init,
  chess_board: null,
  paint_pieces_on_board
}