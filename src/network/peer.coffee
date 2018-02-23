data = {
  'status': ['host', 'begin']
  'connection',
  'channel'
}

change_status = (status) ->
  data.status = status
  [type, phase] = status
  status_binds[type][phase]()

status_binds =
  'host':
    'begin': ->
      ui.enable ui.local_offer_btn
      ui.hide ui.local_answer_btn
      ui.p2p_status.value = 'Please copy and send your offer to your peer.'
    'pending': ->
      ui.enable ui.local_offer_btn
      ui.hide ui.local_answer_btn
      ui.p2p_status.value = 'Please paste the answer you received from your peer below.'
    'connected': ->
      ui.hide ui.local_offer_btn
      ui.hide ui.local_answer_btn
      ui.hide ui.radio_host
      ui.hide ui.radio_guest
      ui.hide ui.p2p_paste
      ui.p2p_status.value = 'You are connected to your peer as the host.'
  'guest':
    'begin': ->
      ui.hide ui.local_offer_btn
      ui.disable ui.local_answer_btn
      ui.p2p_status.value = 'Please paste the offer you received from your peer below.'
    'pending': ->
      ui.hide ui.local_offer_btn
      ui.enable ui.local_answer_btn
      ui.p2p_status.value = 'Please copy and send the answer to your peer.'
    'connected': ->
      ui.hide ui.local_offer_btn
      ui.hide ui.local_answer_btn
      ui.hide ui.radio_host
      ui.hide ui.radio_guest
      ui.hide ui.p2p_paste
      ui.p2p_status.value = 'You are connected to your peer as the guest.'

init = ->
  ui.hide ui.account_panel
  ui.enable ui.p2p_panel

  change_status data.status
  data.connection = new RTCPeerConnection({iceServers: [{urls: []}]});
  init_data_channel data.connection
  data.connection.ondatachannel = receive_data_channel
  ui.p2p_paste.addEventListener 'paste', remote_onpaste

set_clipboard = (message) ->
  dummy = document.createElement "input"
  document.body.appendChild dummy
  dummy.setAttribute "value", message
  dummy.select()
  document.execCommand "copy"
  document.body.removeChild dummy

get_clipboard = (evt) ->
  evt.clipboardData.getData('Text')

init_data_channel = (conn) ->
  data.channel = conn.createDataChannel 'data'
  console.log data.channel.binaryType
  hook_data_channel data.channel

receive_data_channel = (e) ->
  console.log 'received channel', e
  data.channel = e.channel
  hook_data_channel data.channel

create_local_offer = ->
  data.connection.createOffer().then (des) =>
    data.connection.setLocalDescription(des)
    .catch err_handler
  .catch err_handler

local_offer_onclick = ->
  sdp = null
  create_local_offer().then () =>
    sdp = JSON.stringify data.connection.localDescription
  setTimeout (() => set_clipboard sdp), 1000
  change_status ['host', 'pending']

remote_onpaste = (evt) ->
  [type, phase] = data.status
  
  if type is 'host' and phase is 'pending'
    answer_remote get_clipboard evt
  
  if type is 'guest' and phase is 'begin'
    answer_remote get_clipboard evt
    change_status ['guest', 'pending']

local_answer_onclick = ->
  set_clipboard JSON.stringify data.connection.localDescription

answer_remote = (remote_sdp) ->
  remote_des = new RTCSessionDescription JSON.parse remote_sdp
  data.connection.setRemoteDescription(remote_des).then =>
    data.connection.createAnswer().then (des) =>
      data.connection.setLocalDescription(des)
      .catch err_handler
    .catch err_handler
  .catch err_handler

hook_data_channel = (data_channel) ->
  data_channel.onopen = (e) ->
    console.log 'channel is open', e
    [type, phase] = data.status
    change_status [type, 'connected']
    network.set_output_channel data_channel
    if data.status[0] is 'guest'
      mode.play_as_guest()
    else
      mode.play_as_host()
  
  data_channel.onmessage = (e) ->
    network.incoming e.data

  data_channel.onclose = ->
    console.log 'channel closed'

err_handler = (err) ->
  console.log err

window.peer = {
  init,
  change_status,
  local_offer_onclick,
  local_answer_onclick,
  remote_onpaste
}
