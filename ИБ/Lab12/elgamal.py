from sympy import mod_inverse

class ElGamal:
    @staticmethod
    def generate_elgamal_signature(p, g, x, k, H):
        y = pow(g, x, p)
        m = p - 1
        k_1 = mod_inverse(k, p - 1)
        a = pow(g, k, p)
        b = (k_1 * (H - (x * a) % m) % m) % m

        signature = ElGamal.int_to_bytes(a) + ElGamal.int_to_bytes(b)
        return signature

    @staticmethod
    def verify_elgamal_signature(p, g, y, H, signature):
        a = ElGamal.bytes_to_int(signature[:len(signature)//2])
        b = ElGamal.bytes_to_int(signature[len(signature)//2:])

        ya = pow(y, a, p)
        ab = pow(a, b, p)
        pr1 = (ya * ab) % p
        pr2 = pow(g, H, p)

        return pr1 == pr2

    @staticmethod
    def int_to_bytes(value):
        # Convert an integer to bytes
        return value.to_bytes((value.bit_length() + 7) // 8, byteorder='big')

    @staticmethod
    def bytes_to_int(bytes_seq):
        # Convert bytes to an integer
        return int.from_bytes(bytes_seq, byteorder='big')