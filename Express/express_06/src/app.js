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
    connection.query(query, (err, result, fields) => {
        if (err) throw err;
        res.render("index", {result});
        console.log(result);
    });
});

app.get('/peli/:id',(req,res)=>{
    const id = req.params.id
    const query = "SELECT * FROM pelis";
    connection.query(query, (err, result, fields) => {
        if (err) throw err;
        res.render("index", {result});
    res.render()
})
});

// Start server
app.listen(PORT, () => {
    console.log(`Servidor iniciado en http://localhost:${PORT}`);
});
