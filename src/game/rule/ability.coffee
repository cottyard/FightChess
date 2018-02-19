ability_matrix =
                 # atk      atk cd       ast           shield        HP       move cd     heals     self-heal
  king:        [      3,        5,       [3, 0.3],    [5, 0.5],    1000,          60,      0.2,         0.2],
  queen:       [      3,       20,       [2, 0.2],      [0, 0],     200,         100,      0.1,         0.5],
  rook:        [     20,       30,       [1, 0.1],    [3, 0.1],     600,         140,        0,           0],
  bishop:      [     10,       20,       [1, 0.1],    [1, 0.1],     400,          60,        0,           0],
  knight:      [      3,        6,       [1, 0.1],    [1, 0.1],     400,          40,        0,           0],
  pawn:        [      6,       12,       [1, 0.1],      [0, 0],     240,          80,        0,           0],
  super_pawn:  [      7,       15,       [1, 0.1],      [0, 0],     300,          70,        0,           0]

raw_data_to_attr = (data) ->
  'atk': data[0],
  'atk_cd': data[1],
  'ast': data[2],
  'shield': data[3][0],
  'shield_heal': data[3][1],
  'hp': data[4],
  'move_cd': data[5]

for p of ability_matrix
  ability_matrix[p] = raw_data_to_attr ability_matrix[p]

window.rule.ability = ability_matrix