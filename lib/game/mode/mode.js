// Generated by CoffeeScript 2.2.1
(function() {
  window.mode = {
    play_as_host: function() {
      return game.init_host();
    },
    play_as_guest: function() {
      game.init_guest();
      return game.start();
    },
    play_demo: function() {
      game.init_demo();
      gamestate.start_game('white');
      return game.start();
    }
  };

}).call(this);

//# sourceMappingURL=mode.js.map
