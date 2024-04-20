import numpy as np


def read_from_file(file_name):
    with open(file_name, 'r', encoding='utf-8') as file:
        return file.read()


def convert_to_two_dimensional_array(text, rows, cols):
    padded_text = ''.join(text).ljust(rows * cols)
    return np.array([list(padded_text[i:i + cols]) for i in range(0, len(padded_text), cols)])



def encrypt_route_spiral(open_text):
    text_length = len(open_text)
    rows = int(text_length ** 0.5) + 1 if text_length ** 0.5 % 1 != 0 else int(text_length ** 0.5)
    cols = rows if rows * (rows - 1) >= text_length else rows + 1
    data = convert_to_two_dimensional_array(open_text, rows, cols)
    result = []

    top = 0
    bottom = rows - 1
    left = 0
    right = cols - 1
    direction = 0

    while top <= bottom and left <= right:
        if direction == 0:
            for i in range(left, right + 1):
                result.append(data[top, i])
            top += 1
        elif direction == 1:
            for i in range(top, bottom + 1):
                result.append(data[i, right])
            right -= 1
        elif direction == 2:
            for i in range(right, left - 1, -1):
                result.append(data[bottom, i])
            bottom -= 1
        elif direction == 3:
            for i in range(bottom, top - 1, -1):
                result.append(data[i, left])
            left += 1
        direction = (direction + 1) % 4

    return result


def decrypt_route_spiral(encrypted_text):
    text_length = len(encrypted_text)
    rows = int(text_length ** 0.5) + 1 if text_length ** 0.5 % 1 != 0 else int(text_length ** 0.5)
    cols = rows if rows * (rows - 1) >= text_length else rows + 1
    result = [[''] * cols for _ in range(rows)]

    top = 0
    bottom = rows - 1
    left = 0
    right = cols - 1
    direction = 0
    index = 0

    while top <= bottom and left <= right:
        if direction == 0:
            for i in range(left, right + 1):
                if index < text_length:
                    result[top][i] = encrypted_text[index]
                    index += 1
            top += 1
        elif direction == 1:
            for i in range(top, bottom + 1):
                if index < text_length:
                    result[i][right] = encrypted_text[index]
                    index += 1
            right -= 1
        elif direction == 2:
            for i in range(right, left - 1, -1):
                if index < text_length:
                    result[bottom][i] = encrypted_text[index]
                    index += 1
            bottom -= 1
        elif direction == 3:
            for i in range(bottom, top - 1, -1):
                if index < text_length:
                    result[i][left] = encrypted_text[index]
                    index += 1
            left += 1
        direction = (direction + 3) % 4  # Reverse direction

    decrypted_text = ''
    for row in result:
        decrypted_text += ''.join(row)

    return decrypted_text.strip()






input_text = read_from_file('input.txt')
encrypted_text = encrypt_route_spiral(input_text)
print('Зашифрованный текст: ',''.join(encrypted_text))

decrypted_text = decrypt_route_spiral(encrypted_text)
print('Расшифрованный текст: ', ''.join(decrypted_text))