const http = require("node:http");

const server = http.createServer((req,res)=>{
    console.log("Has realizado una peticion, ha Node.js!!");
});

server.listen(3306,()=>{
    console.log("Servidor se ha levantado en http://localhost:3306");
})