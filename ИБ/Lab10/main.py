import os
import base64
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes


def main():
    text = "Hello World Def".lower()

    open_text = b"Hello World Def"

    rsa_private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=4096
    )
    rsa_public_key = rsa_private_key.public_key()

    encrypted_text_rsa = encrypt_rsa(open_text, rsa_public_key)
    print(encrypted_text_rsa.hex())
    decrypted_text_rsa = decrypt_rsa(encrypted_text_rsa, rsa_private_key)
    print(decrypted_text_rsa.decode())

    p = 137
    g = 50
    x = 15

    encrypted_text_gamal = encrypt(text, p, g, x)
    decrypted_text_gamal = decrypt(encrypted_text_gamal, p, g, x)

    print(decrypted_text_gamal)


def encrypt_rsa(plaintext, public_key):
    ciphertext = public_key.encrypt(
        plaintext,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    return ciphertext


def decrypt_rsa(ciphertext, private_key):
    plaintext = private_key.decrypt(
        ciphertext,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    return plaintext


def encrypt(plaintext, p, g, x):
    y = pow(g, x, p)
    b = []
    for char in plaintext:
        b.append(pow(y, 20, p) * ord(char) % p)
    return b


def decrypt(b, p, g, x):
    dec_data = ""
    a = pow(g, 20, p)
    for num in b:
        p0 = p - 1 - x
        m1 = pow(a, p0, p)
        r = (m1 * num) % p
        dec_data += chr(r)
    return dec_data


if __name__ == "__main__":
    main()