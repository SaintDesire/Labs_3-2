import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

data = (3, 6, 9, 12, 15)

fig, simple_chart = plt.subplots()

simple_chart.plot(data)

plt.savefig('chart.png')  # сохранение графика в файл

# Откройте файл chart.png для просмотра графика