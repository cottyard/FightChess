get_mouse_pos = (evt) ->
  mouse_x = evt.clientX - game.cvs_bounding_rect.left - settings.cvs_border_width 
  mouse_y = evt.clientY - game.cvs_bounding_rect.top - settings.cvs_border_width 
  [mouse_x, mouse_y]

get_coordinate = (evt) ->
  calc.pos_to_coord get_mouse_pos evt

picking_piece = null

on_mousedown = (evt) ->
  return if picking_piece
  coord = get_coordinate evt
  picking_piece = board.chess_board.get_piece coord
  [pos_x, pos_y] = get_mouse_pos evt

on_mouseup = (evt) ->
  return unless picking_piece
  coord = get_coordinate evt
  picking_piece.move_to coord
  picking_piece = null
  board.paint_pieces_on_board game.ctx.static
  shape.clear_canvas game.ctx.animate

on_mousemove = (evt) ->
  coord = calc.pos_to_coord get_mouse_pos evt
  game.textarea.value = "#{coord}"
  return unless picking_piece
  shape.clear_canvas game.ctx.animate
  shape.set_style game.ctx.animate, shape.style_tp
  paint.piece_at game.ctx.animate, picking_piece, get_mouse_pos evt

init = ->
  game.cvs.animate.addEventListener "mousedown", on_mousedown, false
  game.cvs.animate.addEventListener "mouseup", on_mouseup, false
  game.cvs.animate.addEventListener "mousemove", on_mousemove, false

window.input = {
  init
}