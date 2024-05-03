window.addEventListener('DOMContentLoaded', (event) => {
    fetch('/gamesList')
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                console.error('Error:', data.error);
            } else {
                const gameInfo = document.getElementById('gameInfo');
                data.games.forEach(game => {
                    const gameElement = document.createElement('div');
                    const gameTitle = document.createElement('p');
                    const gameLink = document.createElement('a');

                    gameTitle.textContent = game.gameTitle;
                    gameLink.href = '/game?gameTitle=' + encodeURIComponent(game.gameTitle);
                    gameLink.classList.add('game-link');
                    gameLink.appendChild(gameTitle);

                    gameElement.classList.add('game');
                    gameElement.style.border = '1px solid black';
                    gameElement.style.padding = '15px';
                    gameElement.appendChild(gameLink);

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
                    }

                    gameInfo.appendChild(gameElement);
                });
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
});