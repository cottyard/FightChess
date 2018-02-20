test = ->
  piece_test()
  board_test()

board_test = ->
  b0 = new board.Board()
  b0.set_out_board()
  sb = board.serialize b0
  b = new board.Board()
  board.deserialize sb, b

  compare_boards b, b0
  console.log 'board test passed'

compare_boards = (b, b0) ->
  for i in [1..8]
    for j in [1..8]
      o = b.is_occupied [i, j]
      o0 = b0.is_occupied [i, j]
      assert o, o0, 'occupied #{i}, #{j}'
      compare_pieces (b.get_piece [i, j]), (b0.get_piece [i, j]) if o
  assert b.spawn_cd['white'], b0.spawn_cd['white'], 'spawn cd white'
  assert b.spawn_cd['black'], b0.spawn_cd['black'], 'spawn cd black'

piece_test = ->
  p = new piece.Piece 'white', 'king'
  p.activate_attack_cd()
  p.activate_move_cd()
  sp = piece.serialize p, [1, 2]
  [pd, [x, y]] = piece.deserialize sp
  assert x, 1, 'x'
  assert y, 2, 'y'

  compare_pieces pd, p
  console.log 'piece test passed'

compare_pieces = (p, p0) ->
  for a in piece.serialization_attributes
    assert p[a], p0[a], a

assert = (value, expected, msg) ->
  if value isnt expected
    console.log 'assertion fail', value, expected, msg
    throw 'test failed'

window.gamestatetest = {
  test
}
