const Sequelize = require('sequelize');

module.exports = new Sequelize('lab_19', 'student', 'fitfit', {
    dialect: 'mssql',
    port: 1433,
    define: {
        timestamps: false,
    },
    pool: {
        max: 5,
        min: 0,
        idle: 10000,
    },
});