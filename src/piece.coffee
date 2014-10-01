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

pawn_moves = (color, coord, board) ->
  regular = []
  offensive = []
  
  [col, row] = coord
  starting_row = if color is 'black' then 2 else 7
  orient = if color is 'black' then 1 else -1
  
  if add_regular_move regular, [col, row + orient], board
    add_regular_move regular, [col, row + 2 * orient], board if row is starting_row
  add_offensive_move offensive, color, [col + 1, row + orient], board
  add_offensive_move offensive, color, [col - 1, row + orient], board

  {regular, offensive}

knight_moves_deltas = [
  [2, 1], [2, -1], [-2, 1], [-2, -1],
  [1, 2], [1, -2], [-1, 2], [-1, -2]
]
knight_moves = (color, coord, board) ->
  regular = []
  offensive = []
  
  [col, row] = coord
  for [dx, dy] in knight_moves_deltas
    add_regular_move regular, [col + dx, row + dy], board
    add_offensive_move offensive, color, [col + dx, row + dy], board
    
  {regular, offensive}

bishop_moves_orients = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
bishop_moves = (color, coord, board) ->
  regular = []
  offensive = []
  
  [col, row] = coord
  for [dx, dy] in bishop_moves_orients
    next = [col, row]
    while true
      next = [next[0] + dx, next[1] + dy]
      break unless add_regular_move regular, next, board
    add_offensive_move offensive, color, next, board
    
  {regular, offensive}

rook_moves_orients = [[1, 0], [0, 1], [-1, 0], [0, -1]]
rook_moves = (color, coord, board) ->
  regular = []
  offensive = []
  
  [col, row] = coord
  for [dx, dy] in rook_moves_orients
    next = [col, row]
    while true
      next = [next[0] + dx, next[1] + dy]
      break unless add_regular_move regular, next, board
    add_offensive_move offensive, color, next, board
    
  {regular, offensive}
  
queen_moves = (color, coord, board) ->
  regular = []
  offensive = []
  
  [col, row] = coord
  for [dx, dy] in rook_moves_orients.concat bishop_moves_orients
    next = [col, row]
    while true
      next = [next[0] + dx, next[1] + dy]
      break unless add_regular_move regular, next, board
    add_offensive_move offensive, color, next, board
    
  {regular, offensive}

king_moves_deltas = [
  [1, 0], [0, 1], [-1, 0], [0, -1],
  [1, 1], [1, -1], [-1, 1], [-1, -1]
]
king_moves = (color, coord, board) ->
  regular = []
  offensive = []
  
  [col, row] = coord
  for [dx, dy] in king_moves_deltas
    add_regular_move regular, [col + dx, row + dy], board
    add_offensive_move offensive, color, [col + dx, row + dy], board
  
  {regular, offensive}

move_strategies =
  pawn: pawn_moves
  knight: knight_moves
  bishop: bishop_moves
  rook: rook_moves
  queen: queen_moves
  king: king_moves

class Piece
  constructor: (@color, @type, @coordinate, @board) ->
    @strategy

  move_to: (new_coord) ->
    @board.lift_piece @coordinate if @is_onboard()
    @coordinate = new_coord
    @board.place_piece @ if new_coord?

  valid_moves: ->
    move_strategies[@type] @color, @coordinate, @board

  is_onboard: ->
    @coordinate?
    
window.piece = {
  Piece
}