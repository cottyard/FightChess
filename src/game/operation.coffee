operation_queue = [] # queue of user operation

handle_cached_operations = ->
  while operation_queue.length > 0
    handle_operation(operation_queue.shift())

send_cached_operations = ->
  for op in operation_queue
    ev.trigger_now 'network_out_operation', {operation: calc.to_string op}
  operation_queue = []

is_valid_operation = (op_evt) ->
  return false unless board.instance.is_occupied op_evt.piece.coordinate
  authentic_piece = board.instance.get_piece op_evt.piece.coordinate
  return false unless piece.piece_equal authentic_piece, op_evt.piece # replace this with unique piece identity
  return false unless authentic_piece.can_move()
  moves = authentic_piece.valid_moves()
  if calc.coord_one_of op_evt.coord_to, moves.regular
    return true
  else
    return false

handle_operation = (op_evt) ->
  if is_valid_operation op_evt
    authentic_piece = board.instance.get_piece op_evt.piece.coordinate
    ev.trigger 'battle_move', {piece: authentic_piece, coord_to: op_evt.coord_to}

on_network_operation_in = (evt) ->
  op = calc.from_string evt.operation
  calc.set_type op.piece, piece.Piece
  operation_queue.push op

on_game_operation = (evt) ->
  operation_queue.push evt

init = ->
  ev.hook 'op_movepiece', on_game_operation
  ev.hook 'network_in_operation', on_network_operation_in

window.operation = {
  init,
  handle_cached_operations,
  send_cached_operations
}