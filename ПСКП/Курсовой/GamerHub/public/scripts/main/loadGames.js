totalPages = null;

function addGames(data) {
    const gameInfo = document.getElementById('gameInfo');
    gameInfo.style.display = 'flex'; // Добавьте стиль display для использования Flexbox
    gameInfo.style.flexWrap = 'wrap'; // Разрешить перенос блоков на новую строку

    while (gameInfo.firstChild) {
        gameInfo.removeChild(gameInfo.firstChild);
    }

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
        gameInfo.appendChild(gameLink);

        const gameTitle = document.createElement('p');
        gameTitle.textContent = game.gameTitle;
        gameElement.appendChild(gameTitle);
    });
}

window.addEventListener('DOMContentLoaded', (event) => {
    fetch('/gamesList')
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                console.error('Error:', data.error);
            } else {
                addGames(data);
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });

    async function getGameCountAndPages() {
        try {
            const response = await fetch('/countGames');
            const data = await response.json();

            const count = data.count;
            totalPages = Math.ceil(count / 15);

            createPageButtons(totalPages, 1); // Создаем кнопки для первой страницы
        } catch (error) {
            console.error('Ошибка при получении общего количества игр:', error);
        }
    }

    function createPageButtons(totalPages, currentPage) {
        const paginationButtons = document.getElementById('paginationButtons');
        paginationButtons.innerHTML = ''; // Очистить содержимое элемента
        const maxButtons = 8; // Максимальное количество кнопок для отображения

// Определение первой и последней страницы для отображения
        let startPage, endPage;
        if (totalPages <= maxButtons) {
            // Если общее количество страниц меньше или равно максимальному количеству кнопок,
            // отображаем все страницы
            startPage = 2;
            endPage = totalPages - 1;
        } else {
            // Если общее количество страниц больше максимального количества кнопок,
            // вычисляем первую и последнюю страницы для отображения
            if (currentPage <= (Math.floor(maxButtons / 2) + 1)) {
                // Если текущая страница ближе к началу, отображаем первые maxButtons страниц
                startPage = 2;
                endPage = maxButtons + startPage;
            } else if (currentPage + Math.floor(maxButtons / 2) >= totalPages) {
                // Если текущая страница ближе к концу, отображаем последние maxButtons страниц
                startPage = totalPages - (maxButtons + 1);
                endPage = totalPages - 1;
            } else {
                // В остальных случаях отображаем страницы вокруг текущей страницы
                startPage = currentPage - Math.floor(maxButtons / 2);
                endPage = currentPage + Math.floor(maxButtons / 2);

            }
        }


            const firstButton = document.createElement('button');
            firstButton.textContent = '1';
            firstButton.classList.add('pagesButton'); // Добавить класс "button"
            firstButton.addEventListener('click', function() {
                goToPage(1);
            });
            paginationButtons.appendChild(firstButton);

        for (let i = startPage; i <= endPage; i++) {
            if (i !== 1 && i !== totalPages) {
                const button = document.createElement('button');
                button.textContent = i;
                button.classList.add('pagesButton'); // Добавить класс "button"
                button.addEventListener('click', function() {
                    goToPage(i);
                });

                if (i === currentPage) {
                    button.classList.add('active'); // Добавить класс "active" для текущей страницы
                }

                paginationButtons.appendChild(button); // Добавить кнопку в элемент
            }
        }

            const lastButton = document.createElement('button');
            lastButton.textContent = totalPages;
            lastButton.classList.add('pagesButton'); // Добавить класс "button"
            lastButton.addEventListener('click', function() {
                goToPage(totalPages);
            });
            paginationButtons.appendChild(lastButton);


        const pageInput = document.createElement('input');
        pageInput.type = 'number';
        pageInput.min = 1;
        pageInput.max = totalPages;
        pageInput.value = currentPage;
        pageInput.classList.add('page-input'); // Добавить класс "page-input"
        paginationButtons.appendChild(pageInput);

        pageInput.addEventListener('input', function() {
            let pageNumber = parseInt(pageInput.value);
            if (pageNumber < 1) {
                pageNumber = 1;
            } else if (pageNumber > totalPages) {
                pageNumber = totalPages;
            }
            pageInput.value = pageNumber;
        });

        // Создание кнопки для перехода на указанную страницу
        const goButton = document.createElement('button');
        goButton.textContent = 'Go';
        goButton.classList.add('go-button'); // Добавить класс "go-button"
        goButton.addEventListener('click', function() {
            const pageNumber = parseInt(pageInput.value);
            if (pageNumber >= 1 && pageNumber <= totalPages) {
                goToPage(pageNumber);
            } else {
                console.error('Invalid page number');
            }
        });
        paginationButtons.appendChild(goButton);
    }

    function goToPage(page) {
        console.log('Переход на страницу:', page);
        createPageButtons(totalPages, page)
        // Отправить запрос на сервер с указанием номера страницы
        fetch(`/gamesList?page=${page}`)
            .then(response => response.json())
            .then(data => {
                addGames(data)
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }

    getGameCountAndPages()
});