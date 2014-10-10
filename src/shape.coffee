arrow = (ctx, x, y, to_x, to_y, size = 10) ->
  line ctx, x, y, to_x, to_y

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

  ctx.save()
  ctx.translate to_x, to_y
  ctx.rotate angle
  triangle ctx, 0, -size, -size / 2, 0, size / 2, 0
  ctx.restore()

line = (ctx, x, y, to_x, to_y) ->
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

text = (ctx, text, x, y) ->
  ctx.fillText text, x, y

clear_canvas = (ctx) ->
  ctx.save()
  ctx.setTransform 1, 0, 0, 1, 0, 0
  ctx.clearRect 0, 0, ctx.canvas.width, ctx.canvas.height
  ctx.restore()

set_style = (ctx, style) ->
  ctx.strokeStyle = ctx.fillStyle = style

style_red_tp = "rgba(255, 0, 0, 0.7)"
style_green_tp = "rgba(0, 255, 0, 0.7)"
style_tp = "rgba(0, 0, 0, 0.5)"
style_blue = "#BBF"
style_brown = "#BB9"

window.shape = {
  arrow,
  line,
  triangle,
  rectangle,
  text,
  
  clear_canvas,
  
  set_style,
  
  style_red_tp,
  style_green_tp,
  style_brown,
  style_blue,
  style_tp
}