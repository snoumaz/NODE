// Obtener el formulario y el campo de entrada
const formApellidoLetra = document.getElementById('formApellidoLetra');

formApellidoLetra.addEventListener('submit', (e) => {
    e.preventDefault(); // Prevenir el envío del formulario por defecto
    // Obtener el valor del campo de entrada
    let letrasApellido = document.getElementById('letras-apellido').value;
    iniciales ="/alumnos/" + letrasApellido;
    // Redirigir a la ruta con el apellido1 proporcionado
    window.location.href = iniciales;
    
});