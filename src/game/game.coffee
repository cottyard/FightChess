move_round = ->
  ev.trigger_now 'move_round_begin', {}
  ev.trigger_now 'move_round', {}
  ev.trigger_now 'move_round_end', {}

assist_round = ->
  ev.trigger_now 'assist_round_begin', {}
  ev.trigger_now 'assist_round', {}
  ev.trigger_now 'assist_round_end', {}
  
recover_round = ->
  ev.trigger_now 'recover_round_begin', {}
  ev.trigger_now 'recover_round', {}
  ev.trigger_now 'recover_round_end', {}

attack_round = ->
  ev.trigger_now 'attack_round_begin', {}
  ev.trigger_now 'attack_round', {}
  ev.trigger_now 'attack_round_end', {}
  
ai_think_round = ->
  ev.trigger_now 'ai_think_round', {}

render_gametick = ->
  shape.clear_canvas ui.ctx.static
  ev.trigger_now 'render', {}

next_gametick = ->
  ev.trigger 'gametick', {}

game_loop_obj = null
start = ->
  game_loop_obj = setInterval next_gametick, 100

stop = ->
  clearInterval game_loop_obj

window.game = {
  start,
  stop,
  init_demo: null,
  init_host: null,
  init_guest: null,
  init_observer: null,

  move_round,
  assist_round,
  recover_round,
  attack_round,
  ai_think_round,
  render_gametick
}