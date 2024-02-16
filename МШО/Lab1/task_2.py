import pandas as pd
import matplotlib
matplotlib.use('Agg')  # Явное указание бэкенда
import matplotlib.pyplot as plt

df = pd.read_csv('North America Restaurants.csv')
print(df.head())


# 3. Построение гистограммы частот по столбцу 'weighted_rating_value'
df['weighted_rating_value'].hist()
plt.xlabel('Значения')
plt.ylabel('Частота')
plt.title('Гистограмма весового рейтинга')
plt.show()

# 4. Расчет медианы и среднего значения столбца 'weighted_rating_value'
median_value = df['weighted_rating_value'].median()
mean_value = df['weighted_rating_value'].mean()
print('Медиана:', median_value)
print('Среднее значение:', mean_value)

# 5. Построение box plot для столбца 'weighted_rating_value'
plt.boxplot(df['weighted_rating_value'])
plt.ylabel('Значения')
plt.title('Box Plot весового рейтинга')
plt.show()

# 6. Применение метода .describe() к столбцу 'weighted_rating_value'
column_stats = df['weighted_rating_value'].describe()
print(column_stats)

# 7. Группировка данных по столбцу 'country' и расчет среднего значения и суммы для столбца 'aggregated_rating_count'
grouped_data = df.groupby('country')
mean_rating_count = grouped_data['aggregated_rating_count'].mean()
sum_rating_count = grouped_data['aggregated_rating_count'].sum()
print('Среднее значение количества рейтингов по странам:')
print(mean_rating_count)
print('Сумма количества рейтингов по странам:')
print(sum_rating_count)