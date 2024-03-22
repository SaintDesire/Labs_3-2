-- Вставка данных в таблицу Candidates
INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES 
    ('Петухов Роман Лукьевич', 'nuneutromeujou-7930@yopmail.com', 'Высшее', '12 лет', 'Java, SQL, Python', TO_DATE('2024-03-17', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('Молчанов Влас Куприянович', 'wugriqueubeuve-5766@yopmail.com', 'Среднее', '3 года', 'C#, JavaScript', TO_DATE('2024-03-18', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('Соколов Владлен Егорович', 'teukikoufrico-1910@yopmail.com', 'Высшее', '5 лет', 'ASP.NET, C#', TO_DATE('2024-03-19', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('Кононов Гаянэ Тихонович', 'jeugrisouleini-5419@yopmail.com', 'Среднее', '1 год', 'React, JavaScript', TO_DATE('2024-03-20', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('Кошелев Виссарион Дмитриевич', 'faprayuloffou-6970@yopmail.com', 'Высшее', '9 лет', 'Django, SQL, Python', TO_DATE('2024-03-21', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('Калинин Архип Игоревич', 'wiwaukaquixo-6834@yopmail.com', 'Среднее', '3 года', 'C#, JavaScript', TO_DATE('2024-03-22', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('Терентьев Панкрат Артёмович', 'kupoquopretra-2066@yopmail.com', 'Высшее', '8 лет', 'Java, SQL, Python', TO_DATE('2024-03-23', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('Фомин Вольдемар Сергеевич', 'broixecanopi-1986@yopmail.com', 'Среднее', '3 года', 'C#, JavaScript', TO_DATE('2024-03-24', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('Логинов Руслан Улебович', 'suresajoba-4558@yopmail.com', 'Высшее', '6.5 лет', 'Java, SQL, Python', TO_DATE('2024-03-25', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('Копылов Роберт Богданович', 'troiffittuppoigru-5765@yopmail.com', 'Среднее', '2 года', 'C#, JavaScript', TO_DATE('2024-03-26', 'YYYY-MM-DD'));




-- Создание департаментов
INSERT INTO Departments (DepartmentName, Manager, CreationDate)
VALUES ('Отдел продаж', 3, TO_DATE('2024-03-27', 'YYYY-MM-DD'));


-- Создание записей в таблицу Employees для существующих кандидатов
INSERT INTO Employees (FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES ('Петухов Роман Лукьевич', 'Разработчик ПО', TO_DATE('2024-03-27', 'YYYY-MM-DD'), 120000, 1, 11, 1);

INSERT INTO Employees (FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES ('Молчанов Влас Куприянович', 'Тестировщик ПО', TO_DATE('2024-03-28', 'YYYY-MM-DD'), 90000, 2, 12, 2);

INSERT INTO Employees (FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES ('Соколов Владлен Егорович', 'Разработчик ПО', TO_DATE('2024-03-29', 'YYYY-MM-DD'), 120000, 1, 3, 1);

-- Создание записей в таблицу Interviews для добавленных сотрудников
INSERT INTO Interviews (DateTime, AnswerID, RecruiterID, Results)
VALUES (TO_DATE('2024-03-27 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1, 1);

INSERT INTO Interviews (DateTime, AnswerID, RecruiterID, Results)
VALUES (TO_DATE('2024-03-28 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 2, 1);

INSERT INTO Interviews (DateTime, AnswerID, RecruiterID, Results)
VALUES (TO_DATE('2024-03-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 1, 1);


-- Создание записей в таблицу VacancyAnswers для добавленных интервью
INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (1, 11);

INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (17, 12);

INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (1, 3);


-- Создание записей в таблицу Ratings для добавленных интервью
INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
VALUES ('Технические навыки', 8, 'Хороший уровень владения языком программирования', 4);

INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
VALUES ('Технические навыки', 6, 'Знание основных языков программирования', 5);

INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
VALUES ('Коммуникативные навыки', 8, 'Умение работать в команде и решать конфликты', 6);

-- Добавление записей о рекрутерах в таблицу Recruiters
INSERT INTO Recruiters (FullName, ContactInfo)
VALUES ('Зуева Диана Фроловна', 'woullattixousoi-5954@yopmail.com');

INSERT INTO Recruiters (FullName, ContactInfo)
VALUES ('Герасимова Анастасия Романовна', 'zipeuzetreummou-9692@yopmail.com');

INSERT INTO Recruiters (FullName, ContactInfo)
VALUES ('Маркова Августина Иринеевна', 'frauneunnequiri-1731@yopmail.com');



-- Добавление записей о вакансиях в таблицу Vacancies
INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Разработчик ПО', 'Высшее техническое образование, опыт работы от 2 лет', 'Офисная работа, гибкий график', 100000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Тестировщик ПО', 'Опыт тестирования от 1 года', 'Удаленная работа', 80000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Аналитик данных', 'Высшее математическое или техническое образование, опыт работы от 3 лет', 'Офисная работа', 120000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('UX/UI дизайнер', 'Опыт работы от 2 лет, знание инструментов дизайна', 'Гибкий график', 90000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Системный администратор', 'Опыт администрирования от 3 лет, знание сетевых технологий', 'Офисная работа', 110000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Маркетолог', 'Опыт маркетинга от 2 лет, знание цифровых инструментов продвижения', 'Гибкий график', 95000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Финансовый аналитик', 'Высшее экономическое образование, опыт работы от 3 лет', 'Офисная работа', 130000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('HR-специалист', 'Опыт работы в HR от 2 лет, знание трудового законодательства', 'Гибкий график', 85000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Продуктовый менеджер', 'Опыт управления продуктом от 3 лет, знание Agile методологий', 'Офисная работа', 125000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Бизнес-аналитик', 'Опыт анализа бизнес-процессов от 2 лет, навыки работы с SQL', 'Гибкий график', 105000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('DevOps инженер', 'Опыт внедрения CI/CD от 2 лет, знание современных DevOps инструментов', 'Удаленная работа', 115000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Специалист по технической поддержке', 'Опыт работы в IT-поддержке от 1 года, коммуникабельность', 'Офисная работа', 85000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Программист C++', 'Опыт разработки на C++ от 3 лет, знание STL и многопоточного программирования', 'Гибкий график', 110000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Администратор баз данных', 'Опыт администрирования СУБД от 2 лет, знание SQL и технологий резервного копирования', 'Офисная работа', 120000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Web-разработчик', 'Опыт веб-разработки от 2 лет, знание HTML, CSS, JavaScript', 'Гибкий график', 100000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));


