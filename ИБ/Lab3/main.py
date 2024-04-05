# Нахождение наибольшего общего делителя (НОД) двух чисел
def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

# Нахождение НОД трех чисел
def gcd_three(a, b, c):
    return gcd(gcd(a, b), c)

# Проверка, является ли число простым
def is_prime(n):
    if n <= 1:
        return False
    if n <= 3:
        return True
    if n % 2 == 0 or n % 3 == 0:
        return False
    i = 5
    while i * i <= n:
        if n % i == 0 or n % (i + 2) == 0:
            return False
        i += 6
    return True

# Поиск простых чисел в заданном диапазоне
def find_primes(start, end):
    primes = []
    for num in range(start, end + 1):
        if is_prime(num):
            primes.append(num)
    return primes

# Функция для нахождения простых множителей числа
def prime_factors(n):
    factors = []
    # Проверяем делится ли число на 2
    while n % 2 == 0:
        factors.append(2)
        n //= 2
    # Проверяем делится ли число на нечетные числа
    for i in range(3, int(n**0.5) + 1, 2):
        while n % i == 0:
            factors.append(i)
            n //= i
    # Если n больше 2, значит это простое число больше двух
    if n > 2:
        factors.append(n)
    return factors

# Заданные числа m и n
m = 540
n = 577

# Находим простые множители для чисел m и n
prime_factors_m = prime_factors(m)
prime_factors_n = prime_factors(n)


# Вычисление НОД двух чисел
print("НОД чисел 540 и 577:", gcd(540, 577))

# Вычисление НОД трех чисел
print("НОД чисел 540, 577 и 600:", gcd_three(540, 577, 600))

# Поиск простых чисел в интервале [2, 577]
print("Простые числа в интервале от 2 до 577:", find_primes(2, 577))

# Поиск простых чисел в интервале [540, 577]
print("Простые числа в интервале от 540 до 577:", find_primes(540, 577))

# Пример разбиения числа на произведение простых множителей
print("Простые множители числа m ({}): {}".format(m, prime_factors_m))
print("Простые множители числа n ({}): {}".format(n, prime_factors_n))
