const editButton = document.getElementById('edit-button');
editButton.addEventListener('click', () => {
    const editUserInfo = document.getElementById('edit-user-info');
    if (editUserInfo.style.display === 'none') {
        editUserInfo.style.display = 'block';
    } else {
        editUserInfo.style.display = 'none';
    }
});


function getUserID() {
    const userIdElement = document.getElementById('userId-show');
    const user_id = userIdElement.textContent;
    return user_id;
}


// Получение элемента input для загрузки аватара
const avatarInput = document.getElementById('avatar-upload');

// Асинхронная функция для отправки информации о пользователе
async function sendUserInfo(formData) {
    try {
        // Создание объекта XMLHttpRequest
        const xhr = new XMLHttpRequest();

        // Отправка запроса
        xhr.open('POST', 'http://localhost:3000/update-avatar');
        xhr.send(formData);

        // Обработка ответа
        xhr.onload = function () {
            if (xhr.status === 200) {
                console.log(xhr.response);
                const response = JSON.parse(xhr.response);
                const avatarElement = document.getElementById('avatar');
                if (response.avatar) {
                    const avatarBuffer = new Uint8Array(response.avatar.data).buffer;
                    const avatarData = arrayBufferToBase64(avatarBuffer);
                    avatarElement.src = `data:image/jpeg;base64,${avatarData}`;
                } else {
                    avatarElement.src = 'img/avatar-default.png';
                }
            } else {
                console.error('Произошла ошибка при отправке запроса');
            }
        };
    } catch (error) {
        console.error(error);
    }
}

// Обработчик события изменения значения input
avatarInput.addEventListener('change', (event) => {
    const file = avatarInput.files[0];

    const user_id = getUserID();

    // Создание объекта FormData
    const formData = new FormData();
    formData.append('avatar', file);
    formData.append('user_id', user_id);
    console.log(user_id)

    sendUserInfo(formData);
});



// Получение элементов DOM
const editUserInfo = document.getElementById('edit-user-info');
const usernameInput = document.getElementById('username');
const saveUsernameButton = document.getElementById('save-username');
const emailInput = document.getElementById('email');
const saveEmailButton = document.getElementById('save-email');
const passwordInput = document.getElementById('password');
const savePasswordButton = document.getElementById('save-password');
const avatarUploadInput = document.getElementById('avatar-upload');

const usernameElement = document.getElementById('username-show');
const userIdElement = document.getElementById('userId-show');
const emailElement = document.getElementById('email-show');


// При нажатии кнопки "Изменить" для имени пользователя
saveUsernameButton.addEventListener('click', () => {
    const user_id = getUserID(); // Получение user_id из вашего источника данных
    console.log(user_id)
    const username = usernameInput.value; // Получение нового имени пользователя
    updateUserUsername(user_id, username); // Отправка запроса на обновление имени пользователя
});

// При нажатии кнопки "Изменить" для email
saveEmailButton.addEventListener('click', () => {
    const user_id = getUserID(); // Получение user_id из вашего источника данных
    const email = emailInput.value; // Получение нового email
    updateUserEmail(user_id, email); // Отправка запроса на обновление email
});

// При нажатии кнопки "Изменить" для пароля
savePasswordButton.addEventListener('click', () => {
    const user_id = getUserID(); // Получение user_id из вашего источника данных
    const password = passwordInput.value; // Получение нового пароля
    updateUserPassword(user_id, password); // Отправка запроса на обновление пароля
});

// Функция для отправки запроса на обновление имени пользователя
function updateUserUsername(user_id, username) {
    const errorElement = document.getElementById('username-error');
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/update-username');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function () {
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.response);
            console.log(response.message);
            usernameElement.textContent = `Имя: ${username}`;
            errorElement.textContent = null;
        } else if (xhr.status === 400) {
            const response = JSON.parse(xhr.response);
            console.error(response.message);
            errorElement.textContent = response.message;
            errorElement.style.color = 'red';
        } else {
            console.error('Произошла ошибка при отправке запроса');
        }
    };
    const data = JSON.stringify({ user_id: user_id, username: username });
    xhr.send(data);
}

// Функция для отправки запроса на обновление email
function updateUserEmail(user_id, email) {
    const errorElement = document.getElementById('email-error');
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/update-email');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function () {
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.response);
            console.log(response.message);
            emailElement.textContent = `Email: ${email}`
            errorElement.textContent = null;
        } else if (xhr.status === 400) {
            const response = JSON.parse(xhr.response);
            console.error(response.message);
            errorElement.textContent = response.message;
            errorElement.style.color = 'red';
        } else {
            console.error('Произошла ошибка при отправке запроса');
        }
    };
    const data = JSON.stringify({ user_id: user_id, email: email });
    xhr.send(data);
}

// Функция для отправки запроса на обновление пароля
function updateUserPassword(user_id, password) {
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/update-password');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function () {
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.response);
            console.log(response.message);
        } else {
            console.error('Произошла ошибка при отправке запроса');
        }
    };
    const data = JSON.stringify({ user_id: user_id, password: password });
    xhr.send(data);
}
