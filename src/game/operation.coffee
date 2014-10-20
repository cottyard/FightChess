operation_queue = [] # queue of user operation

handle_cached_operations = ->
  while operation_queue.length > 0
    handle_operation(operation_queue.shift())

send_cached_operations = ->
  for op in operation_queue
    ev.trigger_now 'network_out_operation', {operation: calc.to_string op}
  operation_queue = []

handle_operation = (op_evt) ->
  return unless board.instance.is_occupied op_evt.piece.coordinate
  local_piece = board.instance.get_piece op_evt.piece.coordinate
  return unless piece.piece_equal local_piece, op_evt.piece
  moves = local_piece.valid_moves()
  if calc.coord_one_of op_evt.coord_to, moves.regular
    ev.trigger 'battle_move', {piece: local_piece, coord_to: op_evt.coord_to}

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