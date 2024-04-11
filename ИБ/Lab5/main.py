import time
import matplotlib

matplotlib.use('TkAgg')
import matplotlib.pyplot as plt


# Функция для шифрования текста методом маршрутной перестановки
def encrypt_by_route(text, key):
    encrypted_text = ""
    text_length = len(text)
    # Создаем матрицу для хранения текста в виде таблицы
    matrix = [[' ' for _ in range(key)] for _ in range((text_length + key - 1) // key)]
    row, col = 0, 0

    # Заполняем матрицу текстом
    for char in text:
        matrix[row][col] = char
        col += 1
        if col == key or (col == key - 1 and row >= text_length // key):
            col = 0
            row += 1

    # Считываем зашифрованный текст по спирали
    for i in range(key):
        for j in range(len(matrix)):
            if i % 2 == 0:
                encrypted_text += matrix[j][i]
            else:
                encrypted_text += matrix[len(matrix) - j - 1][i]

    return encrypted_text


# Функция для расшифрования текста методом маршрутной перестановки
def decrypt_by_route(text, key):
    decrypted_text = ""
    text_length = len(text)
    # Создаем матрицу для хранения текста в виде таблицы
    matrix = [[' ' for _ in range(key)] for _ in range((text_length + key - 1) // key)]
    row, col = 0, 0

    # Заполняем матрицу текстом
    for i in range(key):
        for j in range(len(matrix)):
            if i % 2 == 0:
                matrix[j][i] = text[row]
            else:
                matrix[len(matrix) - j - 1][i] = text[row]
            row += 1

    # Считываем расшифрованный текст из матрицы
    for i in range(len(matrix)):
        for j in range(key):
            decrypted_text += matrix[i][j]

    return decrypted_text


# Функция для формирования гистограммы частот появления символов
def plot_histogram(text, title):
    frequency = {}
    for char in text:
        if char in frequency:
            frequency[char] += 1
        else:
            frequency[char] = 1

    sorted_frequency = sorted(frequency.items(), key=lambda x: x[1], reverse=True)
    chars = [pair[0] for pair in sorted_frequency]
    counts = [pair[1] for pair in sorted_frequency]

    plt.bar(chars, counts)
    plt.title(title)
    plt.show()


# Функция для замера времени выполнения операции
def measure_time(func, *args):
    start_time = time.time()
    result = func(*args)
    end_time = time.time()
    execution_time = end_time - start_time
    return result, execution_time


# Считываем текст из файла input.txt
with open("input.txt", "r", encoding="utf-8") as file:
    original_text = file.read()

key = 3

encrypted_text, encryption_time = measure_time(encrypt_by_route, original_text, key)
print("Encrypted text:", encrypted_text)
print("Encryption time:", encryption_time)

decrypted_text, decryption_time = measure_time(decrypt_by_route, encrypted_text, key)
print("Decrypted text:", decrypted_text)
print("Decryption time:", decryption_time)

plot_histogram(original_text, "Original Text Histogram")
plot_histogram(encrypted_text, "Encrypted Text Histogram")
