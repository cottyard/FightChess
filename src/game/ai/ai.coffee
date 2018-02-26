think_interval = null
thinking_cooldown = null
ai_color = null
ai_current = null

init = ->
  ai_current = set_ai 1
  set_interval 3

activate = (color) ->
  ev.hook 'ai_think_round', on_think
  ai_color = color

deactivate = ->
  ev.unhook 'ai_think_round', on_think

on_think = (evt) ->
  return unless ai_current?
  if thinking_cooldown < 0
    op = ai_current.think_of_one_operation evt.board.clone(), ai_color
    ev.trigger('op_movepiece', op) if op isnt 'abort'
    if think_interval?
      thinking_cooldown = think_interval
  else
    thinking_cooldown--

set_interval = (interval) ->
  think_interval = Math.floor interval * 10

set_ai = (ai_number) ->
  all_ai = [null, ai.monkey, ai.dolphin]
  ai_current = all_ai[ai_number]

window.ai = {
  init,
  activate,
  deactivate,
  set_interval,
  set_ai,
  monkey: null,
  dolphin: null
}