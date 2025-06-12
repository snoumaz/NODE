// Ejemplo de un servidor HTTP básico en Node.js
const http = require("node:http");

// Crear un servidor HTTP que escuche en el puerto 3306
const server = http.createServer((req,res)=>{
    console.log("Has realizado una peticion, ha Node.js!!");
});

// Configurar la respuesta del servidor
server.listen(3306,()=>{
    console.log("Servidor se ha levantado en http://localhost:3306");
})
