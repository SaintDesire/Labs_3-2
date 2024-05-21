const { Sequelize, Op } = require('sequelize');

const sequelize = new Sequelize('GamerHub', 'student', 'fitfit', {
    host: 'localhost',
    dialect: 'mssql',
    logging: false
});

sequelize
    .authenticate()
    .then(() => {
        console.log('Database connection has been established successfully');
    })
    .catch((error) => {
        console.error('Unable to connect to the database:', error);
    });

const User = sequelize.define('Users', {
    user_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    username: {
        type: Sequelize.STRING,
        allowNull: false
    },
    password: {
        type: Sequelize.STRING,
        allowNull: false
    },
    email: {
        type: Sequelize.STRING,
        allowNull: false
    },
    role: {
        type: Sequelize.STRING,
        allowNull: false
    },
    registration_date: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.NOW
    },
    avatar: {
        type: Sequelize.BLOB('long'),
        allowNull: true
    }
}, {
    tableName: 'Users',
    timestamps: false
});

const Game = sequelize.define('Games', {
    game_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    title: {
        type: Sequelize.STRING,
        allowNull: false
    },
    release_date: {
        type: Sequelize.DATE,
        allowNull: false
    },
    developer: {
        type: Sequelize.STRING,
        allowNull: false
    },
    genre: {
        type: Sequelize.STRING,
        allowNull: false
    }
}, {
    tableName: 'Games', // Название таблицы
    timestamps: false // Если нет столбцов created_at и updated_at
});

const Rating = sequelize.define('Rating', {
    rating_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    game_id: {
        type: Sequelize.INTEGER,
        allowNull: false
    },
    user_id: {
        type: Sequelize.INTEGER,
        allowNull: false
    },
    rating: {
        type: Sequelize.INTEGER,
        allowNull: false
    },
}, {
    tableName: 'Ratings',
    timestamps: false
});

const Wishlist = sequelize.define('Wishlist', {
    wishlist_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    user_id: Sequelize.INTEGER,
    game_id: Sequelize.INTEGER
}, {
    tableName: 'Wishlist',
    timestamps: false
});

const Notification = sequelize.define('Notifications', {
    notification_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    message: {
        type: Sequelize.TEXT,
        allowNull: false
    }
}, {
    tableName: 'Notifications',
    timestamps: false
});



const Feedback = sequelize.define('Feedback', {
    feedback_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    message: {
        type: Sequelize.TEXT,
        allowNull: false
    },
    game_id: {
        type: Sequelize.INTEGER, // Тип поля может отличаться в зависимости от вашей базы данных
        allowNull: false
    }
}, {
    tableName: 'Feedback',
    timestamps: false,
    associate: function(models) {
        Feedback.belongsTo(models.User, { foreignKey: 'user_id' });
    }
});

User.hasMany(Rating, { foreignKey: 'user_id' });
Rating.belongsTo(User, { foreignKey: 'user_id' });

Game.hasMany(Rating, { foreignKey: 'game_id' });
Rating.belongsTo(Game, { foreignKey: 'game_id' });

User.hasMany(Wishlist, { foreignKey: 'user_id' });
Wishlist.belongsTo(User, { foreignKey: 'user_id' });

Game.hasMany(Wishlist, { foreignKey: 'game_id' });
Wishlist.belongsTo(Game, { foreignKey: 'game_id' });

User.hasMany(Feedback, { foreignKey: 'user_id' });
Feedback.belongsTo(User, { foreignKey: 'user_id' });



// Синхронизация моделей с базой данных
async function syncDatabase() {
    try {
        await sequelize.sync({ alter: true });
        console.log('Таблицы успешно созданы и синхронизированы с базой данных');
    } catch (error) {
        console.error('Ошибка создания и синхронизации таблиц:', error);
    }
}


module.exports = {
    sequelize,
    syncDatabase,
    User,
    Game,
    Rating,
    Wishlist,
    Notification,
    Feedback,
    Op
};