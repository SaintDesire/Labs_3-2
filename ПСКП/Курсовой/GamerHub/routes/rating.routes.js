const express = require('express');
const app = express();
const bodyParser = require("body-parser");
const cookieParser = require('cookie-parser');
const { sequelizeClient, Rating } = require('../db');


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Обработка POST-запроса для добавления записи в модель Rating
app.post('/addRating', (req, res) => {
    const { game_id, user_id, rating } = req.body;

    Rating.findOne({
        where: {
            user_id: user_id,
            game_id: game_id
        }
    })
        .then((existingRating) => {
            if (existingRating) {
                existingRating.update({ rating: rating })
                    .then((updatedRating) => {
                        res.status(200).json(updatedRating);
                    })
                    .catch((error) => {
                        console.error('Ошибка при обновлении рейтинга:', error);
                        res.status(500).json({ error: 'Ошибка при обновлении рейтинга' });
                    });
            } else {
                Rating.create({ game_id, user_id, rating })
                    .then((newRating) => {
                        res.status(201).json(newRating);
                    })
                    .catch((error) => {
                        console.error('Ошибка при создании рейтинга:', error);
                        res.status(500).json({ error: 'Ошибка при создании рейтинга' });
                    });
            }
        })
        .catch((error) => {
            console.error('Ошибка при поиске рейтинга:', error);
            res.status(500).json({ error: 'Ошибка при поиске рейтинга' });
        });
});

app.get('/getRatings/:game_id', (req, res) => {
    const gameId = req.params.game_id;

    Rating.findAll({
        where: {
            game_id: gameId
        }
    })
        .then((ratings) => {
            let totalRating = 0;

            ratings.forEach((rating) => {
                if (rating.rating) {
                    totalRating++;
                } else {
                    totalRating--;
                }
            });

            res.json({ rating: totalRating });
        })
        .catch((error) => {
            console.error('Ошибка при получении рейтинга:', error);
            res.status(500).json({ error: 'Ошибка при получении рейтинга' });
        });
});

module.exports = app;