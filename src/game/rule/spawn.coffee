spawn_cd_by_piece_count = (
  cd * 10 \
  for cd in [
    10,10,10,12,14,
    16,18,20,24,28,
    32,36,40,44,50])

get_sapwn_cd = (piece_count) ->
  if piece_count < 1 or piece_count > 16
    throw "invalid piece count"
  spawn_cd_by_piece_count[piece_count - 1]

window.rule.spawn = { 
  spawn_cd: get_sapwn_cd
}