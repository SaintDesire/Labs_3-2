const fs = require('fs');
const path = require('path');

const dataFilePath = path.join(__dirname, '../data/contacts.json');

function getIndex(req, res) {
    // Отображаем форму добавления контакта
    fs.readFile(dataFilePath, 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            res.status(500).send('Internal Server Error');
            return;
        }
        const contacts = JSON.parse(data);
        // Отображаем форму индекса с данными справочника
        res.render('index', { contacts });
    });
}

function getAddForm(req, res) {
    // Отображаем форму добавления контакта
    fs.readFile(dataFilePath, 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            res.status(500).send('Internal Server Error');
            return;
        }
        const contacts = JSON.parse(data);
        // Отображаем форму добавления с данными справочника
        res.render('add', { contacts });
    });
}

function postAddForm(req, res) {
    // Получаем данные из тела запроса
    const { name, phone } = req.body;
    // Читаем данные из файла справочника
    fs.readFile(dataFilePath, 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            res.status(500).send('Internal Server Error');
            return;
        }
        const contacts = JSON.parse(data);
        let lastId = 0;
        // Ищем последний id в массиве контактов
        if (contacts.length > 0) {
            lastId = Math.max(...contacts.map(contact => contact.id));
        }
        // Генерируем новый id
        const id = lastId + 1;
        // Добавляем новый контакт в массив с новым id
        contacts.push({ id, name, phone });
        // Записываем обновленные данные в файл справочника
        fs.writeFile(dataFilePath, JSON.stringify(contacts, null, 2), (err) => {
            if (err) {
                console.error(err);
                res.status(500).send('Internal Server Error');
                return;
            }
            // Перенаправляем пользователя на главную страницу
            res.redirect('/');
        });
    });
}



function getUpdateForm(req, res) {
    const { id } = req.query;
    fs.readFile(dataFilePath, 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            res.status(500).send('Internal Server Error');
            return;
        }
        const contacts = JSON.parse(data);
        const contact = contacts.find(contact => contact.id === Number(id));
        if (!contact) {
            res.status(404).send('Contact not found');
            return;
        }
        res.render('update', { contact, contacts });
    });
}

function postUpdateForm(req, res) {
    // Получаем данные из тела запроса
    const { id, name, phone } = req.body;
    // Читаем данные из файла справочника
    fs.readFile(dataFilePath, 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            res.status(500).send('Internal Server Error');
            return;
        }
        const contacts = JSON.parse(data);
        // Ищем контакт для обновления
        const contactIndex = contacts.findIndex(contact => contact.id === Number(id));
        if (contactIndex !== -1) {
            // Обновляем данные контакта
            contacts[contactIndex].name = name;
            contacts[contactIndex].phone = phone;
            // Записываем обновленные данные в файл справочника
            fs.writeFile(dataFilePath, JSON.stringify(contacts, null, 2), (err) => {
                if (err) {
                    console.error(err);
                    res.status(500).send('Internal Server Error');
                    return;
                }
                // Перенаправляем пользователя на главную страницу
                res.redirect('/');
            });
        } else {
            res.status(404).send('Contact not found');
        }
    });
}

function postDelete(req, res) {
    // Получаем id контакта для удаления
    const { id } = req.body;
    // Читаем данные из файла справочника
    fs.readFile(dataFilePath, 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            res.status(500).send('Internal Server Error');
            return;
        }
        let contacts = JSON.parse(data);
        // Фильтруем контакты, оставляя только те, которые не соответствуют id для удаления
        contacts = contacts.filter(contact => contact.id !== parseInt(id));
        // Записываем обновленные данные в файл справочника
        fs.writeFile(dataFilePath, JSON.stringify(contacts, null, 2), (err) => {
            if (err) {
                console.error(err);
                res.status(500).send('Internal Server Error');
                return;
            }
            // Перенаправляем пользователя на главную страницу
            res.redirect('/');
        });
    });
}




module.exports = {
    getIndex,
    getAddForm,
    postAddForm,
    getUpdateForm,
    postUpdateForm,
    postDelete,
};
