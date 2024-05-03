const express = require('express');
const passport = require('passport');
const session = require('express-session');
const GoogleStrategy = require('passport-google-oauth20').Strategy;

const app = express();
app.use(session({ secret: 'secret-key', resave: true, saveUninitialized: true }));
app.use(passport.initialize());
app.use(passport.session());

// Конфигурация паспорта и стратегии аутентификации
// здесь необходимо подставить свои данные для социальной сети
passport.use(new GoogleStrategy({
    clientID: '215131105079-fpr0v3trognc64r95ckksnga4ed3epng.apps.googleusercontent.com',
    clientSecret: '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',
    callbackURL: '/auth/google/callback'
}, (accessToken, refreshToken, profile, cb) => {
    // здесь можно сохранить информацию о пользователе в базу данных
    return cb(null, profile);
}));

// Настройка сериализации и десериализации пользователя
passport.serializeUser((user, cb) => {
    cb(null, user);
});

passport.deserializeUser((obj, cb) => {
    cb(null, obj);
});

// Маршрут для аутентификации через Google
app.get('/auth/google', (req, res, next) => {
    if (req.isAuthenticated() && !req.query.logout) {
        res.redirect('/resource');
    } else {
        passport.authenticate('google', { scope: ['profile'], prompt: 'select_account' })(req, res, next);
    }
}, passport.authenticate('google', { scope: ['profile'], prompt: 'select_account' }));

// Маршрут коллбэка после аутентификации через Google
app.get('/auth/google/callback', passport.authenticate('google', {
    successRedirect: '/resource',
    failureRedirect: '/login'
}));

app.get('/logout', (req, res) => {
    req.logout(function(err) {
        if (err) {
            console.log(err);
        }
        res.redirect('/login');
    });
});

// Маршрут для доступа к защищенному ресурсу
app.get('/resource', (req, res) => {
    if (req.isAuthenticated()) {
        res.send('RESOURCE: ' + JSON.stringify(req.user));
    } else {
        res.redirect('/login');
    }
});

// Маршрут для отображения страницы аутентификации
app.get('/login', (req, res) => {
    res.send('<a href="/auth/google">Login with Google</a>');
});

// Маршрут для обработки неизвестных URI
app.get('*', (req, res) => {
    res.status(404).send('404 Not Found');
});

// Запуск сервера на порту 3000
app.listen(3000, () => {
    console.log('Server is running on port 3000');
});