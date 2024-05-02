import pandas as pd
import pymssql
from datetime import datetime

# Подключение к базе данных
conn = pymssql.connect(server='localhost', database='GamerHub', user='user', password='123')

# Создание курсора
cursor = conn.cursor()

# Чтение CSV файла
df = pd.read_csv('metacritic_games.csv')

# Замена значений NaN на пустую строку
df = df.fillna('')

# Сохранение данных в таблицу Games
for index, row in df.iterrows():
    title = row['game']
    developer = row['developer']
    release_date_str = row['release_date']
    genre = row['genre']

    # Преобразование значения release_date в формат даты
    release_date = datetime.strptime(release_date_str, "%b %d, %Y").date()

    # SQL запрос для вставки данных в таблицу Games
    query = "INSERT INTO Games (title, developer, release_date, genre) VALUES (%s, %s, %s, %s)"

    # Выполнение запроса с использованием курсора
    cursor.execute(query, (title, developer, release_date, genre))

# Подтверждение транзакции
conn.commit()

# Закрытие курсора и соединения с базой данных
cursor.close()
conn.close()