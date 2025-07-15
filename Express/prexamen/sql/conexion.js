// Importar los módulos necesarios
import mysql from 'mysql2';
// Cargar las variables de entorno desde el archivo .env
process.loadEnvFile();

// Configurar la conexión a la base de datos MySQL
const configConnection = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME
}; 
// Crear una conexión a la base de datos MySQL y exportarla
// Esto permite que otros módulos importen esta conexión para interactuar con la base de datos
export const connection = mysql.createConnection(configConnection);