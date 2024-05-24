const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const { sequelize, Game, Op, User, Notification } = require('./db');
const { formatGameTitle, getGameImages } = require('./images');
const fs = require('fs');
const https = require('https');
const path = require('path');
const WebSocket = require('ws');
const winston = require('winston');
const routes = require('./routes/authJWT.routes');
const comments = require('./routes/comments.routes');
const ratings = require('./routes/rating.routes');
const user = require('./routes/user.routes');
const wishlist = require('./routes/wishlist.routes');
const adminPanel = require('./routes/adminPanel.routes');
const http = require('http');


const privateKey = fs.readFileSync('https/GamerHub.key', 'utf8');
const certificate = fs.readFileSync('https/GamerHub.crt', 'utf8');
const ca = fs.readFileSync('https/CA.crt', 'utf8');

const app = express();
const port = process.env.PORT || 443;
const httpPort = 80;
const wsPort = process.env.WS_PORT || 8080;

const wss = new WebSocket.Server({ port: wsPort });

app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));
app.use(routes);
app.use(comments);
app.use(ratings);
app.use(user);
app.use(wishlist);
app.use(adminPanel);

const credentials = {
    key: privateKey,
    cert: certificate,
    ca: ca
};

app.use((req, res, next) => {
    if (!req.secure) {
        // Перенаправление на HTTPS
        res.redirect(`https://${req.headers.host}${req.url}`);
    } else {
        next();
    }
});


app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '/html/main.html'));
});

app.get('/search', async (req, res) => {
    try {
        const gameTitle = req.query.gameTitle;
        const games = await Game.findAll({
            where: {
                title: {
                    [Op.like]: `%${gameTitle.replace('$', '$$')}%`,
                },
            },
        });
        res.json({ games });
    } catch (error) {
        winston.error('Error:', error);
        res.json({ error: 'An error occurred' });
    }
});

app.get('/login', (req, res) => {
    res.sendFile(path.join(__dirname, '/html/loginPage.html'));
});

app.get('/register', (req, res) => {
    res.sendFile(path.join(__dirname, '/html/registerPage.html'));
});

app.get('/search-game', async (req, res) => {
    try {
        const gameTitle = req.query.gameTitle;
        const images = await getGameImages(gameTitle);
        if (images.length === 0) {
            res.json({ error: 'No images found' });
        } else {
            res.json({ images });
        }
    } catch (error) {
        winston.error('Error:', error);
        res.json({ error: 'An error occurred' });
    }
});

app.get('/gamesList', async (req, res) => {
    try {
        const page = req.query.page || 1;
        const offset = (page - 1) * 15;
        const games = await Game.findAll({ limit: 15, offset });
        const gameResults = await Promise.all(games.map(async (game) => {
            const images = await getGameImages(game.title);
            return { gameTitle: game.title, image: images[images.length - 1] };
        }));
        res.json({ games: gameResults });
    } catch (error) {
        winston.error('Error:', error);
        res.json({ error: 'An error occurred' });
    }
});

app.post('/gamesList', async (req, res) => {
    try {
        const genre = req.body.genre;
        const games = await Game.findAll({ where: { genre }, limit: 15 });
        const gameResults = await Promise.all(games.map(async (game) => {
            const images = await getGameImages(game.title);
            return { gameTitle: game.title, image: images[images.length - 1] };
        }));
        res.json({ games: gameResults });
    } catch (error) {
        winston.error('Error:', error);
        res.json({ error: 'An error occurred' });
    }
});

app.get('/game', async (req, res) => {
    try {
        const gameTitle = req.query.gameTitle;
        res.sendFile(path.join(__dirname, '/html/game.html'), {
            gameInfo: JSON.stringify({ gameTitle })
        });
    } catch (error) {
        winston.error('Error:', error);
        res.redirect('/');
    }
});

app.post('/game', async (req, res) => {
    try {
        const gameTitle = req.body.gameTitle;
        const gameInfo = await Game.findOne({ where: { title: gameTitle } });
        if (!gameInfo) {
            return res.status(404).json({ error: 'Game not found' });
        }
        const images = await getGameImages(gameInfo.title);
        res.json({
            title: gameInfo.title,
            game_id: gameInfo.game_id,
            release_date: gameInfo.release_date,
            genre: gameInfo.genre,
            developer: gameInfo.developer,
            images
        });
    } catch (error) {
        winston.error('Error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.get('/countGames', async (req, res) => {
    try {
        const count = await Game.count();
        res.json({ count });
    } catch (error) {
        winston.error('Ошибка при подсчете количества игр:', error);
        res.status(500).json({ error: 'Ошибка при подсчете количества игр' });
    }
});

app.get('/profile', (req, res) => {
    res.sendFile(path.join(__dirname, '/html/profile.html'));
});

app.get('/wishlist', (req, res) => {
    res.sendFile(path.join(__dirname, '/html/wishlist.html'));
});

app.get('/admin-panel', async (req, res) => {
    try {
        const userId = req.query.userId;
        const user = await User.findOne({ where: { user_id: userId } });
        if (user && user.role === 'admin') {
            res.sendFile(path.join(__dirname, '/html/admin-panel.html'));
        } else {
            res.status(403).send('Доступ запрещен');
        }
    } catch (error) {
        winston.error('Error:', error);
        res.status(500).send('Внутренняя ошибка сервера');
    }
});

app.post('/notification', async (req, res) => {
    try {
        const notification = await Notification.create({ message: req.body.message });
        winston.info('Создано новое уведомление:', notification.message);
        wss.clients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(JSON.stringify(notification));
            }
        });
        res.status(200).send('Уведомление создано');
    } catch (error) {
        winston.error('Ошибка при создании уведомления:', error);
        res.status(500).send('Ошибка сервера');
    }
});

wss.on('connection', (ws) => {
    ws.on('message', (message) => {
        ws.send('Получено сообщение: ' + message);
    });

    ws.on('close', () => {
        winston.info('Соединение с клиентом закрыто');
    });
});

const httpsServer = https.createServer(credentials, app);

httpsServer.listen(port, () => {
    winston.info(`Server listening on port ${port}`);
});

const httpServer = http.createServer((req, res) => {
    // Перенаправление на HTTPS
    res.writeHead(301, { Location: `https://${req.headers.host}${req.url}` });
    res.end();
});

httpServer.listen(httpPort, () => {
    winston.info(`HTTP server listening on port ${httpPort}`);
});


winston.info(`Сервер WebSocket запущен на порту ${wsPort}`);