destination = (
  (null for j in [1..8]) for i in [1..8]
)

set_destination = (coord_from, coord_to) ->

get_destination = (coord) ->

navigate = (coord) ->

on_piece_move = (evt) ->

on_piece_transformed = (evt) ->

on_piece_promoted = (evt) ->

init = ->
  ev.hook 'piece_move', on_piece_move
  ev.hook 'piece_transformed', on_piece_transformed
  ev.hook 'piece_promoted', on_piece_promoted

window.navig = {
  set_destination,
  get_destination,
  get_move,
  on_piece_move,
  on_piece_transformed,
  on_piece_promoted
}