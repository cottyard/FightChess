destination = (
  (null for j in [1..8]) for i in [1..8]
)

set_destination = (coord_from, coord_to) ->

get_destination = (coord) ->

navigate = (board, coord) ->

on_piece_move = (evt) ->

on_piece_transformed = (evt) ->

on_piece_promoted = (evt) ->

find_move = (board, [x, y], [des_x, des_y]) ->


# //       var graph = new Graph([
# //         [1,1,1,1],
# //         [0,1,1,0],
# //         [0,0,1,1]
# //       ], { diagonal: true });
# //       var start = graph.grid[0][0];
# //       var end = graph.grid[2][3];
# //       var result = Astar.search(graph, start, end);
# //       console.log(result);

# //       (3) [GridNode, GridNode, GridNode]
# // GridNode {x: 1, y: 1, weight: 1, f: 4.41421, g: 1.41421, …}
# // GridNode {x: 2, y: 2, weight: 1, f: 3.82842, g: 2.82842, …}
# // GridNode {x: 2, y: 3, weight: 1, f: 3.82842, g: 3.82842, …}

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
  on_piece_promoted,
  navigate
}