user = {};

fetch('/user-info')
    .then(response => {
        if (response.ok) {
            return response.json();
        } else {
            throw new Error('Необходимо авторизоваться');
        }
    })
    .then(data => {
        user = data;
        document.getElementById('user-id').textContent = user.user_id;
        document.getElementById('commentForm').style.display = 'block';
    })
    .catch(error => {
        console.error('Ошибка:', error);
        document.getElementById('commentForm').style.display = 'none';
        const errorMessage = document.createElement('div');
        errorMessage.innerText = 'Необходимо авторизоваться';
        document.getElementById('comments-section').appendChild(errorMessage);
    });


document.getElementById("commentForm").addEventListener("submit", function(event) {
    event.preventDefault();

    var form = event.target;
    var comment = form.elements.comment.value;
    const game_id = document.getElementById('game_id').textContent;

    // Проверка наличия авторизации пользователя
    if (!user.user_id) {
        console.error("Ошибка: Необходимо авторизоваться");
        return;
    }

    fetch("/addComment", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            comment: comment,
            user_id: user.user_id,
            game_id: game_id
        })
    })
        .then(function(response) {
            if (response.status === 200) {
                // Обработка успешного добавления комментария
                console.log("Комментарий успешно добавлен");
                // Очистка формы
                form.elements.comment.value = "";
                // Обновление списка комментариев
                getComments();
            } else {
                return response.text(); // Получить текст ошибки из ответа
            }
        })
        .then(function(errorMessage) {
            if (errorMessage) {
                console.error("Ошибка при добавлении комментария:", errorMessage);
            }
        })
        .catch(function(error) {
            console.error("Error:", error);
        });
});
function getComments() {
    const game_id = document.getElementById('game_id').textContent;

    fetch("/getComments?game_id=" + game_id)
        .then(function(response) {
            if (response.status === 200) {
                return response.json();
            } else {
                throw new Error("Ошибка при получении комментариев");
            }
        })
        .then(function(comments) {
            var commentsContainer = document.getElementById("comments-container");
            commentsContainer.innerHTML = "";

            if (comments.length === 0) {
                var noCommentsBlock = document.createElement("div");
                noCommentsBlock.classList.add("no-comments-block");
                noCommentsBlock.textContent = "Нет комментариев";
                commentsContainer.appendChild(noCommentsBlock);
            } else {
                comments.forEach(function(comment) {
                    var commentBlock = document.createElement("div");
                    commentBlock.classList.add("comment-block");

                    var userNickname = document.createElement("div");
                    userNickname.classList.add("user-nickname");
                    if (comment.User) {
                        userNickname.textContent = comment.User.username;
                    } else {
                        userNickname.textContent = "Анонимный пользователь";
                    }
                    commentBlock.appendChild(userNickname);

                    var commentMessage = document.createElement("div");
                    commentMessage.classList.add("comment-message");
                    commentMessage.textContent = comment.message;
                    commentBlock.appendChild(commentMessage);

                    commentsContainer.appendChild(commentBlock);
                });
            }
        })
        .catch(function(error) {
            console.error("Error:", error);
        });
}

var intervalId = setInterval(function() {
    const game_id = document.getElementById('game_id').textContent;
    if (game_id !== '') {
        clearInterval(intervalId); // Очистка интервала
        getComments();
    }
}, 250);