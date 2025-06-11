// Sintaxis antigua del 

const os = require('node:os');

console.log("Hay tantos",os.cpus().length, "cpus");
console.log(os.cpus()[0]);
console.log(os.freemem()/1024/1024/1024, "GB");
console.log(os.totalmem()/1024/1024/1024, "GB");
console.log(os.hostname());
console.log(os.release());
console.log(os.userInfo());

