ability_matrix =
                 # atk      atk cd       ast           shield        HP        move cd
  king:        [ [4, 12],       10,      [10, 0.3],    [1, 0.1],     150,          30],
  queen:       [  [2, 4],       15,       [5, 0.5],   [50, 0.1],      10,          50],
  rook:        [[14, 20],       30,       [1, 0.1],    [6, 0.3],     400,          75],
  bishop:      [ [8, 14],       20,       [3, 0.1],    [1, 0.1],     100,          30],
  knight:      [  [1, 4],        5,       [2, 0.1],    [2, 0.2],     200,          20],
  pawn:        [  [3, 5],       15,       [1, 0.1],      [0, 0],     120,          40],
  super_pawn:  [  [3, 5],       15,       [1, 0.1],    [1, 0.1],     125,          35]

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