const Router = require('express');
const session = require('express-session');
const jwt = require('jsonwebtoken');
const router = new Router();
const fs = require('fs');
const redis = require("redis");
const bodyParser = require("body-parser");
const cookieParser = require('cookie-parser');
const { sequelizeClient, User } = require('../db');

const redisClient = redis.createClient();
redisClient.connect().then(() => {
    console.log('connect Redis');
}).catch((err) => {
    console.log('connection error Redis:', err);
});

router.use(bodyParser.urlencoded({ extended: true }));
router.use(bodyParser.json());
router.use(cookieParser());

redisClient.on("ready", () => {
    console.log("Connected!");
});

redisClient.on("error", (err) => {
    console.log("Error in the Connection");
});

router.use(session({
    secret: 'korshun',
    resave: false,
    saveUninitialized: false
}));

const generateAccesToken = (username, email, _expiresIn = '24m', _secret = secret) => {
    const payload = {
        username,
        email
    };
    return jwt.sign(payload, _secret, { expiresIn: _expiresIn });
}

function decodeToken(token) {
    try {
        const decoded = jwt.decode(token);
        return decoded;
    } catch (error) {
        console.error('Error decoding token:', error.message);
        return null;
    }
}

router.get('/logout', (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            console.error('Error destroying session:', err);
            res.status(500).send('Internal Server Error');
        } else {
            res.clearCookie('access_token');
            res.clearCookie('refresh_token');
            res.redirect('/login');
        }
    });
});
router.get('/resource', async (req, res) => {
    if (req.session && req.session.user) {
        const { username } = req.session.user;
        const { refreshToken } = req.cookies;

        jwt.verify(refreshToken, 'refresh_secret', async (err, user) => {
            if (err) {
                return res.status(401).send('Unauthorized');
            }
        });

        try {
            console.log("GET | /resource | refreshToken", refreshToken);

            const result2 = await redisClient.get(`key${refreshToken}`);

            if (`${username}` === result2) {
                return res.status(401).send('Refresh token is in the BLACKLIST :)');
            }
        } catch (error) {
            console.error('Error accessing Redis:', error);
            return res.status(500).send('Internal Server Error');
        }

        res.send(`Resource page. You're authorized. <br/> Username: ${req.session.user.username} Info: ${req.session.user.email}`);
    } else {
        res.status(401).send('Unauthorized');
    }
});

router.get('/refresh-token', async (req, res) => {
    const existRefreshToken = req.cookies.refreshToken;
    console.log("/refresh-token | existRefreshToken", existRefreshToken);
    const decodedToken = decodeToken(existRefreshToken);

    if (decodedToken)
        console.log('Decoded token:', decodedToken);
    else
        console.log('Token decoding failed.');

    if (existRefreshToken) {
        jwt.verify(existRefreshToken, 'refresh_secret', async (err, user) => {
            if (err) {
                return res.status(401).send('Unauthorized');
            } else if (user) {
                const usrname = user.username;
                console.log("Check key: ", `key${existRefreshToken}`);

                const Banned = await redisClient.get(`key${existRefreshToken}`);
                if (`value ${usrname}` === Banned) {
                    return res.status(401).send('Refresh token in black list');
                }

                const newAccessToken = generateAccesToken(decodedToken.username, decodedToken.email, '10m', 'access_secret');
                const newRefreshToken = generateAccesToken(decodedToken.username, decodedToken.email, '24h', 'refresh_secret');

                res.clearCookie('accessToken');
                res.clearCookie('refreshToken');

                res.cookie('accessToken', newAccessToken, { httpOnly: true, sameSite: 'strict' });
                res.cookie('refreshToken', newRefreshToken, { httpOnly: true, sameSite: 'strict', path: '/' });

                await redisClient.set(`key${existRefreshToken}`, `${usrname}`);
                const bannedToken = await redisClient.get(`key${existRefreshToken}`);

                console.log('ADD refresh token in black list', bannedToken);
                console.log('NEW refreshToken ' + newRefreshToken);

                res.redirect('/resource');
            }
        });
    } else {
        res.status(400).send('No refresh token provided');
    }
});

router.post('/login', (req, res) => {
    const { username, password } = req.body;

    User.findOne({ where: { username: username } })
        .then(user => {
            if (user) {
                if (user.password === password) {
                    req.session.user = user;
                    try {
                        const accessToken = generateAccesToken(user.username, user.email, '10m', 'access_secret');
                        const refreshToken = generateAccesToken(user.username, user.email, '24h', 'refresh_secret');

                        res.cookie('accessToken', accessToken, { httpOnly: true, sameSite: 'strict' });
                        res.cookie('refreshToken', refreshToken, { httpOnly: true, sameSite: 'strict', path: '/' });

                        res.redirect('/resource');
                    } catch (error) {
                        console.error('Error:', error);
                        res.status(500).send('Internal Server Error');
                    }
                } else {
                    res.status(401).send('Incorrect password');
                }
            } else {
                res.redirect('/login');
            }
        })
        .catch(err => {
            console.error('Error:', err);
            res.status(500).send('Internal Server Error');
        });
});

router.post('/register', (req, res) => {
    console.log('register');
    const { username, email, password } = req.body;
    role = 'user';

    User.findOne({ where: { username: username } })
        .then(existingUser => {
            if (existingUser) {
                // Имя пользователя уже занято
                res.status(400).send('Username already taken');
            } else {
                // Создаем нового пользователя
                User.create({ username: username, password: password, email: email, role: role })
                    .then(user => {
                        res.status(200).redirect('/login');
                    })
                    .catch(err => {
                        console.error('Error registering user:', err);
                        res.status(500).send('Error registering user');
                    });
            }
        })
        .catch(err => {
            console.error('Error checking existing user:', err);
            res.status(500).send('Error checking existing user');
        });
});

router.use(function (err, req, res, next) {
    res.send(err.message);
});

module.exports = router;