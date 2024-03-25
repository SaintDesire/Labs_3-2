const express = require('express');
const mssql = require('mssql');

const app = express();
const port = process.env.PORT || 3000;

// Подключение к базе данных
const dbConfig = {
    user: 'server',
    password: '123123',
    server: 'localhost',
    database: 'GamerHub',
    options: {
        encrypt: true, // Для использования защищенного соединения
        trustServerCertificate: true // Для доверия сертификату сервера (не рекомендуется использовать в рабочем окружении)
    }
};

async function connectToDB() {
    try {
        await mssql.connect(dbConfig);
        console.log('Connected to the database');
    } catch (error) {
        console.error('Error connecting to the database:', error);
    }
}

// Маршрут для стартовой страницы
app.get('/', (req, res) => {
    res.send('Добро пожаловать на стартовую страницу вашего приложения!');
});

// Запуск сервера
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);

    // Подключение к базе данных при запуске сервера
    connectToDB();
});
