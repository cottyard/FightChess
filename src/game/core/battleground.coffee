init = ->
  battleground.instance = new Board(true)
  battleground.instance.set_out_board()
  ev.hook 'render', on_render

on_render = (evt) ->
  paint.board ui.ctx.static

# TODO: rewrite the serialization
get_state = ->
  serialized_pieces = []
  for pieces in battleground.instance.board
    for p in pieces
      if p?
        serialized_pieces.push piece.serialize_piece p
  buffer = new ArrayBuffer serialized_pieces.length * piece.serialization_btyes
  pointer = 0
  for pb in serialized_pieces
    calc.write_buf_to_buf pb, buffer, 0, pointer, piece.serialization_btyes
    pointer += piece.serialization_btyes
  buffer

set_state = (buffer) ->
  battleground.instance.clean_up_board()
  piece_count = buffer.byteLength / piece.serialization_btyes
  pointer = 0
  for i in [0...piece_count]
    pb = new ArrayBuffer piece.serialization_btyes
    calc.write_buf_to_buf buffer, pb, i * piece.serialization_btyes, 0, piece.serialization_btyes
    p = piece.deserialize_piece pb
    battleground.instance.place_piece p

window.battleground = {
  init,
  instance: null,
  get_state,
  set_state
}
