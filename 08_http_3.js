import http from "node:http";
// Como obtener los datos del .env
process.loadEnvFile();
// El puerto se puede pasar como argumento al ejecutar el script
// Ejemplo: node 07_http_2.js 3000
const puerto = parseInt(process.env.PORT || process.argv[2] || 3306);
let title = "";
let h1 = "";
let p = "";

const server = http.createServer((req, res) => {
    // console.log(res.statusCode);
    if(req.url == "/"){
        // console.log("conectado a la raiz del servidor");
        res.writeHead(200, { "Content-Type": "text/html" });
        title = "Home"
        h1= "<h1>Bienvenido a la raiz del servidor</h1>";
    }else if(req.url == "/contacto"){
        res.writeHead(200, { "Content-Type": "text/html" });
        title = "Contacto"
        h1="<h1>Bienvenido a la pagina de contacto</h1>";
    }else{
        res.writeHead(404, { "Content-Type": "text/html" });
        title = "404 Not Found"
        h1="<h1>Pagina no encontrada</h1>"
        p="<p>La pagina que buscas no existe.<br>Vuelve pagina de inicio desde aqui.<br> <a href='/'>Volver al inicio🏡</a></p>"
        
    };
const html = `<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; color: #333; padding: 20px; }
        h1 { color: #4CAF50; }
        p { font-size: 16px; }
    </style>
</head>
<body>
    ${h1}
    ${p}
</body>
</html>`;
    // res.writeHead(200, { "Content-Type": "text/plain" });
    // res.end("Respuesta del servidor");
    res.end(html);
});
server.listen(puerto, () => {
    console.log(`Servidor se ha levantado en http://localhost:${puerto}`);
});