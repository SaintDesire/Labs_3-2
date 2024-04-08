const {Sequelize} = require('sequelize');

const sequelize = new Sequelize('Lab17', 'student', 'fitfit', {
    host: 'localhost',
    dialect: 'mssql',
});

module.exports = sequelize;