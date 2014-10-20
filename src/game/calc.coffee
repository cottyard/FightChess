to_string = (obj) ->
  JSON.stringify obj

from_string = (str) ->
  JSON.parse str

set_type = (obj, type) ->
  obj.__proto__ = type.prototype
  obj

copy_array = (arr) ->
  arr.slice 0

remove_item_from_array = (item, arr) ->
  index = arr.indexOf item
  arr.splice index, 1 unless index is -1

randint = ([lower, upper]) ->
  Math.floor((Math.random() * (upper - lower + 1)) + lower);

shrink_segment = (point_from, point_to, length = 15)->
  [x, y] = point_from
  [to_x, to_y] = point_to
  angle = get_segment_angle x, y, to_x, to_y
  dx = length * Math.sin angle
  dy = length * Math.cos angle
  x += dx
  y -= dy
  to_x -= dx
  to_y += dy
  return [[x, y], [to_x, to_y]]

get_segment_angle = (x, y, to_x, to_y) ->
  delta_x = to_x - x
  delta_y = to_y - y
  
  if delta_x is 0
    angle = if delta_y > 0 then Math.PI else 0
  else
    angle = Math.atan delta_y / delta_x
    if delta_x < 0
      angle -= Math.PI / 2
    else
      angle += Math.PI / 2
  return angle

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

coord_equal = (coord_1, coord_2) ->
   coord_1[0] is coord_2[0] and coord_1[1] is coord_2[1]

coord_one_of = (coord, coord_list) ->
  for c in coord_list
    if coord_equal coord, c
      return true
  false

window.calc = {
  coord_to_pos,
  pos_to_coord,
  coord_equal,
  coord_one_of,
  
  get_segment_angle,
  shrink_segment,
  
  randint,
  
  remove_item_from_array,
  copy_array,
  
  to_string,
  from_string,
  set_type
}