// Importamos los módulos necesarios
import express from 'express';
// Importamos la conexión a la base de datos
import { connection } from './sql/conexion.js'; 
// Cargamos las variables de entorno desde el archivo .env
process.loadEnvFile();
// Importamos la conexión a la base de datos
const app = express(); 
// Configuramos el puerto del servidor
const PORT = process.env.PORT || 3002;
// console.log(PORT); Muestra el puerto en la consola
// Ruta de los ficheros estáticos
// app.use(express.static(process.cwd() + 'public'));
app.use(express.static('public'));

// Rutas de la API
app.get('/', (req, res) => {
    // Enviamos el archivo index.html como respuesta a la ruta raíz
    res.sendFile('index.html', { root: './public' });
});

// Ruta para obtener todos los alumnos
// Esta ruta responde a las peticiones GET en /alumnos
app.get('/alumnos', (req, res) => {
    // Consulta SQL para obtener todos los alumnos
    const query = 'SELECT * FROM alumno'; 
    // Realizamos una consulta a la base de datos para obtener todos los alumnos
    connection.query( query, (error, results) => {
        if (error) {// Si hay un error, lo lanzamos
        // Si la consulta es exitosa, enviamos los resultados como respuesta        
        return res.status(500).json({ error: 'Error al obtener los alumnos' });
        }
        // Enviamos los resultados como respuesta
            res.json(results);
        });
    });


app.get('/alumnos/:apellido1', (req, res) => {
    const apellido1 = req.params.apellido1; // Obtenemos el apellido1 de los parámetros de la URL y lo convertimos a mayúsculas
    // Realizamos una consulta a la base de datos para obtener el alumno con el apellido1
    // Usamos ? para evitar inyección SQL y concatenamos el comodín %
    const query = "SELECT * FROM alumno WHERE apellido1 LIKE ? ORDER BY apellido1, apellido2 ASC"; // Consulta SQL para obtener el alumno por apellido1
    // Ejecutamos la consulta con el apellido1 proporcionado
    connection.query(query, [`${apellido1}%`], (error, results) => {
        // Si hay un error, lo lanzamos
        // Si la consulta es exitosa, enviamos los resultados como respuesta
        if (error) {
            // Si hay un error, respondemos con un estado 500 y un mensaje de error
            return res.status(500).json({ error: 'Error al obtener el alumno' });
        }
        // Si no se encuentra ningún alumno, respondemos con un estado 404 y un mensaje de error
        if (results.length === 0) {
            // Si no se encuentra el alumno, respondemos con un estado 404 y un mensaje de error
            return res.status(404).json({ message: 'Alumno no encontrado' });
        }
        // Si la consulta es exitosa, enviamos los resultados como respuesta
        res.json(results);
    });
});

// Apellidoprofe/nombreprofe -> nombre , apellido y las asignaturas que imparte
app.get('/profesor/:apellido1/:nombre', (req, res) => {
    const apellido1 = req.params.apellido1; // Obtenemos el apellido1 de los parámetros de la URL
    const nombre = req.params.nombre; // Obtenemos el nombre1 de los parámetros de la URL
    // Realizamos una consulta a la base de datos para obtener el profesor con el apellido1 y nombre1
    // Usamos ? para evitar inyección SQL y concatenamos el comodín %
    const query = "SELECT a.nombre FROM profesor p INNER JOIN impartir i ON p.idProfesor = i.idProfesor INNER JOIN asignatura a ON i.idAsignatura = a.idAsignatura WHERE p.apellido1 = ? AND p.nombre = ?;"; // Consulta SQL para obtener el profesor por apellido1 y nombre1
    // Ejecutamos la consulta con el apellido1 y nombre1 proporcionados
    connection.query(query, [`${apellido1}`, `${nombre}`], (error, results) => {
        // Si hay un error, lo lanzamos 
        if (error) {
            // Si hay un error, respondemos con un estado 500 y un mensaje de error
            return res.status(500).json({ error: 'Error al obtener el profesor' });
        }
        // Si no se encuentra ningún profesor, respondemos con un estado 404 y un mensaje de error
        if (results.length === 0) {
            // Si no se encuentra el profesor, respondemos con un estado 404 y un mensaje de error
            return res.status(404).json({ message: 'Profesor no encontrado' });
        }
        // Si la consulta es exitosa, enviamos los resultados como respuesta en formato JSON las asignaturas que imparte en formato array
        const asignaturas = results.map(result => result.nombre);
        function capitalize(str) {
            return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
        }
        res.json({
            profesor: {
                nombre: capitalize(nombre),
                apellido1: capitalize(apellido1)
            },
            asignaturas: asignaturas
        });
    });
});            


// Ruta para manejar errores 404
app.use((req, res) => {
    // Si la ruta no existe, respondemos con un estado 404 y un mensaje de error
    res.status(404).send('<h1>404 - Página no encontrada</h1>');
}); 

// Lanzamos el servidor listening en el puerto configurado
app.listen(PORT, () => {
    // Mostramos un mensaje en la consola indicando que el servidor está corriendo
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});