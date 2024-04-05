use HiringStaff;
-- Заполнение таблицы Кандидаты
INSERT INTO Candidates(FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('Иванов Иван Иванович', 'ivanov@example.com', 'Высшее', '5 лет', 'Java, SQL, Python', '2024-03-15'),
       ('Петров Петр Петрович', 'petrov@example.com', 'Среднее', '3 года', 'C#, JavaScript', '2024-03-14');

-- Заполнение таблицы Вакансии
INSERT INTO Vacancies(Title, Requirements, Conditions, Salary, PublicationDate)
VALUES ('Разработчик ПО', 'Высшее техническое образование, опыт работы от 2 лет', 'Офисная работа, гибкий график', 100000, '2024-03-15'),
       ('Тестировщик ПО', 'Опыт тестирования от 1 года, знание тестировочных инструментов', 'Удаленная работа', 80000, '2024-03-14');


-- Заполнение таблицы Отделы
INSERT INTO Departments(DepartmentName, Manager, CreationDate)
VALUES ('Отдел разработки', 1, '2023-01-01'),
       ('Отдел тестирования', 2, '2023-02-01');

-- Заполнение таблицы Интервью
INSERT INTO Interviews(DateTime, AnswerID, RecruiterID, Results)
VALUES ('2024-07-20 10:00:00', 1, 1, 1),
       ('2024-04-22 14:00:00', 2, 2, 1);

-- Заполнение таблицы Оценки
INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
VALUES ('Технические навыки', 8, 'Хороший уровень владения языком программирования', 4),
       ('Коммуникативные навыки', 7, 'Уверенное общение с командой', 5);

-- Заполнение таблицы Рекрутеры
INSERT INTO Recruiters (FullName, ContactInfo)
VALUES ('Петрова Елена Петровна', 'petrova@example.com'),
       ('Иванов Иван Иванович', 'ivanov@example.com');

-- Заполнение таблицы Отклики на вакансию
INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (1, 2),
       (2, 1);

	   -- Заполнение таблицы Сотрудники
INSERT INTO Employees(FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES ('Сидоров Сидор Сидорович', 'Разработчик ПО', '2023-01-10', 120000, NULL, 2, 1),
       ('Иванова Анна Ивановна', 'Тестировщик ПО', '2023-02-05', 90000, NULL, 1, 1);