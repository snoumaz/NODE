function sumar (a, b) {
    return a + b;
}
function restar (a, b) {
    return a - b;
}

export function calculadora( a,b,operacion){
    switch (operacion){
        case "suma" : 
        return sumar(a,b)
        break
    }
    return operacion(a,b)
}
console.log(calculadora(5,10,sumar));