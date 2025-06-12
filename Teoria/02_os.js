// Sintaxis de importación de módulos en Node.js Version 12 y posteriores
// Importar el módulo 'os' para acceder a información del sistema operativo
const os = require('node:os');

// Muestra información del sistema operativo CPUs, memoria, hostname, etc.
console.log("Hay tantos",os.cpus().length, "cpus");
console.log(os.cpus()[0]);
console.log(os.freemem()/1024/1024/1024, "GB");
console.log(os.totalmem()/1024/1024/1024, "GB");
console.log(os.hostname());
console.log(os.release());
console.log(os.userInfo());

