###
all events:

pick, drop, hover {
  coord: [coord_x, coord_y]
}

mousedown, mouseup, mousemove {
  pos: [pos_x, pos_y]
}

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

window.ev = {
  trigger,
  hook
}