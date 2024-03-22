-- ������� ������ � ������� Candidates
INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES 
    ('������� ����� ��������', 'nuneutromeujou-7930@yopmail.com', '������', '12 ���', 'Java, SQL, Python', TO_DATE('2024-03-17', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('�������� ���� �����������', 'wugriqueubeuve-5766@yopmail.com', '�������', '3 ����', 'C#, JavaScript', TO_DATE('2024-03-18', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('������� ������� ��������', 'teukikoufrico-1910@yopmail.com', '������', '5 ���', 'ASP.NET, C#', TO_DATE('2024-03-19', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('������� ����� ���������', 'jeugrisouleini-5419@yopmail.com', '�������', '1 ���', 'React, JavaScript', TO_DATE('2024-03-20', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('������� ��������� ����������', 'faprayuloffou-6970@yopmail.com', '������', '9 ���', 'Django, SQL, Python', TO_DATE('2024-03-21', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('������� ����� ��������', 'wiwaukaquixo-6834@yopmail.com', '�������', '3 ����', 'C#, JavaScript', TO_DATE('2024-03-22', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('��������� ������� ��������', 'kupoquopretra-2066@yopmail.com', '������', '8 ���', 'Java, SQL, Python', TO_DATE('2024-03-23', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('����� ��������� ���������', 'broixecanopi-1986@yopmail.com', '�������', '3 ����', 'C#, JavaScript', TO_DATE('2024-03-24', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('������� ������ ��������', 'suresajoba-4558@yopmail.com', '������', '6.5 ���', 'Java, SQL, Python', TO_DATE('2024-03-25', 'YYYY-MM-DD'));

INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('������� ������ ����������', 'troiffittuppoigru-5765@yopmail.com', '�������', '2 ����', 'C#, JavaScript', TO_DATE('2024-03-26', 'YYYY-MM-DD'));




-- �������� �������������
INSERT INTO Departments (DepartmentName, Manager, CreationDate)
VALUES ('����� ������', 3, TO_DATE('2024-03-27', 'YYYY-MM-DD'));


-- �������� ������� � ������� Employees ��� ������������ ����������
INSERT INTO Employees (FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES ('������� ����� ��������', '����������� ��', TO_DATE('2024-03-27', 'YYYY-MM-DD'), 120000, 1, 11, 1);

INSERT INTO Employees (FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES ('�������� ���� �����������', '����������� ��', TO_DATE('2024-03-28', 'YYYY-MM-DD'), 90000, 2, 12, 2);

INSERT INTO Employees (FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES ('������� ������� ��������', '����������� ��', TO_DATE('2024-03-29', 'YYYY-MM-DD'), 120000, 1, 3, 1);

-- �������� ������� � ������� Interviews ��� ����������� �����������
INSERT INTO Interviews (DateTime, AnswerID, RecruiterID, Results)
VALUES (TO_DATE('2024-03-27 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1, 1);

INSERT INTO Interviews (DateTime, AnswerID, RecruiterID, Results)
VALUES (TO_DATE('2024-03-28 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 2, 1);

INSERT INTO Interviews (DateTime, AnswerID, RecruiterID, Results)
VALUES (TO_DATE('2024-03-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 1, 1);


-- �������� ������� � ������� VacancyAnswers ��� ����������� ��������
INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (1, 11);

INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (17, 12);

INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (1, 3);


-- �������� ������� � ������� Ratings ��� ����������� ��������
INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
VALUES ('����������� ������', 8, '������� ������� �������� ������ ����������������', 4);

INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
VALUES ('����������� ������', 6, '������ �������� ������ ����������������', 5);

INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
VALUES ('��������������� ������', 8, '������ �������� � ������� � ������ ���������', 6);

-- ���������� ������� � ���������� � ������� Recruiters
INSERT INTO Recruiters (FullName, ContactInfo)
VALUES ('����� ����� ��������', 'woullattixousoi-5954@yopmail.com');

INSERT INTO Recruiters (FullName, ContactInfo)
VALUES ('���������� ��������� ���������', 'zipeuzetreummou-9692@yopmail.com');

INSERT INTO Recruiters (FullName, ContactInfo)
VALUES ('������� ��������� ���������', 'frauneunnequiri-1731@yopmail.com');



-- ���������� ������� � ��������� � ������� Vacancies
INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('����������� ��', '������ ����������� �����������, ���� ������ �� 2 ���', '������� ������, ������ ������', 100000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('����������� ��', '���� ������������ �� 1 ����', '��������� ������', 80000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('�������� ������', '������ �������������� ��� ����������� �����������, ���� ������ �� 3 ���', '������� ������', 120000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('UX/UI ��������', '���� ������ �� 2 ���, ������ ������������ �������', '������ ������', 90000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('��������� �������������', '���� ����������������� �� 3 ���, ������ ������� ����������', '������� ������', 110000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('����������', '���� ���������� �� 2 ���, ������ �������� ������������ �����������', '������ ������', 95000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('���������� ��������', '������ ������������� �����������, ���� ������ �� 3 ���', '������� ������', 130000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('HR-����������', '���� ������ � HR �� 2 ���, ������ ��������� ����������������', '������ ������', 85000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('����������� ��������', '���� ���������� ��������� �� 3 ���, ������ Agile �����������', '������� ������', 125000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('������-��������', '���� ������� ������-��������� �� 2 ���, ������ ������ � SQL', '������ ������', 105000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('DevOps �������', '���� ��������� CI/CD �� 2 ���, ������ ����������� DevOps ������������', '��������� ������', 115000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('���������� �� ����������� ���������', '���� ������ � IT-��������� �� 1 ����, ������������������', '������� ������', 85000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('����������� C++', '���� ���������� �� C++ �� 3 ���, ������ STL � �������������� ����������������', '������ ������', 110000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('������������� ��� ������', '���� ����������������� ���� �� 2 ���, ������ SQL � ���������� ���������� �����������', '������� ������', 120000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

INSERT INTO Vacancies (Title, Requirements, Conditions, Salary, PublicationDate)
VALUES 
    ('Web-�����������', '���� ���-���������� �� 2 ���, ������ HTML, CSS, JavaScript', '������ ������', 100000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));


