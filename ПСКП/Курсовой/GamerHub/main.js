const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const { sequelize, Game, Op, User } = require('./db');
const { formatGameTitle, getGameImages } = require('./images');
const fs = require('fs');

const app = express();
const port = 3000;

app.use(express.urlencoded({ extended: true }));

// Создание подключения к базе данных
sequelize
    .authenticate()
    .then(() => {
        console.log('Database connection has been established successfully');
    })
    .catch((error) => {
        console.error('Unable to connect to the database:', error);
    });

// Маршрут для обработки запросов GET /
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/html/game.html');
});

// Маршрут для обработки запросов GET /search
app.get('/search', (req, res) => {
    const gameTitle = req.query.gameTitle;

    Game.findAll({
        where: {
            title: {
                [Op.like]: `%${gameTitle.replace('$', '$$')}%`,
            },
        },
    })
        .then((games) => {
            res.json({ games });
        })
        .catch((error) => {
            console.error('Error:', error);
            res.json({ error: 'An error occurred' });
        });
});

// Маршрут для обработки запросов GET /game
app.get('/game', (req, res) => {
    const gameTitle = req.query.gameTitle;

    getGameImages(gameTitle)
        .then((images) => {
            if (images.length === 0) {
                res.json({ error: 'No images found' });
            } else {
                res.json({ images });
            }
        })
        .catch((error) => {
            console.error('Error:', error);
            res.json({ error: 'An error occurred' });
        });
});

app.get('/gamesList', async (req, res) => {
    try {
        const games = await Game.findAll({
            limit: 10, // Максимальное количество игр для вывода (10 строчек)
        });

        const gamePromises = games.map(async (game) => {
            const gameTitle = game.title;
            const images = await getGameImages(gameTitle);
            const lastImage = images[images.length - 1];
            return { gameTitle, image: lastImage };
        });

        const gameResults = await Promise.all(gamePromises);

        res.json({ games: gameResults });
    } catch (error) {
        console.error('Error:', error);
        res.json({ error: 'An error occurred' });
    }
});

app.get('/login', (req, res) => {
    res.sendFile(__dirname + '/html/loginPage.html');
});
app.get('/register', (req, res) => {
    res.sendFile(__dirname + '/html/registerPage.html');
});

app.post('/register', (req, res) => {
    const { username, password, email } = req.body;
    User.create({ username, password, email, role: 'user' })
        .then(() => {
            res.redirect('/login'); // Перенаправление на страницу авторизации после успешной регистрации
        })
        .catch(error => {
            console.log('Error:', error);
            res.status(500).json({ error: 'Failed to register user' });
        });
});
app.post('/login', (req, res) => {
    const { username, password } = req.body;
    User.findOne({ where: { username, password } })
        .then(user => {
            if (user) {
                res.redirect('/'); // Перенаправление на главную страницу после успешной авторизации
            } else {
                res.status(401).json({ error: 'Invalid username or password' });
            }
        })
        .catch(error => {
            console.log('Error:', error);
            res.status(500).json({ error: 'Failed to login' });
        });
});

// Запуск сервера
app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});