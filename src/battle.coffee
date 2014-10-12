assist_queue = []

on_battle_assist = (evt) ->
  assist_queue.push evt
  
handle_assist_queue = ->
  while assist_queue.length > 0
    handle_assist assist_queue.shift()

handle_assist = (evt) ->
  evt.astee.shield_total += evt.enhancement[0]
  evt.astee.shield += evt.enhancement[0]
  evt.astee.shield_heal += evt.enhancement[1]

init = ->
  ev.hook 'battle_assist', on_battle_assist
  ev.hook 'assist_round', handle_assist_queue
      
window.battle = {
  init
}