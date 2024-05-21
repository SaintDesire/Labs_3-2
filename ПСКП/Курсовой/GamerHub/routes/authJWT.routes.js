const Router = require('express');
const jwt = require('jsonwebtoken');
const router = new Router();
const fs = require('fs');
const redis = require("redis");
const bodyParser = require("body-parser");
const cookieParser = require('cookie-parser');
const { sequelizeClient, User } = require('../db');
const crypto = require('crypto');

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

const generateAccessToken = (username, email, _expiresIn = '24m', _secret = secret) => {
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

const authenticateToken = (req, res, next) => {
    const token = req.cookies.accessToken;

    if (!token) return res.sendStatus(401);

    jwt.verify(token, 'access_secret', (err, user) => {
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
};

const hashPassword = (password) => {
    return crypto.createHash('sha256').update(password).digest('hex');
};

router.get('/logout', (req, res) => {
    // Очистка куки с токенами
    res.clearCookie('accessToken', { httpOnly: true, sameSite: 'strict' });
    res.clearCookie('refreshToken', { httpOnly: true, sameSite: 'strict', path: '/' });

    // Перенаправление на страницу входа
    res.redirect('/login');
});

router.get('/resource', authenticateToken, async (req, res) => {
    try {
        const { username } = req.user;
        const { refreshToken } = req.cookies;

        jwt.verify(refreshToken, 'refresh_secret', async (err, user) => {
            if (err) {
                return res.status(401).send('Unauthorized');
            }
        });

        const result2 = await redisClient.get(`key${refreshToken}`);
        if (`${username}` === result2) {
            return res.status(401).send('Refresh token is in the BLACKLIST :)');
        }

        res.send(`Resource page. You're authorized. <br/> Username: ${username} Info: ${req.user.email}`);
    } catch (error) {
        console.error('Error accessing resource:', error);
        return res.status(500).send('Internal Server Error');
    }
});

router.get('/user-info', authenticateToken, (req, res) => {
    const { username, email } = req.user;

    User.findOne({ where: { username: username, email: email } })
        .then(user => {
            if (user) {
                res.json(user);
            } else {
                res.status(404).send('User not found');
            }
        })
        .catch(error => {
            console.error('Error fetching user data:', error);
            res.status(500).send('Server Error');
        });
});

router.get('/refresh-token', async (req, res) => {
    const existRefreshToken = req.cookies.refreshToken;
    const decodedToken = decodeToken(existRefreshToken);

    if (existRefreshToken) {
        jwt.verify(existRefreshToken, 'refresh_secret', async (err, user) => {
            if (err) {
                return res.status(401).send('Unauthorized');
            } else if (user) {
                const usrname = user.username;
                const Banned = await redisClient.get(`key${existRefreshToken}`);
                if (`value ${usrname}` === Banned) {
                    return res.status(401).send('Refresh token in black list');
                }

                const newAccessToken = generateAccessToken(decodedToken.username, decodedToken.email, '10m', 'access_secret');
                const newRefreshToken = generateAccessToken(decodedToken.username, decodedToken.email, '24h', 'refresh_secret');

                res.clearCookie('accessToken');
                res.clearCookie('refreshToken');

                res.cookie('accessToken', newAccessToken, { httpOnly: true, sameSite: 'strict' });
                res.cookie('refreshToken', newRefreshToken, { httpOnly: true, sameSite: 'strict', path: '/' });

                await redisClient.set(`key${existRefreshToken}`, `${usrname}`);
                console.log('ADD refresh token in black list', await redisClient.get(`key${existRefreshToken}`));
                console.log('NEW refreshToken ' + newRefreshToken);
                res.status(200).json({ accessToken: newAccessToken });
            }
        });
    } else {
        res.status(400).send('No refresh token provided');
    }
});

router.post('/login', (req, res) => {
    const { username, password } = req.body;
    const hashedPassword = hashPassword(password);

    User.findOne({ where: { username: username } })
        .then(user => {
            if (user && user.password === hashedPassword) {
                const accessToken = generateAccessToken(user.username, user.email, '10m', 'access_secret');
                const refreshToken = generateAccessToken(user.username, user.email, '24h', 'refresh_secret');

                res.cookie('accessToken', accessToken, { httpOnly: true, sameSite: 'strict' });
                res.cookie('refreshToken', refreshToken, { httpOnly: true, sameSite: 'strict', path: '/' });

                res.status(200).json({ accessToken, refreshToken });
            } else {
                res.status(401).send("Incorrect username or password");
            }
        })
        .catch(err => {
            console.error('Error:', err);
            res.status(500).send('Internal Server Error');
        });
});

router.post('/register', (req, res) => {
    const { username, email, password } = req.body;
    const role = 'user';
    const registrationDate = new Date();
    const hashedPassword = hashPassword(password);

    User.findOne({ where: { username: username } })
        .then(existingUser => {
            if (existingUser) {
                res.status(400).send('Username already taken');
            } else {
                User.create({
                    username: username,
                    password: hashedPassword,
                    email: email,
                    role: role,
                    registration_date: registrationDate
                })
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