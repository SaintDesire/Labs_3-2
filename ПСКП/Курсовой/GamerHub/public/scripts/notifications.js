const socket = new WebSocket('ws://localhost:8080');

// Проверка поддержки API уведомлений при загрузке страницы
window.onload = function() {
    if ('Notification' in window && Notification.permission !== 'granted') {
        // Запрос разрешения на показ уведомлений при загрузке страницы
        Notification.requestPermission();
    }
};

if (!('Notification' in window)) {
    console.log('Уведомления не поддерживаются в вашем браузере');
}

if (Notification.permission !== 'granted') {
    console.log('Разрешение на показ уведомлений не предоставлено');
}

socket.onmessage = function(event) {
    const message = event.data;
    console.log('Получено сообщение от сервера:', message);

    try {
        const notification = JSON.parse(message);
        showNotification(notification.message);

    } catch (error) {
        console.error('Ошибка при разборе уведомления:', error);
    }
};

// Функция для отображения уведомления
function showNotification(message) {
    // Проверка, поддерживается ли API уведомлений в браузере
    if ('Notification' in window && Notification.permission === 'granted') {
        console.log(message)
        new Notification('Новое уведомление', { body: message });
    } else if ('Notification' in window && Notification.permission !== 'denied') {
        // Запрос разрешения на показ уведомлений
        Notification.requestPermission().then((permission) => {
            if (permission === 'granted') {
                // Создание уведомления
                new Notification('Новое уведомление', { body: message });
            }
        });
    } else {
        console.log('Уведомления не поддерживаются в вашем браузере');
    }
}