use HiringStaff;
-- ���������� ������� ���������
INSERT INTO Candidates(FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES ('������ ���� ��������', 'ivanov@example.com', '������', '5 ���', 'Java, SQL, Python', '2024-03-15'),
       ('������ ���� ��������', 'petrov@example.com', '�������', '3 ����', 'C#, JavaScript', '2024-03-14');

-- ���������� ������� ��������
INSERT INTO Vacancies(Title, Requirements, Conditions, Salary, PublicationDate)
VALUES ('����������� ��', '������ ����������� �����������, ���� ������ �� 2 ���', '������� ������, ������ ������', 100000, '2024-03-15'),
       ('����������� ��', '���� ������������ �� 1 ����, ������ ������������� ������������', '��������� ������', 80000, '2024-03-14');


-- ���������� ������� ������
INSERT INTO Departments(DepartmentName, Manager, CreationDate)
VALUES ('����� ����������', 1, '2023-01-01'),
       ('����� ������������', 2, '2023-02-01');

-- ���������� ������� ��������
INSERT INTO Interviews(DateTime, AnswerID, RecruiterID, Results)
VALUES ('2024-07-20 10:00:00', 1, 1, 1),
       ('2024-04-22 14:00:00', 2, 2, 1);

-- ���������� ������� ������
INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
VALUES ('����������� ������', 8, '������� ������� �������� ������ ����������������', 4),
       ('��������������� ������', 7, '��������� ������� � ��������', 5);

-- ���������� ������� ���������
INSERT INTO Recruiters (FullName, ContactInfo)
VALUES ('������� ����� ��������', 'petrova@example.com'),
       ('������ ���� ��������', 'ivanov@example.com');

-- ���������� ������� ������� �� ��������
INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (1, 2),
       (2, 1);

	   -- ���������� ������� ����������
INSERT INTO Employees(FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES ('������� ����� ���������', '����������� ��', '2023-01-10', 120000, NULL, 2, 1),
       ('������� ���� ��������', '����������� ��', '2023-02-05', 90000, NULL, 1, 1);