from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes, serialization

class RSA:
    @staticmethod
    def generate_rsa_keys():
        private_key = rsa.generate_private_key(
            public_exponent=65537,
            key_size=2048
        )
        public_key = private_key.public_key()
        return (
            public_key.public_bytes(
                encoding=serialization.Encoding.DER,
                format=serialization.PublicFormat.SubjectPublicKeyInfo
            ),
            private_key.private_bytes(
                encoding=serialization.Encoding.DER,
                format=serialization.PrivateFormat.PKCS8,
                encryption_algorithm=serialization.NoEncryption()
            )
        )

    @staticmethod
    def create_rsa_signature(data, private_key_bytes):
        private_key = serialization.load_der_private_key(private_key_bytes, password=None)
        return private_key.sign(
            data,
            padding.PKCS1v15(),
            hashes.SHA256()
        )

    @staticmethod
    def verify_rsa_signature(data, signature, public_key_bytes):
        public_key = serialization.load_der_public_key(public_key_bytes)
        try:
            public_key.verify(
                signature,
                data,
                padding.PKCS1v15(),
                hashes.SHA256()
            )
            return True
        except:
            return False