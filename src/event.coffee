###
data structure spec
  pos: [pos_x, pos_y]
  coord: [coord_x, coord_y]

all events:

raw input
  mousedown, mouseup, mousemove {pos}
input operation
  pick, drop, hover {coord}
game operation
  op_movepiece {piece, coord_to}
battle
  battle_attack {piece_atker, piece_atkee, coord_from, coord_to, damage}
  battle_assist {piece_aster, piece_astee, coord_from, coord_to, enhancement}
  battle_heal {piece_healer, piece_healee, coord_from, coord_to, recuperation}
  battle_move {piece, coord_to}
game
  move_round_begin, move_round, move_round_end,
  assist_round_begin, assist_round, assist_round_end, 
  recover_round_begin, recover_round, recover_round_end, 
  attack_round_begin, attack_round, attack_round_end {}
  gametick {}
  render {}
 
###

handlers = {}

trigger = (evt_name, evt) ->
  if handlers[evt_name]?
    for hdl in handlers[evt_name]
      hdl evt

hook = (evt_name, hdl) ->
  unless handlers[evt_name]?
    handlers[evt_name] = []
  handlers[evt_name].push hdl

unhook = (evt_name, hdl) ->
  hdls = handlers[evt_name]
  if hdls?
    calc.remove_item_from_array hdl, hdls

window.ev = {
  trigger,
  hook,
  unhook
}