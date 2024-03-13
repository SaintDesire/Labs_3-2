import numpy as np
import pandas as pd
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import seaborn as sns

# Загрузка данных
data = pd.read_csv('autoscout24-germany-dataset.csv')
data_old = data

# ============================== Задание 1 ==============================

# Визуальное выявление пропусков данных
sns.heatmap(data.isnull(), cmap='viridis', cbar=False)
plt.show()

# Расчетное выявление пропусков данных
missing_values = data.isnull().sum()
print("\nПропущенные значения в каждом столбце:\n")

# Подсчет количество нулевых значений по столбцам
for col in data.columns:
    pct_missing = data[col].isnull().sum()
    print('{} - {}'.format(col, round(pct_missing)))

print("\nПроцент пропущенных значений в каждом столбце:\n")
# Подсчет процента нулевых значений по столбцам
for col in data.columns:
    pct_missing = np.mean(data[col].isnull())
    print('{} - {:.2f}%'.format(col, pct_missing*100))
# ============================== Задание 2 ==============================

print("\nУдаляем model\n")
# Удаляем model т.к. большой процент пустых значений
data = data.drop(["model"],axis=1)
print(data.columns)
print(data.head())

print()
# ============================== Задание 3 ==============================

# Заполняем строки gear самым популярным значением
most_common_gear = data['gear'].mode()[0]
data['gear'] = data['gear'].fillna(most_common_gear)

# Заполняем строки hp средним значением
data['hp'] = data['hp'].fillna(data['hp'].mean())

# Подсчет процента нулевых значений по столбцам
for col in data.columns:
    pct_missing = np.mean(data[col].isnull())
    print('{} - {:.2f}%'.format(col, pct_missing*100))

sns.heatmap(data.isnull(), cmap='viridis', cbar=False)
plt.show()

# ============================== Задание 4 ==============================

# Подсчет частоты значений столбца "gear" в исходном датасете data_old
gear_counts_old = data_old["gear"].value_counts()

# Построение гистограммы распределения категориальных значений перед обработкой пропусков
plt.figure(figsize=(10, 6))
gear_counts_old.plot(kind='bar', color='blue', alpha=0.5)
plt.xlabel("Gear Type")
plt.ylabel("Frequency")
plt.title("Histogram of Gear Distribution (Before Handling Missing Values)")
plt.show()

# Подсчет частоты значений столбца "gear" в обработанном датасете data
gear_counts_new = data["gear"].value_counts()

# Построение гистограммы распределения категориальных значений после обработки пропусков
plt.figure(figsize=(10, 6))
gear_counts_new.plot(kind='bar', color='blue', alpha=0.5)
plt.xlabel("Gear Type")
plt.ylabel("Frequency")
plt.title("Histogram of Gear Distribution (After Handling Missing Values)")
plt.show()

# ============================== Задание 5 ==============================

top_10_prices = data["price"].nlargest(10)
print(top_10_prices)

# Функция для удаления выбросов на основе IQR
def remove_outliers_iqr(data, column):
    Q1 = np.percentile(data[column], 25)
    Q3 = np.percentile(data[column], 75)
    IQR = Q3 - Q1
    threshold = 1.5 * IQR
    data = data[(data[column] >= Q1 - threshold) & (data[column] <= Q3 + threshold)]
    return data

# Определение списка столбцов, которые нужно проверить на выбросы
columns_to_check = ['mileage', 'price', 'hp']

# Цикл для проверки и удаления выбросов для каждого столбца
for column in columns_to_check:
    data = remove_outliers_iqr(data, column)

top_10_prices = data["price"].nlargest(10)
print(top_10_prices)

# ============================== Задание 6 ==============================

# Список полей, которые вы хотите преобразовать в числовой тип данных
fields_to_convert = ['make', 'fuel', 'gear', 'offerType']

# Преобразование текстовых данных в числовой вид
for field in fields_to_convert:
    if data[field].dtype == object:  # Проверка, что тип данных поля является строковым
        data[field] = pd.to_numeric(data[field].str.rstrip('%'), errors='coerce')

# ============================== Задание 7 ==============================

# Сохранение обработанного датасета в CSV файл
data.to_csv('processed_dataset.csv', index=False)
