def custom_ascii_xor(a, b):
    # Если b - это строка ASCII, преобразуем ее в список чисел ASCII
    if isinstance(b, str):
        b = [ord(char) for char in b]

    # Выравнивание списков, если их длины не совпадают
    max_len = max(len(a), len(b))
    a += [0] * (max_len - len(a))
    b += [0] * (max_len - len(b))

    # Применение операции XOR к каждому символу
    result = [char_a ^ char_b for char_a, char_b in zip(a, b)]

    return result


def custom_base64_xor(a, b):
    # Декодирование строки из base64
    bytes_b = base64_decode(b)

    # Выравнивание списков, если их длины не совпадают
    max_len = max(len(a), len(bytes_b))
    a += [0] * (max_len - len(a))
    bytes_b += [0] * (max_len - len(bytes_b))

    # Применение операции XOR к каждому байту
    result = [byte_a ^ byte_b for byte_a, byte_b in zip(a, bytes_b)]

    return result


def base64_decode(s):
    base64_table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    bytes_ascii = []
    padding = s.count('=')
    s = s.replace('=', '')

    for char in s:
        index = base64_table.index(char)
        bytes_ascii.append(index)

    if padding > 0:
        bytes_ascii = bytes_ascii[:-padding]

    return bytes_ascii


# Пример использования функций
a_ascii = [ord(char) for char in "Korshun"]
b_ascii = [ord(char) for char in "Nikita"]
xor_result_ascii = custom_ascii_xor(a_ascii, b_ascii)
xor_result_ascii = custom_ascii_xor(xor_result_ascii, b_ascii)
print("Результат XOR с ASCII кодами:", xor_result_ascii)

import task_1 as b

a_base64 = b.base64_encode("Korshun")
b_base64 = b.base64_encode("Nikita")
xor_result_base64 = custom_base64_xor([ord(char) for char in a_base64], b_base64)
xor_result_base64 = custom_base64_xor(xor_result_base64, b_base64)
print("Результат XOR с base64 строками:", ''.join([chr(byte) for byte in xor_result_base64]))
