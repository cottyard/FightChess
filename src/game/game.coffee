move_round = (board) ->
  ev.trigger_now 'move_round_begin', { board }
  ev.trigger_now 'move_round', { board }
  ev.trigger_now 'move_round_end', { board }

assist_round = (board) ->
  ev.trigger_now 'assist_round_begin', { board }
  ev.trigger_now 'assist_round', { board }
  ev.trigger_now 'assist_round_end', { board }
  
recover_round = (board) ->
  ev.trigger_now 'recover_round_begin', { board }
  ev.trigger_now 'recover_round', { board }
  ev.trigger_now 'recover_round_end', { board }

attack_round = (board) ->
  ev.trigger_now 'attack_round_begin', { board }
  ev.trigger_now 'attack_round', { board }
  ev.trigger_now 'attack_round_end', { board }
  
ai_think_round = (board) ->
  ev.trigger_now 'ai_think_round', { board }

end_of_rounds = (board) ->
  ev.trigger_now 'end_of_rounds', { board }

render_gametick = ->
  shape.clear_canvas ui.ctx.static
  ev.trigger_now 'render', {}

next_gametick = ->
  ev.trigger 'gametick', {}

game_loop_obj = null
start = ->
  return if game_loop_obj?
  game_loop_obj = setInterval next_gametick, 100

stop = ->
  clearInterval game_loop_obj
  game_loop_obj = null

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
  end_of_rounds,
  render_gametick
}