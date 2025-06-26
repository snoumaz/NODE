// ==========================================
// SCRIPT DEL PANEL DE ADMINISTRACIÓN
// ==========================================
// JavaScript del lado cliente para manejar las operaciones CRUD
// en el panel de administración de viajes

// ==========================================
// SELECCIÓN DE ELEMENTOS DOM
// ==========================================
// Obtener referencias a las secciones principales del formulario
const sectionInsert = document.getElementById("insert");    // Sección para insertar nuevos viajes
const sectionUpdate = document.getElementById("update");    // Sección para actualizar viajes existentes
sectionUpdate.style.display = "none";                      // Ocultar inicialmente la sección de actualización
const dataUpdate = document.getElementById("dataUpdate");   // Formulario de actualización

// ==========================================
// FUNCIÓN DELETE - Eliminar viaje
// ==========================================
/**
 * Elimina un viaje específico enviando petición DELETE al servidor
 * @param {string} id - ID único del viaje a eliminar
 */
function deleteTravel(id) {
  // console.log(id);  // Debug: mostrar ID del viaje a eliminar

  // Enviar petición HTTP DELETE al endpoint del servidor
  fetch(`/delete/${id}`, {
    method: "DELETE",
  })
    .then((response) => {
      // Procesar respuesta del servidor (JSON con mensaje de confirmación)
      response.json();
    })
    .then((data) => {
      // Recargar la página para mostrar los cambios actualizados
      location.reload();
    })
    .catch((err) => console.log(err));  // Manejar errores de la petición
}

// ==========================================
// FUNCIÓN EDIT - Preparar formulario para edición
// ==========================================
/**
 * Prepara y muestra el formulario de edición con los datos del viaje seleccionado
 * @param {string} travel - String JSON con los datos del viaje a editar
 */
function editTravel(travel) {
  // Cambiar visibilidad de secciones: ocultar inserción, mostrar edición
  sectionInsert.style.display = "none";
  sectionUpdate.style.display = "block";

  // Convertir string JSON recibido a objeto JavaScript
  const newTravel = JSON.parse(travel);
  // console.log(newTravel.id);  // Debug: mostrar ID del viaje a editar

  // Llenar formulario de edición con los datos actuales del viaje
  document.getElementById("update_id").value = newTravel.id;                    // ID (oculto, no editable)
  document.getElementById("update_ruta").value = newTravel.ruta;                // Ruta URL del viaje
  document.getElementById("update_nombre").value = newTravel.nombre;            // Nombre del paquete
  document.getElementById("update_descripcion").value = newTravel.descripcion;  // Descripción detallada
  document.getElementById("update_precio").value = newTravel.precio;            // Precio del viaje
  document.getElementById("update_lugar").value = newTravel.lugar;              // Lugar de destino
  document.getElementById("update_img").value = newTravel.img;                  // URL de la imagen
}

// ==========================================
// EVENT LISTENER - Manejo del formulario de actualización
// ==========================================
// Escuchar el evento submit del formulario de actualización
dataUpdate.addEventListener("submit", (event) => {
  // Prevenir comportamiento por defecto del formulario (recarga de página)
  event.preventDefault();
  // console.log(dataUpdate);  // Debug: mostrar formulario completo

  // ==========================================
  // PROCESAMIENTO DE DATOS DEL FORMULARIO
  // ==========================================
  // Extraer datos del formulario usando FormData API
  const formData = new FormData(dataUpdate);
  // Convertir FormData a objeto JavaScript plano
  const datosFormulario = Object.fromEntries(formData);
  console.log(datosFormulario);  // Debug: mostrar datos del formulario

  // ==========================================
  // MÉTODO ALTERNATIVO COMENTADO (para referencia)
  // ==========================================
  // Alternativa manual para limpiar nombres de campos:
  // let newObject = {}
  // for (clave in datosFormulario) {
  //   const claveLimpia = clave.replace("update_", "");
  //   newObject[claveLimpia] = datosFormulario[clave]
  // }
  // console.log(newObject);

  // ==========================================
  // TRANSFORMACIÓN DE DATOS PARA EL SERVIDOR
  // ==========================================
  // Convertir objeto a JSON y limpiar prefijos "update_" de los nombres de campo
  let newString = JSON.stringify(datosFormulario).replaceAll('update_', "")
  // console.log(newString);  // Debug: mostrar JSON final

  // ==========================================
  // ENVÍO DE PETICIÓN PUT AL SERVIDOR
  // ==========================================
  fetch(`update/${datosFormulario.update_id}`, {
    method: "PUT",                                    // Método HTTP PUT para actualización
    headers: { "content-type": "application/json" }, // Indicar que enviamos JSON
    body : newString                                  // Datos del viaje actualizado en JSON
  })
  .then( response => response.text())  // Procesar respuesta como texto
  .then( result => {
    console.log(result);  // Debug: mostrar respuesta del servidor
    location.reload()     // Recargar página para mostrar cambios
  })
  .catch (err => console.log("Error:", err))  // Manejar errores de la petición
});
