const express = require('express')
const app = express()
process.loadEnvFile() // Cargar las variables de entorno desde el archivo .env
const path = require('node:path') // Importar el módulo path
const port = process.env.PORT || 3000 // Definir el puerto del servidor, si no está definido en las variables de entorno, usar 3000
// ruta de los ficheros estaticos de public
app.use(express.static(path.join(__dirname,"public")));
// Informar a express de cual es el motor de las plantillas
app.set("view engine","ejs")
app.set("views", "./views")

// Rutas
app.get('/', (req, res) =>{ 
    res.send('¡Todo OK!')
})
app.get('/alumnos',(req,res) =>{
    res.render("alumnos",{"h1":"Titulo enviado desde la ruta", "titulo": "Alumnos de clase Ferran"})
})
app.get('/cursos',(req,res)=> {
    res.render("cursos",{"h1":"Cursos disponibles", "titulo": "Cursos EJS"})
})



app.use( (req, res) =>{ 
    res.status(404).sendFile(path.join(__dirname,"public","404.html"))
})
app.listen(port, () => console.log(`Servidor iniciado en http://localhost:${port}`))
