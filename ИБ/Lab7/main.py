import gzip
import time

import pyDes


with open('input.txt', 'rb') as file:
    data = file.read()
#data = b"Please encrypt my data"
key1 = "Информац".encode("utf-8")[:8]
key2 = "зопаснос".encode("utf-8")[:8]
key3 = "лаборато".encode("utf-8")[:8]

weak_keys = [
    b'\x01\x01\x01\x01\x01\x01\x01\x01',
    b'\x1F\x1F\x1F\x1F\x0E\x0E\x0E\x0E',
    b'\xE0\xE0\xE0\xE0\xF1\xF1\xF1\xF1',
    b'\xFE\xFE\xFE\xFE\xFE\xFE\xFE\xFE'
]

semi_weak_keys = [
    b'\x01\xFE\x01\xFE\x01\xFE\x01\xFE',
    b'\x1F\xE0\x1F\xE0\x0E\xF1\x0E\xF1',
    b'\x01\xE0\x01\xE0\x01\xF1\x01\xF1',
    b'\x1F\xFE\x1E\xEE\x0E\xFE\x0E\xFE',
    b'\x01\x1F\x01\x1F\x01\x0E\x01\x0E',
    b'\xE0\xFE\xE0\xFE\xF1\xFE\xF1\xFE'
]

# Шифрование
k1 = pyDes.des(key1, pyDes.CBC, b"\0\0\0\0\0\0\0\0", pad=None, padmode=pyDes.PAD_PKCS5)
k2 = pyDes.des(key2, pyDes.CBC, b"\0\0\0\0\0\0\0\0", pad=None, padmode=pyDes.PAD_PKCS5)
k3 = pyDes.des(key3, pyDes.CBC, b"\0\0\0\0\0\0\0\0", pad=None, padmode=pyDes.PAD_PKCS5)

encrypt_start_time = time.time()
encrypted_data = k1.encrypt(data)
encrypted_data = k2.encrypt(encrypted_data)
encrypted_data = k3.encrypt(encrypted_data)
encrypt_end_time = time.time()


print("Encrypted: %r \n Time spent: %.6f seconds" % (encrypted_data, encrypt_end_time-encrypt_start_time))

# Дешифрование
decrypt_start_time = time.time()
decrypted_data = k3.decrypt(encrypted_data)
decrypted_data = k2.decrypt(decrypted_data)
decrypted_data = k1.decrypt(decrypted_data)
decrypt_end_time = time.time()

print("Decrypted: %r \n Time spent: %.6f seconds" % (decrypted_data, decrypt_end_time-decrypt_start_time))



def calculate_avalanche_effect(data, key):
    k = pyDes.des(key, pyDes.CBC, b"\0\0\0\0\0\0\0\0", pad=None, padmode=pyDes.PAD_PKCS5)
    encrypted_data = k.encrypt(data)
    return sum(x != y for x, y in zip(encrypted_data, encrypted_data[:1] + encrypted_data[:-1]))

print("Шифрование с использованием слабых ключей:")
for key in weak_keys:
    avalanche_effect = calculate_avalanche_effect(data, key)
    print("Encrypted with weak key %r, Avalanche Effect: %d" % (key, avalanche_effect))

print("\nШифрование с использованием полуслабых ключей:")
for key in semi_weak_keys:
    avalanche_effect = calculate_avalanche_effect(data, key)
    print("Encrypted with semi-weak key %r, Avalanche Effect: %d" % (key, avalanche_effect))


# Сжатие открытого текста
compressed_data = gzip.compress(data)
compression_ratio = len(compressed_data) / len(data)
print("Compression ratio of open text: %.2f" % compression_ratio)

# Сжатие зашифрованного текста
compressed_encrypted_data = gzip.compress(encrypted_data)
compression_ratio_encrypted = len(compressed_encrypted_data) / len(encrypted_data)
print("Compression ratio of encrypted text: %.2f" % compression_ratio_encrypted)