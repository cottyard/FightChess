my_id = null
me = null
peer = null

wait = (callback) ->
  me.on 'connection', (conn) ->
    init_connection conn, callback conn.peer

connect = (id, callback) ->
  conn = me.connect id
  conn.on 'open', ->
    init_connection conn, callback

init_connection = (conn, callback) ->
  conn.on 'data', (data) ->
    ev.trigger 'network_in', {data}
  ev.hook 'network_out', (evt) -> send_data conn, evt.data
  callback()

send_data = (conn, data) ->
  conn.send data

login = (id, callback) ->
  me = new Peer id, {host: 'localhost', port: '9000'}
  me.on 'open', (id) ->
    my_id = id
    callback()

window.network = {
  wait,
  connect,
  login
}