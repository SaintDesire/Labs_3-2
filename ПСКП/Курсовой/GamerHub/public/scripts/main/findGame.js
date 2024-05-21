
const form = document.querySelector('form');
const gameTitleInput = document.querySelector('#gameTitle');
const gameInfoDiv = document.querySelector('#gameInfo');
form.addEventListener('submit', (event) => {
    event.preventDefault();
    const gameTitle = gameTitleInput.value;
    const formattedGameTitle = encodeURIComponent(gameTitle);
    console.log(formattedGameTitle)
    const gameUrl = '/game?gameTitle=' + formattedGameTitle;

    window.location.href = gameUrl;
});

gameTitleInput.addEventListener('input', (event) => {
    const input = event.target;
    const inputValue = input.value;

    if (inputValue.length >= 2) {
        fetch('/search?gameTitle=' + encodeURIComponent(inputValue))
            .then((response) => response.json())
            .then((data) => {
                const searchResults = data.games;
                const suggestionsDiv = document.querySelector('#suggestionsDiv');

                if (suggestionsDiv) {
                    suggestionsDiv.innerHTML = '';
                } else {
                    const suggestionsDiv = document.createElement('div');
                    suggestionsDiv.id = 'suggestionsDiv';
                    suggestionsDiv.style.display = 'flex';
                    suggestionsDiv.style.flexWrap = 'wrap';
                    suggestionsDiv.style.marginTop = '10px';
                    form.appendChild(suggestionsDiv);
                }

                searchResults.forEach((game) => {
                    const suggestion = document.createElement('div');
                    const suggestionLink = document.createElement('a');

                    suggestionLink.href = '/game?gameTitle=' + encodeURIComponent(game.title);
                    suggestionLink.classList.add('game-link');
                    suggestionLink.textContent = game.title;

                    suggestion.classList.add('suggestion');
                    suggestion.style.padding = '5px';
                    suggestion.style.margin = '5px';
                    suggestion.style.border = '1px solid black';
                    suggestion.addEventListener('click', () => {
                        gameTitleInput.value = game.title;
                        suggestionsDiv.remove();
                        form.dispatchEvent(new Event('submit'));
                    });
                    suggestion.appendChild(suggestionLink);
                    suggestionsDiv.appendChild(suggestion);
                });
            })
            .catch((error) => {
                console.error('Error:', error);
            });
    } else {
        const suggestionsDiv = document.querySelector('#suggestionsDiv');
        if (suggestionsDiv) {
            suggestionsDiv.remove();
        }
    }
});

document.addEventListener('click', (event) => {
    if (gameTitleInput.value.length >= 3) {
        return;
    }

    const suggestionsDiv = document.querySelector('#suggestionsDiv');
    if (event.target !== gameTitleInput && event.target !== suggestionsDiv) {
        if (suggestionsDiv) {
            suggestionsDiv.remove();
        }
    }
});