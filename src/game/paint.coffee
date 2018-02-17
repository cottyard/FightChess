piece_drawing_types =
  black:
    pawn: '\u265F'
    super_pawn: '\u265F'
    knight: '\u265E'
    bishop: '\u265D'
    rook: '\u265C'
    queen: '\u265B'
    king: '\u265A'
  white:
    pawn: '\u2659'
    super_pawn: '\u2659'
    knight: '\u2658'
    bishop: '\u2657'
    rook: '\u2656'
    queen: '\u2655'
    king: '\u2654'

# indicators

hp_indicator = (ctx, [pos_x, pos_y], current, total) ->
  half = settings.half_grid_size
  # for hp < 10%, give the red indicator.
  # for hp > 10%, give a gradient color from green to red.
  total = 0.9 * total
  current -= 0.1 * total
  current = 0 if current < 0
  color_offset = Math.floor (total - current) / total * 255 * 2
  red_offset = if color_offset > 255 then 255 else color_offset
  green_offset = color_offset - red_offset
  shape.set_style ctx, "rgba(#{red_offset}, #{255 - green_offset}, 0, 0.9)"
  shape.rectangle ctx, pos_x + half - 7, pos_y - half, 7, 7, yes

move_cd_indicator = (ctx, [pos_x, pos_y], current, total) ->
  return if current is 0
  percentage = (total - current) / total
  half = settings.half_grid_size
  shape.save_style ctx
  shape.set_style ctx, "rgba(0, 255, 255, 0.7)"
  shape.rectangle ctx, pos_x - half, pos_y + half - 3, settings.grid_size * percentage, 4, yes
  shape.restore_style ctx

determine_shield_transparency = (total) ->
  if total <= 1 then 0.4 else \
  if total <= 3 then 0.5 else \
  if total <= 7 then 0.6 else \
  if total <= 13 then 0.7 else \
  if total <= 21 then 0.8 else 0.9

shield_indicator = (ctx, [pos_x, pos_y], current, total) ->
  return if total is 0
  half = settings.half_grid_size
  length = settings.grid_size - 7
  percentage = current / total
  cut_length = (1 - percentage) * length
  transparency = determine_shield_transparency total
  x = pos_x - half + cut_length
  y = pos_y - half
  w = length - cut_length
  h = 7
  shape.set_style ctx, shape.style_white
  shape.rectangle ctx, x, y, w, h, yes
  shape.set_style ctx, "rgba(0, 0, 255, #{transparency})"
  shape.rectangle ctx, x, y, w, h, yes

# api

background = (ctx, size) ->
  ctx.save()
  grid_size = settings.grid_size
  shape.set_style ctx, shape.style_brown
  for x in [0...size ] by grid_size
    for y in [0...size ] by grid_size
      if (x + y) / grid_size % 2 isnt 0
        shape.rectangle ctx, x, y, grid_size, grid_size, yes
  ctx.restore()

piece_at = (ctx, piece, [pos_x, pos_y]) ->
  color = piece.color
  type = piece.type
  half = settings.half_grid_size
  shape.text ctx, piece_drawing_types[color][type],
             pos_x - half + 5, pos_y - half + 40
  shape.save_style ctx
  hp_indicator ctx, [pos_x, pos_y], piece.hp, piece.hp_total
  shield_indicator ctx, [pos_x, pos_y], piece.shield, piece.shield_total
  move_cd_indicator ctx, [pos_x, pos_y], piece.move_cd_ticks, piece.move_cd
  shape.restore_style ctx

board = (ctx) ->
  for i in [1..8]
    for j in [1..8]
      continue unless battleground.instance.is_occupied [i, j]
      piece_at ctx, battleground.instance.get_piece([i, j]), calc.coord_to_pos([i, j])

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

window.paint = {
  background,
  piece_at,
  board,
  mark_grid
}