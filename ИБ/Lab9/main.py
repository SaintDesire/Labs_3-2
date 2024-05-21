import random
import math
import time
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import base64


def main():
    # with open("ascii.txt") as open_text:
    #     print(open_text.read())
    open_text = b"Korshun Nikita Igorevich"
    private_key = []
    sequence = []
    num = 4
    z = 8
    buff = num

    for i in range(z):
        sequence.append(buff)
        buff = random.randint(buff * 2, buff * 3)
    private_key = sequence

    print("Private Key")
    for i in private_key:
        print(i, end=" ")

    print("\n")
    public_key = []
    n = sum(private_key) + 2
    a = generate_coprime(n)
    sequence1 = []

    for i in private_key:
        sequence1.append((a * i) % n)
    public_key = sequence1

    print("Public Key")
    for i in public_key:
        print(i, end=" ")
    print("\n")

    encrypted_text = encrypt(public_key, open_text)
    decrypted_text = decrypt(private_key, encrypted_text, a, n)

    print("\nEncrypted: ", end="")
    for number in encrypted_text:
        print(number, end=" ")

    decrypted_phrase = decrypted_text.decode('utf-8')
    print("\nDecrypted:", decrypted_phrase)

    # message_lengths = []
    # encryption_times_ascii = []
    # encryption_times_base64 = []
    # decryption_times_ascii = []
    # decryption_times_base64 = []
    #
    # for i in range(1, 500):
    #     message_length = len(open_text) * i
    #     message_lengths.append(message_length)
    #
    #     extended_text = open_text * i
    #
    #     # ASCII encoding
    #     start_time = time.perf_counter()
    #     if isinstance(extended_text, str):
    #         extended_text = extended_text.encode('ascii')
    #     encrypted_text_ascii = encrypt(public_key, extended_text)  # Pass public_key and extended_text to encrypt()
    #     encryption_time_ascii = (time.perf_counter() - start_time) * 1000
    #     encryption_times_ascii.append(encryption_time_ascii)
    #
    #     start_time = time.perf_counter()
    #     decrypted_text_ascii = decrypt(private_key, encrypted_text_ascii, a, n)  # Pass private_key, encrypted_text, a, n to decrypt()
    #     decryption_time_ascii = (time.perf_counter() - start_time) * 1000
    #     decryption_times_ascii.append(decryption_time_ascii)
    #
    #     # Base64 encoding
    #     start_time = time.perf_counter()
    #     if isinstance(extended_text, str):
    #         extended_text = base64.b64encode(extended_text.encode('utf-8'))
    #     encrypted_text_base64 = encrypt(public_key, extended_text)  # Pass public_key and extended_text to encrypt()
    #     encryption_time_base64 = (time.perf_counter() - start_time) * 1000
    #     encryption_times_base64.append(encryption_time_base64)
    #
    #     start_time = time.perf_counter()
    #     decrypted_text_base64 = decrypt(private_key, encrypted_text_base64, a, n)  # Pass private_key, encrypted_text, a, n to decrypt()
    #     decryption_time_base64 = (time.perf_counter() - start_time) * 1000
    #     decryption_times_base64.append(decryption_time_base64)
    #
    # plt.plot(message_lengths, encryption_times_ascii, label='Encryption (ASCII)')
    # plt.plot(message_lengths, decryption_times_ascii, label='Decryption (ASCII)')
    # plt.plot(message_lengths, encryption_times_base64, label='Encryption (Base64)')
    # plt.plot(message_lengths, decryption_times_base64, label='Decryption (Base64)')
    # plt.xlabel('Message Length')
    # plt.ylabel('Time (ms)')
    # plt.title('Encryption and Decryption Times')
    # plt.legend()
    # plt.show()

def generate_coprime(n):
    while True:
        number = random.randint(1, n)
        if nod(number, n) == 1:
            return number


def nod(a, b):
    while b != 0:
        a, b = b, a % b
    return a


def encrypt(public_key, text):
    start_time = time.perf_counter()
    encrypted_list = []

    for b in text:
        binary_string = format(int(b), '08b')
        sum_val = 0
        for i in range(8):
            if binary_string[i] == '1':
                sum_val += public_key[i]
        encrypted_list.append(sum_val)

    elapsed_time = (time.perf_counter() - start_time) * 1000
    print(f"Encrypt:\t{elapsed_time:.2f} ms")
    return encrypted_list


def decrypt(private_key, encrypted_text, a, n):
    start_time = time.perf_counter()
    decrypted_bytes = []
    inverse = 1

    while inverse * a % n != 1:
        inverse += 1

    for item in encrypted_text:
        decrypted_value = (item * inverse) % n
        binary_string = ''
        for i in range(len(private_key) - 1, -1, -1):
            if decrypted_value >= private_key[i]:
                binary_string = '1' + binary_string
                decrypted_value -= private_key[i]
            else:
                binary_string = '0' + binary_string

        decrypted_byte = int(binary_string, 2).to_bytes(1, byteorder='big')
        decrypted_bytes.append(decrypted_byte)

    elapsed_time = (time.perf_counter() - start_time) * 1000
    print(f"Decrypt:\t{elapsed_time:.2f} ms")
    return b''.join(decrypted_bytes)


if __name__ == "__main__":
    main()