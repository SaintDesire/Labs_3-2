-- Заполнение таблицы Кандидаты
INSERT INTO Candidates(CandidateID, FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES (1, 'Иванов Иван Иванович', 'ivanov@example.com', 'Высшее', '5 лет', 'Java, SQL, Python', TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Candidates(CandidateID, FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES (2, 'Петров Петр Петрович', 'petrov@example.com', 'Среднее', '3 года', 'C#, JavaScript', TO_DATE('2024-03-14', 'YYYY-MM-DD'));

-- Заполнение таблицы Вакансии
INSERT INTO Vacancies(VacancyID, Title, Requirements, Conditions, Salary, PublicationDate)
VALUES (1, 'Разработчик ПО', 'Высшее техническое образование, опыт работы от 2 лет', 'Офисная работа, гибкий график', 100000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies(VacancyID, Title, Requirements, Conditions, Salary, PublicationDate)
VALUES (2, 'Тестировщик ПО', 'Опыт тестирования от 1 года, знание тестировочных инструментов', 'Удаленная работа', 80000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

-- Заполнение таблицы Отделы
INSERT INTO Departments(DepartmentID, DepartmentName, Manager, CreationDate)
VALUES (1, 'Отдел разработки', 1, TO_DATE('2023-01-01', 'YYYY-MM-DD'));

INSERT INTO Departments(DepartmentID, DepartmentName, Manager, CreationDate)
VALUES (2, 'Отдел тестирования', 2, TO_DATE('2023-02-01', 'YYYY-MM-DD'));

-- Заполнение таблицы Интервью
INSERT INTO Interviews(InterviewID, DateTime, AnswerID, RecruiterID, Results)
VALUES (1, TO_TIMESTAMP('2024-03-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1, 1);

INSERT INTO Interviews(InterviewID, DateTime, AnswerID, RecruiterID, Results)
VALUES (2, TO_TIMESTAMP('2024-03-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 1, 1);

-- Заполнение таблицы Оценки
INSERT INTO Ratings (RatingID, Criteria, Score, Comments, InterviewID)
VALUES (1, 'Технические навыки', 8, 'Хороший уровень владения языком программирования', 4);

INSERT INTO Ratings (RatingID, Criteria, Score, Comments, InterviewID)
VALUES (2, 'Коммуникативные навыки', 7, 'Уверенное общение с командой', 5);

-- Заполнение таблицы Рекрутеры
INSERT INTO Recruiters (RecruiterID, FullName, ContactInfo)
VALUES (1, 'Петрова Елена Петровна', 'petrova@example.com');

INSERT INTO Recruiters (RecruiterID, FullName, ContactInfo)
VALUES (2, 'Иванов Иван Иванович', 'ivanov@example.com');

-- Заполнение таблицы Отклики на вакансию
INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (1, 2);

INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (2, 1);

-- Заполнение таблицы Сотрудники
INSERT INTO Employees(EmployeeID, FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES (1, 'Сидоров Сидор Сидорович', 'Разработчик ПО', TO_DATE('2023-01-10', 'YYYY-MM-DD'), 120000, NULL, 2, 1);

INSERT INTO Employees(EmployeeID, FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES (2, 'Иванова Анна Ивановна', 'Тестировщик ПО', TO_DATE('2023-02-05', 'YYYY-MM-DD'), 90000, NULL, 1, 1);
