
def base64_encode(s):
    # Определение таблицы base64
    base64_table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

    # Преобразовать строку в байты, используя кодировку ASCII
    bytes_ascii = s.encode('utf-8')

    # Создание списка для хранения закодированных символов
    encoded_chars = []

    # Цикл по байтам в строке
    for i in range(0, len(bytes_ascii), 3):
        # Получить тройку байтов
        chunk = bytes_ascii[i:i + 3]

        # Получить значения ASCII для каждого байта в тройке (если они существуют)
        byte1 = chunk[0] if len(chunk) > 0 else 0
        byte2 = chunk[1] if len(chunk) > 1 else 0
        byte3 = chunk[2] if len(chunk) > 2 else 0

        # Разбить каждый байт на шесть битов
        # Получаем индексы в таблице base64
        index1 = (byte1 & 0xFC) >> 2
        index2 = ((byte1 & 0x03) << 4) | ((byte2 & 0xF0) >> 4)
        index3 = ((byte2 & 0x0F) << 2) | ((byte3 & 0xC0) >> 6)
        index4 = byte3 & 0x3F

        # Закодировать индексы в символы base64
        encoded_chars.append(base64_table[index1])
        encoded_chars.append(base64_table[index2])
        encoded_chars.append(base64_table[index3])
        encoded_chars.append(base64_table[index4])

    # Добавить символы "=" для дополнения
    padding = len(bytes_ascii) % 3
    if padding == 1:
        encoded_chars[-2:] = "=="
    elif padding == 2:
        encoded_chars[-1] = "="

    # Объединить закодированные символы в строку
    encoded_string = ''.join(encoded_chars)
    return encoded_string


def main():
    input_file_path = "turkey.txt"
    output_file_path = "output_file.txt"

    try:
        with open(input_file_path, 'r') as file:
            text = file.read()
            encoded_text = base64_encode(text)
            print(encoded_text)

        with open(output_file_path, 'w') as file:
            file.write(encoded_text)

        print("Конвертация завершена!")
    except FileNotFoundError:
        print("Файл не найден!")
    except Exception as e:
        print("Произошла ошибка:", e)


if __name__ == "__main__":
    main()

