const sectionInsert= document.getElementById("insert")
const sectionUpdate= document.getElementById("update")
const dataUpdate = document.getElementById("dataUpdate")
sectionUpdate.style.display = "none"

function deleteTravel(id) {
    fetch(`/delete/${id}`, {
        method: "DELETE"
    })
    .then(response => response.json())
    .then(data => {
        location.reload();
    }).catch(err => {
        console.error("Fetch error:", err);
        alert("Failed to delete travel item. Check console for details.");
    });
}

function editTravel(travel) {
    sectionInsert.style.display = "none"
    sectionUpdate.style.display = "block"
    const newTravel = JSON.parse(travel)
    // console.log(newTravel);
    document.getElementById("id_update").value = newTravel.id
    document.getElementById("ruta_update").value = newTravel.ruta
    document.getElementById("lugar_update").value = newTravel.lugar
    document.getElementById("nombre_update").value = newTravel.nombre
    document.getElementById("descripcion_update").value = newTravel.descripcion
    document.getElementById("precio_update").value = newTravel.precio
    document.getElementById("img_update").value = newTravel.img
    
} 

dataUpdate.addEventListener('submit', (e) => {
    e.preventDefault();
    const formData = new FormData(dataUpdate);
    const datosFormulario = Object.fromEntries(formData.entries());
    let claveClean = JSON.stringify(datosFormulario).replaceAll('_update',"")
    fetch(`/update/${datosFormulario.id}`, {
        method: "PUT",
        headers: { "content-type": "application/json" },
        body: claveClean
    })
    .then(response => response.text())
    .then(result => {
        console.log(result)})
    .catch(err => console.log("Error:", err));
});
