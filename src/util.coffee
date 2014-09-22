arrow = (ctx, x, y, to_x, to_y, size = 10) ->
  line ctx, x, y, to_x, to_y
  
  delta_x = to_x - x
  delta_y = to_y - y
  
  if delta_y is 0
    angle = if delta_x < 0 then Math.PI else 0
  else
    angle = Math.atan delta_x / delta_y
    
    
  ctx.save()
  ctx.translate to_x, to_y
  ctx.rotate angle + Math.PI / 2
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

set_style = (ctx, style) ->
  ctx.strokeStyle = ctx.fillStyle = style

window.util = {
  arrow,
  line,
  triangle,
  
  set_style
}