// Ejemplo de servidor HTTP con Node.js
// Importar el módulo 'process' para manejar variables de entorno y argumentos de línea de comandos
import http from "node:http";
// Como obtener los datos del .env
process.loadEnvFile();
// El puerto se puede pasar como argumento al ejecutar el script
// Ejemplo: node 07_http_2.js 3000
const puerto = parseInt(process.env.PORT || process.argv[2] || 3306);

// Definir un estilo CSS para la respuesta HTML
const style = `<style>
body { font-family: Arial, sans-serif; background-color: #f4f4f4; color: #333; padding: 20px; }
h1 { color: #4CAF50; }
p { font-size: 16px; }
</style>`;

// Crear un servidor HTTP que maneje diferentes rutas
const server = http.createServer((req, res) => {
    // console.log(res.statusCode);
    // Si la URL solicitada es la raíz del servidor
    if(req.url == "/"){
        // console.log("conectado a la raiz del servidor");
        res.writeHead(200, { "Content-Type": "text/html" }); // Establecer el código de estado 200 (OK) y el tipo de contenido HTML
        res.write("<meta charset='utf-8'>"); // Establecer la codificación de caracteres a UTF-8
        res.write(style); // Incluir el estilo CSS definido anteriormente
        res.write("<h1>Bienvenido a la raiz del servidor</h1>"); // Escribir un encabezado HTML
        res.end(); // Finalizar la respuesta al cliente
        return; // Terminar la ejecución de la función para esta ruta
    }else if(req.url == "/contacto"){ // Si la URL solicitada es /contacto
        res.writeHead(200, { "Content-Type": "text/html" }); // Establecer el código de estado 200 (OK) y el tipo de contenido HTML
        res.write("<meta charset='utf-8'>"); // Establecer la codificación de caracteres a UTF-8
        res.write(style); // Incluir el estilo CSS definido anteriormente
        res.write("<h1>Bienvenido a la pagina de contacto</h1>"); // Escribir un encabezado HTML
        res.end(); // Finalizar la respuesta al cliente
        return; // Terminar la ejecución de la función para esta ruta
        // console.log("conectado a la pagina de contacto");
    }else{ // Si la URL solicitada es desconocida o no coincide con las anteriores
        res.writeHead(404, { "Content-Type": "text/html" }); // Establecer el código de estado 404 (Not Found) y el tipo de contenido HTML
        res.write("<meta charset='utf-8'>"); // Establecer la codificación de caracteres a UTF-8
        res.write(style); // Incluir el estilo CSS definido anteriormente
        res.write("<h1>Pagina no encontrada</h1>"); // Escribir un encabezado HTML indicando que la página no fue encontrada
        res.write("<p>La pagina que buscas no existe.<br>Vuelve pagina de inicio desde aqui.<br> <a href='/'>Volver al inicio🏡</a></p>"); // Incluir un enlace para volver a la página de inicio
        res.end(); // Finalizar la respuesta al cliente
        return; // Terminar la ejecución de la función para esta ruta
    };

    // res.writeHead(200, { "Content-Type": "text/plain" });
    // res.end("Respuesta del servidor");
});
// Iniciar el servidor y escuchar en el puerto especificado
server.listen(puerto, () => {
    console.log(`Servidor se ha levantado en http://localhost:${puerto}`);
});
