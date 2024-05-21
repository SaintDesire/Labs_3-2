const express = require('express');
const app = express();
const bodyParser = require("body-parser");
const cookieParser = require('cookie-parser');
const fs = require('fs');
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });
const { sequelizeClient, Rating, User } = require('../db');


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());


app.post('/update-avatar', upload.single('avatar'), (req, res) => {
    // Получение информации о загруженном файле
    const file = req.file;

    // Получение user_id из запроса
    const user_id = req.body.user_id;

    // Проверка наличия файла
    if (!file) {
        res.status(400).json({ message: 'Ошибка: файл не был загружен' });
        return;
    }

    // Чтение содержимого файла
    fs.readFile(file.path, (err, data) => {
        if (err) {
            console.error('Ошибка при чтении файла', err);
            res.status(500).json({ message: 'Внутренняя ошибка сервера' });
            return;
        }

        // Удаление временного файла
        fs.unlink(file.path, (err) => {
            if (err) {
                console.error('Ошибка при удалении временного файла', err);
            }
        });

        // Обновление столбца avatar для пользователя с заданным user_id
        User.update({ avatar: data }, { where: { user_id: user_id } })
            .then(() => {
                res.json({ message: 'Аватар успешно обновлен', avatar: data});
            })
            .catch((error) => {
                console.error('Ошибка при обновлении аватара', error);
                res.status(500).json({ message: 'Внутренняя ошибка сервера' });
            });
    });
});
app.post('/update-username', (req, res) => {
    const { user_id, username } = req.body;

    // Проверка, занято ли имя пользователя
    User.findOne({ where: { username: username } })
        .then((existingUser) => {
            if (existingUser && existingUser.user_id !== user_id) {
                return res.status(400).json({ message: 'Имя пользователя уже занято' });
            }

            // Обновление имени пользователя
            User.update({ username: username }, { where: { user_id: user_id } })
                .then(() => {
                    res.json({ message: 'Имя пользователя успешно обновлено' });
                })
                .catch((error) => {
                    console.error('Ошибка при обновлении имени пользователя', error);
                    res.status(500).json({ message: 'Внутренняя ошибка сервера' });
                });
        })
        .catch((error) => {
            console.error('Ошибка при проверке имени пользователя', error);
            res.status(500).json({ message: 'Внутренняя ошибка сервера' });
        });
});

app.post('/update-email', (req, res) => {
    const { user_id, email } = req.body;

    // Проверка, занят ли email
    User.findOne({ where: { email: email } })
        .then((existingUser) => {
            if (existingUser && existingUser.user_id !== user_id) {
                return res.status(400).json({ message: 'Email уже занят' });
            }

            // Обновление email
            User.update({ email: email }, { where: { user_id: user_id } })
                .then(() => {
                    res.json({ message: 'Email успешно обновлен' });
                })
                .catch((error) => {
                    console.error('Ошибка при обновлении email', error);
                    res.status(500).json({ message: 'Внутренняя ошибка сервера' });
                });
        })
        .catch((error) => {
            console.error('Ошибка при проверке email', error);
            res.status(500).json({ message: 'Внутренняя ошибка сервера' });
        });
});

app.post('/update-password', (req, res) => {
    const { user_id, password } = req.body;
    User.update({ password: password }, { where: { user_id: user_id } })
        .then(() => {
            res.json({ message: 'Пароль успешно обновлен' });
        })
        .catch((error) => {
            console.error('Ошибка при обновлении пароля', error);
            res.status(500).json({ message: 'Внутренняя ошибка сервера' });
        });
});

module.exports = app;