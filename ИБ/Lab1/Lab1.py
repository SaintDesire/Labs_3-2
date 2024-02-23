# -*- coding: utf-8 -*-
from collections import Counter
import math

def calculate_entropy(frequencies):
    total = sum(frequencies)
    if total == 0:
        return 0
    probabilities = [freq / total for freq in frequencies]
    entropy = 0
    for prob in probabilities:
        if prob > 0:
            entropy += prob * math.log2(prob)
    return -entropy

def load_text_file(filename):
    with open(filename, 'r', encoding='utf-8') as file:
        text = file.read()
    return text

def text_to_binary(text):
    binary_data = bytes(text, 'utf-8')
    return binary_data

def write_binary_file(filename, binary_data):
    with open(filename, 'wb') as file:
        file.write(binary_data)

def load_binary_file(filename):
    with open(filename, 'rb') as file:
        content = file.read()
    return content

# Задание 1

macedonian_text = load_text_file('makedon.txt')
turkish_text = load_text_file('turkey.txt')

# Определение алфавитов для македонского и турецкого языков
macedonian_alphabet = ['а', 'б', 'в', 'г', 'д', 'ѓ', 'е', 'ж', 'з', 'ѕ', 'и', 'ј', 'к', 'л', 'љ', 'м', 'н', 'њ', 'о', 'п', 'р', 'с', 'т', 'ќ', 'у', 'ф', 'х', 'ц', 'ч', 'џ', 'ш']
turkish_alphabet = ['a', 'b', 'c', 'ç', 'd', 'e', 'f', 'g', 'ğ', 'h', 'ı', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'ö', 'p', 'r', 's', 'ş', 't', 'u', 'ü', 'v', 'y', 'z']

# Анализ текста и расчет энтропии
macedonian_frequencies = [macedonian_text.count(char) for char in macedonian_alphabet]
macedonian_entropy = calculate_entropy(macedonian_frequencies)
# print(macedonian_frequencies)
print('Энтропия македонского текста:', macedonian_entropy)

turkish_frequencies = [turkish_text.count(char) for char in turkish_alphabet]
turkish_entropy = calculate_entropy(turkish_frequencies)
# print(turkish_frequencies)
print('Энтропия турецкого текста:', turkish_entropy)


# Задание 2

macedonian_binary_data = text_to_binary(macedonian_text)
turkish_binary_data = text_to_binary(turkish_text)

write_binary_file('macedonian.bin', macedonian_binary_data)
write_binary_file('turkish.bin', turkish_binary_data)

# Загрузка бинарных файлов
macedonian_binary_data = load_binary_file('macedonian.bin')
turkish_binary_data = load_binary_file('turkish.bin')

# Расчет частот и энтропии
macedonian_frequencies = list(Counter(macedonian_binary_data).values())
macedonian_entropy = calculate_entropy(macedonian_frequencies)
print('Энтропия македонского бинарного алфавита:', macedonian_entropy)

turkish_frequencies = list(Counter(turkish_binary_data).values())
turkish_entropy = calculate_entropy(turkish_frequencies)
print('Энтропия турецкого бинарного алфавита:', turkish_entropy)

# Задание 3
FIO_macedonian_text = "Коrшун Никита Игоревич"
FIO_turkish_text = "Korşun Nikita İgoreviç"
binary_FIO = ''.join(format(ord(char), '08b') for char in "Коршун Никита Игоревич")
binary_entropy = calculate_entropy([binary_FIO.count('0'), binary_FIO.count('1')])

print("Количество информации на основе македонского сообщения:", macedonian_entropy * len(FIO_macedonian_text))
print("Количество информации на основе турецкого сообщения:", turkish_entropy * len(FIO_turkish_text))
print("Количество информации на основе бинарного сообщения:", binary_entropy * len(binary_FIO))

# Задание 4

error_probabilities = [0.1, 0.5, 1.0]

def effective_entropy(p, q, binary):
    if binary and (p == 0 or q == 0):
        return 1
    if not binary:
        return 0
    return 1 - ((-p * math.log2(p)) - (q * math.log2(q)))

def amount_info_with_error(entropy, p, q, count, binary):
        return entropy * effective_entropy(p, q, binary) * count

for p in error_probabilities:
    if p == 1 or p == 0:
        macedonian_conditional_entropy = 0
        turkish_conditional_entropy = 0
        binary_conditional_entropy = 0
    else:
        macedonian_conditional_entropy = -p * math.log2(p) - (1 - p) * math.log2(1 - p)
        turkish_conditional_entropy = -p * math.log2(p) - (1 - p) * math.log2(1 - p)
        binary_conditional_entropy = -p * math.log2(p) - (1 - p) * math.log2(1 - p)

    macedonian_efficiency_entropy = 1 - macedonian_conditional_entropy
    turkish_efficiency_entropy = 1 - turkish_conditional_entropy
    binary_efficiency_entropy = 1 - binary_conditional_entropy

    macedonian_info_with_error = amount_info_with_error(macedonian_efficiency_entropy, p, 1 - p, len(FIO_macedonian_text), False)
    turkish_info_with_error = amount_info_with_error(turkish_efficiency_entropy, p, 1 - p, len(FIO_turkish_text), False)
    binary_info_with_error = amount_info_with_error(binary_efficiency_entropy, p, 1 - p, len(binary_FIO), True)

    print(f"\nВероятность ошибки: {p}")
    print(f"Информационное количество с учетом ошибки на основе македонского сообщения: {macedonian_info_with_error}")
    print(f"Информационное количество с учетом ошибки на основе турецкого сообщения: {turkish_info_with_error}")
    print(f"Информационное количество с учетом ошибки на основе бинарного представления ФИО: {binary_info_with_error}")