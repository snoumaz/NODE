/*
TABLA DE MULTIPLICAR
El usuario indicara que numero desea para la tabla:
node .\04_tabla_multi.js 'N'
Con eso generaremos esta salida por terminal:

Tabla de Multiplicar de N > numero elegido por el usuario
==========================
1 X N = N
.
.
.
10 X N = N
*/
// Importar el módulo 'fs' para operaciones de sistema de archivos
import fs from "node:fs";

// Definir las variables para la tabla de multiplicar a partir de los argumentos de la línea de comandos
const numero = parseInt(process.argv[2]);
const num_inicio= parseInt(process.argv[3]);
const num_fin = parseInt(process.argv[4]);

// Definir la variable para mostrar la tabla de multiplicar
let tabla = `Tabla de Multiplicar de ${numero}\n`;
tabla += "=".repeat(tabla.length -1);

// Generar la tabla de multiplicar desde num_inicio hasta num_fin
for(let i = num_inicio; i <= num_fin; i++) {
    tabla += `\t\n${i} x ${numero} = ${i * numero}`;
}
// Mostrar la tabla de multiplicar en la consola
console.log(tabla);
// Guardar la tabla de multiplicar en un archivo
try{
fs.writeFileSync(`tabla_del_${numero}_inicio_${num_inicio}_fin_${num_fin}.txt`, tabla, "utf-8");
}catch (error) {
    console.log(error);
}
