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
      
    }
})
io.on('connection', async (socket) => {
    console.log('Usuario conectado');
    // Eventos de conexión y desconexión
    socket.on('disconnect', () => {
        console.log('Usuario desconectado');
    });

    socket.on('chatMessage', async (msg, username) => {
        console.log('Mensaje recibido:', msg, 'de usuario:', username);
        let result 
         try {
            result = await db.execute({
                sql:`insert into messages (user, content) values (:msg, :username)`,
                args: {msg, username}
            })
         } catch (error) {
            console.error('Error al procesar el mensaje:', error);
            return;
        }
        console.log('Mensaje insertado con ID:', result.lastInsertRowid);       
        io.emit('chatMessage', msg,result.lastInsertRowid.toLocaleString(), username);
    });
    console.log(socket.handshake.auth);

    if (!socket.recovered) {
        try {
           const result = await db.execute({
           sql : 'SELECT * FROM messages WHERE id_message > ? ORDER BY fecha DESC ',
            args: [socket.handshake.auth.serverOffset ?? 0]
        });
        result.rows.forEach(row => {
            console.log('Mensaje recuperado:', row);
            socket.emit('chatMessage', row.content, row.id_message.toLocaleString(), row.user,row.fecha);
        });
        } catch (error) {
            console.error('Error al recuperar mensajes:', error);
        }
    }

});

app.use(logger('dev'))
app.use(express.static(process.cwd() + "/client"))

app.get("/",(req,res) => {
    res.sendFile(process.cwd() + "/client/index.html")
})


server.listen(PORT,()=>{
    console.log(`Servidor iniciado en http://localhost:${PORT}`);
})