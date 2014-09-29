hoop = (num, [range_lower, range_upper]) ->
  num = range_lower if num < range_lower
  num = range_upper if num > range_upper
  num

coord_to_pos = ([x, y]) ->
  pos_x = settings.grid_size * (x - 0.5)
  pos_y = settings.grid_size * (y - 0.5)
  [pos_x, pos_y]

pos_to_coord = ([x, y]) ->
  coord_x = hoop x // settings.grid_size + 1, [1, 8]
  coord_y = hoop y // settings.grid_size + 1, [1, 8]
  [coord_x, coord_y]

window.calc = {
  coord_to_pos,
  pos_to_coord
}