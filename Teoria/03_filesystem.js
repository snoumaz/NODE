// File System Operations in Node.js
// Importar el módulo 'fs' para operaciones de sistema de archivos
const fs = require("node:fs");

// Craear un archivo y escribir en él
let texto = "En un lugar de la mancha cuyo nombre no puedo acordarme. Porque no me acuerdo.\n"
fs.writeFileSync("prueba.txt",texto, "utf-8");

// Añadir texto al archivo existente
let append = "Si los se no me se el texto."
fs.appendFileSync("prueba.txt",append, "utf-8");

// Añadir más texto al archivo existente
let append2 = "\t McPollo\n"
fs.appendFileSync("prueba.txt",append2, "utf-8");

// Leer el contenido del archivo
let prueba=fs.readFileSync("prueba.txt","utf-8");
console.log(prueba);

// Comprobar si el archivo existe y entonces eliminarlo
if (fs.existsSync("temp")) {
    fs.rmdirSync("temp");
    console.log("Directorio 'temp' eliminado.");
}
// Crear un directorio temporal
fs.mkdirSync("temp");

// Vaciar el contenido del archivo
fs.truncateSync("prueba.txt", 0, (err) => {
    if (err) {
        console.error("Error al truncar el archivo:", err);
    } else {
        console.log("Archivo truncado exitosamente.");
    }
});

// Crear subdirectorios dentro del directorio temporal
fs.mkdirSync("temp/temp2", { recursive: true });
fs.mkdirSync("temp/temp1",{ recursive: true });

// Mover un archivo a un directorio específico
fs.renameSync("prueba.txt", "temp/prueba.txt");

// Leer el contenido del directorio temporal
let contenidoTemp = fs.readdirSync("temp");
console.log("Contenido del directorio 'temp':", contenidoTemp);

// Eliminar el directorio temporal y su contenido
fs.rmdirSync("temp", { recursive: true });
console.log("Directorio 'temp' eliminado.");

// Eliminar un archivo específico
fs.unlinkSync("temp/prueba.txt");
console.log("Archivo 'prueba.txt' eliminado.");
