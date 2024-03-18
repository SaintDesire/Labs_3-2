-- ���������� ������� ���������
INSERT INTO Candidates(CandidateID, FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES (1, '������ ���� ��������', 'ivanov@example.com', '������', '5 ���', 'Java, SQL, Python', TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Candidates(CandidateID, FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
VALUES (2, '������ ���� ��������', 'petrov@example.com', '�������', '3 ����', 'C#, JavaScript', TO_DATE('2024-03-14', 'YYYY-MM-DD'));

-- ���������� ������� ��������
INSERT INTO Vacancies(VacancyID, Title, Requirements, Conditions, Salary, PublicationDate)
VALUES (1, '����������� ��', '������ ����������� �����������, ���� ������ �� 2 ���', '������� ������, ������ ������', 100000, TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Vacancies(VacancyID, Title, Requirements, Conditions, Salary, PublicationDate)
VALUES (2, '����������� ��', '���� ������������ �� 1 ����, ������ ������������� ������������', '��������� ������', 80000, TO_DATE('2024-03-14', 'YYYY-MM-DD'));

-- ���������� ������� ������
INSERT INTO Departments(DepartmentID, DepartmentName, Manager, CreationDate)
VALUES (1, '����� ����������', 1, TO_DATE('2023-01-01', 'YYYY-MM-DD'));

INSERT INTO Departments(DepartmentID, DepartmentName, Manager, CreationDate)
VALUES (2, '����� ������������', 2, TO_DATE('2023-02-01', 'YYYY-MM-DD'));

-- ���������� ������� ��������
INSERT INTO Interviews(InterviewID, DateTime, AnswerID, RecruiterID, Results)
VALUES (1, TO_TIMESTAMP('2024-03-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1, 1);

INSERT INTO Interviews(InterviewID, DateTime, AnswerID, RecruiterID, Results)
VALUES (2, TO_TIMESTAMP('2024-03-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 1, 1);

-- ���������� ������� ������
INSERT INTO Ratings (RatingID, Criteria, Score, Comments, InterviewID)
VALUES (1, '����������� ������', 8, '������� ������� �������� ������ ����������������', 4);

INSERT INTO Ratings (RatingID, Criteria, Score, Comments, InterviewID)
VALUES (2, '��������������� ������', 7, '��������� ������� � ��������', 5);

-- ���������� ������� ���������
INSERT INTO Recruiters (RecruiterID, FullName, ContactInfo)
VALUES (1, '������� ����� ��������', 'petrova@example.com');

INSERT INTO Recruiters (RecruiterID, FullName, ContactInfo)
VALUES (2, '������ ���� ��������', 'ivanov@example.com');

-- ���������� ������� ������� �� ��������
INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (1, 2);

INSERT INTO VacancyAnswers (VacancyID, CandidateID)
VALUES (2, 1);

-- ���������� ������� ����������
INSERT INTO Employees(EmployeeID, FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES (1, '������� ����� ���������', '����������� ��', TO_DATE('2023-01-10', 'YYYY-MM-DD'), 120000, NULL, 2, 1);

INSERT INTO Employees(EmployeeID, FullName, Position, HireDate, Salary, DepartmentID, CandidateID, RecruiterID)
VALUES (2, '������� ���� ��������', '����������� ��', TO_DATE('2023-02-05', 'YYYY-MM-DD'), 90000, NULL, 1, 1);
