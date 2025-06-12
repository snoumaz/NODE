// Crear aplicacion en 2 fases

const pizza =[
{"tipo":"Cuatro Quesos","precio":18.00},
{"tipo":"Margjerita","precio":16.00},
{"tipo":"Napolitana","precio":17.25},
{"tipo":"Diavola","precio":16.50}
]

//Para ejecutar el programa:
// node 07_pizzeria_1.js
let mensaje = "";
if (process.argv.length==2){
    // Primera fase mostar sin agumentos
    mensaje = "\nPizzeria Nodini\n"
    mensaje += "*".repeat(mensaje.length -2)
    // Bucle
    for (let i = 0; i <pizza.length; i++){
        mensaje += `\n\t${i+1}. Pizza ${pizza[i].tipo} a ${pizza[i].precio.toFixed(2)}€`
    } 
    mensaje += "\n¿Cuál es su elección?\n\n";
} else if(process.argv.length==3){
    let indice = process.argv[2]
    mensaje = `\nHa elegido: ${pizza[indice - 1].tipo}. Importe: ${pizza[indice - 1].precio.toFixed(2)} `
} else{
    mensaje = "\nDemasiado argumentos al realizar su comanda."
}

console.log(mensaje,"\n\n");

