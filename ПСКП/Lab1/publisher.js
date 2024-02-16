const redis = require('redis');

// Создание клиента Redis для издателя
const publisher = redis.createClient();

// Функция для публикации сообщения
const publishMessage = async () => {
    try {
        // Подключение к Redis
        await publisher.connect();

        // Публикация сообщения на канале 'myChannel'
        await publisher.publish('myChannel', JSON.stringify('Hello'));

        // Завершение работы с клиентом Redis
        publisher.quit();

        console.log('Message published successfully');
    } catch (error) {
        console.error('Error publishing message:', error);
    }
};

// Вызов функции для публикации сообщения
publishMessage();
