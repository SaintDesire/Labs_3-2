const express = require('express');
const jwt = require('jsonwebtoken');
const cookieParser = require('cookie-parser');
const redis = require('redis');
const USERS = require('./models/Users.js');
const path = require("path");

const app = express();
app.use(express.json());
app.use(cookieParser());

const redisClient = redis.createClient();

app.get('/', (req, res) => {
    res.send('Welcome to Express JWT Authentication Example');
});

// Регистрация нового пользователя
app.post('/register', async (req, res) => {
    try {
        const { username, password, info } = req.body;
        const newUser = await USERS.create({ username, password, info });
        res.status(201).json(newUser);
    } catch (err) {ч
        res.status(400).json({ message: err.message });
    }
});

// GET /login для возврата формы и POST /login для аутентификации
app.route('/login')
    .get((req, res) => {
        res.sendFile(path.join(__dirname, 'login.html')); // отправляем файл формы
    })
    .post(async (req, res) => {
        try {
            const { username, password } = req.body;
            const user = await USERS.findOne({ where: { username, password } });
            if (!user) throw new Error('Invalid username or password');

            const accessToken = jwt.sign({ username }, 'accessSecret', { expiresIn: '10m' });
            const refreshToken = jwt.sign({ username }, 'refreshSecret', { expiresIn: '24h' });

            res.cookie('accessToken', accessToken, { httpOnly: true, sameSite: 'strict' });
            res.cookie('refreshToken', refreshToken, { httpOnly: true, sameSite: 'strict' });

            res.redirect('/resource');
        } catch (err) {
            res.status(401).json({ message: err.message });
        }
    });

// GET /refresh-token для обновления токена доступа
app.get('/refresh-token', (req, res) => {
    try {
        const refreshToken = req.cookies.refreshToken;
        if (!refreshToken) throw new Error('Refresh token not found');

        jwt.verify(refreshToken, 'refreshSecret', (err, decoded) => {
            if (err) throw new Error('Invalid refresh token');

            const accessToken = jwt.sign({ username: decoded.username }, 'accessSecret', { expiresIn: '10m' });
            res.cookie('accessToken', accessToken, { httpOnly: true, sameSite: 'strict' });
            res.send('Access token refreshed');
        });
    } catch (err) {
        res.status(401).json({ message: err.message });
    }
});

// GET /logout для отключения доступа
app.get('/logout', (req, res) => {
    res.clearCookie('accessToken');
    res.clearCookie('refreshToken');
    res.send('Logged out successfully');
});

// GET /resource для отправки сообщения RESOURCE и информации об аутентифицированном пользователе
app.get('/resource', (req, res) => {
    try {
        const accessToken = req.cookies.accessToken;
        if (!accessToken) throw new Error('Access token not found');

        jwt.verify(accessToken, 'accessSecret', (err, decoded) => {
            if (err) throw new Error('Invalid access token');
            res.send(`RESOURCE: User ${decoded.username}`);
        });
    } catch (err) {
        res.status(401).json({ message: err.message });
    }
});

// Обработка ошибок 404
app.use((req, res, next) => {
    res.status(404).send('404 Not Found');
});

// Обработка ошибок 401
app.use((err, req, res, next) => {
    res.status(401).json({ message: err.message });
});

// Запуск сервера на порту 3000
app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
