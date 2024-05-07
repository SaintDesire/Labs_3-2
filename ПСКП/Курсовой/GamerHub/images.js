const axios = require('axios');
const cheerio = require('cheerio');
// Функция для преобразования названия игры в формат URL
function formatGameTitle(gameTitle) {
    return gameTitle.replace(/[^a-zA-Z0-9\s]/g, "").replace(/\s/g, "-").toLowerCase();
}

// Функция для получения картинок игры
async function getGameImages(gameTitle) {
    const formattedTitle = formatGameTitle(gameTitle);
    const url = `https://www.gamespot.com/games/${formattedTitle}/`;
    console.log(url)

    try {
        const response = await axios.get(url);
        const $ = cheerio.load(response.data);
        const imageElements = $('.pod-images__item img');
        const additionalImageElement = $('.imgflare--boxart img');

        const images = [];
        imageElements.each((index, element) => {
            const imageUrl = $(element).attr('src');
            images.push(imageUrl);
        });

        const additionalImageUrl = additionalImageElement.attr('src');
        if (additionalImageUrl) {
            images.push(additionalImageUrl);
        }

        if (images.length === 0) {
            const words = gameTitle.split(' ');
            console.log(words)
            if (words.length > 1) {
                const newTitle = words.slice(0, -1).join(' ');
                return await getGameImages(newTitle);
            } else {
                throw new Error('No images found');
            }
        }

        return images;
    } catch (error) {
        console.error('Error:', error);
        return [];
    }
}


module.exports = {
    formatGameTitle,
    getGameImages
}