// Funciones Mayores para Arrays principales
const arrayOriginal = [1,2,3,4,5,6,7]

// Con estas funciones obtendremos otro array que no modifica el array original

// MAP 
// Se utiliza para realizar operacion sobre todos los elementos del array Original.
// Queremos obtener otro array con el doble de los numero dentro del array.
// Devolvera otro array con el mismo numeros de elementos del array original.
// arrayInicial.map(item_que_devuelve => accion)
const arrayMap = arrayOriginal.map(numero => numero *2)
console.log(arrayMap);

// FILTER 
// Filtra los elementos del array Original segun una condicion
// devuelve otro array con los elementos filtrados
// arrayInicial.filter(item_que_devuelve => condicion)
const arrayFilter = arrayOriginal.filter(numero => numero%2 == 0)
console.log(arrayFilter);

// REDUCE
// Devuelve el resultado de una operacion aplicada a todos los valores del array original
// arrayInicial.reduce((acumulador, item) => operacion a realizar)
const resultadoReduce = arrayOriginal.reduce((acumulador, numero) => acumulador + numero)
console.log(resultadoReduce);