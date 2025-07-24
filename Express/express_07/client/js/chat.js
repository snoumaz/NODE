// esteroides para el código
import {io} from "https://cdnjs.cloudflare.com/ajax/libs/socket.io/4.8.1/socket.io.esm.min.js";

const formUserName = document.getElementById('formUserName');
let userName = "";
formUserName.addEventListener('submit', (event) => {
    event.preventDefault();
    userName = document.getElementById('userName').value.trim();
    localStorage.setItem('userName', userName);
    formUserName.style.display = 'none';
    document.getElementById('messages').style.display = 'block';
    document.getElementById('formMessage').style.display = 'block';
});

