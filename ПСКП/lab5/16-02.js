const express = require('express');
const fs = require('fs');
const app = express();

const passport = require('passport');
const DigestStrategy = require('passport-http').DigestStrategy;
const session = require('express-session')({
    resave: false,
    saveUninitialized: false,
    secret: 'qweqwe'
});

const port = 3000;
const users = JSON.parse(fs.readFileSync('users.json'));

app.use(session);
app.use(passport.initialize());
passport.use(new DigestStrategy({ qop: 'auth' },
    (username, done) => {
        console.log(`\npassport.use: username = ${username}`);
        let rc = null;
        let user = users.find(u => u.username === username);
        if (!user) {
            rc = done(null, false);
            console.log(`denied: username = ${username}`);
        } else {
            rc = done(null, user.username, user.password);
        }
        return rc;
    },
    (params, done) => {
        console.log('params: ', params);
        // Здесь вы можете добавить дополнительные проверки параметров, если необходимо
        done(null, true);
    }
));

// Перенеправление на /login
app.get('/', (req, res) => res.redirect('/login'));

// Ввод логина и пароля в prompt'е для аутентифицированного доступа к ресурсу
app.get('/login', (req, res, next) => {
    if (req.session.logout) {
        req.session.logout = false;
        delete req.headers['authorization'];
    }
    next();
})
    .get(
        '/login',
        passport.authenticate('digest', { session: false }),
        (req, res) => { res.redirect('/resource'); }
    );

// Отключить аутентифицированный доступ к ресурсу
app.get('/logout', (req, res) => {
    req.session.logout = true;
    res.redirect('/login');
});

// Ресурс отправляет сообщение RESOURCE
// При попытке неаутентифицированного доступа выполняет переадресацию на GET /login
app.get('/resource', (req, res) => {
    if (req.headers['authorization']) {
        res.send('This is resource with protection');
    } else {
        res.redirect('/login');
    }
});

// Остальные URI => Сообщение со статусом 404
app.get('*', (req, res) => {
    res.status(404).send('Error 404: Not Found');
});

app.listen(process.env.PORT || port, () => console.log(`[OK] Server running at localhost:${port}/\n`));
