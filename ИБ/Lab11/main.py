import hashlib
import time
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

def hash_md5(message):
    md5_hash = hashlib.md5()
    md5_hash.update(message.encode('utf-8'))
    return md5_hash.hexdigest()

def hash_sha256(message):
    sha256_hash = hashlib.sha256()
    sha256_hash.update(message.encode('utf-8'))
    return sha256_hash.hexdigest()

def measure_hash_time(hash_func, message):
    start_time = time.time()
    hash_func(message)
    end_time = time.time()
    return end_time - start_time

message_sizes = [1000000, 2000000, 3000000]
md5_times = []
sha256_times = []

for size in message_sizes:
    message = 'a' * size
    md5_time = measure_hash_time(hash_md5, message)
    sha256_time = measure_hash_time(hash_sha256, message)
    md5_times.append(md5_time)
    sha256_times.append(sha256_time)


plt.plot(range(1, 4), md5_times, label='MD5')
plt.plot(range(1, 4), sha256_times, label='SHA-256')
plt.xlabel('Attempt')
plt.ylabel('Time (seconds)')
plt.title('Hashing Time vs Attempt')
plt.legend()
plt.show()