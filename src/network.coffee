my_name = 'zc'
me = null

init = ->
  me = new Peer 'zc', {key: 'e0xgy0whoajor'}
  me.on 'open', on_id_open

on_id_open = (id) ->
  console.log "#{my_name ready}"

wait = ->
  me.on 'connection', (conn) ->
    init_connection conn

connect = (id) ->
  conn = me.connect id
  init_connection conn

init_connection = (conn) ->
  conn.on 'open', ->
    conn.on 'data', (data) ->
      console.log 'there says', data
    conn.send("this is #{my_name} here");

window.network = {
  init,
  wait,
  connect
}