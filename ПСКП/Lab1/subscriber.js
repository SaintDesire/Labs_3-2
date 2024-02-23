const redis = require('redis');

const subscriber = redis.createClient();

const subscribeToChannel = async () => {
    try {
        await subscriber.connect();

        await subscriber.subscribe('myChannel', (message, channel) => {
            console.log(`Received message from channel ${channel}: ${message}`);
        });
    } catch (error) {
        console.error('Error subscribing to channel:', error);
    }
};

subscribeToChannel();
