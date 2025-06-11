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
import fs from "node:fs";

const numero = parseInt(process.argv[2]);
const num_inicio= parseInt(process.argv[3]);
const num_fin = parseInt(process.argv[4]);
let tabla = `Tabla de Multiplicar de ${numero}\n`;
tabla += "=".repeat(tabla.length -1);

for(let i = num_inicio; i <= num_fin; i++) {
    tabla += `\t\n${i} x ${numero} = ${i * numero}`;
}
console.log(tabla);
try{
fs.writeFileSync(`tabla_del_${numero}_inicio_${num_inicio}_fin_${num_fin}.txt`, tabla, "utf-8");
}catch (error) {
    console.log(error);
}