import numpy as np
import pandas as pd

def numpy_operations():
    # Создание двумерного массива из 20 целых случайных чисел
    array = np.random.randint(0, 10, (4, 5))
    print("Исходный массив:")
    print(array)

    # Разделение массива на 2 массива
    array1, array2 = np.split(array, 2)
    print("\nПервый массив:")
    print(array1)
    print("\nВторой массив:")
    print(array2)

    # Поиск заданных значений в первом массиве (например, равных 6)
    target_value = 6
    matching_values = np.where(array1 == target_value)
    print("\nЗначения, равные", target_value, "в первом массиве:")
    print(array1[matching_values])

    # Подсчет количества найденных элементов
    count = np.count_nonzero(array1 == target_value)
    print("\nКоличество найденных элементов, равных", target_value, "в первом массиве:", count)

def pandas_operations():
    # Создание объекта Series из массива NumPy
    array = np.random.randint(0, 10, (4, 5))
    print("Исходный массив:")
    print(array)
    series = pd.Series(array.flatten())
    print("\nОбъект Series:")
    print(series)

    # Произведение различных математических операций над Series
    print("\nСумма элементов в Series:", series.sum())
    print("Максимальное значение в Series:", series.max())
    print("Минимальное значение в Series:", series.min())

    # Создание объекта DataFrame из массива NumPy
    df = pd.DataFrame(array)
    print("\nОбъект DataFrame:")
    print(df)

    # Написание строки заголовков в созданном DataFrame
    df.columns = ["A", "B", "C", "D", "E"]
    print("\nDataFrame с заголовками:")
    print(df)

    # Удаление любой строки
    df = df.drop(1)  # Удаляем вторую строку
    print("\nDataFrame после удаления строки:")
    print(df)

    # Удаление любого столбца
    df = df.drop("B", axis=1)  # Удаляем столбец "B"
    print("\nDataFrame после удаления столбца:")
    print(df)

    # Вывод размера получившегося DataFrame
    print("\nРазмер DataFrame:", df.shape)

    # Поиск всех элементов, равных какому-либо числу
    target_number = 4
    matching_elements = df[df == target_number]
    print("\nЭлементы, равные", target_number, "в DataFrame:")
    print(matching_elements)


numpy_operations()
print('-' * 50)
pandas_operations()
