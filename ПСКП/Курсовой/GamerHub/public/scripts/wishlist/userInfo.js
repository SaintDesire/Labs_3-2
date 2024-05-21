window.addEventListener('DOMContentLoaded', () => {
    axios.get('/user-info')
        .then(response => {
            const userInfo = response.data;
            const userId = userInfo.user_id;
            const userIdParagraph = document.getElementById('user-id');
            userIdParagraph.textContent = userId;
            userIdParagraph.style.display = 'none';
        })
        .catch(error => {
            console.error('Ошибка при получении данных о пользователе:', error);
        });
});