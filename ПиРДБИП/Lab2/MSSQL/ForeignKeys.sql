-- ������� ���� �������-��������
IF NOT EXISTS (SELECT * 
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_Employees_Candidates')
BEGIN
    ALTER TABLE Employees
    ADD CONSTRAINT FK_Employees_Candidates FOREIGN KEY (CandidateID) 
    REFERENCES Candidates(CandidateID);
END;

-- ������� ���� �������-��������
IF NOT EXISTS (SELECT * 
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_Employees_Recruiters')
BEGIN
    ALTER TABLE Employees
    ADD CONSTRAINT FK_Employees_Recruiters FOREIGN KEY (RecruiterID) 
    REFERENCES Recruiters(RecruiterID);
END;

-- ������� ���� �������-�����
IF NOT EXISTS (SELECT * 
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_Employees_Departments')
BEGIN
    ALTER TABLE Employees
    ADD CONSTRAINT FK_Employees_Departments FOREIGN KEY (DepartmentID) 
    REFERENCES Departments(DepartmentID);
END;

-- ������� ���� �����-��������
IF NOT EXISTS (SELECT * 
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_Departments_Employees')
BEGIN
    ALTER TABLE Departments
    ADD CONSTRAINT FK_Departments_Employees FOREIGN KEY (Manager) 
    REFERENCES Employees(EmployeeID);
END;

-- ������� ���� �����-��������
IF NOT EXISTS (SELECT * 
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_Departments_Employees')
BEGIN
    ALTER TABLE Departments
    ADD CONSTRAINT FK_Departments_Employees FOREIGN KEY (Manager) 
    REFERENCES Employees(EmployeeID);
END;

-- ������� ���� ��������-��������
IF NOT EXISTS (SELECT * 
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_Interviews_Recruiters')
BEGIN
    ALTER TABLE Interviews
    ADD CONSTRAINT FK_Interviews_Recruiters FOREIGN KEY (RecruiterID) 
    REFERENCES Recruiters(RecruiterID);
END;

-- ������� ���� ��������-������
IF NOT EXISTS (SELECT * 
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_Interviews_VacancyAnswers')
BEGIN
    ALTER TABLE Interviews
    ADD CONSTRAINT FK_Interviews_VacancyAnswers FOREIGN KEY (AnswerID) 
    REFERENCES VacancyAnswers(AnswerID);
END;

-- ������� ���� �������-��������
IF NOT EXISTS (SELECT * 
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_Ratings_Interviews')
BEGIN
    ALTER TABLE Ratings
    ADD CONSTRAINT FK_Ratings_Interviews FOREIGN KEY (InterviewID) 
    REFERENCES Interviews(InterviewID);
END;

-- ������� ���� ������-��������
IF NOT EXISTS (SELECT * 
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_VacancyAnswers_Vacanies')
BEGIN
    ALTER TABLE VacancyAnswers
    ADD CONSTRAINT FK_VacancyAnswers_Vacanies FOREIGN KEY (VacancyID) 
    REFERENCES Vacancies(VacancyID);
END;

-- ������� ���� ������-��������
IF NOT EXISTS (SELECT * 
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_VacancyAnswers_Candidate')
BEGIN
    ALTER TABLE VacancyAnswers
    ADD CONSTRAINT FK_VacancyAnswers_Candidate FOREIGN KEY (CandidateID) 
    REFERENCES Candidates(CandidateID);
END;


-- ========================================================================

-- ���������� ����������������� ���������� ����� � ������� ���������
ALTER TABLE Candidates
ADD CandidateID INT IDENTITY(1,1) PRIMARY KEY;

-- ���������� ����������������� ���������� ����� � ������� ��������
ALTER TABLE Vacancies
ADD VacancyID INT IDENTITY(1,1) PRIMARY KEY;

-- ���������� ����������������� ���������� ����� � ������� ����������
ALTER TABLE Employees
ADD EmployeeID INT IDENTITY(1,1) PRIMARY KEY;

-- ���������� ����������������� ���������� ����� � ������� ������
ALTER TABLE Departments
ADD DepartmentID INT IDENTITY(1,1) PRIMARY KEY;

-- ���������� ����������������� ���������� ����� � ������� ��������
ALTER TABLE Interviews
ADD InterviewID INT IDENTITY(1,1) PRIMARY KEY;

-- ���������� ����������������� ���������� ����� � ������� ������
ALTER TABLE Ratings
ADD RatingID INT IDENTITY(1,1) PRIMARY KEY;

-- ���������� ����������������� ���������� ����� � ������� ���������
ALTER TABLE Recruiters
ADD RecruiterID INT IDENTITY(1,1) PRIMARY KEY;

-- ���������� ����������������� ���������� ����� � ������� ������� �� ��������
ALTER TABLE VacancyAnswers
ADD AnswerID INT IDENTITY(1,1) PRIMARY KEY;
