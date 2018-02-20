spawn_cd_by_piece_count = (
  cd * 10 \
  for cd in [
    5,6,8,12,14,
    16,18,20,25,30,
    35,40,45,50,55,60])

get_sapwn_cd = (piece_count) ->
  if piece_count < 1 or piece_count > 16
    throw "invalid piece count"
  spawn_cd_by_piece_count[piece_count - 1]

window.rule.spawn = { 
  spawn_cd: get_sapwn_cd
}