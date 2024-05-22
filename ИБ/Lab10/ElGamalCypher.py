import random
import time
from Crypto.Util import number

class ElGamalCypher:
    def __init__(self, p, g, x):
        self.p = p
        self.g = g
        self.x = x
        self.y = pow(g, x, p)

    def encrypt(self, plaintext):
        start_time = time.perf_counter()

        k = random.randint(2, self.p - 2)
        a = pow(self.g, k, self.p)
        b = pow(self.y, k, self.p)

        ciphertext = bytearray()
        for byte in plaintext:
            ciphertext.append(byte ^ (a & 0xFF))
            ciphertext.append(byte ^ (b & 0xFF))

        elapsed_time = time.perf_counter() - start_time
        print(f"El-Gamal Encrypt:\t{elapsed_time * 1e6:.3f} microseconds ({elapsed_time * 1e3:.3f} ms)")
        return bytes(ciphertext)

    def decrypt(self, ciphertext):
        start_time = time.perf_counter()

        plaintext = bytearray()
        for i in range(0, len(ciphertext), 2):
            a = ciphertext[i]
            b = ciphertext[i + 1]
            plaintext.append(a ^ b ^ self.x)

        elapsed_time = time.perf_counter() - start_time
        print(f"El-Gamal Decrypt:\t{elapsed_time * 1e6:.3f} microseconds ({elapsed_time * 1e3:.3f} ms)")
        return bytes(plaintext)