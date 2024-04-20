def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

def phi(n):
    result = n
    p = 2
    while p * p <= n:
        if n % p == 0:
            while n % p == 0:
                n //= p
            result -= result // p
        p += 1
    if n > 1:
        result -= result // n
    return result

def count_coprimes_with_n(n):
    return phi(n)

def gcd_extended(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, x, y = gcd_extended(b % a, a)
        return (g, y - (b // a) * x, x)

def mod_inverse(a, m):
    g, x, y = gcd_extended(a, m)
    if g != 1:
        raise Exception('Обратного элемента не существует')
    else:
        return x % m

def gcd_two_numbers(a, b):
    while b != 0:
        a, b = b, a % b
    return a

def gcd_three_numbers(a, b, c):
    return gcd_two_numbers(a, gcd_two_numbers(b, c))


# Пример использования
number = 4466
result = count_coprimes_with_n(number)
print("Число взаимно простых чисел с", number, ":", result)

a = 59
n = 151
inverse = mod_inverse(a, n)
print("Число, обратное к", a, "по модулю", n, ":", inverse)


num1 = 32
num2 = 88
num3 = 44
num4 = 121
num5 = 11
gcd_of_two = gcd_two_numbers(num1, num2)
gcd_of_three = gcd_three_numbers(num3, num4, num5)
print("НОД чисел", num1, "и", num2, ":", gcd_of_two)
print("НОД чисел", num3, ",", num4, "и", num5, ":", gcd_of_three)
