from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric.utils import Prehashed

class Schnorr:
    @staticmethod
    def generate_schnorr_keys():
        private_key = ec.generate_private_key(ec.SECP256R1())
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
    def create_schnorr_signature(data, private_key_bytes):
        private_key = serialization.load_der_private_key(private_key_bytes, password=None)
        return private_key.sign(data, ec.ECDSA(hashes.SHA256()))

    @staticmethod
    def verify_schnorr_signature(data, signature, public_key_bytes):
        public_key = serialization.load_der_public_key(public_key_bytes)
        try:
            public_key.verify(signature, data, ec.ECDSA(hashes.SHA256()))
            return True
        except:
            return False