const express = require('express');
const app = express();
const bodyParser = require("body-parser");
const cookieParser = require('cookie-parser');
const { sequelizeClient, Feedback, User, Game, Notification } = require('../db');
const winston = require('winston');

// Настройка логирования
const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        new winston.transports.Console(),
        new winston.transports.File({ filename: 'error.log', level: 'error' }),
    ],
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cookieParser());

// Централизованная обработка ошибок
app.use((err, req, res, next) => {
    logger.error(err.stack);
    res.status(500).json({ error: 'Internal Server Error' });
});

// Обработчик для получения списка пользователей
app.get('/api/users', async (req, res, next) => {
    try {
        const users = await User.findAll();
        if (!users.length) {
            return res.status(404).json({ error: 'No users found' });
        }
        res.json(users);
    } catch (error) {
        logger.error('Error retrieving users:', error);
        next(error);
    }
});

// Обработчик для получения списка игр
app.get('/api/games', async (req, res, next) => {
    try {
        const games = await Game.findAll();
        if (!games.length) {
            return res.status(404).json({ error: 'No games found' });
        }
        res.json(games);
    } catch (error) {
        logger.error('Error retrieving games:', error);
        next(error);
    }
});

// Обработчик для получения списка уведомлений
app.get('/api/notifications', async (req, res, next) => {
    try {
        const notifications = await Notification.findAll();
        if (!notifications.length) {
            return res.status(404).json({ error: 'No notifications found' });
        }
        res.json(notifications);
    } catch (error) {
        logger.error('Error retrieving notifications:', error);
        next(error);
    }
});

// Обработчик для получения списка комментариев
app.get('/api/comments', async (req, res, next) => {
    try {
        const comments = await Feedback.findAll({ order: [['feedback_id', 'DESC']] });
        if (!comments.length) {
            return res.status(404).json({ error: 'No comments found' });
        }
        res.json(comments);
    } catch (error) {
        logger.error('Error retrieving comments:', error);
        next(error);
    }
});

app.put('/api/users/:user_id', async (req, res, next) => {
    const userId = req.params.user_id;
    const { username, email } = req.body;

    if (!username || !email) {
        return res.status(400).json({ error: 'Username and email are required' });
    }

    try {
        const userToUpdate = await User.findOne({ where: { user_id: userId } });
        if (userToUpdate) {
            userToUpdate.username = username;
            userToUpdate.email = email;
            await userToUpdate.save();
            res.sendStatus(200);
        } else {
            res.status(404).json({ error: 'User not found' });
        }
    } catch (error) {
        logger.error('Error updating user:', error);
        next(error);
    }
});

app.put('/api/games/:game_id', async (req, res, next) => {
    const gameId = req.params.game_id;
    const { genre } = req.body;

    if (!genre) {
        return res.status(400).json({ error: 'Genre is required' });
    }

    try {
        const gameToUpdate = await Game.findOne({ where: { game_id: gameId } });
        if (gameToUpdate) {
            gameToUpdate.genre = genre;
            await gameToUpdate.save();
            res.sendStatus(200);
        } else {
            res.status(404).json({ error: 'Game not found' });
        }
    } catch (error) {
        logger.error('Error updating game:', error);
        next(error);
    }
});

module.exports = app;