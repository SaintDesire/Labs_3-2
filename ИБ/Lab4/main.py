import string
import time
from collections import Counter
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

def measure_time(func, *args, **kwargs):
    start_time = time.time()
    result = func(*args, **kwargs)
    end_time = time.time()
    execution_time = end_time - start_time
    return result, execution_time


def keyword_substitution_cipher(text, keyword):
    russian_alphabet = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'
    substituted_alphabet = keyword.lower() + ''.join(c for c in russian_alphabet if c not in keyword.lower())

    substitution_dict = dict(zip(russian_alphabet, substituted_alphabet))

    encrypted_text = ''.join(substitution_dict.get(char, char) for char in text.lower())

    return encrypted_text

def keyword_substitution_decipher(text, keyword):
    russian_alphabet = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'
    substituted_alphabet = keyword.lower() + ''.join(c for c in russian_alphabet if c not in keyword.lower())

    substitution_dict = dict(zip(substituted_alphabet, russian_alphabet))

    decrypted_text = ''.join(substitution_dict.get(char, char) for char in text.lower())

    return decrypted_text

def create_porta_table():
    russian_alphabet = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'
    table = {}
    counter = 1
    for row_char in russian_alphabet:
        for col_char in russian_alphabet:
            table[(row_char, col_char)] = f"{counter:03}"
            counter += 1
    return table

def porta_cipher(text, table):
    if len(text) % 2 != 0:
        text += 'А'

    encrypted_text = ""
    for i in range(0, len(text), 2):
        if text[i] == '\n':
            encrypted_text += '\n'
        pair = (text[i], text[i + 1])
        encrypted_pair = table.get(pair)
        if encrypted_pair is not None:
            encrypted_text += encrypted_pair + ' '
    return encrypted_text

def porta_decipher(text, table):
    decrypted_text = ""
    for i in range(0, len(text), 4):
        pair_code = text[i:i+4]
        for pair, code in table.items():
            if code == pair_code:
                decrypted_text += pair[0] + pair[1]
                break
    return decrypted_text

def plot_histogram(text, title):
    frequencies = Counter(text)
    labels, values = zip(*sorted(frequencies.items()))

    plt.bar(labels, values)
    plt.title(title)
    plt.xlabel('Symbols')
    plt.ylabel('Frequency')
    plt.show()

def main():
    try:
        with open('input.txt', 'r', encoding='utf-8') as file:
            plaintext = file.read().strip()
    except FileNotFoundError:
        print("File not found!")
        return
    except Exception as e:
        print("An error occurred:", e)
        return
    keyword = "коршун"

    encrypted_text_caesar, encryption_time_caesar = measure_time(keyword_substitution_cipher, plaintext, keyword)

    try:
        with open('output_caesar.txt', 'w', encoding='utf-8') as file:
            file.write(format(encrypted_text_caesar))
        print("Output written to output_caesar.txt successfully.")
    except Exception as e:
        print("An error occurred while writing to output file:", e)

    decrypted_text_caesar, decryption_time_caesar = measure_time(keyword_substitution_cipher, plaintext, keyword)

    plot_histogram(plaintext.lower(), 'Гистограмма частот символов (Оригинальное сообщение)')
    plot_histogram(encrypted_text_caesar, 'Гистограмма частот символов (Шифр цезаря с ключом)')

    print("Время зашифрования (Шифр Цезаря с ключом):", encryption_time_caesar, "seconds")
    print("Время расшифрования (Шифр Цезаря с ключом):", decryption_time_caesar, "seconds")

    porta_table = create_porta_table()
    encrypted_text_porta, encryption_time_porta = measure_time(porta_cipher, plaintext.upper(), porta_table)
    try:
        with open('output_porta.txt', 'w', encoding='utf-8') as file:
            file.write(format(encrypted_text_porta))
        print("Output written to output_porta.txt successfully.")
    except Exception as e:
        print("An error occurred while writing to output file:", e)

    decrypted_text_porta, decryption_time_porta = measure_time(porta_decipher, encrypted_text_porta, porta_table)

    plot_histogram(encrypted_text_porta, 'Гистограмма частот символов (Шифр Порты)')

    print("Время зашифрования (Шифр Порты)::", encryption_time_porta, "seconds")
    print("Время расшифрования (Шифр Порты)::", decryption_time_porta, "seconds")

if __name__ == "__main__":
    main()
