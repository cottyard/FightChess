generate_all_moves = (board, color) ->
  all_moves = []
  for [coord, p] from board.all_pieces()
    continue unless p.color is color
    continue unless p.can_move()
    moves = board.get_valid_moves coord
    for c in moves.regular
      all_moves.push {
        piece: p,
        coord_to: c,
        coord_from: coord
      }
  all_moves


type_value = 
  'pawn': 10
  'super_pawn': 20
  'knight': 30,
  'bishop': 30,
  'rook': 30,
  'queen': 30,
  'king': 0

pawn_pos_value =
  1: 0
  2: 0
  3: 0
  4: 2
  5: 3
  6: 4
  7: 5
  8: 0

super_pawn_pos_value = 
  1: 0
  2: 6
  3: 5
  4: 4
  5: 3
  6: 2
  7: 1
  8: 0

evaluate_board = (board, color) ->
  # e = 0
  # for [[col, row], p] from b.all_pieces()
  #   ours = p.color is color
  #   if ours
  #     e += type_value[p.type]
  #     if p.type is 'pawn'
  #       e += pawn_pos_value[?]


evaluate_move = (board, color, move) ->
  b = board.clone()
  b.move_to move.coord_from, move.coord_to
  continue unless p.can_move()
  b.get_valid_moves coord
  attacks = current_piece.valid_moves(b).offensive.length
  if current_piece.color is move.piece.color
    evaluation += attacks
  else
    evaluation -= attacks
  

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