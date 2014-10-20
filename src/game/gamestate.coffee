get_state = ->
  calc.to_string {
    board_state: board.get_state()
    effect_state: effect.get_state()
  }

set_state = (str) ->
  state = calc.from_string str
  board.set_state state.board_state
  effect.set_state state.effect_state

window.gamestate = {
  get_state,
  set_state
}