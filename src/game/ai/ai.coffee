think_interval = 10
thinking_cooldown = think_interval
ai_color = null

init = ->

activate = (color) ->
  ev.hook 'ai_think_round', on_think
  ai_color = color

deactivate = ->
  ev.unhook 'ai_think_round', on_think

on_think = ->
  if thinking_cooldown is 0
    op = ai.monkey.think_of_one_operation(board.instance, ai_color)
    ev.trigger('op_movepiece', op) if op isnt 'abort'
    thinking_cooldown = think_interval
  else
    thinking_cooldown--

window.ai = {
  init,
  activate,
  deactivate,
  monkey: null
}