const fs = require("node:fs");
const path = require("path");

const archivoJSON = "./escuela.json";

// Función para leer datos del archivo JSON
function leer() {
    try {
        if (!fs.existsSync(archivoJSON)) { // Verificar si el archivo existe
            return []; // Si no existe, retornar un array vacío
        }
        const datos = fs.readFileSync(archivoJSON, "utf-8"); // Leer el contenido del archivo
        // Si el archivo está vacío, retornar un array vacío
        return datos.trim() ? JSON.parse(datos) : []; // Parsear el contenido JSON
    } catch (error) {
        console.error("Error al leer el archivo:", error.message);
        return [];
    }
}

// Función para guardar datos en el archivo JSON
function grabar(datos) {
    try {
        fs.writeFileSync(archivoJSON, JSON.stringify(datos, null, 2), "utf-8");
        return true;
    } catch (error) {
        console.error("Error al escribir el archivo:", error.message);
        return false;
    }
}

// Función para matricular un alumno
function registrar(nombre, apellido, edad, asignatura) {
    const datos = leer();

    // Verificar si el alumno ya existe en esa asignatura
    const existeMatricula = datos.find(alumno =>
        alumno.nombre === nombre &&
        alumno.apellido === apellido &&
        alumno.asignatura === asignatura
    );

    if (existeMatricula) {
        console.log(`El alumno ${nombre} ${apellido} ya está matriculado en ${asignatura}`);
        return;
    }

    // Agregar nueva matrícula
    const nuevaMatricula = {
        nombre: nombre,
        apellido: apellido,
        edad: parseInt(edad),
        asignatura: asignatura
    };

    datos.push(nuevaMatricula);

    if (grabar(datos)) {
        console.log(`Alumno ${nombre} ${apellido} matriculado en ${asignatura}`);
    }
}

// Función para borrar un alumno
function borrar(nombre, apellido) {
    const datos = leer();
    const datosOriginales = datos.length;

    // Filtrar para eliminar todas las matrículas del alumno
    const datosFiltrados = datos.filter(alumno =>
        !(alumno.nombre === nombre && alumno.apellido === apellido)
    );

    if (datosFiltrados.length === datosOriginales) {
        console.log("No tenemos matriculado a ese alumno");
        return;
    }

    if (grabar(datosFiltrados)) {
        console.log(`Alumno ${nombre} ${apellido} eliminado de todas las asignaturas`);
    }
}

// Función para mostrar todos los alumnos
function mostrarTodos() {
    const datos = leer();

    if (datos.length === 0) {
        console.log("No hay alumnos matriculados");
        return;
    }

    // Ordenar por apellido, nombre, asignatura (A-Z)
    datos.sort((a, b) => {
        if (a.apellido !== b.apellido) {
            return a.apellido.localeCompare(b.apellido);
        }
        if (a.nombre !== b.nombre) {
            return a.nombre.localeCompare(b.nombre);
        }
        return a.asignatura.localeCompare(b.asignatura);
    });

    console.log("Alumnos matriculados");
    console.log("====================");

    datos.forEach(alumno => {
        console.log(`${alumno.nombre} ${alumno.apellido} ${alumno.edad} ${alumno.asignatura}`);
    });

    console.log("---------------------------------------");
    console.log(`Total: ${datos.length} alumnos matriculados`);
}

// Función para mostrar asignaturas de un alumno
function mostrarAsignaturas(nombre, apellido) {
    const datos = leer();

    const matriculasAlumno = datos.filter(alumno =>
        alumno.nombre === nombre && alumno.apellido === apellido
    );

    if (matriculasAlumno.length === 0) {
        console.log("No tenemos matriculado a ese alumno");
        return;
    }

    console.log(`El alumno ${nombre} ${apellido} está matriculado de:`);
    matriculasAlumno.forEach(matricula => {
        console.log(`    -- ${matricula.asignatura}`);
    });
}

// Función para mostrar alumnos de una asignatura
function mostrarAlumnos(asignatura) {
    const datos = leer();

    const alumnosAsignatura = datos.filter(alumno =>
        alumno.asignatura === asignatura
    );

    if (alumnosAsignatura.length === 0) {
        console.log(`No hay alumnos matriculados en ${asignatura}`);
        return;
    }

    // Ordenar por apellido, nombre
    alumnosAsignatura.sort((a, b) => {
        if (a.apellido !== b.apellido) {
            return a.apellido.localeCompare(b.apellido);
        }
        return a.nombre.localeCompare(b.nombre);
    });

    console.log(`Alumnos matriculados en ${asignatura}`);
    console.log("=========================");

    alumnosAsignatura.forEach(alumno => {
        console.log(`${alumno.nombre} ${alumno.apellido} ${alumno.edad}`);
    });

    console.log("--------------------------------");
    console.log(`Total: ${alumnosAsignatura.length} alumnos matriculados`);
}

// Función principal para procesar argumentos
function main() {
    if (process.argv.length == 2) {
        // Mostrar todos los alumnos
        mostrarTodos();
    } else if (process.argv.length == 3) {
        // Mostrar alumnos de una asignatura
        const asignatura = process.argv[2];
        mostrarAlumnos(asignatura);
    } else if (process.argv.length == 4) {
        // Mostrar las asignaturas del alumno
        const nombre = process.argv[2];
        const apellido = process.argv[3];
        mostrarAsignaturas(nombre, apellido);
    } else if (process.argv.length == 5) {
        // Borrar al alumno
        const nombre = process.argv[2];
        const apellido = process.argv[3];
        const flag = process.argv[4];

        if (flag === "-1") {
            borrar(nombre, apellido);
        } else {
            console.log("Error: Para borrar un alumno usa -1 como tercer parámetro");
        }
    } else if (process.argv.length == 6) {
        // Inscribir al usuario
        const nombre = process.argv[2];
        const apellido = process.argv[3];
        const edad = process.argv[4];
        const asignatura = process.argv[5];

        // Validar edad
        if (isNaN(parseInt(edad)) || parseInt(edad) <= 0) {
            console.log("Error: La edad debe ser un número positivo");
            return;
        }

        registrar(nombre, apellido, edad, asignatura);
    } else {
        // Mensaje de error
        console.log("Error: Formato de comando incorrecto");
        console.log("Uso:");
        console.log("  node escuela.js                              - Mostrar todos los alumnos");
        console.log("  node escuela.js asignatura                   - Mostrar alumnos de la asignatura");
        console.log("  node escuela.js nombre apellido              - Mostrar asignaturas del alumno");
        console.log("  node escuela.js nombre apellido -1           - Borrar alumno");
        console.log("  node escuela.js nombre apellido edad asig    - Matricular alumno");
    }
}

// Ejecutar la función principal
main();
