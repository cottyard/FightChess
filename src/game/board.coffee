class Board
  piece_arrangement = ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook']
  constructor: ->
    @board = (
      (null for j in [1..8]) for i in [1..8]
    )
  
  set_out_board: ->
    for x in [1..8]
      @place_piece new piece.Piece 'white', 'pawn', [x, 7]
      @place_piece new piece.Piece 'white', piece_arrangement[x - 1], [x, 8]

    for x in [1..8]
      @place_piece new piece.Piece 'black', 'pawn', [x, 2]
      @place_piece new piece.Piece 'black', piece_arrangement[x - 1], [x, 1]

  clean_up_board: ->
    for i in [1..8]
      for j in [1..8]
        if @is_occupied [i, j]
          @get_piece([i, j]).unhook_actions()
          @lift_piece [i, j]

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
  board.instance = new Board()
  board.instance.set_out_board()
  ev.hook 'render', on_render

on_render = (evt) ->
  paint.board ui.ctx.static

write_buffer_to_buffer = (buffer_1, buffer_2, from_1, from_2, size)->
  view_1 = new Uint8Array buffer_1
  view_2 = new Uint8Array buffer_2
  for i in [1..size]
    view_2[from_2++] = view_1[from_1++]

get_state = ->
  serialized_pieces = []
  for pieces in board.instance.board
    for p in pieces
      if p?
        serialized_pieces.push piece.serialize_piece p
  buffer = new ArrayBuffer serialized_pieces.length * piece.serialization_btyes
  pointer = 0
  for pb in serialized_pieces
    write_buffer_to_buffer pb, buffer, 0, pointer, piece.serialization_btyes
    pointer += piece.serialization_btyes
  buffer

set_state = (buffer) ->
  board.instance.clean_up_board()
  piece_count = buffer.byteLength / piece.serialization_btyes
  pointer = 0
  for i in [0...piece_count]
    pb = new ArrayBuffer piece.serialization_btyes
    write_buffer_to_buffer buffer, pb, i * piece.serialization_btyes, 0, piece.serialization_btyes
    p = piece.deserialize_piece pb
    board.instance.place_piece p

window.board = {
  init,
  instance: null,
  get_state,
  set_state
}