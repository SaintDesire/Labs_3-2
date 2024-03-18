use HiringStaff;

-- Процедура создания нового кандидата
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



-- Функция получения информации о кандидате по его ID
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



-- Процедура обновления данных кандидата
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



-- Процедура удаления кандидата
CREATE PROCEDURE DeleteCandidate
    @CandidateID INT
AS
BEGIN
    DELETE FROM Candidates
    WHERE CandidateID = @CandidateID;
END;



-- Процедура обновления информации о сотруднике
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



-- Процедура удаления сотрудника
CREATE PROCEDURE DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    DELETE FROM Employees
    WHERE EmployeeID = @EmployeeID;
END;




-- ==============================================================

SELECT * FROM Candidates;

-- Добавление кандидата
EXEC CreateCandidate 'Новый Кандидат', 'email@example.com', 'Высшее', '3 года', 'Java, SQL', '2024-03-15';

-- Получение данных кандидата
SELECT * FROM GetCandidateInfo(1);

-- Обновление кандидата
EXEC UpdateCandidate 5, 'Обновленный Кандидат', 'updated_email@example.com', 'Высшее', '5 лет', 'Java, SQL, Python', '2024-03-16';

-- Удаление кандидата
EXEC DeleteCandidate 5;



SELECT * FROM Employees;

-- Обновление сотрудника
EXEC UpdateEmployee 4, 'Обновленный Сотрудник', 'QA Engineer', '2024-03-16', 95000, 4, 2, 1;

-- Удаление сотрудника
EXEC DeleteEmployee 4;



-- =========================== Бизнес функции ===========================

-- Назначение интервью
CREATE PROCEDURE ScheduleInterview
    @CandidateID INT,
    @VacancyID INT,
    @InterviewDateTime DATETIME,
    @RecruiterID INT
AS
BEGIN
    -- Проверка, что кандидат и вакансия существуют
    IF NOT EXISTS (SELECT * FROM Candidates WHERE CandidateID = @CandidateID) OR
       NOT EXISTS (SELECT * FROM Vacancies WHERE VacancyID = @VacancyID)
    BEGIN
        RAISERROR('Кандидат или вакансия не существуют.', 16, 1)
        RETURN;
    END

    -- Проверка, что рекрутер существует
    IF NOT EXISTS (SELECT * FROM Recruiters WHERE RecruiterID = @RecruiterID)
    BEGIN
        RAISERROR('Рекрутер не существует.', 16, 1)
        RETURN;
    END

	-- Вставка записи о назначении на интервью кандидата на вакансию
	INSERT INTO VacancyAnswers (VacancyID, CandidateID)
	VALUES (@VacancyID, @CandidateID);

	-- Получение последнего идентификатора вставленной записи
	DECLARE @AnswerID INT;
	SET @AnswerID = SCOPE_IDENTITY();

	-- Вставка записи об интервью
	INSERT INTO Interviews (DateTime, AnswerID, RecruiterID)
	VALUES (@InterviewDateTime, @AnswerID, @RecruiterID);


    PRINT 'Интервью успешно назначено.';
END;


-- DROP PROCEDURE IF EXISTS ScheduleInterview;


-- Вызов процедуры для назначения интервью для кандидата на конкретную вакансию
EXEC ScheduleInterview 
    @CandidateID = 1,               -- ID кандидата
    @VacancyID = 1,                 -- ID вакансии
    @InterviewDateTime = '2024-03-27 10:00:00',  -- Дата и время интервью
    @RecruiterID = 1;               -- ID рекрутера



-- Процедура оценки интервью
CREATE PROCEDURE RateInterview
    @InterviewID INT,
    @Criteria VARCHAR(100),
    @Score FLOAT,
    @Comments VARCHAR(100)
AS
BEGIN
    -- Проверка, существует ли интервью с указанным ID
    IF NOT EXISTS (SELECT * FROM Interviews WHERE InterviewID = @InterviewID)
    BEGIN
        RAISERROR('Интервью с указанным ID не существует.', 16, 1)
        RETURN;
    END

    -- Вставка записи о рейтинге интервью
    INSERT INTO Ratings (Criteria, Score, Comments, InterviewID)
    VALUES (@Criteria, @Score, @Comments, @InterviewID);
    
    -- Обновление результатов интервью
    UPDATE Interviews
    SET Results = 1  -- Устанавливаем положительный результат (1 для типа BIT)
    WHERE InterviewID = @InterviewID;

    PRINT 'Интервью успешно оценено.';
END;


EXEC RateInterview 
    @InterviewID = 9,
    @Criteria = 'Технические навыки',
    @Score = 8.5,
    @Comments = 'Хорошее владение языком программирования.';
