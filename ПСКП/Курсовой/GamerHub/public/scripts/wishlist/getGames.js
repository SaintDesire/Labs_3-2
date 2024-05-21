window.addEventListener("DOMContentLoaded", function() {
    // Проверка, что user_id не пустая строка
    const checkUserId = setInterval(() => {
        let user_id = document.getElementById('user-id').textContent;
        if (user_id !== "") {
            clearInterval(checkUserId);

            // Отправить GET-запрос для получения списка игр из обработчика
            fetch(`/wishlist-games?user_id=${user_id}`)
                .then(response => response.json())
                .then(data => {
                    if (data.games) {
                        const gameInfo = document.getElementById('wishlist');
                        gameInfo.style.display = 'flex'; // Установите родительский элемент в режим Flexbox
                        gameInfo.style.flexWrap = 'wrap'; // Разрешить перенос блоков на новую строку

                        data.games.forEach(game => {
                            const gameLink = document.createElement('a');
                            gameLink.href = '/game?gameTitle=' + encodeURIComponent(game.gameTitle);
                            gameLink.classList.add('game-link');

                            const gameElement = document.createElement('div');
                            gameElement.classList.add('game');
                            gameElement.style.width = '250px';
                            gameElement.style.border = '1px solid black';
                            gameElement.style.padding = '15px';
                            gameElement.style.textAlign = 'center';

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
                                const noImageText = document.createElement('span');
                                noImageText.textContent = 'No image';
                                noImageText.style.width = '200px';
                                noImageText.style.height = '200px';
                                noImageText.style.display = 'inline-block';
                                noImageText.style.transform = 'rotate(45deg)';
                                noImageText.style.margin = '10px';
                                noImageText.style.border = '1px solid black';
                                gameElement.appendChild(noImageText);
                            }

                            gameLink.appendChild(gameElement);
                            gameInfo.appendChild(gameLink);

                            const gameTitle = document.createElement('p');
                            gameTitle.textContent = game.gameTitle;
                            gameElement.appendChild(gameTitle);
                        });
                    } else {
                        console.log('Не удалось получить список игр');
                    }
                })
                .catch(error => {
                    console.error("Произошла ошибка при отправке GET-запроса:", error);
                });
        }
    }, 250);
});