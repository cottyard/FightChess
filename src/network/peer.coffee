data = {
  'status': ['host', 'begin']
  'connection',
  'channel'
}

inputs = {
  'role_btn',
  'local_offer_btn',
  'local_answer_btn',
  'status',
  'send_txt',
  'chat'
}

change_status = (status) ->
  data.status = status
  [type, phase] = status
  status_binds[type][phase]()

status_binds =
  'host':
    'begin': ->
      enable inputs.local_offer_btn
      hide inputs.local_answer_btn
      inputs.status.value = 'Please send your offer to your peer.'
    'pending': ->
      enable inputs.local_offer_btn
      hide inputs.local_answer_btn
      inputs.status.value = 'Please paste the answer you received from your peer.'
    'connected': ->
      hide inputs.local_offer_btn
      hide inputs.local_answer_btn
      inputs.status.value = 'You are connected to your peer.'
  'guest':
    'begin': ->
      hide inputs.local_offer_btn
      disable inputs.local_answer_btn
      inputs.status.value = 'Please paste the offer you received from your peer.'
    'pending': ->
      hide inputs.local_offer_btn
      enable inputs.local_answer_btn
      inputs.status.value = 'Please send the answer to your peer.'
    'connected': ->
      hide inputs.local_offer_btn
      hide inputs.local_answer_btn
      inputs.status.value = 'You are connected to your peer.'

init = ->
  for i of inputs
    inputs[i] = document.getElementById i
  change_status data.status
  data.connection = new RTCPeerConnection({iceServers: [{urls: []}]});
  init_data_channel data.connection
  data.connection.ondatachannel = receive_data_channel
  document.addEventListener 'paste', remote_onpaste

enable = (btn) ->
  btn.style.display = ''
  btn.disabled = false

disable = (btn) ->
  btn.style.display = ''
  btn.disabled = true

hide = (btn) ->
  btn.style.display = 'none'

set_clipboard = (message) ->
  dummy = document.createElement "input"
  document.body.appendChild dummy
  dummy.setAttribute "value", message
  dummy.select()
  document.execCommand "copy"
  console.log "copied" + dummy.value
  document.body.removeChild dummy

get_clipboard = (evt) ->
  evt.clipboardData.getData('Text')

init_data_channel = (conn) ->
  data.channel = conn.createDataChannel 'data'
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
    console.log 'chat channel is open', e
    [type, phase] = data.status
    change_status [type, 'connected']
  
  data_channel.onmessage = (e) ->
    console.log 'received' + e.data
    inputs.chat.innerHTML = inputs.chat.innerHTML + "<pre>"+ e.data + "</pre>"

  data_channel.onclose = ->
    console.log 'chat channel closed'

err_handler = (err) ->
  console.log err

send_message = ->
  text = inputs.send_txt.value
  chat.innerHTML = chat.innerHTML + "<pre class=sent>" + text + "</pre>"
  data.channel.send text
  inputs.send_txt.value = ""

window.peer = {
  init,
  change_status,
  local_offer_onclick,
  local_answer_onclick,
  send_message
}
