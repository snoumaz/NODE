// Obtener el formulario y el campo de entrada
const formApellidoLetra = document.getElementById('formApellidoLetra');

formApellidoLetra.addEventListener('submit', (e) => {
    e.preventDefault(); // Prevenir el envío del formulario por defecto
    // Obtener el valor del campo de entrada
    let letrasApellido = document.getElementById('letras-apellido').value;
    let iniciales = "/alumnos/" + letrasApellido;
    // Redirigir a la ruta con el apellido1 proporcionado
    window.location.href = iniciales;
    
});

const formProfeAsignatura = document.getElementById('formProfeAsignatura');
formProfeAsignatura.addEventListener('submit', (e) => {
    e.preventDefault(); // Prevenir el envío del formulario por defecto
    // Obtener los valores de los campos de entrada
    let apellido1 = document.getElementById('apellido1').value;
    let nombre = document.getElementById('nombre').value;
    // Construir la ruta con los parámetros proporcionados
    let iniciales = `/profesor/${apellido1}/${nombre}`;
    // Redirigir a la ruta con el apellido1 y nombre proporcionados
    window.location.href = iniciales;
});