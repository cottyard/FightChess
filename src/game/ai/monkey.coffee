try_moving_piece = (board, piece, coord) ->
  return 'no moves' unless piece.can_move()
  moves = board.get_valid_moves coord
  if moves.regular.length > 0
    return calc.pick_one moves.regular
  else
    return 'no moves'

think_of_one_operation = (board, color) ->
  all_moves = []
  for [coord, p] from board.all_pieces()
    current_piece = board.get_piece coord
    continue unless current_piece.color is color
    result_coord = try_moving_piece board, current_piece, coord
    if result_coord isnt 'no moves'
      all_moves.push {
        piece: current_piece,
        coord_to: result_coord,
        coord_from: coord
      }
  if all_moves.length > 0
    return calc.pick_one all_moves
  else
    return 'abort'

window.ai.monkey = {
  think_of_one_operation
}