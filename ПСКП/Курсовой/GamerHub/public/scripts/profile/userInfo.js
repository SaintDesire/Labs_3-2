window.addEventListener('DOMContentLoaded', () => {
    axios.get('/user-info')
        .then(response => {
            const userInfo = response.data;
            displayUserInfo(userInfo);

            const userId = userInfo.user_id;
            if(userInfo.role === 'admin') {
                const adminElement = document.getElementById('admin-panel');
                adminElement.style.display = 'block';
            }
            const userIdElement = document.getElementById('user-id');
            userIdElement.textContent = userId;
            axios.get(`/getUserComments?userId=${userId}`)
                .then(response => {
                    const commentCount = response.data.commentCount;
                    displayCommentCount(commentCount);
                })
                .catch(error => {
                    console.error('Ошибка при получении количества комментариев:', error);
                });
        })
        .catch(error => {
            console.error('Ошибка при получении данных о пользователе:', error);
        });
});

function displayCommentCount(commentCount) {
    const commentCountElement = document.getElementById('comment-count');
    commentCountElement.textContent = `Количество комментариев: ${commentCount}`;
}

function arrayBufferToBase64(buffer) {
    let binary = '';
    const bytes = new Uint8Array(buffer);
    const len = bytes.byteLength;
    for (let i = 0; i < len; i++) {
        binary += String.fromCharCode(bytes[i]);
    }
    return window.btoa(binary);
}

function displayUserInfo(userInfo) {
    const avatarElement = document.getElementById('avatar');
    const usernameElement = document.getElementById('username-show');
    const userIdElement = document.getElementById('userId-show');
    const emailElement = document.getElementById('email-show');
    const dateElement = document.getElementById('date-show');

    if (userInfo.avatar) {
        const avatarBuffer = new Uint8Array(userInfo.avatar.data).buffer;
        const avatarData = arrayBufferToBase64(avatarBuffer);
        avatarElement.src = `data:image/jpeg;base64,${avatarData}`;
    } else {
        avatarElement.src = 'img/avatar-default.png';
    }

    usernameElement.textContent = `Имя: ${userInfo.username}`;
    emailElement.textContent = `Email: ${userInfo.email}`;
    userIdElement.textContent = userInfo.user_id;
    userIdElement.style.display = 'none';

    const registrationDate = new Date(userInfo.registration_date);
    const currentDate = new Date();
    const timeDiff = Math.abs(currentDate.getTime() - registrationDate.getTime());
    const daysDiff = Math.ceil(timeDiff / (1000 * 60 * 60 * 24)) - 1;
    dateElement.textContent = `Стаж на сайте: ${daysDiff} дней`;
}
