from Crypto.PublicKey import RSA
from ElGamalCypher import ElGamalCypher
from RSACypher import RSACypher

class CypherHelper:
    @staticmethod
    def get_open_text():
        with open("open_text.txt", "rb") as file:
            return file.read()

    @staticmethod
    def write_to_file(data, filename):
        with open(filename, "wb") as file:
            file.write(data)

    @staticmethod
    def read_from_file(filename):
        with open(filename, "rb") as file:
            return file.read()

def main():
    fileNameEncryptRSA = "encrypt_rsa.txt"
    fileNameDecryptRSA = "decrypt_rsa.txt"
    fileNameEncryptElGamal = "encrypt_el_gamal.txt"
    fileNameDecryptElGamal = "decrypt_el_gamal.txt"

    open_text = CypherHelper.get_open_text()

    rsa_key = RSA.generate(4096)
    public_key = rsa_key.publickey()
    private_key = rsa_key

    encrypted_text_rsa = RSACypher.encrypt(open_text, public_key)
    decrypted_text_rsa = RSACypher.decrypt(encrypted_text_rsa, private_key)
    CypherHelper.write_to_file(encrypted_text_rsa, fileNameEncryptRSA)
    CypherHelper.write_to_file(decrypted_text_rsa, fileNameDecryptRSA)

    p = 29
    g = 7
    x = 10
    el_gamal = ElGamalCypher(p, g, x)

    encrypted_text_el_gamal = el_gamal.encrypt(open_text)
    decrypted_text_el_gamal = el_gamal.decrypt(encrypted_text_el_gamal)
    CypherHelper.write_to_file(encrypted_text_el_gamal, fileNameEncryptElGamal)
    # CypherHelper.write_to_file(decrypted_text_el_gamal, fileNameDecryptElGamal)

    length = len(CypherHelper.read_from_file("open_text.txt"))
    length_gamal = len(CypherHelper.read_from_file(fileNameEncryptElGamal))
    length_rsa = len(CypherHelper.read_from_file(fileNameEncryptRSA))
    print(f"Gamal length: {length_gamal}\n" +
          f"RSA length: {length_rsa}\n" +
          f"Text length: {length}")

    # RSACypher.first_task()

if __name__ == "__main__":
    main()