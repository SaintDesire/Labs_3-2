const redis = require('redis');

// Создание клиента Redis для подписчика
const subscriber = redis.createClient();

// Функция для подписки на канал и обработки сообщений
const subscribeToChannel = async () => {
    try {
        // Подключение к Redis
        await subscriber.connect();

        // Подписка на канал 'myChannel' и обработка сообщений
        await subscriber.subscribe('myChannel', (channel, message) => {
            console.log(`Received message from channel ${channel}: ${message}`);
        });

    } catch (error) {
        console.error('Error subscribing to channel:', error);
    }
};

// Вызов функции для подписки на канал
subscribeToChannel();
