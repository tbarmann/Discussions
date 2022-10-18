// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

import {Socket} from "phoenix"
let socket = new Socket("/live", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
}

window.createSocket = createSocket;
