import time
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_OAEP

class RSACypher:
    @staticmethod
    def encrypt(plaintext, public_key):
        start_time = time.perf_counter()

        cipher = PKCS1_OAEP.new(public_key)
        ciphertext = cipher.encrypt(plaintext)

        elapsed_time = time.perf_counter() - start_time
        print(f"RSA Encrypt:\t\t{elapsed_time * 1e6:.3f} microseconds ({elapsed_time * 1e3:.3f} ms)")
        return ciphertext

    @staticmethod
    def decrypt(ciphertext, private_key):
        start_time = time.perf_counter()

        cipher = PKCS1_OAEP.new(private_key)
        plaintext = cipher.decrypt(ciphertext)

        elapsed_time = time.perf_counter() - start_time
        print(f"RSA Decrypt:\t\t{elapsed_time * 1e6:.3f} microseconds ({elapsed_time * 1e3:.3f} ms)")
        return plaintext

    @staticmethod
    def first_task():
        a = 20
        x = 100000
        N = int("1" + "0" * 300)
        n = N

        for _ in range(10):
            start_time = time.perf_counter()
            RSACypher.fync_y(a, x, n)
            elapsed_time = time.perf_counter() - start_time
            print(f"x = {x}\t({elapsed_time * 1e3:.3f} ms)")
            x += 100000

    @staticmethod
    def fync_y(a, x, n):
        return pow(a, x, n)