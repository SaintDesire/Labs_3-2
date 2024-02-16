const redis = require("redis");

const client = redis.createClient();

async function testIncr() {
    for (let i = 1; i <= 10000; i++) {
        await client.incr("incr");
    }
}

async function testDecr() {
    for (let i = 1; i <= 10000; i++) {
        await client.decr("incr");
    }
}

async function runTests() {
    try {
        console.time("incr");
        await testIncr();
        console.timeEnd("incr");

        console.time("decr");
        await testDecr();
        console.timeEnd("decr");
    } catch (error) {
        console.error("Error during tests:", error);
    } finally {
        client.quit().then(() => {
            console.log("Redis connection closed");
        }).catch((err) => {
            console.log("Redis connection error:", err);
        });
    }
}

client.connect().then(async () => {
    console.log('connect Redis');
    await runTests();
}).catch((err) => {
    console.log('connection error Redis:', err);
});