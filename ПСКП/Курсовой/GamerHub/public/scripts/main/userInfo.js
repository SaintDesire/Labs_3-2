function getUserInfo() {
    fetch('/user-info')
        .then(response => response.json())
        .then(data => {
            console.log(data);
            if (data) {
                document.getElementById('loginButton').style.display = 'none';
                document.getElementById('registerButton').style.display = 'none';

                const userIconSvg = `
<svg height="30px" width="30px" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 60.671 60.671" xml:space="preserve">
  <g>
    <g>
      <ellipse style="fill:#ffffff;" cx="30.336" cy="12.097" rx="11.997" ry="12.097"/>
      <path style="fill:#ffffff;" d="M35.64,30.079H25.031c-7.021,0-12.714,5.739-12.714,12.821v17.771h36.037V42.9 C48.354,35.818,42.661,30.079,35.64,30.079z"/>
    </g>
  </g>
</svg>
`;

                const usernameElement = document.createElement('span');
                usernameElement.id = 'username-span';
                usernameElement.style.display = 'flex';
                usernameElement.style.alignItems = 'center';

                const usernameTextElement = document.createElement('p');
                usernameTextElement.textContent = data.username;
                usernameTextElement.style.marginRight = '10px'

                const userIconElement = document.createElement('div');
                userIconElement.innerHTML = userIconSvg;

                usernameElement.appendChild(usernameTextElement);
                usernameElement.appendChild(userIconElement);

                const headerElement = document.querySelector('header');
                headerElement.appendChild(usernameElement);

                const dropdownMenu = document.getElementById('dropdownMenu');
                const logoutButton = document.getElementById('logoutButton');

                usernameElement.addEventListener('click', () => {
                    dropdownMenu.classList.toggle('show');
                });


                // Обработчик для кнопки "Выйти"
                logoutButton.onclick = () => {
                    fetch('/logout')
                        .then(() => {
                            window.location.href = '/'; // Перенаправление на главную страницу после выхода
                        })
                        .catch(error => {
                            console.error('Error:', error);
                        });
                };

                const header = document.querySelector('header');
                header.appendChild(usernameElement);
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
}


// Вызываем функцию getUserInfo() при загрузке страницы
document.addEventListener('DOMContentLoaded', getUserInfo);