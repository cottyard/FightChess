pick_one = (list) ->
  list[calc.randint([0, list.length - 1])]

try_moving_piece = (piece) ->
  return 'no moves' unless piece.can_move()
  moves = piece.valid_moves()
  if moves.regular.length > 0
    return pick_one moves.regular
  else
    return 'no moves'

think_of_one_operation = (board, color) ->
  all_moves = []
  for i in [1..8]
    for j in [1..8]
      continue unless board.is_occupied [j, i]
      current_piece = board.get_piece [j, i]
      continue unless current_piece.color is color
      result_coord = try_moving_piece current_piece
      if result_coord isnt 'no moves'
        all_moves.push {
          piece: current_piece,
          coord_to: result_coord
        }
  if all_moves.length > 0
    return pick_one all_moves
  else
    return 'abort'

window.ai.monkey = {
  think_of_one_operation
}