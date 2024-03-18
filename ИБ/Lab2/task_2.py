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

def calculate_redundancy(alphabet_size, entropy):
    return 1 - (entropy / math.log2(alphabet_size))

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
    alphabet_size_a = len(frequency_a)
    alphabet_size_b = len(frequency_b)
    hartley_entropy_a = calculate_hartley_entropy(alphabet_size_a)
    hartley_entropy_b = calculate_hartley_entropy(64)

    # Вычисление энтропии Шеннона
    shannon_entropy_a = calculate_shannon_entropy(frequency_a)
    shannon_entropy_b = calculate_shannon_entropy(frequency_b)

    # Вычисление избыточности алфавитов
    redundancy_a = calculate_redundancy(alphabet_size_a, shannon_entropy_a)
    redundancy_b = calculate_redundancy(alphabet_size_b, shannon_entropy_b)

    # Вывод результатов
    print("Документ на латинице:")
    print(f"Энтропия Хартли: {hartley_entropy_a}")
    print(f"Энтропия Шеннона: {shannon_entropy_a}")
    print(f"Избыточность алфавита: {redundancy_a}")

    print("\nДокумент Base64:")
    print(f"Энтропия Хартли: {hartley_entropy_b}")
    print(f"Энтропия Шеннона: {shannon_entropy_b}")
    print(f"Избыточность алфавита: {redundancy_b}")

if __name__ == "__main__":
    main()
