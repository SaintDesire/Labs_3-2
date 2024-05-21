const express = require('express');
const app = express();
const bodyParser = require("body-parser");
const cookieParser = require('cookie-parser');
const { sequelizeClient, Feedback, User } = require('../db');


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cookieParser());

// Обработчик POST-запроса для добавления комментария
app.post("/addComment", function(req, res) {
    var comment = req.body.comment;
    var user_id = req.body.user_id;
    var game_id = req.body.game_id;

    Feedback.create({
        message: comment,
        user_id: user_id,
        game_id: game_id
    })
        .then(function() {
            res.sendStatus(200); // Отправка успешного статуса
        })
        .catch(function(error) {
            console.error("Ошибка при добавлении комментария:", error);
            res.sendStatus(500); // Отправка статуса ошибки сервера
        });
});

app.get("/getComments", function(req, res) {
    const game_id = req.query.game_id; // Получение значения game_id из запроса

    Feedback.findAll({
        where: { game_id: game_id }, // Добавление условия where для выборки комментариев к определенной игре
        include: [{
            model: User,
            attributes: ['username']
        }]
    })
        .then(function(comments) {
            res.json(comments);
        })
        .catch(function(error) {
            console.error("Ошибка при получении комментариев:", error);
            res.sendStatus(500);
        });
});

app.get("/getUserComments", function(req, res) {
    const userId = req.query.userId; // Получение значения user_id из запроса
    Feedback.count({ where: { user_id: userId } })
        .then(function(commentCount) {
            res.json({ commentCount: commentCount });
        })
        .catch(function(error) {
            console.error("Ошибка при получении комментариев:", error);
            res.sendStatus(500); // Отправка статуса ошибки сервера
        });
});

module.exports = app;