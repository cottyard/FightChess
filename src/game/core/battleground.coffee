init = ->
  battleground.instance = new board.Board(true)
  battleground.instance.set_out_board()
  ev.hook 'end_of_rounds', on_end_of_rounds
  ev.hook 'render', on_render

on_end_of_rounds = (evt) ->
  wk = battleground.instance.count_piece 'king', 'white'
  bk = battleground.instance.count_piece 'king', 'black'
  if wk is 0 and bk is 0
    ev.trigger_now 'game_end', { result: 'draw' }
  else if wk is 0
    ev.trigger_now 'game_end', { result: 'win', player: 'black' }
  else if bk is 0
    ev.trigger_now 'game_end', { result: 'win', player: 'white' }

on_render = (evt) ->
  paint.board ui.ctx.static

get_state = ->
  board.serialize battleground.instance

set_state = (buffer) ->
  board.deserialize buffer, battleground.instance

window.battleground = {
  init,
  instance: null,
  get_state,
  set_state
}
