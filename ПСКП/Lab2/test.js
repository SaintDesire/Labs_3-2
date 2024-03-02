//http-server
const sql=require('mssql');
const url = require("url");
const fs = require("fs");
const http = require("http");

let config={
    user: "student",
    password: "fitfit",
    database: "KNI",
    server: "localhost",
    trustServerCertificate: true,
    pool: {
        min:4,
        max:10
    }
}


const pool = new sql.ConnectionPool(config);

pool.connect().then(() => {
    console.log('Подключение к MSSQL успешно установлено');
}).catch(err => {
    console.error('Ошибка подключения к MSSQL:', err);
});
