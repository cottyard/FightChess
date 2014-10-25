me = null
connection = null

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
    handle_network_in data
  connection = conn

login = (id, callback_success, callback_failure) ->
  me = new Peer id, {key: '6l7puzc60rgujtt9'}
  me.on 'open', (id) ->
    callback_success()
  me.on 'error', peer_error_handler
  peer_error_callbacks['network'] = ->
    me = null
    callback_failure()

handle_network_in = (data) ->
  switch data.type
    when 'gamestate'
      ev.trigger 'network_in_gamestate', {gamestate: data.content}
    when 'operation'
      ev.trigger 'network_in_operation', {operation: data.content}

wrap_data = (type, content) ->
  {
    type,
    content
  }

on_network_out = (type, content_name) ->
  (evt) ->
    return unless connection?
    connection.send wrap_data type, evt[content_name]

init = ->
  ev.hook 'network_out_gamestate', on_network_out 'gamestate', 'gamestate'
  ev.hook 'network_out_operation', on_network_out 'operation', 'operation'

window.network = {
  init,

  wait,
  connect,
  login
}