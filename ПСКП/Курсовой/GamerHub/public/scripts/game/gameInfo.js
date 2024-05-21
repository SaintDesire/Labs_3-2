window.addEventListener('DOMContentLoaded', (event) => {
    const gameTitle = decodeURIComponent(window.location.search.split('=')[1]);

    const gameTitleElement = document.getElementById('gameTitle');
    const releaseDateElement = document.getElementById('releaseDate');
    const genreElement = document.getElementById('genre');
    const developerElement = document.getElementById('developer');
    const gameImagesElement = document.getElementById('gameImages');
    const mainImageElement = document.querySelector('.main-img');
    const gameIdElement = document.getElementById('game_id');


    fetch('/game', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ gameTitle: gameTitle })
    })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                console.error('Error:', data.error);
            } else {
                const images = data.images;
                const releaseDate = data.release_date;
                const genre = data.genre;
                const developer = data.developer;
                const game_id = data.game_id;
                const gameTitle = data.title;

                releaseDateElement.textContent = releaseDate;
                genreElement.textContent = genre;
                developerElement.textContent = developer;
                gameIdElement.textContent = game_id;
                gameTitleElement.textContent = gameTitle;

                images.forEach((imageUrl, index) => {
                    if (index !== images.length - 1) {
                        const imageElement = document.createElement('img');
                        imageElement.src = imageUrl;
                        imageElement.alt ='Game Image';
                        imageElement.classList.add('game-image');
                        imageElement.addEventListener('click', () => openModal(imageUrl));
                        gameImagesElement.appendChild(imageElement);
                    }
                });

                mainImageElement.src = images[images.length - 1];
                mainImageElement.style.cursor = 'default';


            }
        })
        .catch(error => {
            console.error('Error:', error);
        });

    // Внутри <script> тега
    const modal = document.getElementById('myModal');
    const modalImage = document.getElementById('modalImage');

    function openModal(imageUrl) {
        modalImage.src = imageUrl;
        modal.style.display = 'block';
    }

    modal.addEventListener('click', () => {
        modal.style.display = 'none';
    });
});