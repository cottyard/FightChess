// Generated by CoffeeScript 2.2.1
(function() {
  var assist_queue, attack_queue, handle_assist, handle_assist_queue, handle_attack, handle_attack_queue, handle_move, handle_move_queue, init, move_queue, on_battle_assist, on_battle_attack, on_battle_move;

  assist_queue = [];

  attack_queue = [];

  move_queue = [];

  on_battle_assist = function(evt) {
    return assist_queue.push(evt);
  };

  on_battle_attack = function(evt) {
    return attack_queue.push(evt);
  };

  on_battle_move = function(evt) {
    return move_queue.push(evt);
  };

  handle_assist_queue = function(evt) {
    var results;
    results = [];
    while (assist_queue.length > 0) {
      results.push(handle_assist(evt.board, assist_queue.shift()));
    }
    return results;
  };

  handle_attack_queue = function(evt) {
    var results;
    results = [];
    while (attack_queue.length > 0) {
      results.push(handle_attack(evt.board, attack_queue.shift()));
    }
    return results;
  };

  handle_move_queue = function(evt) {
    var results;
    results = [];
    while (move_queue.length > 0) {
      results.push(handle_move(evt.board, move_queue.shift()));
    }
    return results;
  };

  handle_assist = function(board, evt) {
    return evt.astee.assist(evt.assistance, evt.heal);
  };

  handle_attack = function(board, evt) {
    var hurt;
    hurt = evt.atkee.inflict(evt.damage);
    if (hurt) {
      return ev.trigger('piece_hurt', {
        piece: evt.atkee,
        coord: evt.coord_to
      });
    }
  };

  handle_move = function(board, evt) {
    return board.move_to(evt.coord_from, evt.coord_to);
  };

  init = function() {
    ev.hook('battle_assist', on_battle_assist);
    ev.hook('battle_attack', on_battle_attack);
    ev.hook('battle_move', on_battle_move);
    ev.hook('assist_round', handle_assist_queue);
    ev.hook('attack_round', handle_attack_queue);
    return ev.hook('move_round', handle_move_queue);
  };

  window.battle = {init};

}).call(this);

//# sourceMappingURL=battle.js.map
