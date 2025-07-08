import mysql from 'mysql2'
process.loadEnvFile()
const configConnection = {
    host: process.env.HOST_DB,
    user: process.env.USER_DB,
    password: process.env.PASS_DB,
    database: process.env.DATABASE,
    port: process.env.PORT_DB
};

export const connection = mysql.createConnection(configConnection)