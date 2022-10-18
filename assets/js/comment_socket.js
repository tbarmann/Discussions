// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

import {Socket} from "phoenix"
let socket = new Socket("/live", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("comments:1", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
