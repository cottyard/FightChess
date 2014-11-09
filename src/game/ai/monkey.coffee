try_moving_piece = (piece) ->
  return 'no moves' unless piece.can_move()
  moves = piece.valid_moves()
  if moves.regular.length > 0
    return moves.regular[0]
  else
    return 'no moves'

think_of_one_operation = (board, color) ->
  for i in [1..8]
    for j in [1..8]
      continue unless board.is_occupied [j, i]
      current_piece = board.get_piece [j, i]
      continue unless current_piece.color is color
      result_coord = try_moving_piece current_piece
      if result_coord isnt 'no moves'
        return {
          piece: current_piece,
          coord_to: result_coord
        }
  return 'abort'

window.ai.monkey = {
  think_of_one_operation
}