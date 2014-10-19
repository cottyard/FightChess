tick_count = 0

on_gametick = ->
  tick_count++
  console.log 'tick', tick_count if tick_count % 100 is 0

logging_evts = ['pick', 'drop', 'battle_move']

init = ->
  ev.hook 'gametick', on_gametick
  for evt_name in logging_evts
    ev.hook evt_name, do (evt_name) -> (evt) -> console.log evt_name, evt

window.log = {
  init
}