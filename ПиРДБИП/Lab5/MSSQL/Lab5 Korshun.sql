-- ���������� ������ ������ HR ���������, �� �������, �� �������, �� ���.
SELECT 
    YEAR(DateTime) AS Year,
    MONTH(DateTime) AS Month,
    Recruiters.FullName AS RecruiterName,
    COUNT(InterviewID) AS InterviewsCount,
    CASE 
        WHEN MONTH(DateTime) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(DateTime) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(DateTime) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(DateTime) BETWEEN 10 AND 12 THEN 'Q4'
    END AS Quarter,
    CASE 
        WHEN MONTH(DateTime) BETWEEN 1 AND 6 THEN 'H1'
        WHEN MONTH(DateTime) BETWEEN 7 AND 12 THEN 'H2'
    END AS HalfYear
FROM 
    Interviews
INNER JOIN 
    Recruiters ON Interviews.RecruiterID = Recruiters.RecruiterID
WHERE 
    (YEAR(DateTime) = YEAR(GETDATE()) AND MONTH(DateTime) BETWEEN 1 AND MONTH(GETDATE())) OR
    (YEAR(DateTime) = YEAR(GETDATE()) AND MONTH(DateTime) BETWEEN 1 AND 6) OR
    (YEAR(DateTime) <= YEAR(GETDATE()))
GROUP BY 
    YEAR(DateTime),
    MONTH(DateTime),
    Recruiters.FullName,
    CASE 
        WHEN MONTH(DateTime) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(DateTime) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(DateTime) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(DateTime) BETWEEN 10 AND 12 THEN 'Q4'
    END,
    CASE 
        WHEN MONTH(DateTime) BETWEEN 1 AND 6 THEN 'H1'
        WHEN MONTH(DateTime) BETWEEN 7 AND 12 THEN 'H2'
    END
ORDER BY 
    Year,
    Month;









-- ���������� ������ ������ HR �� ������������ ������:
--	���������� ������� �����������;
--	��������� � ����� ����������� ������� ����������� (� %);
--	��������� � ���������� ����������� ����������� (� %).


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




-- ����������������� ���������� ������� ������������ ROW_NUMBER() ��� ��������� ����������� 
-- ������� �� �������� (�� 20 ����� �� ������ ��������).

-- ������ ����� �������� � ������ ��������
DECLARE @PageNumber INT = 2; -- ����� ��������
DECLARE @PageSize INT = 20; -- ������ ��������

-- ��������� ������� ��� ��������
DECLARE @StartRow INT = (@PageNumber - 1) * @PageSize + 1;
DECLARE @EndRow INT = @StartRow + @PageSize - 1;

-- ������ � �������� ������������
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


-- ����������������� ���������� ������� ������������ ROW_NUMBER() ��� �������� ����������.
WITH RankedVacancies AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Title, Requirements, Conditions, Salary ORDER BY VacancyID) AS RowNum
    FROM
        Vacancies
)
DELETE FROM RankedVacancies WHERE RowNum > 1;


-- ������� ��� ������� ������������ ���� ���������� �������� ����������� �� ��������� 6 ������� ���������
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


-- ����� ������������ ���������� ������ ���� ������������� ��� 
-- ��������� ��������� � ������������ ������? ������� ��� ���� �������.
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
