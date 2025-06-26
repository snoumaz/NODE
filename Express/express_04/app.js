// ==========================================
// DEPENDENCIAS DEL PROYECTO
// ==========================================
const fs = require("node:fs");                    // Sistema de archivos para leer/escribir archivos
const path = require("node:path");                // Utilidades para trabajar con rutas de archivos
const crypto = require('node:crypto')             // Para generar IDs únicos aleatorios
const express = require("express");               // Framework web para Node.js (sintaxis CommonJS)
const app = express();                            // Crear instancia de la aplicación Express
const {deleteItem, writeTravelsJson,insertItem} = require('./utils/funciones') // Funciones utilitarias personalizadas

// ==========================================
// CONFIGURACIÓN DEL SERVIDOR
// ==========================================
process.loadEnvFile();                           // Cargar variables de entorno desde archivo .env
const PORT = process.env.PORT;                   // Obtener puerto desde variables de entorno

// ==========================================
// MIDDLEWARE - CONFIGURACIONES GLOBALES
// ==========================================
// Servir archivos estáticos (CSS, JS, imágenes) desde la carpeta 'public'
app.use(express.static(path.join(__dirname, "public")));

// Configurar EJS como motor de plantillas para renderizar vistas dinámicas
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

// Middleware para procesar datos de formularios HTML (application/x-www-form-urlencoded)
app.use(express.urlencoded({extended: true}))
// Middleware para procesar datos JSON en las peticiones
app.use(express.json())

// ==========================================
// CARGA Y PREPARACIÓN DE DATOS
// ==========================================
// Cargar datos de viajes desde archivo JSON
const jsonDataInicial = require("./data/travels.json");
// Ordenar los datos alfabéticamente por lugar (campo 'lugar') en español
const jsonData = jsonDataInicial.sort( (a, b) => a.lugar.localeCompare(b.lugar, "es", {numeric:true}))

// ==========================================
// RUTAS DINÁMICAS PARA CADA VIAJE
// ==========================================
// Crear una ruta GET específica para cada viaje basada en su campo 'ruta'
jsonData.forEach(travel => {
  // Crear ruta dinámica: ej. /madrid, /barcelona, etc.
  app.get(`${travel.ruta}`, (req, res) => {
    // Renderizar plantilla 'travels.ejs' pasando datos del viaje específico
    res.render("travels", {
        "lugar" : `${travel.lugar}`,           // Nombre del lugar de destino
        "nombre" : `${travel.nombre}`,         // Nombre del paquete de viaje
        "descripcion" : `${travel.descripcion}`, // Descripción detallada del viaje
        "precio" : `${travel.precio}`,         // Precio del paquete
        "img" : `${travel.img}`,               // Imagen representativa del destino
        "id" : `${travel.id}`,                 // ID único del viaje
        "travels" : jsonData                   // Array completo de todos los viajes (para navegación)
    });
  });
});

// ==========================================
// RUTA ADMINISTRATIVA
// ==========================================
// Ruta para acceder al panel de administración
app.get("/admin", (req, res) => {
    // Renderizar vista de administración con todos los datos de viajes
    res.render("admin", {jsonData})
})

// ==========================================
// API REST - OPERACIONES CRUD
// ==========================================

// ==========================================
// CREATE - Crear nuevo viaje
// ==========================================
app.post("/insert", (req, res) => {
    // console.log(req.body);  // Debug: mostrar datos recibidos del formulario

    // Obtener datos del nuevo viaje desde el cuerpo de la petición
    let newTravel = req.body

    // Usar función utilitaria para procesar e insertar el nuevo viaje
    // Esta función se encarga de: validar ruta, convertir precio, generar ID, y agregar al array
    insertItem(jsonData, newTravel)

    // console.log(jsonData);  // Debug: mostrar array actualizado

    // Guardar datos actualizados en el archivo JSON
    writeTravelsJson(jsonData)

    // Redireccionar de vuelta al panel de administración
    res.redirect("/admin")
})

// ==========================================
// DELETE - Eliminar viaje existente
// ==========================================
app.delete("/delete/:id", (req, res) => {
  // Obtener ID del viaje a eliminar desde los parámetros de la URL
  const idDelete = req.params.id
  // console.log("El id es", idDelete);  // Debug: mostrar ID a eliminar

  // Usar función utilitaria para filtrar y eliminar el elemento con el ID especificado
  const newJsonData = deleteItem(jsonData,idDelete)

  // Guardar el array filtrado en el archivo JSON
  writeTravelsJson(newJsonData)

  // Sincronizar el array local en memoria con los datos actualizados
  // Vaciar el array actual y llenarlo con los nuevos datos
  jsonData.length = 0
  newJsonData.forEach( travel => {
    jsonData.push(travel)
  })

  // Responder con JSON confirmando la eliminación exitosa
  res.json({"mensaje": "elemento borrado correctamente"})

  // setTimeout(() => res.json({"mensaje": "elemento borrado correctamente"}), 200)  // Alternativa con delay

})

// ==========================================
// UPDATE - Actualizar viaje existente
// ==========================================
app.put("/update/:id", (req, res) => {
  // Obtener ID del viaje a actualizar desde los parámetros de la URL
  const idUpdate = req.params.id
  // Obtener nuevos datos desde el cuerpo de la petición
  const body = req.body
  // console.log(body);  // Debug: mostrar datos a actualizar

  // Buscar el viaje específico en el array y actualizar sus propiedades
  for ( travel of jsonData) {
    if (travel.id == idUpdate) {
      // Actualizar cada propiedad del objeto con los nuevos valores
      for (clave in travel) {
        if(clave === 'precio') {
          // Si la clave es 'precio', convertirla a número flotante
          travel[clave] = parseFloat(body[clave])
        } else {
          // Actualizar la propiedad con el nuevo valor del cuerpo de la petición
          travel[clave] = body[clave]
        }
      }
      break  // Salir del bucle una vez encontrado y actualizado el elemento
    }
  }

  console.log(jsonData);  // Debug: mostrar array completo actualizado

  // Guardar datos actualizados en el archivo JSON
  writeTravelsJson(jsonData)

  // Confirmar actualización exitosa
  res.send("todo OK")

})

// ==========================================
// INICIAR SERVIDOR
// ==========================================
// Poner el servidor a escuchar en el puerto especificado
app.listen(PORT, () => {
  console.log(`Servidor levantado en http://localhost:${PORT}`);
});
