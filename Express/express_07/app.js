import express from 'express'
import logger from 'morgan'
import { Server } from 'socket.io'
import { createServer } from 'node:http'
process.loadEnvFile()
import { createClient } from '@libsql/client'

const db = createClient({
    url: process.env.DB_URL,
    authToken: process.env.DB_TOKEN
})

await db.execute(`
    CREATE TABLE IF NOT EXISTS messages (
        id_message INTEGER PRIMARY KEY AUTOINCREMENT,
        user TEXT default 'Anonimo',
        content TEXT,
        fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )`)       

const PORT = process.env.PORT || 10000
const app = express()
const server = createServer(app)

const io = new Server(server, {
    connectionStateRecovery: {
        origin: '*',
        methods: ['GET', 'POST']
    }
})
app.use(logger('dev'))
app.use(express.static(process.cwd() + "/client"))

app.get("/",(req,res) => {
    res.sendFile(process.cwd() + "/client/index.html")
})


server.listen(PORT,()=>{
    console.log(`Servidor iniciado en http://localhost:${PORT}`);
})