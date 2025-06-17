const express = require('express');
const app = express();
const path = require('node:path')
process.loadEnvFile();
const port = parseInt(process.env.PORT || process.argv[2] || 1234);

app.use(express.static(path.join(__dirname,"public")))

app.get('/', (req, res) => {
    res.send('<h1>Estamos en la pagina inicial o home </h1> <br> <h2>Hola PACO</h2>');
})
app.get('/api', (req, res) =>{
    res.json({"curso": "NODE", "tema": "Express"})
})
app.use((req, res)=>{
    // res.status(404).send("<h2>Error 404: no existe esta ruta</h2>")
    res.status(404).sendFile(path.join(__dirname,"public","404.html"))
})
app.listen(port, () => {
    console.log(`Servidor funcionando en http://localhost:${port}`);
})

