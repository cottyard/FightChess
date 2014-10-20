is_in_range = (num, [lower, upper]) ->
  num >= lower and num <= upper

is_in_board = (coord) ->
  [x, y] = coord
  is_in_range(x, [1, 8]) and is_in_range(y, [1, 8])

add_regular_move = (moves, coord, board) ->
  if is_in_board(coord) and not board.is_occupied(coord)
    moves.push coord
    return true
  false

add_offensive_move = (moves, color, coord, board) ->
  if is_in_board(coord) and 
     board.is_occupied(coord) and 
     board.get_piece(coord).color isnt color
    moves.push coord
    return true
  false

add_defensive_move = (moves, color, coord, board) ->
  if is_in_board(coord) and 
     board.is_occupied(coord) and 
     board.get_piece(coord).color is color
    moves.push coord
    return true
  false

pawn = (color, coord, board) ->
  regular = []
  offensive = []
  defensive = []
  
  [col, row] = coord
  starting_row = if color is 'black' then 2 else 7
  orient = if color is 'black' then 1 else -1
  
  if add_regular_move regular, [col, row + orient], board
    add_regular_move regular, [col, row + 2 * orient], board if row is starting_row
  add_offensive_move offensive, color, [col + 1, row + orient], board
  add_offensive_move offensive, color, [col - 1, row + orient], board
  add_defensive_move defensive, color, [col + 1, row + orient], board
  add_defensive_move defensive, color, [col - 1, row + orient], board
  
  {regular, offensive, defensive}

super_pawn_moves_deltas = [
  [1, 0], [-1, 0], [0, 1], [0, -1]
]
super_pawn_atk_ast_deltas = [
  [1, 1], [1, -1], [-1, 1], [-1, -1]
]
super_pawn = (color, coord, board) ->
  regular = []
  offensive = []
  defensive = []
  
  [col, row] = coord
  for [x, y] in super_pawn_moves_deltas
    add_regular_move regular, [col + x, row + y], board
  for [x, y] in super_pawn_atk_ast_deltas
    add_defensive_move defensive, color, [col + x, row + y], board
    add_offensive_move offensive, color, [col + x, row + y], board

  {regular, offensive, defensive}

knight_moves_deltas = [
  [2, 1], [2, -1], [-2, 1], [-2, -1],
  [1, 2], [1, -2], [-1, 2], [-1, -2]
]
knight = (color, coord, board) ->
  regular = []
  offensive = []
  defensive = []
  
  [col, row] = coord
  for [dx, dy] in knight_moves_deltas
    add_regular_move regular, [col + dx, row + dy], board
    add_offensive_move offensive, color, [col + dx, row + dy], board
    add_defensive_move defensive, color, [col + dx, row + dy], board
    
  {regular, offensive, defensive}

bishop_moves_orients = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
bishop = (color, coord, board) ->
  regular = []
  offensive = []
  defensive = []
  
  [col, row] = coord
  for [dx, dy] in bishop_moves_orients
    next = [col, row]
    while true
      next = [next[0] + dx, next[1] + dy]
      break unless add_regular_move regular, next, board
    add_offensive_move offensive, color, next, board
    add_defensive_move defensive, color, next, board
    
  {regular, offensive, defensive}

rook_moves_orients = [[1, 0], [0, 1], [-1, 0], [0, -1]]
rook = (color, coord, board) ->
  regular = []
  offensive = []
  defensive = []
  
  [col, row] = coord
  for [dx, dy] in rook_moves_orients
    next = [col, row]
    while true
      next = [next[0] + dx, next[1] + dy]
      break unless add_regular_move regular, next, board
    add_offensive_move offensive, color, next, board
    add_defensive_move defensive, color, next, board
    
  {regular, offensive, defensive}
  
queen = (color, coord, board) ->
  regular = []
  offensive = []
  defensive = []
  
  [col, row] = coord
  for [dx, dy] in rook_moves_orients.concat bishop_moves_orients
    next = [col, row]
    while true
      next = [next[0] + dx, next[1] + dy]
      break unless add_regular_move regular, next, board
    add_offensive_move offensive, color, next, board
    add_defensive_move defensive, color, next, board
    
  {regular, offensive, defensive}

king_moves_deltas = [
  [1, 0], [0, 1], [-1, 0], [0, -1],
  [1, 1], [1, -1], [-1, 1], [-1, -1]
]
king = (color, coord, board) ->
  regular = []
  offensive = []
  defensive = []
  
  [col, row] = coord
  for [dx, dy] in king_moves_deltas
    add_regular_move regular, [col + dx, row + dy], board
    add_offensive_move offensive, color, [col + dx, row + dy], board
    add_defensive_move defensive, color, [col + dx, row + dy], board
  
  {regular, offensive, defensive}

window.rule.move = {
  strategies: {
    pawn,
    super_pawn,
    knight,
    bishop,
    rook,
    queen,
    king
  }
}