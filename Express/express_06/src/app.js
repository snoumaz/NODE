import express from "express";
import path from "node:path";
import { fileURLToPath } from "url";


// Simulate __dirname in ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Now you can use __dirname for dynamic import
const mysqlModulePath = path.join(__dirname, "..", "mysql", "mysql.js");
const { connection } = await import(`file://${mysqlModulePath}`);

// Optional: Load environment variables
process.loadEnvFile();

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files
app.use(express.static(path.join(__dirname,"..", "public")));

// Set view engine
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "..", "views"));

// Route
app.get('/', (req, res) => {
    const query = "SELECT * FROM pelis";
    let subtitulo = "Todas Las pelis"
    connection.query(query, (err, result, fields) => {
        if (err) throw err;
        res.render("index", {result, subtitulo});
        console.log(result);
    });
});

app.get('/peli/:id',(req,res)=>{
    const id = req.params.id
    const query = `SELECT d.nombre_director, g.nombre_genero,p.fecha,p.titulo_peli,p.valoracion,p.img_peli,p.sinopsis
    FROM directores d
    NATURAL JOIN pelis p
    NATURAL JOIN pelis_generos pg
    NATURAL JOIN generos g
    WHERE p.id_peli = ${id};`;
    connection.query(query, (err, result, fields) => {
        if (err) throw err;
        res.render("peli", {result});
        console.log(result);
})
});

app.get("/genero/:nombre",(req,res)=>{
    let genero = req.params.nombre.replaceAll("-"," ")
    let subtitulo = genero
    const query = `SELECT g.nombre_genero,p.fecha,p.titulo_peli,p.img_peli,p.id_peli
    FROM directores d
    NATURAL JOIN pelis p
    NATURAL JOIN pelis_generos pg
    NATURAL JOIN generos g
    WHERE g.nombre_genero = '${genero}';`;
    connection.query(query, (err, result, fields) => {
        if (err) throw err;
        res.render("index", {result,subtitulo});
        console.log(result);
})

})

// Start server
app.listen(PORT, () => {
    console.log(`Servidor iniciado en http://localhost:${PORT}`);
});
