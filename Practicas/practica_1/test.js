const fs = require("node:fs");
let lectura = fs.readFileSync("test.json","utf-8")
let jsleido = JSON.parse(lectura)

if( process.argv.length ==2){
// Mostrar json
}else if(process.argv.length==3){
    // Mostrar apuntado en la signatura
}else if(process.argv.length==4){
    // Mostar las asignaturas del alumno
}else if(process.argv.length==5){
    // Borrar al alumno en question
}else if(process.argv.length==6){
    // inscrivi al usuario
}else{
    // Mensaje de error
}

const test =[
    {
        "nombre": "Peter",
        "apellido": "Parker",
        "edad": "25",
        "asignatura": "PHP"
    },{
        "nombre": "Jason",
        "apellido": "Momoa",
        "edad": "45",
        "asignatura": "python"
    },
    {
        "nombre": "Bruce",
        "apellido": "Lee",
        "edad": "80",
        "asignatura": "css"
    },
    {
        "nombre": "Bruce",
        "apellido": "Lee",
        "edad": "80",
        "asignatura": "PHP"
    },
    {
        "nombre": "Peter",
        "apellido": "Parker",
        "edad": "25",
        "asignatura": "CSS"
    }
]

fs.writeFileSync("test.json", JSON.stringify(test),"utf-8");


// console.log(jsleido);


let objeto = {
        "nombre": "Bruce",
        "apellido": "Lee",
        "edad": "80",
        "asignatura": "html"
    }

test.push(objeto)
// console.log(test);

let borrado={"nombre":"Bruce", "apellido":"Lee","edad": -1}
if (borrado.edad == -1){
for(let i = test.length -1;i >=0; i--){
//  console.log(test[i]);
 if(test[i].nombre == borrado.nombre && test[i].apellido==borrado.apellido ){
    test.splice(i,1)
 }
 fs.writeFileSync("test.json", JSON.stringify(test),"utf-8")
}
}
console.log(test);