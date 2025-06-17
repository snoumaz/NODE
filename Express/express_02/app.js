const path = require('node:path')
const express = require('express')
const app = express()
process.loadEnvFile()
const port = process.env.PORT || 1234
const jsonData = require("./ventas.json")

app.get('/', (req, res) => res.send('Hello World!'))

// Mostrar datos json
app.get('/api', (req, res) =>{
    // console.log("anyo: ",req.query)
    if (req.query.year && req.query.year == "desc" &&  req.query.pais == "asc"){
        // Create a copy to avoid mutating the original array
        let sortedData = [...jsonData]
            .sort((a, b) => b.anyo - a.anyo) // Sort by year descending
            .sort((a, b) => a.pais.localeCompare(b.pais)); // Then by pais ascending

        return res.json(sortedData)
    } 
    res.json(jsonData)
    
    // 
}) 
app.listen(port, () => console.log(`http://localhost:${port}`))