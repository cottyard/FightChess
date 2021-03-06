// Generated by CoffeeScript 2.2.1
(function() {
  var evaluate_board, evaluate_move, generate_all_moves, pawn_pos_value, super_pawn_pos_value, think_of_one_operation, type_value;

  generate_all_moves = function(board, color) {
    var all_moves, c, coord, i, len, moves, p, ref, x;
    all_moves = [];
    ref = board.all_pieces();
    for (x of ref) {
      [coord, p] = x;
      if (p.color !== color) {
        continue;
      }
      if (!p.can_move()) {
        continue;
      }
      moves = board.get_valid_regular_moves(coord);
      for (i = 0, len = moves.length; i < len; i++) {
        c = moves[i];
        all_moves.push({
          piece: p,
          coord_to: c,
          coord_from: coord
        });
      }
    }
    return all_moves;
  };

  type_value = {
    'pawn': 10,
    'super_pawn': 20,
    'knight': 30,
    'bishop': 30,
    'rook': 30,
    'queen': 30,
    'cannon': 30,
    'king': 0
  };

  pawn_pos_value = {
    white: [null, 0, 5, 4, 3, 2, 0, 0, 0],
    black: [null, 0, 0, 0, 2, 3, 4, 5, 0]
  };

  super_pawn_pos_value = {
    white: [null, 0, 1, 2, 3, 4, 5, 6.5, 0],
    black: [null, 0, 6.5, 5, 4, 3, 2, 1, 0]
  };

  evaluate_board = function(board, color, log = false) {
    var attacked, attacked_coeff, attacking, attacking_coeff, c, coeff, col, dis, distance, e, enemy_king_coord_x, enemy_king_coord_y, enemy_king_hp, i, king_attacked, king_attacking, king_coord_x, king_coord_y, king_hp, len, moves, ours, p, pos_value, ref, ref1, ref2, row, them_defending, us_defending, x, y;
    e = 0;
    attacked = 0;
    attacking = 0;
    them_defending = 0;
    us_defending = 0;
    king_attacked = 0;
    king_attacking = 0;
    king_coord_x = null;
    king_coord_y = null;
    king_hp = null;
    enemy_king_hp = null;
    pos_value = 0;
    enemy_king_coord_x = null;
    enemy_king_coord_y = null;
    ref = board.all_pieces();
    for (x of ref) {
      [[col, row], p] = x;
      ours = p.color === color;
      if (ours) {
        e += type_value[p.type];
        if (p.type === 'pawn') {
          e += pawn_pos_value[color][row];
          pos_value += pawn_pos_value[color][row];
        }
        if (p.type === 'super_pawn') {
          e += super_pawn_pos_value[color][row];
          pos_value += pawn_pos_value[color][row];
        }
        if (p.type === 'king') {
          [king_coord_x, king_coord_y] = [col, row];
          king_hp = p.hp;
        }
      } else {
        if (p.type === 'king') {
          [enemy_king_coord_x, enemy_king_coord_y] = [col, row];
          enemy_king_hp = p.hp;
        }
      }
      moves = board.get_moves([col, row]);
      coeff = ours ? 1 : -1;
      if (p.type === 'queen') {
        e += moves.offensive.length * coeff * 0.2;
      } else {
        e += moves.offensive.length * coeff;
      }
      e -= moves.defensive.length * coeff * 0.5;
      if (ours) {
        attacking += moves.offensive.length;
        us_defending += moves.defensive.length;
      } else {
        attacked += moves.offensive.length;
        them_defending += moves.defensive.length;
      }
      ref1 = moves.offensive;
      for (i = 0, len = ref1.length; i < len; i++) {
        c = ref1[i];
        p = board.get_piece(c);
        switch (p.type) {
          case 'king':
            if (p.color === color) {
              king_attacked += 1;
            } else {
              king_attacking += 1;
            }
            break;
          case 'queen':
            e += p.color === color ? -0.8 : 0.5;
        }
      }
    }
    attacked_coeff = (function() {
      switch (false) {
        case !(king_hp < 100):
          return 5;
        case !(king_hp < 500):
          return 3;
        case !(king_hp < 900):
          return 1.5;
        default:
          return 0.5;
      }
    })();
    attacking_coeff = (function() {
      switch (false) {
        case !(enemy_king_hp < 100):
          return 3;
        case !(enemy_king_hp < 500):
          return 1;
        case !(enemy_king_hp < 900):
          return 0.7;
        default:
          return 0.4;
      }
    })();
    e -= king_attacked * attacked_coeff;
    e += king_attacking * attacking_coeff;
    distance = 7;
    ref2 = board.all_pieces();
    for (y of ref2) {
      [[col, row], p] = y;
      if (p.color !== color) {
        continue;
      }
      if (p.type === 'king') {
        continue;
      }
      dis = Math.max(Math.abs(king_coord_x - col), Math.abs(king_coord_y - row));
      if (dis < distance) {
        distance = dis;
      }
    }
    e -= distance;
    if (log) {
      console.log('=======================================');
      console.log('attacking', attacking, 'attacked', attacked);
      console.log('us_defending', us_defending, 'them_defending', them_defending);
      console.log('king_attacking', king_attacking * attacking_coeff, 'king_attacked', king_attacked * attacked_coeff);
      console.log('king', king_coord_x, king_coord_y);
      console.log('enemy king', enemy_king_coord_x, enemy_king_coord_y);
      console.log('pos', pos_value);
      console.log('king isolation', distance);
      console.log('current', e);
    }
    return e;
  };

  evaluate_move = function(board, color, move) {
    var b;
    b = board.clone();
    b.move_to(move.coord_from, move.coord_to);
    return evaluate_board(b, color);
  };

  think_of_one_operation = function(board, color) {
    var all_moves, current, evaluations, m, max_e;
    current = evaluate_board(board, color);
    all_moves = generate_all_moves(board, color);
    //console.log (String(m[1].coord_to[0])+String(m[1].coord_to[1]) for m in evaluation)
    //console.log (m[0] for m in evaluation)
    evaluations = (function() {
      var i, len, results;
      results = [];
      for (i = 0, len = all_moves.length; i < len; i++) {
        m = all_moves[i];
        results.push([evaluate_move(board, color, m), m]);
      }
      return results;
    })();
    evaluations.sort(function(e1, e2) {
      return e2[0] - e1[0];
    });
    if (evaluations[0] == null) {
      return 'abort';
    }
    [max_e, m] = evaluations[0];
    if (max_e > current) {
      return m;
    } else {
      return 'abort';
    }
  };

  window.ai.dolphin = {think_of_one_operation};

}).call(this);

//# sourceMappingURL=dolphin.js.map
