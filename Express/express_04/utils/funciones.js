// ==========================================
// FUNCIONES UTILITARIAS PARA GESTIÓN DE VIAJES
// ==========================================
// Módulo que contiene funciones reutilizables para operaciones CRUD
// sobre el archivo JSON de viajes

// ==========================================
// DEPENDENCIAS
// ==========================================
const fs = require("node:fs");        // Sistema de archivos para leer/escribir archivos
const path = require("node:path");    // Utilidades para manejar rutas de archivos

// ==========================================
// FUNCIÓN DELETE - Eliminar elemento por ID
// ==========================================
/**
 * Elimina un viaje del array basándose en su ID único
 * @param {Array} jsonData - Array de objetos con todos los viajes
 * @param {string} idParam - ID único del viaje a eliminar
 * @returns {Array} - Nuevo array sin el elemento eliminado
 */
function deleteItem(jsonData, idParam){
    // Filtrar el array excluyendo el elemento con el ID especificado
    return jsonData.filter(travel => travel.id != idParam)
}

// ==========================================
// FUNCIÓN WRITE - Guardar datos en archivo JSON
// ==========================================
/**
 * Guarda el array de viajes actualizado en el archivo travels.json
 * @param {Array} jsonData - Array de objetos con todos los viajes actualizados
 */
function writeTravelsJson(jsonData){
    fs.writeFileSync(
        // Construir ruta: desde /utils subir un nivel (..) y acceder a /data/travels.json
        path.join(__dirname, "..", "data", "travels.json"),
        // Convertir array JavaScript a JSON con formato legible (indentación de 2 espacios)
        JSON.stringify(jsonData, null, 2),
        // Codificación de caracteres UTF-8 para soportar acentos y caracteres especiales
        "utf8"
      );
}

// ==========================================
// FUNCIÓN INSERT - Agregar nuevo viaje
// ==========================================
/**
 * Procesa y agrega un nuevo viaje al array de datos
 * @param {Array} jsonData - Array de objetos con todos los viajes existentes
 * @param {Object} newTravel - Objeto con datos del nuevo viaje a agregar
 * @returns {Array} - Array actualizado con el nuevo viaje incluido
 */
function insertItem(jsonData, newTravel){
    // VALIDACIÓN DE RUTA: Asegurar que la ruta comience con "/"
    if (newTravel.ruta[0] != "/") {
        newTravel.ruta = "/"+newTravel.ruta
    }

    // CONVERSIÓN DE DATOS: Convertir precio de string a número decimal
    newTravel.precio = parseFloat(newTravel.precio)

    // GENERACIÓN DE ID ÚNICO: Crear identificador único usando crypto
    const crypto = require('node:crypto')
    newTravel.id = crypto.randomUUID()

    // INSERCIÓN: Agregar el nuevo viaje al final del array
    jsonData.push(newTravel)

    // Retornar el array actualizado
    return jsonData
}

// ==========================================
// EXPORTACIÓN DE FUNCIONES
// ==========================================
// Hacer disponibles las funciones para otros módulos de la aplicación
module.exports ={deleteItem, writeTravelsJson,insertItem}
