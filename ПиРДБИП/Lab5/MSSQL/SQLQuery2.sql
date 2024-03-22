-- Вычисление итогов работы HR помесячно, за квартал, за полгода, за год.
SELECT
    Recruiters.RecruiterID,
    Recruiters.FullName,
    YEAR(Interviews.DateTime) AS [Year],
    MONTH(Interviews.DateTime) AS [Month],
    COUNT(*) AS [TotalInterviews],
    DATEPART(QUARTER, Interviews.DateTime) AS [Quarter],
    CASE 
        WHEN MONTH(Interviews.DateTime) <= 6 THEN 1
        ELSE 2
    END AS [HalfYear]
FROM
    Recruiters
INNER JOIN
    Interviews ON Recruiters.RecruiterID = Interviews.RecruiterID
GROUP BY
    Recruiters.RecruiterID,
    Recruiters.FullName,
    YEAR(Interviews.DateTime),
    MONTH(Interviews.DateTime),
    DATEPART(QUARTER, Interviews.DateTime),
    CASE 
        WHEN MONTH(Interviews.DateTime) <= 6 THEN 1
        ELSE 2
    END
ORDER BY
    Recruiters.RecruiterID,
    [Year],
    [Month];


-- Вычисление итогов работы HR за определенный период:
--	количество нанятых сотрудников;
--	сравнение с общим количеством нанятых сотрудников (в %);
--	сравнение с количество отвергнутых сотрудников (в %).


DECLARE @StartDate DATE = '2024-03-22';
DECLARE @EndDate DATE = '2024-03-24';

WITH HRPerformance AS (
    SELECT
        COUNT(DISTINCT VacancyAnswers.CandidateID) AS HiredEmployeesCount,
        (SELECT COUNT(DISTINCT CandidateID) FROM VacancyAnswers) AS TotalHiredEmployees,
        COUNT(DISTINCT CASE WHEN Interviews.Results = 0 THEN VacancyAnswers.CandidateID END) AS RejectedEmployeesCount
    FROM
        Interviews
    INNER JOIN
        VacancyAnswers ON Interviews.AnswerID = VacancyAnswers.AnswerID
    WHERE
        Interviews.DateTime BETWEEN @StartDate AND @EndDate
)
SELECT
    HiredEmployeesCount,
    TotalHiredEmployees,
    RejectedEmployeesCount,
    HiredEmployeesCount * 100.0 / NULLIF(TotalHiredEmployees, 0) AS HiredPercentage,
    RejectedEmployeesCount * 100.0 / NULLIF(HiredEmployeesCount, 0) AS RejectedPercentage
FROM
    HRPerformance;




-- Продемонстрируйте применение функции ранжирования ROW_NUMBER() для разбиения результатов 
-- запроса на страницы (по 20 строк на каждую страницу).

-- Задаем номер страницы и размер страницы
DECLARE @PageNumber INT = 1; -- Номер страницы
DECLARE @PageSize INT = 20; -- Размер страницы

-- Вычисляем границы для страницы
DECLARE @StartRow INT = (@PageNumber - 1) * @PageSize + 1;
DECLARE @EndRow INT = @StartRow + @PageSize - 1;

-- Запрос с функцией ранжирования
WITH RankedVacancies AS (
    SELECT	
        *,
        ROW_NUMBER() OVER (ORDER BY VacancyID) AS RowNum
    FROM
        Vacancies
)
SELECT
    *
FROM
    RankedVacancies
WHERE
    RowNum BETWEEN @StartRow AND @EndRow;


-- Продемонстрируйте применение функции ранжирования ROW_NUMBER() для удаления дубликатов.
WITH RankedVacancies AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Title, Requirements, Conditions, Salary ORDER BY VacancyID) AS RowNum
    FROM
        Vacancies
)
DELETE FROM RankedVacancies WHERE RowNum > 1;


-- Вернуть для каждого юридического лица количество принятых сотрудников за последние 6 месяцев помесячно
SELECT
    Recruiters.FullName AS RecruiterName,
    YEAR(Interviews.DateTime) AS [Year],
    MONTH(Interviews.DateTime) AS [Month],
    COUNT(DISTINCT Employees.EmployeeID) AS HiredEmployeesCount
FROM
    Recruiters
INNER JOIN
    Interviews ON Recruiters.RecruiterID = Interviews.RecruiterID
INNER JOIN
    VacancyAnswers ON Interviews.AnswerID = VacancyAnswers.AnswerID
INNER JOIN
    Employees ON VacancyAnswers.CandidateID = Employees.CandidateID
WHERE
    Interviews.DateTime >= DATEADD(MONTH, -6, GETDATE())
GROUP BY
    Recruiters.FullName,
    YEAR(Interviews.DateTime),
    MONTH(Interviews.DateTime)
ORDER BY
    RecruiterName,
    [Year],
    [Month];


-- Какой максимальное количество резюме было предоставлено для 
-- получения должности в определенном отделе? Вернуть для всех отделов.
SELECT
    DepartmentName,
    MAX(ResumesCount) AS MaxResumesCount
FROM
    (
        SELECT
            D.DepartmentName,
            COUNT(*) AS ResumesCount
        FROM
            Departments D
        INNER JOIN
            Employees E ON D.DepartmentID = E.DepartmentID
        GROUP BY
            D.DepartmentName, E.Position
    ) AS Subquery
GROUP BY
    DepartmentName;
