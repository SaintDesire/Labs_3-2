const express = require('express');
const app = express();
const bodyParser = require("body-parser");
const cookieParser = require('cookie-parser');
const { sequelizeClient, Wishlist, Game } = require('../db');
const { formatGameTitle, getGameImages } = require('../images');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Обработчик POST-запроса на добавление игры в список желаемого
app.post('/add-to-favourites', (req, res) => {
    const { game_id, user_id } = req.body;

    // Создание записи в таблице Wishlist
    Wishlist.create({
        user_id: user_id,
        game_id: game_id
    })
        .then(() => {
            res.sendStatus(200); // Отправка успешного статуса
        })
        .catch(error => {
            console.error("Произошла ошибка при добавлении игры в список желаемого:", error);
            res.sendStatus(500); // Отправка статуса ошибки
        });
});

// Обработчик POST-запроса на удаление игры из списка желаемого
app.post('/remove-from-favourites', (req, res) => {
    const { game_id, user_id } = req.body;

    // Удаление записи из таблицы Wishlist
    Wishlist.destroy({
        where: {
            user_id: user_id,
            game_id: game_id
        }
    })
        .then(() => {
            res.sendStatus(200); // Отправка успешного статуса
        })
        .catch(error => {
            console.error("Произошла ошибка при удалении игры из списка желаемого:", error);
            res.sendStatus(500); // Отправка статуса ошибки
        });
});

// Обработчик GET-запроса для проверки наличия игры в списке желаемого
app.get('/check-favourite/:game_id/:user_id', (req, res) => {
    const { game_id, user_id } = req.params;

    // Поиск записи в таблице Wishlist
    Wishlist.findOne({
        where: {
            user_id: user_id,
            game_id: game_id
        }
    })
        .then(wishlist => {
            if (wishlist) {
                res.json({ isFavourite: true }); // Отправка JSON с флагом isFavourite: true
            } else {
                res.json({ isFavourite: false }); // Отправка JSON с флагом isFavourite: false
            }
        })
        .catch(error => {
            console.error("Произошла ошибка при поиске игры в списке желаемого:", error);
            res.sendStatus(500); // Отправка статуса ошибки
        });
});

app.get('/wishlist-games', async (req, res) => {
    try {
        const user_id = decodeURIComponent(req.query.user_id);


        // Найти все значения в списке желаемого для данного пользователя
        const wishlist = await Wishlist.findAll({
            where: { user_id },
        });

        const gamePromises = wishlist.map(async (item) => {
            const game_id = item.game_id;
            const game = await Game.findOne({ where: { game_id: game_id } });

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

module.exports = app;