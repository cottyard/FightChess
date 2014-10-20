// Generated by CoffeeScript 1.8.0
(function() {
  var Assist, Attack, Hurt, effects_assist, effects_attack, effects_hurt, get_state, init, on_battle_assist, on_battle_attack, on_piece_hurt, render_all, render_effects, set_state;

  Assist = (function() {
    function Assist(coord_from, coord_to) {
      this.coord_from = coord_from;
      this.coord_to = coord_to;
    }

    Assist.prototype.render = function(ctx) {
      var to_x, to_y, x, y, _ref, _ref1, _ref2;
      _ref = calc.shrink_segment(calc.coord_to_pos(this.coord_from), calc.coord_to_pos(this.coord_to)), (_ref1 = _ref[0], x = _ref1[0], y = _ref1[1]), (_ref2 = _ref[1], to_x = _ref2[0], to_y = _ref2[1]);
      shape.save_style(ctx);
      shape.set_style(ctx, shape.style_blue_tp);
      shape.arrow(ctx, x, y, to_x, to_y);
      return shape.restore_style(ctx);
    };

    Assist.prototype.next_frame = function() {
      return false;
    };

    return Assist;

  })();

  Attack = (function() {
    function Attack(coord_from, coord_to) {
      this.coord_from = coord_from;
      this.coord_to = coord_to;
      this.transparency = 1;
    }

    Attack.prototype.render = function(ctx) {
      var to_x, to_y, x, y, _ref, _ref1, _ref2;
      _ref = calc.shrink_segment(calc.coord_to_pos(this.coord_from), calc.coord_to_pos(this.coord_to)), (_ref1 = _ref[0], x = _ref1[0], y = _ref1[1]), (_ref2 = _ref[1], to_x = _ref2[0], to_y = _ref2[1]);
      shape.save_style(ctx);
      shape.set_style(ctx, "rgba(255, 0, 0, " + this.transparency + ")");
      ctx.lineWidth = 3;
      shape.arrow(ctx, x, y, to_x, to_y, 10);
      return shape.restore_style(ctx);
    };

    Attack.prototype.next_frame = function() {
      this.transparency -= 0.2;
      if (this.transparency >= 0.2) {
        return true;
      } else {
        return false;
      }
    };

    return Attack;

  })();

  Hurt = (function() {
    function Hurt(coord) {
      this.coord = coord;
      this.transparency = 0.3;
    }

    Hurt.prototype.render = function(ctx) {
      var x, y, _ref;
      shape.save_style(ctx);
      shape.set_style(ctx, "rgba(255, 0, 0, " + this.transparency + ")");
      _ref = calc.coord_to_pos(this.coord), x = _ref[0], y = _ref[1];
      shape.rectangle(ctx, x - settings.half_grid_size, y - settings.half_grid_size, settings.grid_size, settings.grid_size, true);
      return shape.restore_style(ctx);
    };

    Hurt.prototype.next_frame = function() {
      this.transparency -= 0.1;
      if (this.transparency >= 0.1) {
        return true;
      } else {
        return false;
      }
    };

    return Hurt;

  })();

  effects_assist = [];

  effects_attack = [];

  effects_hurt = [];

  on_battle_assist = function(evt) {
    return effects_assist.push(new Assist(evt.coord_from, evt.coord_to));
  };

  on_battle_attack = function(evt) {
    return effects_attack.push(new Attack(evt.coord_from, evt.coord_to));
  };

  on_piece_hurt = function(evt) {
    return effects_hurt.push(new Hurt(evt.coord));
  };

  render_effects = function(ctx, effects) {
    var e, i, to_be_continued, _i, _len;
    for (i = _i = 0, _len = effects.length; _i < _len; i = ++_i) {
      e = effects[i];
      e.render(ctx);
      to_be_continued = e.next_frame();
      if (!to_be_continued) {
        effects[i] = null;
      }
    }
    return effects.filter(function(e) {
      return e != null;
    });
  };

  render_all = function() {
    var ctx;
    ctx = ui.ctx["static"];
    effects_assist = render_effects(ctx, effects_assist);
    effects_attack = render_effects(ctx, effects_attack);
    return effects_hurt = render_effects(ctx, effects_hurt);
  };

  init = function() {
    ev.hook('battle_assist', on_battle_assist);
    ev.hook('battle_attack', on_battle_attack);
    ev.hook('piece_hurt', on_piece_hurt);
    return ev.hook('render', render_all);
  };

  get_state = function() {
    return calc.to_string({
      assist: effects_assist,
      attack: effects_attack,
      hurt: effects_hurt
    });
  };

  set_state = function(str) {
    var e, state;
    state = calc.from_string(str);
    effects_assist = (function() {
      var _i, _len, _ref, _results;
      _ref = state.assist;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        e = _ref[_i];
        _results.push(calc.set_type(e, Assist));
      }
      return _results;
    })();
    effects_attack = (function() {
      var _i, _len, _ref, _results;
      _ref = state.attack;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        e = _ref[_i];
        _results.push(calc.set_type(e, Attack));
      }
      return _results;
    })();
    return effects_hurt = (function() {
      var _i, _len, _ref, _results;
      _ref = state.hurt;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        e = _ref[_i];
        _results.push(calc.set_type(e, Hurt));
      }
      return _results;
    })();
  };

  window.effect = {
    init: init,
    get_state: get_state,
    set_state: set_state
  };

}).call(this);