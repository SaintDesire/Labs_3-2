window.addEventListener("DOMContentLoaded", function() {
    const game_idElement = document.getElementById("game_id");
    const user_idElement = document.getElementById("user-id");
    const likeButton = document.getElementById("likeButton");
    likeButton.style.userSelect = 'none';

    // Проверка значений каждые 250 мс
    const checkValuesInterval = setInterval(() => {
        if (game_idElement.textContent && user_idElement.textContent) {
            const game_id = game_idElement.textContent;
            const user_id = user_idElement.textContent;
            likeButton.classList.add("enabled");

            // Отправить GET-запрос для проверки наличия игры в списке желаемого
            fetch(`/check-favourite/${game_id}/${user_id}`)
                .then(response => response.json())
                .then(data => {
                    if (data.isFavourite) {
                        likeButton.innerHTML = "❤️";
                        likeButton.style.color = "red";
                    } else {
                        likeButton.innerHTML = "🤍";
                        likeButton.style.color = "initial";
                    }
                })
                .catch(error => {
                    console.error("Произошла ошибка при отправке GET-запроса:", error);
                });

            // Остановка проверки значений после отправки запроса
            clearInterval(checkValuesInterval);
        }
    }, 250);
});

document.getElementById("likeButton").addEventListener("click", function() {
    const likeButton = this;
    const game_id = document.getElementById("game_id").textContent;
    const user_id = document.getElementById("user-id").textContent;

    if (likeButton.innerHTML === "🤍") {
        likeButton.innerHTML = "❤️";
        likeButton.style.color = "red";

        // Отправить запрос на сервер для добавления игры в список желаемого
        fetch("/add-to-favourites", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                game_id: game_id,
                user_id: user_id
            })
        })
            .then(response => {
                if (response.ok) {
                    console.log("Игра добавлена в список желаемого");
                } else {
                    console.error("Не удалось добавить игру в список желаемого");
                }
            })
            .catch(error => {
                console.error("Произошла ошибка при отправке запроса:", error);
            });
    } else {
        likeButton.innerHTML = "🤍";
        likeButton.style.color = "initial";

        // Отправить запрос на сервер для удаления игры из списка желаемого
        fetch("/remove-from-favourites", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                game_id: game_id,
                user_id: user_id
            })
        })
            .then(response => {
                if (response.ok) {
                    console.log("Игра удалена из списка желаемого");
                } else {
                    console.error("Не удалось удалить игру из списка желаемого");
                }
            })
            .catch(error => {
                console.error("Произошла ошибка при отправке запроса:", error);
            });
    }
});