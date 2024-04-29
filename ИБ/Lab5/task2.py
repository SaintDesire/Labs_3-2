import time
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

def plot_frequency_histogram(text, title):
    freq_map = {}
    for char in text:
        freq_map[char] = freq_map.get(char, 0) + 1
        sorted_freq = sorted(freq_map.items(), key=lambda x: x[1], reverse=True)
        characters = [x[0] for x in sorted_freq]
        frequencies = [x[1] for x in sorted_freq]
    plt.bar(characters, frequencies)
    plt.xlabel('Characters')
    plt.ylabel('Frequency')
    plt.title(title)
    plt.show()

class TranspositionCipher:
    def __init__(self, col_num, row_num, cols_key, rows_key):
        assert col_num > 0
        assert row_num > 0
        self.col_num = col_num
        self.row_num = row_num

        assert sorted(cols_key) == list(range(col_num))
        assert sorted(rows_key) == list(range(row_num))
        self.cols_key = cols_key
        self.rows_key = rows_key

    def encrypt(self, plain_text):
        # удаление пробелов
        # нужно уточнить постановку задачи, какие ещё символы должны быть удалены
        plain_text = list(plain_text.replace(" ", ""))
        assert len(plain_text) > 0
        # Заполнение матриц открытым текстом
        matrix_size = self.row_num * self.col_num
        matrix_num = (len(plain_text) + matrix_size - 1) // matrix_size
        matrixes = [None] * matrix_num
        for i in range(matrix_num):
            text = plain_text[i * matrix_size:(i + 1) * matrix_size]
            # дополнение текста "пустым символом"
            text += ["o"] * (matrix_size - len(text))
            matrixes[i] = [text[j:self.col_num + j] for j in range(0, len(text), self.col_num)]
        print("DEBUG: матрицы с открытым текстом: ", matrixes)
        # Сбор шифртекста - перебираются столбцы в соответствии с ключом cols_key
        # в столбце перебираются строки в соответствии с ключом rows_key
        cipher_text = ""
        for M in matrixes:
            for c in self.cols_key:
                for r in self.rows_key:
                    cipher_text += M[r][c]
        return cipher_text

    def decrypt(self, cipher_text):
        # Заполнение матриц шифр-текстом
        matrix_size = self.row_num * self.col_num
        assert len(cipher_text) % matrix_size == 0, "Длина шифростроки должна быть кратна числу элементов в матрице"

        matrix_num = len(cipher_text) // matrix_size
        # создаются пустые матрицы
        # Нельзя делать так: [ [ [None]*self.col_num ] * self.row_num]  * matrix_num
        # нужно создавать каждую строку отдельно, иначе все строки будут указывать на один и тот же участок памяти
        matrixes = [[[None] * self.col_num for _ in range(self.row_num)] for _ in range(matrix_num)]
        pos = 0
        for i in range(matrix_num):
            M = matrixes[i]
            # Колонки заполняются в порядке, заданном ключом
            for c in self.cols_key:
                # Строки в колонках заполняются в порядке, заданном ключом
                for r in self.rows_key:
                    M[r][c] = cipher_text[pos]
                    pos += 1
        plain_text = ""
        # сборка открытого текста: построчно из матриц
        for M in matrixes:
            for row in M:
                plain_text += "".join(row)
        return plain_text


with open('input.txt', 'r', encoding='utf-8') as file:
    text = file.read()

start_time = time.perf_counter()
cipher = TranspositionCipher(col_num=6, row_num=6, cols_key=[0, 2, 3, 4, 5, 1], rows_key=[4, 1, 3, 2, 5, 0])
out = cipher.encrypt(text)
encryption_time = (time.perf_counter() - start_time) * 1000

start_time = time.perf_counter()
out2 = cipher.decrypt(out)
decryption_time = (time.perf_counter() - start_time) * 1000

print("Сообщение: ", text)
print("Шифр:      ", out)
print("Расшифровка: ", out2)
print("Время шифрования двойной перестановки: ", encryption_time, "мс")
print("Время расшифрования двойной перестановки: ", decryption_time, "мс")

plot_frequency_histogram(text, "Частоты появления символов исходного сообщения")
plot_frequency_histogram(out, "Частоты появления символов зашифрованного сообщения (двойная перестановка)")