def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

def mod_inverse(a, m):
    for x in range(1, m):
        if (a * x) % m == 1:
            return x
    return None

def affine_encrypt(text, key):
    result = ''
    a, b = key
    for char in text:
        if char.isalpha():
            if char.islower():
                encrypted_value = (a * (ord(char) - 1072) + b) % 33
                result += chr(encrypted_value + 1072)
                print("Encrypted value for '{}' is: {}".format(char, encrypted_value + 1))
            elif char.isupper():
                encrypted_value = (a * (ord(char) - 1040) + b) % 33
                result += chr(encrypted_value + 1040)
                print("Encrypted value for '{}' is: {}".format(char, encrypted_value + 1))
        else:
            result += char
    return result


def affine_decrypt(ciphertext, key):
    result = ''
    a, b = key
    a_inv = mod_inverse(a, 33)
    if a_inv is None:
        return "Invalid key. 'a' is not coprime with 33."
    for char in ciphertext:
        if char.isalpha():
            if char.islower():
                decrypted_value = (a_inv * (ord(char) - 1072 - b)) % 33
                result += chr(decrypted_value + 1072)
                print("Decrypted value for '{}' is: {}".format(char, decrypted_value + 1))
            elif char.isupper():
                decrypted_value = (a_inv * (ord(char) - 1040 - b)) % 33
                result += chr(decrypted_value + 1040)
                print("Decrypted value for '{}' is: {}".format(char, decrypted_value + 1))
        else:
            result += char
    return result



def main():
    # Пример ключа (a, b)
    key = (7, 7)

    # Пример исходного текста
    plaintext = "В"

    # Шифрование
    encrypted_text = affine_encrypt(plaintext, key)
    print("Зашифровано:", encrypted_text)

    # Дешифрование
    decrypted_text = affine_decrypt(encrypted_text, key)
    print("Расшифровано:", decrypted_text)

    print(mod_inverse(7,33))

if __name__ == "__main__":
    main()
