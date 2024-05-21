document.addEventListener('DOMContentLoaded', () => {
    fetch('/user-info', {
        method: 'GET',
        credentials: 'include'
    })
        .then(response => {
            if (!response.ok) {
                window.location.href = '/';
            }
            return response.json();
        })
        .then(data => {
            console.log('User data:', data);
            // Здесь можно обработать данные пользователя, если необходимо
        })
        .catch(error => {
            console.error('Error fetching user info:', error);
            window.location.href = '/';
        });
});
