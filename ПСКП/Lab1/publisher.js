const redis = require('redis');

const publisher = redis.createClient();

const publishMessage = async () => {
    try {
        await publisher.connect();

        await publisher.publish('myChannel', 'Hello');
        publisher.quit();

        console.log('Message published successfully');
    } catch (error) {
        console.error('Error publishing message:', error);
    }
};

publishMessage();
