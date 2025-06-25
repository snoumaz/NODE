// Importaciones
const express = require('express')
const app = express()
const path = require('node:path') // Importar el módulo path
const fs = require('node:fs')
const cryto = require('node:crypto')

// Carga de .ENV
process.loadEnvFile() // Cargar las variables de entorno desde el archivo .env
const port = process.env.PORT || 3000 // Definir el puerto del servidor, si no está definido en las variables de entorno, usar 3000

// Middlewares
// ruta de los ficheros estaticos de public
app.use(express.static(path.join(__dirname,"public")));
app.use(express.static(path.join(__dirname,"data")));

// Informar a express de cual es el motor de las plantillas
app.set("view engine","ejs")
app.set("views", path.join(__dirname,"views"))

// Recodificar los datos enviado desde el formulario
app.use(express.urlencoded({extended:true}))
app.use(express.json())

// Cargar los datos
const jsonData = require('./data/travels.json')
jsonData.forEach(travel =>{
    // Rutas
    app.get(`${travel.ruta}`, (req, res) =>{ 
    res.render('layout',{
        "lugar":`${travel.lugar}`,
        "nombre":`${travel.nombre}`,
        "descripcion": `${travel.descripcion}`,
        "precio": `${travel.precio}`,
        "img": `${travel.img}`,
        "id": `${travel.id}`,
        "travels": jsonData
    })
})
})

app.get('/admin',(req,res) =>{
    res.render("admin",{jsonData})
})

app.post('/insert',(req,res)=>{
// console.log(req.body);
    let newTravel = req.body
    if(newTravel.ruta[0]!="/"){
        newTravel.ruta = "/"+newTravel.ruta
    }
    newTravel.precio = parseFloat(newTravel.precio)
    newTravel.id = cryto.randomUUID()
    jsonData.push(newTravel)
    // console.log(jsonData);
    fs.writeFileSync(path.join(__dirname,"data","travels.json"),JSON.stringify(jsonData, null, 2), "utf8")
    res.redirect("/admin")
})

app.put("/update/:id", (req, res) => {
    // console.log(req.params.id);
    // console.log(req.body);
    const idUpdate = req.params.id
    const travelChanged = req.body

    const newData = jsonData.filter(travel => travel.id != idChange)

    if (travelChanged.ruta[0] != "/") travelChanged.ruta = "/" + travelChanged.ruta    
    // El precio viene del formulario como string, hay que pasarlo a número
    travelChanged.precio = parseFloat(travelChanged.precio)
    newData.push(travelChanged)
    console.log(newData)
    fs.writeFileSync(path.join(__dirname, "data", "travels.json"), JSON.stringify(newData, null, 2), "utf-8")
    res.redirect("/admin")
})

app.delete("/delete/:id", (req, res) => {
    const idDelete = req.params.id;
    // Filtra los viajes que no coinciden con el id a eliminar
    const newJsonData = jsonData.filter(travel => travel.id != idDelete);
    // Actualiza el archivo
    fs.writeFileSync(path.join(__dirname, "data", "travels.json"),
        JSON.stringify(newJsonData, null, 2),
        "utf-8"
    );
    // Actualiza el array en memoria
    jsonData.length = 0;
    newJsonData.forEach(travel => jsonData.push(travel));
    res.json({ });
});

// Middleware para manejar rutas no existentes y mostrar /404
app.use((req, res) => {
    res.status(404).redirect('/404');
});

// Ruta para mostrar la página 404
app.get('/404', (req, res) => {
    res.status(404).render('404');
});


app.listen(port, () => console.log(`Servidor iniciado en http://localhost:${port}`))