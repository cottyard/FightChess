channel = null

wrap_data = (type, content) ->
  {
    type,
    content
  }

blob_to_arraybuffer = (blob, cb) ->
  fr = new FileReader();
  fr.onload = (evt) ->
    cb(evt.target.result)
  fr.readAsArrayBuffer(blob)

on_network_out = (type) ->
  (evt) ->
    return unless channel?
    data = BinaryPack.pack(wrap_data type, evt)
    blob_to_arraybuffer(data, (ab) ->
      channel.send ab
    )

set_output_channel = (conn) ->
  channel = conn

init = ->
  ev.hook 'network_out_gamestate', on_network_out 'gamestate'
  ev.hook 'network_out_operation', on_network_out 'operation'

incoming = (data) ->
  data = BinaryPack.unpack data

  switch data.type
    when 'gamestate'
      ev.trigger 'network_in_gamestate', { gamestate: data.content.gamestate, boardstate: data.content.boardstate }
    when 'operation'
      ev.trigger 'network_in_operation', { operation: data.content.operation }


window.network = {
  init,
  incoming,
  set_output_channel
}