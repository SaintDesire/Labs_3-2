def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

def mod_inverse(a, m):
    for x in range(1, m):
        if (a * x) % m == 1:
            return x
    return None

def prime_factors(n):
    factors = []
    while n % 2 == 0:
        factors.append(2)
        n //= 2
    for i in range(3, int(n**0.5) + 1, 2):
        while n % i == 0:
            factors.append(i)
            n //= i
    if n > 2:
        factors.append(n)
    return factors

def affine_encrypt(text, key):
    """
    Encrypts the given text using affine cipher.

    Args:
    text (str): The plaintext to be encrypted.
    key (tuple): A tuple (a, b) representing the key for affine cipher.

    Returns:
    str: The encrypted text.
    """
    result = ''
    a, b = key
    for char in text:
        if char.isalpha():
            if char.islower():
                result += chr(((a * (ord(char) - 1072) + b) % 33) + 1072)
            elif char.isupper():
                result += chr(((a * (ord(char) - 1040) + b) % 33) + 1040)
        else:
            result += char
    return result

def affine_decrypt(ciphertext, key):
    """
    Decrypts the given ciphertext using affine cipher.

    Args:
    ciphertext (str): The ciphertext to be decrypted.
    key (tuple): A tuple (a, b) representing the key for affine cipher.

    Returns:
    str: The decrypted text.
    """
    result = ''
    a, b = key
    a_inv = mod_inverse(a, 33)
    if a_inv is None:
        return "Invalid key. 'a' is not coprime with 33."
    for char in ciphertext:
        if char.isalpha():
            if char.islower():
                result += chr(((a_inv * (ord(char) - 1072 - b)) % 33) + 1072)
            elif char.isupper():
                result += chr(((a_inv * (ord(char) - 1040 - b)) % 33) + 1040)
        else:
            result += char
    return result

def main():
    # Пример ключа (a, b)
    key = (7, 7)

    # Пример исходного текста
    plaintext = "СЛОВО"

    # Шифрование
    encrypted_text = affine_encrypt(plaintext, key)
    print("Зашифровано:", encrypted_text)

    # Дешифрование
    decrypted_text = affine_decrypt(encrypted_text, key)
    print("Расшифровано:", decrypted_text)

    # Пример нахождения простых множителей для чисел m и n
    m = 540
    n = 577
    prime_factors_m = prime_factors(m)
    prime_factors_n = prime_factors(n)
    print("Простые множители числа m ({}): {}".format(m, prime_factors_m))
    print("Простые множители числа n ({}): {}".format(n, prime_factors_n))

if __name__ == "__main__":
    main()
