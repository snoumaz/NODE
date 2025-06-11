
const fs = require("node:fs");

// let texto = "En un lugar de la mancha cuyo nombre no puedo acordarme. Porque no me acuerdo.\n"
// fs.writeFileSync("prueba.txt",texto, "utf-8");

// let append = "Si los se no me se el texto."
// fs.appendFileSync("prueba.txt",append, "utf-8");

// let append2 = "\t McPollo\n"
// fs.appendFileSync("prueba.txt",append2, "utf-8");

// let prueba=fs.readFileSync("prueba.txt","utf-8");
// console.log(prueba);

// if (fs.existsSync("temp")) {
//     fs.rmdirSync("temp");
//     console.log("Directorio 'temp' eliminado.");
// }
// fs.mkdirSync("temp");

// fs.truncateSync("prueba.txt", 0, (err) => {
//     if (err) {
//         console.error("Error al truncar el archivo:", err);
//     } else {
//         console.log("Archivo truncado exitosamente.");
//     }
// });

fs.mkdirSync("temp/temp2", { recursive: true });
fs.mkdirSync("temp/temp1",{ recursive: true });