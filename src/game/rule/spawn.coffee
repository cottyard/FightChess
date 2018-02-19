spawn_cd_by_piece_count = (
  cd * 10 \
  for cd in [
    5,5,5,6,7,
    8,9,10,12,14,
    16,18,20,22,25])

get_sapwn_cd = (piece_count) ->
  if piece_count < 1 or piece_count > 16
    throw "invalid piece count"
  spawn_cd_by_piece_count[piece_count - 1]

window.rule.spawn = { 
  spawn_cd: get_sapwn_cd
}