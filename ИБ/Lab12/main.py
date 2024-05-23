import timeit
from rsa import RSA
from elgamal import ElGamal
from schnorr import Schnorr
from helper import Helper

file_name_signature_rsa = "rsa.txt"
file_name_signature_elgamal = "elgamal.txt"
file_name_signature_schnorr = "schnorr.txt"
open_text = Helper.get_open_text("input.txt")

# Генерация и верификация ЭЦП на основе алгоритма RSA
start_time = timeit.default_timer()

rsa_public_key, rsa_private_key = RSA.generate_rsa_keys()
rsa_signature = RSA.create_rsa_signature(open_text, rsa_private_key)
rsa_is_valid = RSA.verify_rsa_signature(open_text, rsa_signature, rsa_public_key)
Helper.write_to_file(rsa_signature, file_name_signature_rsa)

elapsed_time = timeit.default_timer() - start_time
print(f"RSA signature:\t\t{elapsed_time * 1e6:.3f} microseconds ({elapsed_time * 1e3:.3f} ms)")
print(f"Is valid RSA: \t\t{rsa_is_valid}\n")

# Генерация и верификация ЭЦП на основе алгоритма Эль-Гамаля
start_time = timeit.default_timer()

p = 2137
g = 2127
x = 1116
k = 7
H = 2119

signature_elgamal = ElGamal.generate_elgamal_signature(p, g, x, k, H)
y = pow(g, x, p)
elgamal_is_valid = ElGamal.verify_elgamal_signature(p, g, y, H, signature_elgamal)
Helper.write_to_file(signature_elgamal, file_name_signature_elgamal)

elapsed_time = timeit.default_timer() - start_time
print(f"El-Gamal signature:\t{elapsed_time * 1e6:.3f} microseconds ({elapsed_time * 1e3:.3f} ms)")
print(f"Is valid El-Gamal: \t{elgamal_is_valid}\n")

# Генерация и верификация ЭЦП на основе алгоритма Шнорра
start_time = timeit.default_timer()

schnorr_public_key, schnorr_private_key = Schnorr.generate_schnorr_keys()
signature_schnorr = Schnorr.create_schnorr_signature(open_text, schnorr_private_key)
schnorr_is_valid = Schnorr.verify_schnorr_signature(open_text, signature_schnorr, schnorr_public_key)
Helper.write_to_file(signature_schnorr, file_name_signature_schnorr)

elapsed_time = timeit.default_timer() - start_time
print(f"Schnorr signature:\t{elapsed_time * 1e6:.3f} microseconds ({elapsed_time * 1e3:.3f} ms)")
print(f"Is valid Schnorr: \t{schnorr_is_valid}")