const path = require('node:path') // Importar el módulo path
const express = require('express') // Importar el módulo express
const app = express() // Crear una instancia de express
process.loadEnvFile() // Cargar las variables de entorno desde el archivo .env
const port = process.env.PORT || 1234 // Definir el puerto del servidor, si no está definido en las variables de entorno, usar 1234
const jsonData = require("./ventas.json") // Importar los datos del archivo JSON

app.get('/', (req, res) => res.send('Hello World!'))

// Mostrar datos json
app.get('/api', (req, res) =>{
    // console.log("anyo: ",req.query)
    // Si no hay query, devolver todos los datos
    // /api?year=2020&pais=España > estilo de sintaxis de la petición url
    if (req.query.year && req.query.year == "desc" &&  req.query.pais == "asc"){
        // Crear una copia del array y ordenarlo
        // Primero por año de forma descendente y luego por país de forma ascendente
        let sortedData = [...jsonData]
            .sort((a, b) => b.anyo - a.anyo) // Sort por anyo descendiente
            .sort((a, b) => a.pais.localeCompare(b.pais)); // Sort por pais ascendente

        return res.json(sortedData)
    }
    res.json(jsonData)

    //
})

// Cuando la petcion es 'api/paises' de cada pais el total de las ventas de cada uno
// [{"pais": "Italia","ventas-totales": 2500}, {"pais": "Francia","ventas-totales": 3500}]
app.get('/api/paises', (req, res) => {
    let jsonResultados = []
    let ventaPais ={}
    for(let i = 0; i < jsonData.length; i++ ){
        let pais = jsonData[i].pais
        let venta =jsonData[i].venta
        if(!ventaPais[pais]){
            ventaPais[pais] = 0
        }
        ventaPais[pais] += venta
    }
    for(clave in ventaPais){
        jsonResultados.push({"pais":clave, "ventas-totales": ventaPais[clave]})
    }
    if(jsonResultados.length == 0){
        res.json({"respuesta":"No hay datos en este momento"})
    } else{
    res.json(jsonResultados)
    }
})


// Pero si la ruta es '/api/paises/nombre_pais' dara los datos del Pais.
app.get('/api/paises/:nombrePais', (req, res) => {
    const nombrePais = req.params.nombrePais;
    const resultados = jsonData.filter(item => item.pais.toLowerCase() === nombrePais.toLowerCase());
    if (resultados.length === 0) {
        res.json({ "respuesta": "No hay datos en este momento" });
    } else {
        res.json(resultados);
    }
})

app.get('/api/year/:year',(req,res)=>{
    const year = req.params.year;
    const resultadoYear = jsonData.filter(item => parseInt(item.anyo) === parseInt(year))
    if(resultadoYear.length === 0){
         res.json({ "respuesta": "No hay datos en este momento" });
    }else{
        res.json(resultadoYear);
    }
})

app.get('/api/year/:year/:nombrePais',(req,res)=>{
    const year = req.params.year;
    const resultadoYear = jsonData.filter(item => parseInt(item.anyo) === parseInt(year))
    const nombrePais = req.params.nombrePais;
    const resultados = resultadoYear.filter(item => item.pais.toLowerCase() === nombrePais.toLowerCase());
    if(resultados.length === 0){
         res.json({ "respuesta": "No hay datos en este momento" });
    }else{
        res.json(resultados);
    }

})
app.listen(port, () => console.log(`http://localhost:${port}`)) // Iniciar el servidor y mostrar el mensaje en la consola
