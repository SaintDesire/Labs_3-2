const redis = require("redis");

const client = redis.createClient();

async function testHSet() {
    for (let i = 1; i <= 10000; i++) {
        await client.hSet(i.toString(),`id:${i}`,`${JSON.stringify({val:`val-${i}`})}`);
    }
}
async function testHGet() {
    for (let i = 1; i <= 10000; i++) {
        await client.hGet(i.toString(), `id:${i}`);
    }
}

async function runTests() {
    try {
        console.time("hset");
        await testHSet();
        console.timeEnd("hset");

        console.time("hget");
        await testHGet();
        console.timeEnd("hget");
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