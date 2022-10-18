// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

import {Socket} from "phoenix"
let socket = new Socket("/live", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
    .receive("ok", resp => {
      renderComments(resp.comments);
    })
    .receive("error", resp => { console.log("Unable to join", resp) })

  document.querySelector('button').addEventListener('click', () => {
    const content = document.querySelector('textarea').value;

    channel.push('command:add', {content: content});
  });
  };

function renderComments(comments) {
  const renderedComments = comments.map(comment => {
    return `
      <li class="collection-item">
        ${comment.content}
      </li>
    `;
  });
  document.querySelector('.collection').innerHTML = renderedComments.join('');
}

window.createSocket = createSocket;
