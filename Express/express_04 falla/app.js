// Importaciones
const express = require("express");
const app = express();
const path = require("node:path"); // Importar el módulo path
const fs = require("node:fs");
const cryto = require("node:crypto");
const {deleteItem, writeTravelsJson} = require('./utils/funciones')

// Carga de .ENV
process.loadEnvFile(); // Cargar las variables de entorno desde el archivo .env
const port = process.env.PORT || 3000; // Definir el puerto del servidor, si no está definido en las variables de entorno, usar 3000

// Middlewares
// ruta de los ficheros estaticos de public
app.use(express.static(path.join(__dirname, "public")));
app.use(express.static(path.join(__dirname, "data")));

// Informar a express de cual es el motor de las plantillas
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

// Recodificar los datos enviado desde el formulario
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Cargar los datos
const jsonDataInicial = require("./data/travels.json");
const jsonData = jsonDataInicial.sort((a, b) =>
  a.lugar.localeCompare(b.lugar, "es-ES", { numeric: true })
);
jsonData.forEach((travel) => {
  // Rutas
  app.get(`${travel.ruta}`, (req, res) => {
    res.render("layout", {
      lugar: `${travel.lugar}`,
      nombre: `${travel.nombre}`,
      descripcion: `${travel.descripcion}`,
      precio: `${travel.precio}`,
      img: `${travel.img}`,
      id: `${travel.id}`,
      travels: jsonData,
    });
  });
});

app.get("/admin", (req, res) => {
  res.render("admin", { jsonData });
});

app.post("/insert", (req, res) => {
  // console.log(req.body);
  let newTravel = req.body;
  if (newTravel.ruta[0] != "/") {
    newTravel.ruta = "/" + newTravel.ruta;
  }
  newTravel.precio = parseFloat(newTravel.precio);
  newTravel.id = cryto.randomUUID();
  jsonData.push(newTravel);
  // console.log(jsonData);
  fs.writeFileSync(
    path.join(__dirname, "data", "travels.json"),
    JSON.stringify(jsonData, null, 2),
    "utf8"
  );
  res.redirect("/admin");
});

// Agujero negro
// app.put("/update/:id", (req, res) => {
//     const idUpdate = req.params.id;
//     const body = req.body;
//     const newJsonData = jsonData.filter(travel => travel.id != idUpdate);
//     body.precio = parseFloat(body.precio)
//     newJsonData.push(body)
//     fs.writeFileSync(path.join(__dirname, "data", "travels.json"),
//         JSON.stringify(jsonData, null, 2),
//         "utf-8"
//     )
//     res.send("Edita el fichero tu, que yo paso!!")
// });

// Up
app.put("/update/:id", (req, res) => {
  const idUpdate = req.params.id;
  const body = req.body;
  for (travel of jsonData) {
    if (travel.id == idUpdate) {
      for (clave in travel) {
        travel[clave] = body[clave];
      }
      break;
    }
  }
  console.log(jsonData);
  fs.writeFileSync(
    path.join(__dirname, "data", "travels.json"),
    JSON.stringify(jsonData, null, 2),
    "utf-8"
  );
  res.send("Todo ok!!");
});

app.delete("/delete/:id", (req, res) => {
  const idDelete = req.params.id;
  // Filtra los viajes que no coinciden con el id a eliminar
  // const newJsonData = jsonData.filter((travel) => travel.id != idDelete);
  // Actualiza el archivo
  const newJsonData = deleteItem(jsonData,idDelete)
  fs.writeFileSync(
    path.join(__dirname, "data", "travels.json"),
    JSON.stringify(newJsonData, null, 2),
    "utf-8"
  );
  // Actualiza el array en memoria
  jsonData.length = 0;
  newJsonData.forEach((travel) => jsonData.push(travel));
  res.json({});
});

// Middleware para manejar rutas no existentes y mostrar /404
app.use((req, res) => {
  res.status(404).render("404");
});

// Ruta para mostrar la página 404
// app.get('/404', (req, res) => {
//     res.status(404).render('404');
// });

app.listen(port, () =>
  console.log(`Servidor iniciado en http://localhost:${port}`)
);
