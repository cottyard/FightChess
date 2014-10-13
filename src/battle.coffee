assist_queue = []
attack_queue = []

on_battle_assist = (evt) ->
  assist_queue.push evt

on_battle_attack = (evt) ->
  attack_queue.push evt

handle_assist_queue = ->
  while assist_queue.length > 0
    handle_assist assist_queue.shift()

handle_attack_queue = ->
  while attack_queue.length > 0
    handle_attack attack_queue.shift()

handle_assist = (evt) ->
  evt.astee.enhance evt.enhancement

handle_attack = (evt) ->
  evt.atkee.inflict evt.damage

init = ->
  ev.hook 'battle_assist', on_battle_assist
  ev.hook 'battle_attack', on_battle_attack
  ev.hook 'assist_round', handle_assist_queue
  ev.hook 'attack_round', handle_attack_queue
      
window.battle = {
  init
}