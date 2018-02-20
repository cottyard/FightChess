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
  op_movepiece {piece, coord_from, coord_to}
battle
  battle_attack {piece_atker, piece_atkee, coord_from, coord_to, damage}
  battle_assist {piece_aster, piece_astee, coord_from, coord_to, assistance}
  battle_heal {piece_healer, piece_healee, coord_from, coord_to, recuperation}
  battle_move {piece, coord_from, coord_to}
game
  move_round_begin { board }, move_round { board }, move_round_end { board }
  assist_round_begin { board }, assist_round { board }, assist_round_end { board }
  recover_round_begin { board }, recover_round { board }, recover_round_end { board }
  attack_round_begin { board }, attack_round { board }, attack_round_end { board }
  end_of_rounds { board }
  ai_think_round { board }
  gametick {}
  render {}
  game_end { result: draw/win, player }
  game_start {}
piece state
  piece_die { piece, coord }
  piece_hurt { piece, coord }
network
  network_out_gamestate { gamestate, boardstate }
  network_out_operation { operation }
  network_in_gamestate { gamestate, boardstate }
  network_in_operation { operation }
###

handlers = {}
dispatching = no
event_queue = []
halted = no

trigger = (evt_name, evt) ->
  event_queue.push [evt_name, evt]
  if not dispatching # the event being dispatched may trigger other events
    dispatching = yes
    dispatch_queue()
    dispatching = no

trigger_now = (evt_name, evt) ->
  event_queue.push [evt_name, evt]
  dispatch_queue()

dispatch_queue = ->
  unless halted
    while event_queue.length > 0
      dispatch_one_event_from_queue()

dispatch_one_event_from_queue = ->
  [evt_name, evt] = event_queue.shift()
  dispatch_event evt_name, evt

dispatch_event = (evt_name, evt) ->
  hdls = handlers[evt_name]
  if hdls?
    # some handlers may be unhooked during the invocation,
    # so make a copy of all handlers first before invoking them.
    for hdl in calc.copy_array hdls 
      hdl evt

hook = (evt_name, hdl) ->
  unless handlers[evt_name]?
    handlers[evt_name] = []
  if handlers[evt_name].indexOf hdl is -1
    handlers[evt_name].push hdl

unhook = (evt_name, hdl) ->
  hdls = handlers[evt_name]
  if hdls?
    calc.remove_item_from_array hdl, hdls

init = ->
  handlers = {}
  dispatching = no 
  event_queue = []

halt = ->
  halted = yes

resume = ->
  halted = no

window.ev = {
  init,
  trigger,
  trigger_now,
  hook,
  unhook,
  halt,
  resume
}