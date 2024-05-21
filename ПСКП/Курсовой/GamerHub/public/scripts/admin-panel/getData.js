function clearMenus() {
    document.getElementById('function1Menu').innerHTML = '';
    document.getElementById('function2Menu').innerHTML = '';
    document.getElementById('function3Menu').innerHTML = '';
    document.getElementById('function4Menu').innerHTML = '';

    document.getElementById('function1Menu').classList.add('hidden');
    document.getElementById('function2Menu').classList.add('hidden');
    document.getElementById('function3Menu').classList.add('hidden');
    document.getElementById('function4Menu').classList.add('hidden');
}

function displayError(message) {
    const errorDiv = document.createElement('div');
    errorDiv.classList.add('error');
    errorDiv.textContent = message;
    document.body.appendChild(errorDiv);
}

function displayUsers(users) {
    var function1Menu = document.getElementById('function1Menu');
    var table = document.createElement('table');
    table.classList.add('table');
    users.forEach(function(user) {
        var row = document.createElement('tr');
        row.classList.add('row');
        var userId = document.createElement('td');
        userId.classList.add('column');
        userId.textContent = 'User ID: ' + user.user_id;
        var username = document.createElement('td');
        username.classList.add('column');
        username.textContent = 'Username: ' + user.username;
        var email = document.createElement('td');
        email.classList.add('column');
        email.textContent = 'Email: ' + user.email;

        var editButton = document.createElement('button');
        editButton.textContent = 'Изменить';
        editButton.addEventListener('click', function() {
            // Удалить все input-поля из ячеек таблицы
            var inputs = row.querySelectorAll('input');
            inputs.forEach(function(input) {
                input.remove();
            });

            var usernameInput = document.createElement('input');
            usernameInput.type = 'text';
            usernameInput.value = user.username;
            username.innerHTML = '';
            username.appendChild(usernameInput);

            var emailInput = document.createElement('input');
            emailInput.type = 'text';
            emailInput.value = user.email;
            email.innerHTML = '';
            email.appendChild(emailInput);

            var confirmButton = document.createElement('button');
            confirmButton.textContent = 'Подтвердить';
            confirmButton.addEventListener('click', function() {
                var updatedUsername = usernameInput.value;
                var updatedEmail = emailInput.value;
                // Отправить PUT-запрос на сервер с обновленными данными
                var request = new XMLHttpRequest();
                request.open('PUT', '/api/users/' + user.user_id, true);
                request.setRequestHeader('Content-Type', 'application/json');
                request.onreadystatechange = function() {
                    if (request.readyState === 4) {
                        if (request.status === 200) {
                            // Обновить значения в таблице
                            username.textContent = 'Username: ' + updatedUsername;
                            email.textContent = 'Email: ' + updatedEmail;
                            // Обновить значения в переменной user
                            user.username = updatedUsername;
                            user.email = updatedEmail;
                        } else {
                            // Восстановить старые значения в полях
                            username.textContent = 'Username: ' + user.username;
                            email.textContent = 'Email: ' + user.email;
                            displayError('Error updating user');
                        }
                    }
                };
                var data = JSON.stringify({
                    username: updatedUsername,
                    email: updatedEmail
                });
                request.send(data);

                // Восстановить кнопку "Изменить"
                row.removeChild(confirmButton);
                row.appendChild(editButton);
            });

            row.removeChild(editButton);
            row.appendChild(confirmButton);
        });

        row.appendChild(userId);
        row.appendChild(username);
        row.appendChild(email);
        row.appendChild(editButton);
        table.appendChild(row);
    });

    function1Menu.appendChild(table);
    document.getElementById('function1Menu').classList.remove('hidden');
}

function displayGames(games) {
    var function2Menu = document.getElementById('function2Menu');
    var table = document.createElement('table');
    table.classList.add('table');
    games.forEach(function(game) {
        var row = document.createElement('tr');
        row.classList.add('row');
        var gameId = document.createElement('td');
        gameId.classList.add('column');
        gameId.textContent = 'Game ID: ' + game.game_id;
        var title = document.createElement('td');
        title.classList.add('column');
        title.textContent = 'Title: ' + game.title;
        var genre = document.createElement('td');
        genre.classList.add('column');
        genre.textContent = 'Genre: ' + game.genre;

        var editButton = document.createElement('button');
        editButton.textContent = 'Изменить';
        editButton.addEventListener('click', function() {
            // Удалить все input-поля из ячеек таблицы
            var inputs = row.querySelectorAll('input');
            inputs.forEach(function(input) {
                input.remove();
            });

            var genreInput = document.createElement('input');
            genreInput.type = 'text';
            genreInput.value = game.genre;
            genre.innerHTML = '';
            genre.appendChild(genreInput);

            var confirmButton = document.createElement('button');
            confirmButton.textContent = 'Подтвердить';
            confirmButton.addEventListener('click', function() {
                var updatedGenre = genreInput.value;
                // Отправить PUT-запрос на сервер с обновленными данными
                var request = new XMLHttpRequest();
                request.open('PUT', '/api/games/' + game.game_id, true);
                request.setRequestHeader('Content-Type', 'application/json');
                request.onreadystatechange = function() {
                    if (request.readyState === 4) {
                        if (request.status === 200) {
                            // Обновить значения в таблице
                            genre.textContent = 'Genre: ' + updatedGenre;
                            // Обновить значения в массиве games
                            game.genre = updatedGenre;
                        } else {
                            // Восстановить старые значения в полях
                            genre.textContent = 'Genre: ' + game.genre;
                            displayError('Error updating game');
                        }
                    }
                };
                var data = JSON.stringify({
                    genre: updatedGenre
                });
                request.send(data);

                // Восстановить кнопку "Изменить"
                row.removeChild(confirmButton);
                row.appendChild(editButton);
            });

            row.removeChild(editButton);
            row.appendChild(confirmButton);
        });

        row.appendChild(gameId);
        row.appendChild(title);
        row.appendChild(genre);
        row.appendChild(editButton);
        table.appendChild(row);
    });

    function2Menu.appendChild(table);
    document.getElementById('function2Menu').classList.remove('hidden');
}

function displayNotifications(notifications) {
    var function3Menu = document.getElementById('function3Menu');

    // Добавляем поле ввода сообщения и кнопку "Отправить уведомление"
    var messageInput = document.createElement('input');
    messageInput.type = 'text';
    messageInput.id = 'notificationInput';
    var sendButton = document.createElement('button');
    sendButton.textContent = 'Отправить уведомление';
    sendButton.style.marginLeft = '15px';
    sendButton.addEventListener('click', function() {
        var message = document.getElementById('notificationInput').value;
        // Отправить POST-запрос на сервер
        fetch('/notification', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ message: message })
        })
            .then(function(response) {
                if (response.ok) {
                    console.log('Уведомление успешно создано');
                    // Обновляем страницу или выполняем другую необходимую логику
                } else {
                    console.error('Ошибка при создании уведомления');
                    displayError('Error creating notification');
                }
            })
            .catch(function(error) {
                console.error('Ошибка при отправке запроса:', error);
                displayError('Error sending request');
            });
    });

    function3Menu.appendChild(messageInput);
    function3Menu.appendChild(sendButton);

    var table = document.createElement('table');
    table.style.marginTop = '10px';
    table.classList.add('table');
    notifications.forEach(function(notification) {
        var row = document.createElement('tr');
        row.classList.add('row');
        var notificationId = document.createElement('td');
        notificationId.classList.add('column');
        notificationId.textContent = 'Notification ID: ' + notification.notification_id;
        var message = document.createElement('td');
        message.classList.add('column');
        message.textContent = 'Message: ' + notification.message;

        row.appendChild(notificationId);
        row.appendChild(message);
        table.appendChild(row);
    });

    function3Menu.appendChild(table);

    document.getElementById('function3Menu').classList.remove('hidden');
}

function displayComments(comments) {
    var function4Menu = document.getElementById('function4Menu');
    function4Menu.innerHTML = '';
    comments.reverse();
    var table = document.createElement('table');
    table.classList.add('table');
    comments.forEach(function(comment) {
        var row = document.createElement('tr');
        row.classList.add('row');
        var commentId = document.createElement('td');
        commentId.classList.add('column');
        commentId.textContent = 'Comment ID: ' + comment.feedback_id;
        var message = document.createElement('td');
        message.classList.add('column');
        message.textContent = 'Message: ' + comment.message;

        row.appendChild(commentId);
        row.appendChild(message);
        table.appendChild(row);
    });

    function4Menu.appendChild(table);
    document.getElementById('function4Menu').classList.remove('hidden');
}

document.getElementById('function1Button').addEventListener('click', function() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/api/users', true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var users = JSON.parse(xhr.responseText);
                clearMenus();
                displayUsers(users);
            } else {
                displayError('Error retrieving users');
            }
        }
    };
    xhr.send();
});

document.getElementById('function2Button').addEventListener('click', function() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/api/games', true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var games = JSON.parse(xhr.responseText);
                clearMenus();
                displayGames(games);
            } else {
                displayError('Error retrieving games');
            }
        }
    };
    xhr.send();
});

document.getElementById('function3Button').addEventListener('click', function() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/api/notifications', true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var notifications = JSON.parse(xhr.responseText);
                clearMenus();
                displayNotifications(notifications);
            } else {
                displayError('Error retrieving notifications');
            }
        }
    };
    xhr.send();
});

document.getElementById('function4Button').addEventListener('click', function() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/api/comments', true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var comments = JSON.parse(xhr.responseText);
                clearMenus();
                displayComments(comments);
            } else {
                displayError('Error retrieving comments');
            }
        }
    };
    xhr.send();
});

document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('function1Button').click();
});