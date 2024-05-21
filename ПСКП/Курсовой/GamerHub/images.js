const axios = require('axios');
const cheerio = require('cheerio');
const winston = require('winston');

// Функция для преобразования названия игры в формат URL
function formatGameTitle(gameTitle) {
    return gameTitle.replace(/[^a-zA-Z0-9\s]/g, "").replace(/\s/g, "-").toLowerCase();
}

// Функция для извлечения URL изображений из HTML
function extractImageUrls($) {
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

    return images;
}

// Функция для получения картинок игры
async function getGameImages(gameTitle) {
    const formattedTitle = formatGameTitle(gameTitle);
    const url = `https://www.gamespot.com/games/${formattedTitle}/`;

    try {
        const response = await axios.get(url);
        const $ = cheerio.load(response.data);
        let images = extractImageUrls($);

        if (images.length === 0) {
            const words = gameTitle.split(' ');
            if (words.length > 1) {
                const newTitle = words.slice(0, -1).join(' ');
                return await getGameImages(newTitle);
            } else {
                throw new Error('No images found');
            }
        }

        return images;
    } catch (error) {
        winston.error('Error fetching game images:', error);
        return [];
    }
}

module.exports = {
    formatGameTitle,
    getGameImages
};