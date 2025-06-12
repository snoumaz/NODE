// Módulo nativo de Node.js para manejar rutas de archivos
const path = require('node:path');
// Separador de carpetas
console.log(path.sep);

// Unir rutas de archivos, es decir, crear una ruta completa multiplataforma
const ruta_inventada = path.join("proyect","public","css","styles.css")
console.log(ruta_inventada);

// Obtener el nombre y extension del fichero
console.log(path.basename(ruta_inventada));

// Obtener la ruta de las carpetas que contienen los ficheros
console.log(path.dirname(ruta_inventada));
