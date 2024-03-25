import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import confusion_matrix
from sklearn.tree import plot_tree
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt


# Загрузка данных из CSV-файла
data = pd.read_csv('heart.csv')

# ---------------------------------------------------------------------
# Выделите из данных вектор меток У и матрицу признаков Х
print()


# Выделение вектора меток У
Y = data['output']

# Выделение матрицы признаков Х
X = data.drop(columns=['output'])

# Вывод первых нескольких строк для проверки
print("Вектор меток У (первые 5 элементов):")
print(Y.head())
print("\nМатрица признаков Х (первые 5 строк):")
print(X.head())


# ---------------------------------------------------------------------
# Разделение данных на обучающую и тестовую выборки
print()


X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=0.2, random_state=42)

print("Размер обучающей выборки:", X_train.shape)
print("Размер тестовой выборки:", X_test.shape)

# ---------------------------------------------------------------------
# На обучающей выборке получите модели дерева решений и k-ближайших
# соседей, рассчитайте точность моделей.
print()


# Создание модели дерева решений
tree_model = DecisionTreeClassifier(random_state=42)
# Обучение модели дерева решений
tree_model.fit(X_train, y_train)
# Прогнозирование на обучающих данных
tree_train_predictions = tree_model.predict(X_train)
# Рассчет точности модели дерева решений
tree_train_accuracy = accuracy_score(y_train, tree_train_predictions)

# Создание модели k-ближайших соседей
knn_model = KNeighborsClassifier()
# Обучение модели k-ближайших соседей
knn_model.fit(X_train, y_train)
# Прогнозирование на обучающих данных
knn_train_predictions = knn_model.predict(X_train)
# Рассчет точности модели k-ближайших соседей
knn_train_accuracy = accuracy_score(y_train, knn_train_predictions)

# Вывод точности моделей
print("Точность модели дерева решений на обучающей выборке:", tree_train_accuracy)
print("Точность модели k-ближайших соседей на обучающей выборке:", knn_train_accuracy)



# ---------------------------------------------------------------------
# Подберите наилучшие параметры моделей (например, глубину для дерева
# решений, количество соседей для алгоритма knn)
print()


# Для дерева решений
tree_param_grid = {
    'max_depth': [3, 5, 7, 10],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4]
}

tree_grid_search = GridSearchCV(DecisionTreeClassifier(random_state=42), tree_param_grid, cv=5)
tree_grid_search.fit(X_train, y_train)

print("Лучшие параметры для дерева решений:", tree_grid_search.best_params_)
print("Лучшая точность для дерева решений:", tree_grid_search.best_score_)

# Для k-ближайших соседей
knn_param_grid = {
    'n_neighbors': [3, 5, 7, 10],
    'weights': ['uniform', 'distance'],
    'metric': ['euclidean', 'manhattan']
}

knn_grid_search = GridSearchCV(KNeighborsClassifier(), knn_param_grid, cv=5)
knn_grid_search.fit(X_train, y_train)

print("\nЛучшие параметры для k-ближайших соседей:", knn_grid_search.best_params_)
print("Лучшая точность для k-ближайших соседей:", knn_grid_search.best_score_)


# ---------------------------------------------------------------------
# Рассчитайте матрицу ошибок (confusion matrix) для каждой модели
print()


# Для модели дерева решений
tree_test_predictions = tree_model.predict(X_test)
tree_confusion_matrix = confusion_matrix(y_test, tree_test_predictions)

print("Матрица ошибок для модели дерева решений:")
print(tree_confusion_matrix)

# Для модели k-ближайших соседей
knn_test_predictions = knn_model.predict(X_test)
knn_confusion_matrix = confusion_matrix(y_test, knn_test_predictions)

print("\nМатрица ошибок для модели k-ближайших соседей:")
print(knn_confusion_matrix)


# ---------------------------------------------------------------------
# Выберите лучшую модель


# Выводы
# Исходя из этих данных, можно сделать следующие выводы:

# Модель дерева решений имеет более высокую точность на тестовой выборке и меньшее количество ошибок
# в матрице ошибок по сравнению с моделью k-ближайших соседей.

# Хотя модель дерева решений имеет точность 100% на обучающей выборке, но она также имеет
# хорошую точность на тестовой выборке, что указывает на ее обобщающую способность.

# Таким образом, в данном случае, модель дерева решений, скорее всего, является более предпочтительной.


# ---------------------------------------------------------------------
# Визуализируйте полученную модель дерева решений (при визуализации
# желательно уменьшить глубину дерева, что бы рисунок был читаемым, или
# сохранить в отдельный файл)
print()


# Получение лучшей модели дерева решений с наилучшими параметрами
best_tree_model = tree_grid_search.best_estimator_

# Визуализация дерева решений
plt.figure(figsize=(12, 8))
plot_tree(best_tree_model, feature_names=X.columns, class_names=['No Disease', 'Disease'], filled=True)
plt.savefig('decision_tree.png')
plt.show()