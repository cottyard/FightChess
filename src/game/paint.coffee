piece_drawing_types =
  black:
    pawn: '\u265F'
    super_pawn: '\u265F'
    knight: '\u265E'
    bishop: '\u265D'
    rook: '\u265C'
    queen: '\u265B'
    king: '\u265A'
    cannon: '\u7832'
  white:
    pawn: '\u2659'
    super_pawn: '\u2659'
    knight: '\u2658'
    bishop: '\u2657'
    rook: '\u2656'
    queen: '\u2655'
    king: '\u2654'
    cannon: '\u70AE'

piece_super_pawn_decorator = 'S'

# indicators

shield_indicator = (ctx, coord, current, total) ->
  transparency = determine_shield_transparency current
  paint_grid ctx, coord, "rgba(0, 0, 255, #{transparency})"
  # half = settings.half_grid_size
  # length = settings.grid_size - 7
  # percentage = current / total
  # cut_length = (1 - percentage) * length
  # transparency = determine_shield_transparency total
  # x = pos_x - half + cut_length
  # y = pos_y - half
  # w = length - cut_length
  # h = 7
  # shape.set_style ctx, shape.style_white
  # shape.rectangle ctx, x, y, w, h, yes
  # shape.set_style ctx, "rgba(0, 0, 255, #{transparency})"
  # shape.rectangle ctx, x, y, w, h, yes

determine_shield_transparency = (val) ->
  if val >= 20 then 0.5 else val / 40

hp_indicator = (ctx, [pos_x, pos_y], current, total) ->
  half = settings.half_grid_size
  # for hp < 10%, give the red indicator.
  # for hp > 10%, give a gradient color from green to red.
  total_ = 0.9 * total
  current_ = current
  current_ -= 0.1 * total_
  current_ = 0 if current_ < 0
  color_offset = Math.floor (total_ - current_) / total_ * 255 * 2
  red_offset = if color_offset > 255 then 255 else color_offset
  green_offset = color_offset - red_offset
  # shape.rectangle ctx, pos_x + half - 7, pos_y - half, 7, 7, yes
  half = settings.half_grid_size
  length = settings.grid_size
  percentage = current / total
  cut_length = (1 - percentage) * length
  x = pos_x - half + cut_length
  y = pos_y - half
  w = length - cut_length
  h = settings.top_indicator_height
  # shape.set_style ctx, shape.style_white
  # shape.rectangle ctx, x, y, w, h, yes
  shape.set_style ctx, "rgba(#{red_offset}, #{255 - green_offset}, 0, 0.9)"
  shape.rectangle ctx, x, y, w, h, yes

move_cd_indicator = (ctx, [pos_x, pos_y], current, total) ->
  return if current is 0
  percentage = (total - current) / total
  half = settings.half_grid_size
  shape.save_style ctx
  shape.set_style ctx, "rgba(0, 255, 255, 0.7)"
  shape.rectangle ctx, pos_x - half, pos_y + half - 3, settings.grid_size * percentage, 4, yes
  shape.restore_style ctx

# api

background = (ctx, size) ->
  ctx.save()
  grid_size = settings.grid_size
  shape.set_style ctx, shape.style_grey
  for x in [0...size ] by grid_size
    for y in [0...size ] by grid_size
      if (x + y) / grid_size % 2 isnt 0
        shape.rectangle ctx, x, y, grid_size, grid_size, yes
  ctx.restore()

piece_with_indicators = (ctx, piece, coord) ->
  [pos_x, pos_y] = calc.coord_to_pos coord
  piece_at_pos ctx, piece, [pos_x, pos_y]
  shape.save_style ctx
  hp_indicator ctx, [pos_x, pos_y], piece.hp, piece.hp_total
  shield_indicator ctx, coord, piece.shield, piece.shield_total
  move_cd_indicator ctx, [pos_x, pos_y], piece.move_cd_ticks, piece.move_cd
  shape.restore_style ctx

piece_at_pos = (ctx, piece, [pos_x, pos_y]) ->
  color = piece.color
  type = piece.type
  half = settings.half_grid_size
  style = if piece.can_move() then null else shape.style_light
  shape.text ctx, piece_drawing_types[color][type],
             pos_x - half + 5, pos_y - half + 40, style
  if piece.type is 'super_pawn'
    shape.text ctx, piece_super_pawn_decorator,
               pos_x + 8, pos_y - half + 20, null, "18px Courier New"

board = (ctx) ->
  for [coord, p] from battleground.instance.all_pieces()
      piece_with_indicators ctx, p, coord

paint_grid = (ctx, coord, style) ->
  shape.save_style ctx
  shape.set_style ctx, style
  [x, y] = calc.coord_to_pos coord
  shape.rectangle ctx, \
    x - settings.half_grid_size, y - settings.half_grid_size + settings.top_indicator_height, \
    settings.grid_size, settings.grid_size - settings.top_indicator_height, yes
  shape.restore_style ctx

mark_grid = (ctx, coord, style) ->
  padding = 2
  grid_size = settings.grid_size
  [x, y] = coord
  [x, y] = [(x - 1) * grid_size + padding, (y - 1) * grid_size + padding]
  ctx.save()
  ctx.lineWidth = 1 + (padding - 1) * 2
  shape.set_style ctx, style if style?
  shape.rectangle ctx, x, y, grid_size - 2 * padding, grid_size - 2 * padding
  ctx.restore()

mark_attack = (ctx, coord_from, coord_to, transparency) ->
  [[x, y], [to_x, to_y]] = calc.shrink_segment calc.coord_to_pos(coord_from), calc.coord_to_pos(coord_to)
  shape.save_style ctx
  shape.set_style ctx, "rgba(255, 0, 0, #{transparency})"
  ctx.lineWidth = 3
  shape.arrow ctx, x, y, to_x, to_y, 10, null, 3
  shape.restore_style ctx

mark_assist = (ctx, coord_from, coord_to) ->
  [[x, y], [to_x, to_y]] = calc.shrink_segment calc.coord_to_pos(coord_from), calc.coord_to_pos(coord_to)
  shape.save_style ctx
  shape.set_style ctx, shape.style_blue_tp
  shape.arrow ctx, x, y, to_x, to_y
  shape.restore_style ctx

mark_destination = (ctx, coord_from, coord_to) ->
  return if calc.coord_equal coord_from, coord_to
  [[x, y], [to_x, to_y]] = calc.shrink_segment calc.coord_to_pos(coord_from), calc.coord_to_pos(coord_to), 20, 0
  [[x, y], [to_x, to_y]] = calc.shrink_segment [x, y], [to_x, to_y], 5
  shape.save_style ctx
  shape.set_style ctx, shape.style_cerulean_tp
  shape.arrow ctx, x, y, to_x, to_y, 20, 5, 20
  shape.restore_style ctx

window.paint = {
  background,
  piece_at_pos,
  board,
  paint_grid,
  mark_grid,
  mark_attack,
  mark_assist,
  mark_destination
}