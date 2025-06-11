const path = require('node:path');
// Separador de carpetas
console.log(path.sep);

const ruta_inventada = path.join("proyect","public","css","styles.css")
console.log(ruta_inventada);

// Obtener el nombre y extension del fichero
console.log(path.basename(ruta_inventada));

// Obtener la ruta de las carpetas que contienen los ficheros
console.log(path.dirname(ruta_inventada));