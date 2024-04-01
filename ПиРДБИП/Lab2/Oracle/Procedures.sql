-- Процедура создания нового кандидата
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




-- Процедура обновления данных кандидата
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



-- Процедура удаления кандидата
CREATE OR REPLACE PROCEDURE DeleteCandidate(
    CandidateID IN INT
)
AS
BEGIN
    DELETE FROM Candidates
    WHERE CandidateID = CandidateID;
END DeleteCandidate;
/



-- Процедура обновления информации о сотруднике
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



-- Процедура удаления сотрудника
CREATE OR REPLACE PROCEDURE DeleteEmployee(
    EmployeeID IN INT
)
AS
BEGIN
    DELETE FROM Employees
    WHERE EmployeeID = EmployeeID;
END DeleteEmployee;
/



-- Процедура назначения интервью
CREATE OR REPLACE PROCEDURE ScheduleInterview(
    CandidateID IN INT,
    VacancyID IN INT,
    InterviewDateTime IN DATE,
    RecruiterID IN INT
)
AS
BEGIN
    -- Проверка, что кандидат и вакансия существуют
    IF NOT EXISTS (SELECT * FROM Candidates WHERE CandidateID = CandidateID) OR
       NOT EXISTS (SELECT * FROM Vacancies WHERE VacancyID = VacancyID)
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Кандидат или вакансия не существуют.');
    END IF;

    -- Проверка, что рекрутер существует
    IF NOT EXISTS (SELECT * FROM Recruiters WHERE RecruiterID = RecruiterID)
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Рекрутер не существует.');
    END IF;

    -- Вставка записи о назначении на интервью кандидата на вакансию
    INSERT INTO VacancyAnswers (VacancyID, CandidateID)
    VALUES (VacancyID, CandidateID);

    -- Получение последнего идентификатора вставленной записи
    DECLARE AnswerID INT;
    AnswerID := VacancyAnswers_SEQ.currval;

    -- Вставка записи об интервью
    INSERT INTO Interviews (DateTime, AnswerID, RecruiterID)
    VALUES (InterviewDateTime, AnswerID, RecruiterID);

    DBMS_OUTPUT.PUT_LINE('Интервью успешно назначено.');
END ScheduleInterview;
/


-- Процедура оценки интервью
CREATE OR REPLACE PROCEDURE RateInterview(
    InterviewID IN INT,
    Criteria IN VARCHAR2,
    Score IN FLOAT,
    Comments IN VARCHAR2
)
AS
    interview_exists INT;
BEGIN
    -- Проверка, существует ли интервью с указанным ID
    SELECT COUNT(*)
    INTO interview_exists
    FROM Interviews
    WHERE InterviewID = InterviewID;

    IF interview_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Интервью с указанным ID не существует.');
    END IF;

    -- Вставка записи о рейтинге интервью
    INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
    VALUES (Criteria, Score, Comments, InterviewID);
    
    -- Обновление результатов интервью
    UPDATE Interviews
    SET Results = 1  -- Устанавливаем положительный результат (1 для типа BIT)
    WHERE InterviewID = InterviewID;

    DBMS_OUTPUT.PUT_LINE('Интервью успешно оценено.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END RateInterview;
/




-- ##########################################################

SET SERVEROUTPUT ON;


-- Вызов процедуры создания нового кандидата
BEGIN
    CreateCandidate('Новый Кандидат', 'email@example.com', 'Высшее', '3 года', 'Java, SQL', TO_DATE('2024-03-15', 'YYYY-MM-DD'));
END;
/
select * from candidates;


-- Вызов функции получения информации о кандидате по его ID
DECLARE
    candidate_info_row Candidates%ROWTYPE;
BEGIN
    candidate_info_row := GetCandidateInfo(1); -- Передаем ID кандидата для получения информации

    DBMS_OUTPUT.PUT_LINE('Имя кандидата: ' || candidate_info_row.FullName);
    DBMS_OUTPUT.PUT_LINE('Контактная информация: ' || candidate_info_row.ContactInfo);
END;
/


-- Вызов процедуры обновления данных кандидата
BEGIN
    UpdateCandidate(5, 'Обновленный Кандидат', 'updated_email@example.com', 'Высшее', '5 лет', 'Java, SQL, Python', TO_DATE('2024-03-16', 'YYYY-MM-DD'));
END;
/

-- Вызов процедуры удаления кандидата
BEGIN
    DeleteCandidate(5);
END;
/

-- Вызов процедуры обновления информации о сотруднике
BEGIN
    UpdateEmployee(4, 'Обновленный Сотрудник', 'QA Engineer', TO_DATE('2024-03-16', 'YYYY-MM-DD'), 95000, 4, 2, 1);
END;
/

-- Вызов процедуры удаления сотрудника
BEGIN
    DeleteEmployee(4);
END;
/

-- Вызов процедуры назначения интервью
BEGIN
    ScheduleInterview(1, 1, TO_DATE('2024-03-27 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1);
END;
/

-- Вызов процедуры оценки интервью
BEGIN
    RateInterview(9, 'Технические навыки', 8.5, 'Хорошее владение языком программирования.');
END;
/

