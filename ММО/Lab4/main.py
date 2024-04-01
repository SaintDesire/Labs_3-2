from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, precision_score, recall_score, confusion_matrix, RocCurveDisplay
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
matplotlib.use('TkAgg')

data = pd.read_csv('heart.csv')

# Разделение данных на признаки (X) и целевую переменную (y)
X = data.drop(columns=['output'])  # Признаки
y = data['output']  # Целевая переменная

# Разделение данных на обучающий и тестовый наборы
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)


# -----------------------------------------------------------------
# Обучите на своих данных модель логистической регрессии LogisticRegression



# Создание и обучение модели логистической регрессии
# Устанавливаем параметр max_iter на более высокое значение, чтобы убрать предупреждение о сходимости
model = LogisticRegression(max_iter=5000)
model.fit(X_train, y_train)

# Рассчет точности на обучающем и тестовом наборах
train_accuracy = model.score(X_train, y_train)
test_accuracy = model.score(X_test, y_test)

print("Правильность на обучающем наборе: {:.2f}".format(train_accuracy))
print("Правильность на тестовом наборе: {:.2f}".format(test_accuracy))

# Изменение параметра регуляризации C и повторное обучение модели
for C in [100, 0.01]:
    model = LogisticRegression(C=C, max_iter=5000)
    model.fit(X_train, y_train)
    train_accuracy = model.score(X_train, y_train)
    test_accuracy = model.score(X_test, y_test)
    print("\nПараметр регуляризации C =", C)
    print("Правильность на обучающем наборе: {:.2f}".format(train_accuracy))
    print("Правильность на тестовом наборе: {:.2f}".format(test_accuracy))

# Добавление L2-регуляризации
model = LogisticRegression(penalty='l2', C=0.1, max_iter=5000)
model.fit(X_train, y_train)

# Рассчет метрик качества
y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
precision = precision_score(y_test, y_pred)
recall = recall_score(y_test, y_pred)

# Рассчет матрицы ошибок
conf_matrix = confusion_matrix(y_test, y_pred)

print("\nМетрики качества:")
print("Accuracy:", accuracy)
print("Precision:", precision)
print("Recall:", recall)

print("\nМатрица ошибок:")
print(conf_matrix)



# -----------------------------------------------------------------
# Обучите на своих данных модель метода опорных векторов SVC
print()


# Создание и обучение модели метода опорных векторов (SVC)
model_SVC = SVC(max_iter=5000)
model_SVC.fit(X_train, y_train)

# Рассчет точности на обучающем и тестовом наборах
train_accuracy = model_SVC.score(X_train, y_train)
test_accuracy = model_SVC.score(X_test, y_test)

print("Точность на обучающем наборе: {:.2f}".format(train_accuracy))
print("Точность на тестовом наборе: {:.2f}".format(test_accuracy))

# Подбор наилучших параметров с помощью GridSearchCV
SVC_params = {"C": [0.1, 1, 10], "gamma": [0.2, 0.6, 1]}
SVC_grid = GridSearchCV(model_SVC, SVC_params, cv=5, n_jobs=-1)
SVC_grid.fit(X_train, y_train)

print("\nЛучшая точность на обучающем наборе:", SVC_grid.best_score_)
print("Лучшие параметры:", SVC_grid.best_params_)

# Получение точности наилучшей модели на тестовом наборе
best_model = SVC_grid.best_estimator_
best_test_accuracy = best_model.score(X_test, y_test)
print("Точность наилучшей модели на тестовом наборе:", best_test_accuracy)

# Рассчет метрик качества для наилучшей модели
y_pred = best_model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
precision = precision_score(y_test, y_pred)
recall = recall_score(y_test, y_pred)
conf_matrix = confusion_matrix(y_test, y_pred)

print("\nМетрики качества:")
print("Accuracy:", accuracy)
print("Precision:", precision)
print("Recall:", recall)

print("\nМатрица ошибок:")
print(conf_matrix)



# -----------------------------------------------------------------
# В этом же файле (блокноте) обучите на этом же датасете модели
# дерева решений и K-ближайших соседей. Выведите их точность на
# обучающих и тестовых данных
print()


# Создание модели дерева решений
tree_model = DecisionTreeClassifier()
tree_model.fit(X_train, y_train)

# Создание модели k-ближайших соседей
knn_model = KNeighborsClassifier()
knn_model.fit(X_train, y_train)

# Рассчет точности на обучающем и тестовом наборах для дерева решений
tree_train_accuracy = tree_model.score(X_train, y_train)
tree_test_accuracy = tree_model.score(X_test, y_test)

print("Точность модели дерева решений на обучающем наборе:", tree_train_accuracy)
print("Точность модели дерева решений на тестовом наборе:", tree_test_accuracy)

# Рассчет точности на обучающем и тестовом наборах для k-ближайших соседей
knn_train_accuracy = knn_model.score(X_train, y_train)
knn_test_accuracy = knn_model.score(X_test, y_test)

print("Точность модели k-ближайших соседей на обучающем наборе:", knn_train_accuracy)
print("Точность модели k-ближайших соседей на тестовом наборе:", knn_test_accuracy)



# -----------------------------------------------------------------
# Постройте в одних осях четыре ROC-кривые для 4-х обученных моделей
print()



# Создание ROC-кривых для каждой модели
fig, ax = plt.subplots(figsize=(8, 6))

# Логистическая регрессия
logistic_disp = RocCurveDisplay.from_estimator(model, X_test, y_test, ax=ax, name='Logistic Regression')

# Метод опорных векторов
svc_disp = RocCurveDisplay.from_estimator(best_model, X_test, y_test, ax=ax, name='SVC')

# Дерево решений
tree_disp = RocCurveDisplay.from_estimator(tree_model, X_test, y_test, ax=ax, name='Decision Tree')

# k-ближайших соседей
knn_disp = RocCurveDisplay.from_estimator(knn_model, X_test, y_test, ax=ax, name='K-Nearest Neighbors')

# Отображение всех ROC-кривых на одном графике
plt.legend(loc="lower right")
plt.show()