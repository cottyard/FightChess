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
  white: [null, 0, 5, 4, 3, 2, 0, 0, 0]
  black: [null, 0, 0, 2, 3, 4, 5, 0, 0]

super_pawn_pos_value = 
  white: [null, 0, 1, 2, 3, 4, 5, 6, 0]
  black: [null, 0, 6, 5, 4, 3, 2, 1, 0]

evaluate_board = (board, color) ->
  e = 0
  for [[col, row], p] from board.all_pieces()
    ours = p.color is color
    if ours
      e += type_value[p.type]
      if p.type is 'pawn'
        e += pawn_pos_value[color][row]
      if p.type is 'super_pawn'
        e += super_pawn_pos_value[color][row]

    moves = board.get_valid_moves [col, row]

    coeff = ours ? 1 : -1

    e += moves.offensive.length * coeff
    e -= moves.defensive.length * coeff * 0.5
  e

evaluate_move = (board, color, move) ->
  b = board.clone()
  b.move_to move.coord_from, move.coord_to
  return evaluate_board b, color

think_of_one_operation = (board, color) ->
  current = evaluate_board board
  all_moves = generate_all_moves board, color
  #console.log (String(m[1].coord_to[0])+String(m[1].coord_to[1]) for m in evaluation)
  #console.log (m[0] for m in evaluation)
  
  evaluations = ([evaluate_move(board, color, m), m] for m in all_moves)
  evaluations.sort (e1, e2) -> e2[0] - e1[0]

  unless evaluations[0]? 
    return 'abort'

  [max_e, m] = evaluations[0]

  if max_e > current
    return m
  else
    return 'abort'

window.ai.dolphin = {
  think_of_one_operation
}
