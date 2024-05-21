function getRating() {
    const ratingValue = document.getElementById('rating-value');
    const gameId = document.getElementById('game_id').textContent;

    fetch(`/getRatings/${gameId}`)
        .then((response) => response.json())
        .then((data) => {
            const rating = data.rating;
            const formattedRating = rating >= 0 ? `+${rating}` : `${rating}`;
            ratingValue.textContent = formattedRating;
        })
        .catch((error) => {
            console.error('Ошибка при получении рейтинга:', error);
        });
}

document.addEventListener('DOMContentLoaded', () => {
    const checkRatingInterval = setInterval(() => {
        const gameId = document.getElementById('game_id').textContent;

        if (gameId) {
            clearInterval(checkRatingInterval);
            getRating();
        }
    }, 100);

    const arrowUp = document.getElementById('arrow-up');
    const arrowDown = document.getElementById('arrow-down');

    let intervalId = setInterval(() => {
        const userId = document.getElementById('user-id').textContent;
        if (userId !== '') {
            clearInterval(intervalId);

            if (userId) {
                arrowUp.style.pointerEvents = 'all';
                arrowUp.style.opacity = 1;
                arrowDown.style.pointerEvents = 'all';
                arrowDown.style.opacity = 1;
            }

            arrowUp.addEventListener('click', function() {
                addRating(1);
            });

            arrowDown.addEventListener('click', function() {
                addRating(0);
            });
        }
    }, 250);

    setTimeout(() => {
        clearInterval(intervalId);
    }, 3000);
});

function addRating(ratingValue) {
    const gameId = document.getElementById('game_id').textContent;
    const userId = document.getElementById('user-id').textContent;

    fetch('/addRating', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            game_id: gameId,
            user_id: userId,
            rating: ratingValue
        })
    })
        .then(function(response) {
            if (response.ok) {
                getRating();
                console.log('Рейтинг успешно добавлен');
            } else {
                throw new Error('Ошибка при добавлении рейтинга');
            }
        })
        .catch(function(error) {
            console.error('Ошибка:', error);
        });
}