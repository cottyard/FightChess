arrow = (ctx, x, y, to_x, to_y, size = 5, width = null, overlap_offset = 0) ->
  if overlap_offset > 0
    [_, [line_x, line_y]] = calc.shrink_segment [x, y], [to_x, to_y], overlap_offset, 1
  else
    [line_x, line_y] = [to_x, to_y]
  line ctx, x, y, line_x, line_y, width
  angle = calc.get_segment_angle x, y, to_x, to_y
  ctx.save()
  ctx.translate to_x, to_y
  ctx.rotate angle
  triangle ctx, 0, 0, -size / 2, size, size / 2, size
  ctx.restore()

line = (ctx, x, y, to_x, to_y, width = null) ->
  if width?
    ctx.lineWidth = width
  ctx.beginPath()
  ctx.moveTo x, y
  ctx.lineTo to_x, to_y
  ctx.stroke()
  ctx.closePath()

triangle = (ctx, x1, y1, x2, y2, x3, y3) ->
  ctx.beginPath()
  ctx.moveTo x1, y1
  ctx.lineTo x2, y2
  ctx.lineTo x3, y3
  ctx.fill()

rectangle = (ctx, x, y, width, height, fill = no) ->
  if fill
    ctx.fillRect x, y, width, height
  else 
    ctx.strokeRect x, y, width, height

text = (ctx, text, x, y, style, font) ->
  if style?
    save_style ctx
    set_style ctx, style

  if font?
    ctx.font = font

  ctx.fillText text, x, y

  if font?
    ctx.font = settings.piece_font

  if style?
    restore_style ctx

clear_canvas = (ctx) ->
  ctx.save()
  ctx.setTransform 1, 0, 0, 1, 0, 0
  ctx.clearRect 0, 0, ctx.canvas.width, ctx.canvas.height
  ctx.restore()

set_style = (ctx, style) ->
  ctx.strokeStyle = ctx.fillStyle = style

set_linewidth = (ctx, width) ->
  ctx.lineWidth = width

# state

saved_strokestyle = []
saved_fillstyle = []
saved_linewidth = []

save_style = (ctx) ->
  saved_strokestyle.push ctx.strokeStyle
  saved_fillstyle.push ctx.fillStyle
  saved_linewidth.push ctx.lineWidth

restore_style = (ctx) ->
  ctx.strokeStyle = saved_strokestyle.pop()
  ctx.fillStyle = saved_fillstyle.pop()
  ctx.lineWidth = saved_linewidth.pop()

# constant

style_red_tp = "rgba(255, 0, 0, 0.7)"
style_green_tp = "rgba(0, 255, 0, 0.7)"
style_blue_tp = "rgba(0, 0, 255, 0.7)"
style_tp = "rgba(0, 0, 0, 0.5)"
style_white = "#FFF"
style_blue = "#BBF"
style_brown = "#BB9"
style_grey = "#DDD"
style_light = "#888"
style_cerulean_tp = "rgba(153, 217, 234, 0.7)"
style_dark_green = "rgb(67, 134, 45)"

window.shape = {
  arrow,
  line,
  triangle,
  rectangle,
  text,
  
  clear_canvas,
  
  set_style,
  save_style,
  restore_style,
  
  style_red_tp,
  style_green_tp,
  style_blue_tp,
  style_white,
  style_brown,
  style_blue,
  style_grey,
  style_light,
  style_tp,
  style_cerulean_tp,
  style_dark_green
}