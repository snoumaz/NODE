import { calculadora } from "./funciones.js";
import fs from 'node:fs';
import express from 'express';

// console.log(sumar(5, 10));
// console.log(restar(10, 5));
const app = express();

app.get('/', (_, res) => {
  res.send('GET request to the homepage')
})


fs.writeFileSync('test.txt',"Hoy es viernes","utf8")

// console.log(calculadora(5,10,"sumar"));