const { Sequelize, Op } = require('sequelize');

const sequelize = new Sequelize('GamerHub', 'student', 'fitfit', {
    host: 'localhost',
    dialect: 'mssql',
    logging: false
});

// Определение моделей таблиц
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
    }
}, {
    tableName: 'Users', // Название таблицы
    timestamps: false // Если нет столбцов created_at и updated_at
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

const Rating = sequelize.define('Ratings', {
    rating_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    rating: {
        type: Sequelize.INTEGER,
        allowNull: false
    },
    comment: {
        type: Sequelize.TEXT,
        allowNull: false
    }
});

const Wishlist = sequelize.define('Wishlist', {
    wishlist_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    }
}, {
    tableName: 'Wishlist', // Название таблицы
    timestamps: false // Если нет столбцов created_at и updated_at
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
    tableName: 'Notifications', // Название таблицы
    timestamps: false // Если нет столбцов created_at и updated_at
});

const UserList = sequelize.define('UserLists', {
    list_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    title: {
        type: Sequelize.STRING,
        allowNull: false
    }
}, {
    tableName: 'UserLists', // Название таблицы
    timestamps: false // Если нет столбцов created_at и updated_at
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
    }
}, {
    tableName: 'Feedback', // Название таблицы
    timestamps: false // Если нет столбцов created_at и updated_at
});

const Recommendation = sequelize.define('Recommendations', {
    recommendation_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    }
}, {
    tableName: 'Recommendations', // Название таблицы
    timestamps: false // Если нет столбцов created_at и updated_at
});

const Language = sequelize.define('Languages', {
    language_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    language_name: {
        type: Sequelize.STRING,
        allowNull: false
    }
}, {
    tableName: 'Languages', // Название таблицы
    timestamps: false // Если нет столбцов created_at и updated_at
});

const Localization = sequelize.define('Localization', {
    localization_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    localized_title: {
        type: Sequelize.STRING,
        allowNull: false
    },
    localized_description: {
        type: Sequelize.TEXT,
        allowNull: false
    }
}, {
    tableName: 'Localization', // Название таблицы
    timestamps: false // Если нет столбцов created_at и updated_at
});

User.hasMany(Rating, { foreignKey: 'user_id' });
Rating.belongsTo(User, { foreignKey: 'user_id' });

Game.hasMany(Rating, { foreignKey: 'game_id' });
Rating.belongsTo(Game, { foreignKey: 'game_id' });

User.hasMany(Wishlist, { foreignKey: 'user_id' });
Wishlist.belongsTo(User, { foreignKey: 'user_id' });

Game.hasMany(Wishlist, { foreignKey: 'game_id' });
Wishlist.belongsTo(Game, { foreignKey: 'game_id' });

User.hasMany(Notification, { foreignKey: 'user_id' });
Notification.belongsTo(User, { foreignKey: 'user_id' });

Game.hasMany(Notification, { foreignKey: 'game_id' });
Notification.belongsTo(Game, { foreignKey: 'game_id' });

User.hasMany(UserList, { foreignKey: 'user_id' });
UserList.belongsTo(User, { foreignKey: 'user_id' });

Game.hasMany(UserList, { foreignKey: 'game_id' });
UserList.belongsTo(Game, { foreignKey: 'game_id' });

User.hasMany(Feedback, { foreignKey: 'user_id' });
Feedback.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Recommendation, { foreignKey: 'user_id' });
Recommendation.belongsTo(User, { foreignKey: 'user_id' });

Game.hasMany(Recommendation, { foreignKey: 'game_id' });
Recommendation.belongsTo(Game, { foreignKey: 'game_id' });

Language.hasMany(Localization, { foreignKey: 'language_id' });
Localization.belongsTo(Language, { foreignKey: 'language_id' });

Game.hasMany(Localization, { foreignKey: 'game_id' });
Localization.belongsTo(Game, { foreignKey: 'game_id' });


// Определите остальные связи

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
    UserList,
    Feedback,
    Recommendation,
    Language,
    Localization,
    Op
};