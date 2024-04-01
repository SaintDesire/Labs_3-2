-- ��������� �������� ������ ���������
CREATE OR REPLACE PROCEDURE CreateCandidate(
    FullName IN NVARCHAR2,
    ContactInfo IN NVARCHAR2,
    Education IN NVARCHAR2,
    WorkExperience IN NVARCHAR2,
    Skills IN NVARCHAR2,
    RegistrationDate IN DATE
)
AS
BEGIN
    INSERT INTO Candidates (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate)
    VALUES (FullName, ContactInfo, Education, WorkExperience, Skills, RegistrationDate);
END CreateCandidate;
/


CREATE OR REPLACE FUNCTION GetCandidateInfo(
    CandidateID IN INT
)
RETURN Candidates%ROWTYPE
IS
    candidate_info Candidates%ROWTYPE;
BEGIN
    SELECT *
    INTO candidate_info
    FROM Candidates
    WHERE CandidateID = GetCandidateInfo.CandidateID;
    
    RETURN candidate_info;
END GetCandidateInfo;
/




-- ��������� ���������� ������ ���������
CREATE OR REPLACE PROCEDURE UpdateCandidate(
    CandidateID IN INT,
    FullName IN NVARCHAR2,
    ContactInfo IN NVARCHAR2,
    Education IN NVARCHAR2,
    WorkExperience IN NVARCHAR2,
    Skills IN NVARCHAR2,
    RegistrationDate IN DATE
)
AS
BEGIN
    UPDATE Candidates
    SET FullName = FullName,
        ContactInfo = ContactInfo,
        Education = Education,
        WorkExperience = WorkExperience,
        Skills = Skills,
        RegistrationDate = RegistrationDate
    WHERE CandidateID = CandidateID;
END UpdateCandidate;
/



-- ��������� �������� ���������
CREATE OR REPLACE PROCEDURE DeleteCandidate(
    CandidateID IN INT
)
AS
BEGIN
    DELETE FROM Candidates
    WHERE CandidateID = CandidateID;
END DeleteCandidate;
/



-- ��������� ���������� ���������� � ����������
CREATE OR REPLACE PROCEDURE UpdateEmployee(
    EmployeeID IN INT,
    FullName IN NVARCHAR2,
    Position IN NVARCHAR2,
    HireDate IN DATE,
    Salary IN DECIMAL,
    DepartmentID IN INT,
    CandidateID IN INT,
    RecruiterID IN INT
)
AS
BEGIN
    UPDATE Employees
    SET FullName = FullName,
        Position = Position,
        HireDate = HireDate,
        Salary = Salary,
        DepartmentID = DepartmentID,
        CandidateID = CandidateID,
        RecruiterID = RecruiterID
    WHERE EmployeeID = EmployeeID;
END UpdateEmployee;
/



-- ��������� �������� ����������
CREATE OR REPLACE PROCEDURE DeleteEmployee(
    EmployeeID IN INT
)
AS
BEGIN
    DELETE FROM Employees
    WHERE EmployeeID = EmployeeID;
END DeleteEmployee;
/



-- ��������� ���������� ��������
CREATE OR REPLACE PROCEDURE ScheduleInterview(
    CandidateID IN INT,
    VacancyID IN INT,
    InterviewDateTime IN DATE,
    RecruiterID IN INT
)
AS
BEGIN
    -- ��������, ��� �������� � �������� ����������
    IF NOT EXISTS (SELECT * FROM Candidates WHERE CandidateID = CandidateID) OR
       NOT EXISTS (SELECT * FROM Vacancies WHERE VacancyID = VacancyID)
    THEN
        RAISE_APPLICATION_ERROR(-20001, '�������� ��� �������� �� ����������.');
    END IF;

    -- ��������, ��� �������� ����������
    IF NOT EXISTS (SELECT * FROM Recruiters WHERE RecruiterID = RecruiterID)
    THEN
        RAISE_APPLICATION_ERROR(-20001, '�������� �� ����������.');
    END IF;

    -- ������� ������ � ���������� �� �������� ��������� �� ��������
    INSERT INTO VacancyAnswers (VacancyID, CandidateID)
    VALUES (VacancyID, CandidateID);

    -- ��������� ���������� �������������� ����������� ������
    DECLARE AnswerID INT;
    AnswerID := VacancyAnswers_SEQ.currval;

    -- ������� ������ �� ��������
    INSERT INTO Interviews (DateTime, AnswerID, RecruiterID)
    VALUES (InterviewDateTime, AnswerID, RecruiterID);

    DBMS_OUTPUT.PUT_LINE('�������� ������� ���������.');
END ScheduleInterview;
/


-- ��������� ������ ��������
CREATE OR REPLACE PROCEDURE RateInterview(
    InterviewID IN INT,
    Criteria IN VARCHAR2,
    Score IN FLOAT,
    Comments IN VARCHAR2
)
AS
    interview_exists INT;
BEGIN
    -- ��������, ���������� �� �������� � ��������� ID
    SELECT COUNT(*)
    INTO interview_exists
    FROM Interviews
    WHERE InterviewID = InterviewID;

    IF interview_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '�������� � ��������� ID �� ����������.');
    END IF;

    -- ������� ������ � �������� ��������
    INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
    VALUES (Criteria, Score, Comments, InterviewID);
    
    -- ���������� ����������� ��������
    UPDATE Interviews
    SET Results = 1  -- ������������� ������������� ��������� (1 ��� ���� BIT)
    WHERE InterviewID = InterviewID;

    DBMS_OUTPUT.PUT_LINE('�������� ������� �������.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
END RateInterview;
/




-- ##########################################################

SET SERVEROUTPUT ON;


-- ����� ��������� �������� ������ ���������
BEGIN
    CreateCandidate('����� ��������', 'email@example.com', '������', '3 ����', 'Java, SQL', TO_DATE('2024-03-15', 'YYYY-MM-DD'));
END;
/
select * from candidates;


-- ����� ������� ��������� ���������� � ��������� �� ��� ID
DECLARE
    candidate_info_row Candidates%ROWTYPE;
BEGIN
    candidate_info_row := GetCandidateInfo(1); -- �������� ID ��������� ��� ��������� ����������

    DBMS_OUTPUT.PUT_LINE('��� ���������: ' || candidate_info_row.FullName);
    DBMS_OUTPUT.PUT_LINE('���������� ����������: ' || candidate_info_row.ContactInfo);
END;
/


-- ����� ��������� ���������� ������ ���������
BEGIN
    UpdateCandidate(5, '����������� ��������', 'updated_email@example.com', '������', '5 ���', 'Java, SQL, Python', TO_DATE('2024-03-16', 'YYYY-MM-DD'));
END;
/

-- ����� ��������� �������� ���������
BEGIN
    DeleteCandidate(5);
END;
/

-- ����� ��������� ���������� ���������� � ����������
BEGIN
    UpdateEmployee(4, '����������� ���������', 'QA Engineer', TO_DATE('2024-03-16', 'YYYY-MM-DD'), 95000, 4, 2, 1);
END;
/

-- ����� ��������� �������� ����������
BEGIN
    DeleteEmployee(4);
END;
/

-- ����� ��������� ���������� ��������
BEGIN
    ScheduleInterview(1, 1, TO_DATE('2024-03-27 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1);
END;
/

-- ����� ��������� ������ ��������
BEGIN
    RateInterview(9, '����������� ������', 8.5, '������� �������� ������ ����������������.');
END;
/

