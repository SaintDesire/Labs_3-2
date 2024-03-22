import math

def calculate_frequency(text):
    frequency = {}
    total_symbols = 0
    for char in text:
        if char.isalpha():  # Consider only alphabetic characters
            frequency[char] = frequency.get(char, 0) + 1
            total_symbols += 1
    for char, count in frequency.items():
        frequency[char] = count / total_symbols
    return frequency

def calculate_hartley_entropy(alphabet_size):
    return math.log2(alphabet_size)

def calculate_shannon_entropy(frequency):
    entropy = 0
    for prob in frequency.values():
        entropy -= prob * math.log2(prob)
    return entropy

def calculate_redundancy(entropy_shannon, entropy_hartley):
    return ((entropy_hartley - entropy_shannon) / entropy_hartley) * 100

def main():
    # Чтение документов
    with open('turkey.txt', 'r', encoding='utf-8') as file:
        text_a = file.read()

    with open('output_file.txt', 'r', encoding='utf-8') as file:
        text_b = file.read()

    # Вычисление частотности символов
    frequency_a = calculate_frequency(text_a)
    frequency_b = calculate_frequency(text_b)

    # Вычисление энтропии Хартли
    alphabet_size_a = 29
    alphabet_size_b = 64

    hartley_entropy_a = calculate_hartley_entropy(alphabet_size_a)
    hartley_entropy_b = calculate_hartley_entropy(alphabet_size_b)


    # Вычисление энтропии Шеннона
    shannon_entropy_a = calculate_shannon_entropy(frequency_a)
    shannon_entropy_b = calculate_shannon_entropy(frequency_b)

    # Вычисление избыточности алфавитов
    redundancy_a = calculate_redundancy(shannon_entropy_a, hartley_entropy_a)
    redundancy_b = calculate_redundancy(shannon_entropy_b, hartley_entropy_b)

    # Вывод результатов
    print("Документ на латинице:")
    print(f"Энтропия Хартли: {hartley_entropy_a}")
    print(f"Энтропия Шеннона: {shannon_entropy_a}")
    print(f"Избыточность алфавита: {redundancy_a}%")

    print("\nДокумент Base64:")
    print(f"Энтропия Хартли: {hartley_entropy_b}")
    print(f"Энтропия Шеннона: {shannon_entropy_b}")
    print(f"Избыточность алфавита: {redundancy_b}%")

if __name__ == "__main__":
    main()


#
# data_turkey = {'T': 20, 'ü': 58, 'r': 156, 'k': 88, 'i': 210, 'y': 61, 'e': 194, 't': 73, 'l': 124, 'c': 15, 'a': 151, 'h': 22, 'z': 26, 'n': 111, 'g': 25, 'v': 27, 'ç': 21, 'ş': 12, 'ı': 56, 'b': 31, 'd': 51, 'D': 2, 'o': 20, 'ğ': 22, 'u': 33, 'B': 1, 's': 37, 'ö': 6, 'p': 18, 'm': 43, 'A': 13, 'İ': 4, 'S': 5, 'C': 2, 'f': 10, 'K': 4, 'M': 1, 'L': 1, 'P': 1, 'N': 1, 'E': 2, 'j': 2, 'O': 1, 'H': 1}
# data_base64 = {'V': 67, 'N': 54, 'C': 113, 'T': 68, 'Z': 138, 'h': 75, 'y': 55, 'a': 106, 'l': 170, 'S': 52, 'w': 52, 'g': 87, 'X': 89, 'R': 59, 'r': 45, 'W': 112, 'x': 53, 'e': 28, 'j': 3, 'B': 91, 'Y': 96, 'J': 106, 'p': 86, 'G': 148, 'k': 61, 's': 82, 'I': 116, 'H': 43, 'b': 102, 'm': 98, 'd': 75, 'i': 40, 'P': 32, 'L': 21, 'Q': 66, 'q': 13, 'n': 43, 't': 49, 'U': 51, 'F': 61, 'u': 43, 'E': 18, 'v': 8, 'c': 71, 'z': 12, 'D': 7, 'o': 5, 'f': 11, 'M': 23, 'K': 28}
#
# symbols = list(data_turkey.keys())
# frequencies = list(data_turkey.values())
#
# print("Символы латиница:", symbols)
# print("Частоты латиница:", frequencies)
#
#
# symbols = list(data_base64.keys())
# frequencies = list(data_base64.values())
#
# print("Символы base64:", symbols)
# print("Частоты base64:", frequencies)
