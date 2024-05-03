const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const { sequelize, Game, Op, User } = require('./db');
const { formatGameTitle, getGameImages } = require('./images');
const fs = require('fs');
const routes = require('./routes/authJWT.routes')
const path = require('path')

const app = express();
app.use(routes)
const port = 3000;

app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/html/main.html');
});

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

app.get('/login', (req, res) => {
    res.sendFile(__dirname + '/html/loginPage.html');
});
app.get('/register', (req, res) => {
    res.sendFile(__dirname + '/html/registerPage.html');
});

// Маршрут для обработки запросов GET /game
app.get('/search-game', (req, res) => {
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

app.post('/gamesList', async (req, res) => {
    try {
        const genre = req.body.genre;
        const games = await Game.findAll({
            where: { genre: genre }, // Добавьте условие where для выборки игр определенной категории
            limit: 10,
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

app.get('/game', async (req, res) => {
    try {
        const gameTitle = req.query.gameTitle;

        const gameInfo = {
            gameTitle: gameTitle,
        };

        res.sendFile(path.join(__dirname, '/html/game.html'), {
            gameInfo: JSON.stringify(gameInfo)
        });
    } catch (error) {
        console.error('Error:', error);
        res.redirect('/');
    }
});

app.post('/game', async (req, res) => {
    const gameTitle = req.body.gameTitle;

    try {
        // Получение данных об игре по названию из базы данных
        const gameInfo = await Game.findOne({
            where: { title: gameTitle }
        });

        if (!gameInfo) {
            // Если игра не найдена, отправляем ошибку клиенту
            return res.status(404).json({ error: 'Game not found' });
        }

        // Получение массива изображений для игры
        const images = await getGameImages(gameInfo.title);

        // Формируем объект с данными об игре
        const gameData = {
            release_date: gameInfo.release_date,
            genre: gameInfo.genre,
            developer: gameInfo.developer,
            images: images
        };

        // Отправляем данные об игре клиенту
        res.json(gameData);
    } catch (error) {
        // Если произошла ошибка при получении данных из базы данных, отправляем ошибку клиенту
        console.error('Error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Запуск сервера
app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});
