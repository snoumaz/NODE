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
app.listen(port, () => console.log(`http://localhost:${port}`)) // Iniciar el servidor y mostrar el mensaje en la consola
