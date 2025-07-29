// esteroides para el código
import {io} from "https://cdnjs.cloudflare.com/ajax/libs/socket.io/4.8.1/socket.io.esm.min.js";
// ...existing code...

const formUserName = document.getElementById('formUserName');
const form = document.getElementById('form');
const input = document.getElementById('message');
const messages = document.getElementById('messages');
let userName = ""; // Guardar el nombre de usuario actual 
let socket 
let userColors = {}; // Guardar el nombre de usuario

function getRandomColor() {
    const hue = Math.floor(Math.random() * 360);
    return `hsl(${hue}, 70%, 85%)`;
}

formUserName.addEventListener('submit', (event) => {
    event.preventDefault();
    userName = document.getElementById('userName').value.trim();
    userColors[userName] = getRandomColor();
    formUserName.querySelector('input, button').disabled = true;
    if (!socket) {
        socket = io({
            auth: {
                serverOffset: 0,
                userName
            }
        });
        socket.on('chatMessage', (msg, usuarioMensaje) => {
            if(!userColors[usuarioMensaje]) {
                userColors[usuarioMensaje] = getRandomColor();
            }
            const isOwn = usuarioMensaje === userName;
            const color = userColors[usuarioMensaje];
            let item = `<li class="message ${isOwn ? ' own' : ' other'}">`;
            item += `<span class="user" style="background: ${color}">${usuarioMensaje} :</span><br>`;
            item += `<span class="msg${isOwn ? ' own' : ''}">${msg}</span></li>`;
            messages.innerHTML += item;
            messages.scrollTop = messages.scrollHeight;
        });
    }

});

form.addEventListener('submit', (event) => {
    event.preventDefault();
    if (input.value && socket) {
        socket.emit('chatMessage', input.value, userName);
        input.value = '';
    }
});

