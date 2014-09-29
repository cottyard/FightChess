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
  grid_size = settings.grid_size
  shape.text ctx, piece_drawing_types[color][type],
            pos_x - grid_size / 2 + 5, pos_y - grid_size / 2 + 40

window.paint = {
  background,
  piece,
  piece_at
}