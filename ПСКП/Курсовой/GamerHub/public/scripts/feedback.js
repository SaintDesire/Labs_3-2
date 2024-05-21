// Получаем кнопку обратной связи и добавляем обработчик события "click"
const feedbackButton = document.getElementById('feedbackButton');
feedbackButton.addEventListener('click', openFeedbackModal);

// Функция для открытия окна обратной связи
function openFeedbackModal() {
    const modal = document.getElementById('feedbackModal');
    const closeButton = modal.querySelector('.close');
    const emailInput = modal.querySelector('#emailInput');
    const submitButton = modal.querySelector('#submitButton');

    // Отображаем модальное окно
    modal.style.display = 'block';

    // Закрытие модального окна при нажатии на кнопку "Закрыть"
    closeButton.addEventListener('click', closeModal);

    // Закрытие модального окна при щелчке за его пределами
    window.addEventListener('click', clickOutsideModal);

    // Функция для закрытия модального окна
    function closeModal() {
        modal.style.display = 'none';
        closeButton.removeEventListener('click', closeModal);
        window.removeEventListener('click', clickOutsideModal);
        resultMessage.textContent = '';
    }

    // Функция для предотвращения закрытия модального окна при клике внутри него
    function clickOutsideModal(event) {
        if (event.target === modal) {
            closeModal();
        }
    }

    submitButton.addEventListener('click', () => {
        const email = emailInput.value;
        if (isValidEmail(email)) {
            showNotification('Ваша заявка принята');
        }
    });

// Функция для проверки корректности email
    function isValidEmail(email) {
        // Регулярное выражение для проверки email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
}
