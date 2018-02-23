window.mode = {
  play_as_host: -> 
    game.init_host()

  play_as_guest: -> 
    game.init_guest()
    game.start()

  play_demo: ->
    game.init_demo()
    gamestate.start_game 'white'
    game.start()
}
