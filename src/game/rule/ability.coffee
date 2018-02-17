ability_matrix =
                 # atk      atk cd       ast           shield        HP        move cd
  king:        [      8,       10,      [10, 0.3],    [1, 0.1],     180,          30],
  queen:       [      3,       15,       [5, 0.5],   [70, 0.1],      10,          50],
  rook:        [     17,       30,       [3, 0.1],    [3, 0.3],     300,          70],
  bishop:      [     11,       20,       [4, 0.1],    [1, 0.1],     150,          30],
  knight:      [      3,        6,       [2, 0.1],    [2, 0.2],     200,          20],
  pawn:        [      4,       15,       [1, 0.1],      [0, 0],     120,          0], # 40
  super_pawn:  [      4,       15,       [1, 0.1],    [1, 0.1],     125,          0]  # 35

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