function deleteItem(jsonData, idParam){
    return jsonData.filter(travel => travel.id != idParam)
}

function writeTravelsJson(jsonData){
    fs.writeFileSync(
        path.join(__dirname, "data", "travels.json"),
        JSON.stringify(jsonData, null, 2),
        "utf8"
      );
}

function insertItem(){
let newTravel = req.body
    if (newTravel.ruta[0] != "/") {
        newTravel.ruta = "/"+newTravel.ruta
    }    
    newTravel.precio = parseFloat(newTravel.precio)
    newTravel.id = crypto.randomUUID()
    jsonData.push(newTravel)

}

module.exports ={deleteItem, writeTravelsJson,insertItem}