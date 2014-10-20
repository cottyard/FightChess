assist_queue = []
attack_queue = []
move_queue = []

on_battle_assist = (evt) ->
  assist_queue.push evt

on_battle_attack = (evt) ->
  attack_queue.push evt

on_battle_move = (evt) ->
  move_queue.push evt

handle_assist_queue = ->
  while assist_queue.length > 0
    handle_assist assist_queue.shift()

handle_attack_queue = ->
  while attack_queue.length > 0
    handle_attack attack_queue.shift()

handle_move_queue = ->
  while move_queue.length > 0
    handle_move move_queue.shift()

handle_assist = (evt) ->
  evt.astee.enhance evt.enhancement

handle_attack = (evt) ->
  evt.atkee.inflict evt.damage

handle_move = (evt) ->
  evt.piece.move_to evt.coord_to

init = ->
  ev.hook 'battle_assist', on_battle_assist
  ev.hook 'battle_attack', on_battle_attack
  ev.hook 'battle_move', on_battle_move
  ev.hook 'assist_round', handle_assist_queue
  ev.hook 'attack_round', handle_attack_queue
  ev.hook 'move_round', handle_move_queue

window.battle = {
  init
}