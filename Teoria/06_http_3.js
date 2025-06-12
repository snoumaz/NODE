// Ejemplo de servidor HTTP con Node.js
// Importar el módulo http de Node.js
import http from "node:http";
// Como obtener los datos del .env
process.loadEnvFile();
// El puerto se puede pasar como argumento al ejecutar el script
// Ejemplo: node 07_http_2.js 3000
const puerto = parseInt(process.env.PORT || process.argv[2] || 3306);
let title = "";
let h1 = "";
let p = "";

// Crear un servidor HTTP que maneje diferentes rutas
const server = http.createServer((req, res) => {
    // console.log(res.statusCode);
    if(req.url == "/"){ // Si la URL solicitada es la raíz del servidor
        // console.log("conectado a la raiz del servidor");
        res.writeHead(200, { "Content-Type": "text/html" }); // Establecer el código de estado 200 (OK) y el tipo de contenido HTML
        title = "Home" // Titulo de la pagina
        h1= "<h1>Bienvenido a la raiz del servidor</h1>"; // Escribir un encabezado HTML
    }else if(req.url == "/contacto"){ // Si la URL solicitada es /contacto
        res.writeHead(200, { "Content-Type": "text/html" }); // Establecer el código de estado 200 (OK) y el tipo de contenido HTML
        title = "Contacto" // Titulo de la pagina
        h1="<h1>Bienvenido a la pagina de contacto</h1>"; // Escribir un encabezado HTML
    }else{
        res.writeHead(404, { "Content-Type": "text/html" }); // Establecer el código de estado 404 (Not Found) y el tipo de contenido HTML
        title = "404 Not Found" // Titulo de la pagina
        h1="<h1>Pagina no encontrada</h1>"; // Escribir un encabezado HTML
        p="<p>La pagina que buscas no existe.<br>Vuelve pagina de inicio desde aqui.<br> <a href='/'>Volver al inicio🏡</a></p>"; // Incluir un enlace para volver a la página de inicio
    };
    // Definir el contenido HTML de la respuesta
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
    // Mostrar el encabezado HTML según la ruta solicitada
    ${h1}
    // Mostrar el párrafo HTML según la ruta solicitada
    ${p}
</body>
</html>`;
    // res.writeHead(200, { "Content-Type": "text/plain" });
    // res.end("Respuesta del servidor");
    res.end(html); // Finalizar la respuesta al cliente con el contenido HTML generado
});
// Iniciar el servidor y escuchar en el puerto especificado
server.listen(puerto, () => {
    console.log(`Servidor se ha levantado en http://localhost:${puerto}`);
});
