assist_queue = []
attack_queue = []
move_queue = []

on_battle_assist = (evt) ->
  assist_queue.push evt

on_battle_attack = (evt) ->
  attack_queue.push evt

on_battle_move = (evt) ->
  move_queue.push evt

handle_assist_queue = (evt) ->
  while assist_queue.length > 0
    handle_assist evt.board, assist_queue.shift()

handle_attack_queue = (evt) ->
  while attack_queue.length > 0
    handle_attack evt.board, attack_queue.shift()

handle_move_queue = (evt) ->
  while move_queue.length > 0
    handle_move evt.board, move_queue.shift()

handle_assist = (board, evt) ->
  evt.astee.assist evt.assistance, evt.heal

handle_attack = (board, evt) ->
  hurt = evt.atkee.inflict evt.damage
  if hurt
    ev.trigger 'piece_hurt', {
      piece: evt.atkee, 
      coord: evt.coord_to
    }

handle_move = (board, evt) ->
  board.move_to evt.coord_from, evt.coord_to
  ev.trigger 'piece_move', {
    piece: evt.piece,
    coord_from: evt.coord_from,
    coord_to: evt.coord_to
  }

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