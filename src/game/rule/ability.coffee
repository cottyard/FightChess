ability_matrix =
                 # atk      atk cd       ast           shield        hp       move cd     heals     self-heal
  king:        [      3,        5,       [2, 0.1],    [3, 0.3],    1000,          60,      0.1,         0.1]
  queen:       [      3,       20,       [10,  0],   [50, 0.1],     100,          50,      0.1,         0.3]
  rook:        [     20,       30,       [1, 0.1],    [3, 0.1],     600,         120,        0,           0]
  bishop:      [     12,       20,       [1, 0.1],    [1, 0.1],     450,          60,        0,           0]
  knight:      [      3,        6,       [1, 0.1],    [1, 0.1],     400,          50,        0,           0]
  pawn:        [      6,       12,       [1, 0.1],      [0, 0],     240,          80,        0,           0]
  super_pawn:  [      7,       15,       [1, 0.1],      [0, 0],     300,          70,        0,           0]

raw_data_to_attr = (data) ->
  'atk': data[0],
  'atk_cd': data[1],
  'ast': data[2],
  'shield': data[3][0],
  'shield_heal': data[3][1],
  'hp': data[4],
  'move_cd': data[5],
  'heal': data[6],
  'self_heal': data[7]

for p of ability_matrix
  ability_matrix[p] = raw_data_to_attr ability_matrix[p]

window.rule.ability = ability_matrix
