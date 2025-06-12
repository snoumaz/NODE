// Crear aplicacion en 2 fases
const ingredientes_pizza = require("./ingredientes_pizza.js");
const fs = require("node:fs");

let masas =[]
let ingredientes=[]
for (let i=0;i<ingredientes_pizza.length;i++){
    for(clave in ingredientes_pizza[i]){
        if (clave == "masa"){
            masas.push(ingredientes_pizza[i])
        }else if(clave == "ingrediente"){
            ingredientes.push(ingredientes_pizza[i])
        }
    }
}
//Para ejecutar el programa:
// node 07_pizzeria_1.js

// Paso 1: Mostrar el menu de opciones al usuario
if(process.argv.length ==2){
    let menu = "Pizzeria Nodini\n"
    menu += "*".repeat(menu.length -1);
    menu += "\nNuestras masas (elegir una):"
    for (let i = 0; i <masas.length; i++){
            menu += `\n${i+1}. ${masas[i].masa} a  ${masas[i].precio.toFixed(2)}€`
        }
    menu += "\n\nNuestros Ingredientes(Elige 4 de la lista:"
    for (let i = 0; i < ingredientes.length; i++ ){
        menu += `\n${i+1}. ${ingredientes[i].ingrediente} a  ${ingredientes[i].precio.toFixed(2)}€`
    }
    console.log("\n",menu,"\n");
}else if (process.argv.length == 7){
    const tipoMasa = masas[process.argv[2] -1]
    if (tipoMasa == undefined){
        console.log("Error al elegir la masa");
    }else{
    let total = 0;
    let mensaje = "Has elegido pizza de "
    mensaje += `${tipoMasa.masa} con`
    total += tipoMasa.precio;
    for(let i = 3; i < process.argv.length -1; i++){
        mensaje += `${ingredientes[process.argv[i]-1].ingrediente},`
        total += ingredientes[process.argv[i]-1].precio; 
    }
    mensaje += `y ${ingredientes[process.argv[6]-1].ingrediente}`
    total += ingredientes[process.argv[6]-1].precio;
    // console.log(mensaje,`\nImporte total: ${total.toFixed(2)}€`,"\n\n");
    ticket= `Pizzeria Nodini\n`
    ticket += "*".repeat(ticket.length -1);
    ticket += `\nHas elegido pizza de ${tipoMasa.masa} con los siguientes ingredientes:`
    ticket += `\n${ingredientes[process.argv[3]-1].ingrediente}, coste: ${ingredientes[process.argv[3]-1].precio.toFixed(2)}€`
    ticket += `\n${ingredientes[process.argv[4]-1].ingrediente}, coste: ${ingredientes[process.argv[4]-1].precio.toFixed(2)}€`
    ticket += `\n${ingredientes[process.argv[5]-1].ingrediente}, coste: ${ingredientes[process.argv[5]-1].precio.toFixed(2)}€`
    ticket += `\n${ingredientes[process.argv[6]-1].ingrediente}, coste: ${ingredientes[process.argv[6]-1].precio.toFixed(2)}€`
    ticket += `\n\nImporte total: ${total.toFixed(2)}€\n\n`;
    console.log(ticket);
    fs.writeFileSync("ticket.txt",ticket, "utf-8");
    
    }
    
}

