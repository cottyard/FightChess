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
  battle_attack {piece_atker, piece_atkee}
  battle_assist {piece_aster, piece_astee}
  battle_move {piece, coord_to}
game
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
    i = hdls.indexOf hdl
    hdls.splice i, 1 unless i is -1

window.ev = {
  trigger,
  hook,
  unhook
}