me = null

peer_error_callbacks = {}

peer_error_handler = (err) ->
  console.log err
  peer_error_callbacks[err.type]?(err)

wait = (callback) ->
  me.on 'connection', (conn) ->
    init_connection conn
    callback conn.peer

connect = (id, callback_success, callback_failure) ->
  conn = me.connect id
  conn.on 'open', ->
    init_connection conn
    callback_success()
  peer_error_callbacks['peer-unavailable'] = ->
    callback_failure()

init_connection = (conn) ->
  conn.on 'data', (data) ->
    network.incoming data
  network.set_output_channel conn

login = (id, callback_success, callback_failure) ->
  me = new Peer id, {key: '6l7puzc60rgujtt9'}
  me.on 'open', (id) ->
    callback_success()
  me.on 'error', peer_error_handler
  peer_error_callbacks['network'] = ->
    me = null
    callback_failure()

window.peer_server = {
  wait,
  connect,
  login
}
