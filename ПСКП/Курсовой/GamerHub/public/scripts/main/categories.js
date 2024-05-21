
const categoriesDict = new Set(['Action', 'Role-playing', 'Strategy', 'Driving', 'Sports',
    'Arcade', 'Shooter', '2D', '3D'])
const container = document.getElementById('categories');

categoriesDict.forEach(category => {
    const button = document.createElement('button');
    button.textContent = category;
    button.style.marginBottom = '5px';
    container.appendChild(button);
    button.addEventListener('click', handleCategoryClick);
});


// Обработчик нажатия на кнопку категории
function handleCategoryClick(event) {
    const genre = event.target.textContent; // Получаем текстовое значение кнопки
    console.log(genre)
// Отправляем POST запрос на /gamesList с категорией в теле
    fetch('/gamesList', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ genre }),
    })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                console.error('Error:', data.error);
            } else {
                const gameInfoList = document.getElementById('gameInfo');
                gameInfoList.style.display = 'flex'; // Добавьте стиль display для использования Flexbox
                gameInfoList.style.flexWrap = 'wrap'; // Разрешить перенос блоков на новую строку

                while (gameInfoList.firstChild) {
                    gameInfoList.removeChild(gameInfoList.firstChild);
                }

                // Вставляем полученные игры
                data.games.forEach(game => {
                    const gameElement = document.createElement('div');
                    const gameTitle = document.createElement('p');
                    const gameLink = document.createElement('a');

                    gameTitle.textContent = game.gameTitle;
                    gameLink.href = '/game?gameTitle=' + encodeURIComponent(game.gameTitle);
                    gameLink.classList.add('game-link');

                    gameElement.classList.add('game');

                    const lastImage = game.image;
                    if (lastImage) {
                        const gameImage = document.createElement('img');
                        gameImage.src = lastImage;
                        gameImage.alt = 'Game Image';
                        gameImage.style.width = '200px';
                        gameImage.style.height = '200px';
                        gameImage.style.margin = '10px';
                        gameImage.style.border = '1px solid black';
                        gameElement.appendChild(gameImage);
                    } else {
                        const gameImage = document.createElement('img');
                        gameImage.src = 'img/noImageIcon.png    ';
                        gameImage.alt = 'Game Image';
                        gameImage.style.width = '200px';
                        gameImage.style.height = '200px';
                        gameImage.style.margin = '10px';
                        gameImage.style.border = '1px solid black';
                        gameElement.appendChild(gameImage);
                    }

                    gameLink.appendChild(gameElement);
                    gameInfoList.appendChild(gameLink);
                    gameElement.appendChild(gameTitle);
                });
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
};

