const express = require('express')
const app = express()
process.loadEnvFile() // Cargar las variables de entorno desde el archivo .env
const path = require('node:path') // Importar el módulo path
const port = process.env.PORT || 3000 // Definir el puerto del servidor, si no está definido en las variables de entorno, usar 3000

app.get('/', (req, res) => res.send('¡Hola Mundo!'))
app.listen(port, () => console.log(`http://localhost:${port}`))
