generate_all_moves = (board, color) ->
  all_moves = []
  for [coord, p] from board.all_pieces()
    continue unless p.color is color
    continue unless p.can_move()
    moves = board.get_valid_regular_moves coord
    for c in moves
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
  'cannon': 30,
  'king': 0

pawn_pos_value = 
  white: [null, 0, 5, 4, 3, 2, 0, 0, 0]
  black: [null, 0, 0, 0, 2, 3, 4, 5, 0]

super_pawn_pos_value = 
  white: [null, 0, 1, 2, 3, 4, 5, 6.5, 0]
  black: [null, 0, 6.5, 5, 4, 3, 2, 1, 0]

evaluate_board = (board, color, log = no) ->
  e = 0
  attacked = 0
  attacking = 0
  them_defending = 0
  us_defending = 0
  king_attacked = 0
  king_attacking = 0
  king_coord_x = null
  king_coord_y = null
  king_hp = null
  enemy_king_hp = null
  pos_value = 0
  enemy_king_coord_x = null
  enemy_king_coord_y = null

  for [[col, row], p] from board.all_pieces()
    ours = p.color is color
    if ours
      e += type_value[p.type]
      if p.type is 'pawn'
        e += pawn_pos_value[color][row]
        pos_value += pawn_pos_value[color][row]
      if p.type is 'super_pawn'
        e += super_pawn_pos_value[color][row]
        pos_value += pawn_pos_value[color][row]
      if p.type is 'king'
        [king_coord_x, king_coord_y] = [col, row]
        king_hp = p.hp
    else
      if p.type is 'king'
        [enemy_king_coord_x, enemy_king_coord_y] = [col, row]
        enemy_king_hp = p.hp

    moves = board.get_moves [col, row]

    coeff = if ours then 1 else -1

    if p.type is 'queen'
      e += moves.offensive.length * coeff * 0.2
    else
      e += moves.offensive.length * coeff
    e -= moves.defensive.length * coeff * 0.5

    if ours
      attacking += moves.offensive.length
      us_defending += moves.defensive.length
    else
      attacked += moves.offensive.length
      them_defending += moves.defensive.length

    for c in moves.offensive
      p = board.get_piece c
      switch p.type
        when 'king'
          if p.color is color
            king_attacked += 1
          else
            king_attacking += 1
        when 'queen'
          e += if p.color is color then -0.8 else 0.5

  attacked_coeff =
    switch 
      when king_hp < 100 then 5
      when king_hp < 500 then 3
      when king_hp < 900 then 1.5
      else 0.5

  attacking_coeff =
    switch 
      when enemy_king_hp < 100 then 3
      when enemy_king_hp < 500 then 1
      when enemy_king_hp < 900 then 0.7
      else 0.4

  e -= king_attacked * attacked_coeff
  e += king_attacking * attacking_coeff

  distance = 7
  for [[col, row], p] from board.all_pieces()
    continue unless p.color is color
    continue if p.type is 'king'
    dis = Math.max(Math.abs(king_coord_x-col), Math.abs(king_coord_y-row))
    if dis < distance
      distance = dis

  e -= distance

  if log
    console.log '======================================='
    console.log 'attacking', attacking, 'attacked', attacked
    console.log 'us_defending', us_defending, 'them_defending', them_defending
    console.log 'king_attacking', king_attacking * attacking_coeff, 'king_attacked', king_attacked * attacked_coeff
    console.log 'king', king_coord_x, king_coord_y
    console.log 'enemy king', enemy_king_coord_x, enemy_king_coord_y
    console.log 'pos', pos_value
    console.log 'king isolation', distance
    console.log 'current', e

  return e

evaluate_move = (board, color, move) ->
  b = board.clone()
  b.move_to move.coord_from, move.coord_to
  return evaluate_board b, color

think_of_one_operation = (board, color) ->
  current = evaluate_board board, color
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
