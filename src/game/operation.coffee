operation_queue = []

handle_cached_operations = (evt) ->
  while operation_queue.length > 0
    handle_operation evt.board, operation_queue.shift()

send_cached_operations = ->
  for op in operation_queue
    ev.trigger_now 'network_out_operation', {operation: calc.to_string op}
  operation_queue = []

is_valid_operation = (board, op_evt) ->
  return false unless board.is_occupied op_evt.coord_from
  p = board.get_piece op_evt.coord_from
  return false unless p.equals op_evt.piece
  return calc.coord_one_of op_evt.coord_to, (board.get_valid_moves op_evt.coord_from).regular

handle_operation = (board, op_evt) ->
  if is_valid_operation board, op_evt
    p = board.get_piece op_evt.coord_from
    ev.trigger 'battle_move', {piece: p, coord_from: op_evt.coord_from, coord_to: op_evt.coord_to}

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