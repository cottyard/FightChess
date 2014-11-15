generate_all_moves = (board, color) ->
  all_moves = []
  for i in [1..8]
    for j in [1..8]
      continue unless board.is_occupied [j, i]
      current_piece = board.get_piece [j, i]
      continue unless current_piece.color is color
      continue unless current_piece.can_move()
      for coord in current_piece.valid_moves().regular
        all_moves.push {
          piece: current_piece,
          coord_to: coord
        }
  all_moves

evaluate_move = (board, move) ->
  new_board = calc.clone board
  p = new_board.get_piece move.piece.coordinate
  new_board.lift_piece move.piece.coordinate
  p.coordinate = move.coord_to
  new_board.place_piece p
  
  evaluation = 0
  for i in [1..8]
    for j in [1..8]
      continue unless new_board.is_occupied [j, i]
      current_piece = new_board.get_piece [j, i]
      attacks = current_piece.valid_moves(new_board).offensive.length
      if current_piece.color is move.piece.color
        evaluation += attacks
      else
        evaluation -= attacks
  evaluation

think_of_one_operation = (board, color) ->
  all_moves = generate_all_moves board, color
  
  evaluation = ([evaluate_move(board, m), m] for m in all_moves)
  evaluation.sort (e1, e2) -> e2[0] - e1[0]
  #console.log (String(m[1].coord_to[0])+String(m[1].coord_to[1]) for m in evaluation)
  #console.log (m[0] for m in evaluation)
  #console.log evaluation
  
  if evaluation[0]? then evaluation[0][1] else 'abort'

window.ai.dolphin = {
  think_of_one_operation
}