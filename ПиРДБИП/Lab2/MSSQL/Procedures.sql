use HiringStaff;

-- ��������� �������� ������ ���������
CREATE PROCEDURE CreateCandidate
    @FullName NVARCHAR(100),
    @ContactInfo NVARCHAR(100),
    @Education NVARCHAR(100),
    @WorkExperience NVARCHAR(100),
    @Skills NVARCHAR(100),
    @RegistrationDate DATE
AS
BEGIN
    INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
    VALUES (@FullName, @ContactInfo, @Education, @WorkExperience, @Skills, @RegistrationDate);
END;



-- ������� ��������� ���������� � ��������� �� ��� ID
CREATE FUNCTION GetCandidateInfo
    (@CandidateID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Candidates
    WHERE CandidateID = @CandidateID
);



-- ��������� ���������� ������ ���������
CREATE PROCEDURE UpdateCandidate
    @CandidateID INT,
    @FullName NVARCHAR(100),
    @ContactInfo NVARCHAR(100),
    @Education NVARCHAR(100),
    @WorkExperience NVARCHAR(100),
    @Skills NVARCHAR(100),
    @RegistrationDate DATE
AS
BEGIN
    UPDATE Candidates
    SET FullName = @FullName,
        ContactInfo = @ContactInfo,
        Education = @Education,
        WorkExperience = @WorkExperience,
        Skills = @Skills,
        RegistrationDate = @RegistrationDate
    WHERE CandidateID = @CandidateID;
END;



-- ��������� �������� ���������
CREATE PROCEDURE DeleteCandidate
    @CandidateID INT
AS
BEGIN
    DELETE FROM Candidates
    WHERE CandidateID = @CandidateID;
END;



-- ��������� ���������� ���������� � ����������
CREATE PROCEDURE UpdateEmployee
    @EmployeeID INT,
    @FullName NVARCHAR(100),
    @Position NVARCHAR(100),
    @HireDate DATE,
    @Salary DECIMAL(10, 2),
    @DepartmentID INT,
    @CandidateID INT,
    @RecruiterID INT
AS
BEGIN
    UPDATE Employees
    SET FullName = @FullName,
        Position = @Position,
        HireDate = @HireDate,
        Salary = @Salary,
        DepartmentID = @DepartmentID,
        CandidateID = @CandidateID,
        RecruiterID = @RecruiterID
    WHERE EmployeeID = @EmployeeID;
END;



-- ��������� �������� ����������
CREATE PROCEDURE DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    DELETE FROM Employees
    WHERE EmployeeID = @EmployeeID;
END;




-- ==============================================================

SELECT * FROM Candidates;

-- ���������� ���������
EXEC CreateCandidate '����� ��������', 'email@example.com', '������', '3 ����', 'Java, SQL', '2024-03-15';

-- ��������� ������ ���������
SELECT * FROM GetCandidateInfo(1);

-- ���������� ���������
EXEC UpdateCandidate 5, '����������� ��������', 'updated_email@example.com', '������', '5 ���', 'Java, SQL, Python', '2024-03-16';

-- �������� ���������
EXEC DeleteCandidate 5;



SELECT * FROM Employees;

-- ���������� ����������
EXEC UpdateEmployee 4, '����������� ���������', 'QA Engineer', '2024-03-16', 95000, 4, 2, 1;

-- �������� ����������
EXEC DeleteEmployee 4;



-- =========================== ������ ������� ===========================

-- ���������� ��������
CREATE PROCEDURE ScheduleInterview
    @CandidateID INT,
    @VacancyID INT,
    @InterviewDateTime DATETIME,
    @RecruiterID INT
AS
BEGIN
    -- ��������, ��� �������� � �������� ����������
    IF NOT EXISTS (SELECT * FROM Candidates WHERE CandidateID = @CandidateID) OR
       NOT EXISTS (SELECT * FROM Vacancies WHERE VacancyID = @VacancyID)
    BEGIN
        RAISERROR('�������� ��� �������� �� ����������.', 16, 1)
        RETURN;
    END

    -- ��������, ��� �������� ����������
    IF NOT EXISTS (SELECT * FROM Recruiters WHERE RecruiterID = @RecruiterID)
    BEGIN
        RAISERROR('�������� �� ����������.', 16, 1)
        RETURN;
    END

	-- ������� ������ � ���������� �� �������� ��������� �� ��������
	INSERT INTO VacancyAnswers (VacancyID, CandidateID)
	VALUES (@VacancyID, @CandidateID);

	-- ��������� ���������� �������������� ����������� ������
	DECLARE @AnswerID INT;
	SET @AnswerID = SCOPE_IDENTITY();

	-- ������� ������ �� ��������
	INSERT INTO Interviews (DateTime, AnswerID, RecruiterID)
	VALUES (@InterviewDateTime, @AnswerID, @RecruiterID);


    PRINT '�������� ������� ���������.';
END;


-- DROP PROCEDURE IF EXISTS ScheduleInterview;


-- ����� ��������� ��� ���������� �������� ��� ��������� �� ���������� ��������
EXEC ScheduleInterview 
    @CandidateID = 1,               -- ID ���������
    @VacancyID = 1,                 -- ID ��������
    @InterviewDateTime = '2024-03-27 10:00:00',  -- ���� � ����� ��������
    @RecruiterID = 1;               -- ID ���������



-- ��������� ������ ��������
CREATE PROCEDURE RateInterview
    @InterviewID INT,
    @Criteria VARCHAR(100),
    @Score FLOAT,
    @Comments VARCHAR(100)
AS
BEGIN
    -- ��������, ���������� �� �������� � ��������� ID
    IF NOT EXISTS (SELECT * FROM Interviews WHERE InterviewID = @InterviewID)
    BEGIN
        RAISERROR('�������� � ��������� ID �� ����������.', 16, 1)
        RETURN;
    END

    -- ������� ������ � �������� ��������
    INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
    VALUES (@Criteria, @Score, @Comments, @InterviewID);
    
    -- ���������� ����������� ��������
    UPDATE Interviews
    SET Results = 1  -- ������������� ������������� ��������� (1 ��� ���� BIT)
    WHERE InterviewID = @InterviewID;

    PRINT '�������� ������� �������.';
END;


EXEC RateInterview 
    @InterviewID = 9,
    @Criteria = '����������� ������',
    @Score = 8.5,
    @Comments = '������� �������� ������ ����������������.';
