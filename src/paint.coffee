piece_drawing_types =
  black:
    pawn: '\u265F'
    knight: '\u265E'
    bishop: '\u265D'
    rook: '\u265C'
    queen: '\u265B'
    king: '\u265A'
  white:
    pawn: '\u2659'
    knight: '\u2658'
    bishop: '\u2657'
    rook: '\u2656'
    queen: '\u2655'
    king: '\u2654'

# indicators

hp_indicator = (ctx, [pos_x, pos_y], current, total) ->
  
  half = settings.half_grid_size
  color_offset = Math.floor (total - current) / total * 255 * 2
  red_offset = if color_offset > 255 then 255 else color_offset
  green_offset = color_offset - red_offset
  shape.set_style ctx, "rgba(#{red_offset}, #{255 - green_offset}, 0, 0.7)"
  shape.rectangle ctx, pos_x + half - 7, pos_y - half, 7, 7, yes

shield_indicator = (ctx, [pos_x, pos_y], current, total) ->
  return if total is 0
  half = settings.half_grid_size
  length = settings.grid_size - 7
  percentage = current / total
  cut_length = (1 - percentage) * length
  shape.set_style ctx, shape.style_blue_tp
  shape.rectangle ctx, pos_x - half + cut_length, pos_y - half, length - cut_length, 7, yes

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

piece = (ctx, piece) ->
  piece_at ctx, piece, calc.coord_to_pos piece.coordinate

piece_at = (ctx, piece, [pos_x, pos_y]) ->
  color = piece.color
  type = piece.type
  half = settings.half_grid_size
  shape.text ctx, piece_drawing_types[color][type],
             pos_x - half + 5, pos_y - half + 40
  shape.save_style ctx
  hp_indicator ctx, [pos_x, pos_y], piece.hp, piece.hp_total
  shield_indicator ctx, [pos_x, pos_y], piece.shield, piece.shield_total
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

window.paint = {
  background,
  piece,
  piece_at,
  mark_grid
}