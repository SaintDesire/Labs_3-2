-- ¬ычисление итогов работы HR помес€чно, за квартал, за полгода, за год.
SELECT 
    Year,
    Month,
    RecruiterName,
    InterviewsCount,
    Quarter,
    HalfYear,
    SUM(InterviewsCount) OVER(PARTITION BY Year, Quarter) AS QuarterTotal,
    SUM(InterviewsCount) OVER(PARTITION BY Year, HalfYear) AS HalfYearTotal
FROM (
    SELECT 
        EXTRACT(YEAR FROM DateTime) AS Year,
        EXTRACT(MONTH FROM DateTime) AS Month,
        Recruiters.FullName AS RecruiterName,
        COUNT(InterviewID) AS InterviewsCount,
        CASE 
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 7 AND 9 THEN 'Q3'
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 10 AND 12 THEN 'Q4'
        END AS Quarter,
        CASE 
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 1 AND 6 THEN 'H1'
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 7 AND 12 THEN 'H2'
        END AS HalfYear
    FROM 
        Interviews
    INNER JOIN 
        Recruiters ON Interviews.RecruiterID = Recruiters.RecruiterID
    WHERE 
        (EXTRACT(YEAR FROM DateTime) = EXTRACT(YEAR FROM SYSDATE) AND EXTRACT(MONTH FROM DateTime) BETWEEN 1 AND EXTRACT(MONTH FROM SYSDATE)) OR
        (EXTRACT(YEAR FROM DateTime) = EXTRACT(YEAR FROM SYSDATE) AND EXTRACT(MONTH FROM DateTime) BETWEEN 1 AND 6) OR
        (EXTRACT(YEAR FROM DateTime) <= EXTRACT(YEAR FROM SYSDATE))
    GROUP BY 
        EXTRACT(YEAR FROM DateTime),
        EXTRACT(MONTH FROM DateTime),
        Recruiters.FullName,
        CASE 
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 7 AND 9 THEN 'Q3'
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 10 AND 12 THEN 'Q4'
        END,
        CASE 
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 1 AND 6 THEN 'H1'
            WHEN EXTRACT(MONTH FROM DateTime) BETWEEN 7 AND 12 THEN 'H2'
        END
) SubQuery
ORDER BY 
    Year,
    Month;






--  ¬ычисление итогов работы HR за определенный период:
--  Х	количество нан€тых сотрудников;
--  Х	сравнение с общим количеством нан€тых сотрудников (в %);
--  Х	сравнение с количество отвергнутых сотрудников (в %).
SET SERVEROUTPUT ON;

DECLARE
    StartDate DATE := TO_DATE('2024-03-22', 'YYYY-MM-DD');
    EndDate DATE := TO_DATE('2024-03-24', 'YYYY-MM-DD');
    HiredEmployeesCount NUMBER;
    TotalHiredEmployees NUMBER;
    RejectedEmployeesCount NUMBER;
BEGIN
    SELECT
        COUNT(DISTINCT VacancyAnswers.CandidateID),
        COUNT(DISTINCT CASE WHEN Interviews.Results = 0 THEN VacancyAnswers.CandidateID END)
    INTO
        HiredEmployeesCount,
        RejectedEmployeesCount
    FROM
        Interviews
    INNER JOIN
        VacancyAnswers ON Interviews.AnswerID = VacancyAnswers.AnswerID
    WHERE
        Interviews.DateTime BETWEEN StartDate AND EndDate;

    SELECT COUNT(DISTINCT CandidateID) INTO TotalHiredEmployees FROM VacancyAnswers;

    DBMS_OUTPUT.PUT_LINE('HiredEmployeesCount: ' || HiredEmployeesCount);
    DBMS_OUTPUT.PUT_LINE('TotalHiredEmployees: ' || TotalHiredEmployees);
    DBMS_OUTPUT.PUT_LINE('RejectedEmployeesCount: ' || RejectedEmployeesCount);
    DBMS_OUTPUT.PUT_LINE('HiredPercentage: ' || (HiredEmployeesCount * 100.0 / NULLIF(TotalHiredEmployees, 0)));
    DBMS_OUTPUT.PUT_LINE('RejectedPercentage: ' || (RejectedEmployeesCount * 100.0 / NULLIF(HiredEmployeesCount, 0)));
END;









-- ¬ернуть дл€ каждого юридического лица количество прин€тых сотрудников за последние 6 мес€цев помес€чно
SELECT
    Recruiters.FullName AS RecruiterName,
    EXTRACT(YEAR FROM Interviews.DateTime) AS "Year",
    EXTRACT(MONTH FROM Interviews.DateTime) AS "Month",
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
    Interviews.DateTime >= ADD_MONTHS(SYSDATE, -6)
GROUP BY
    Recruiters.FullName,
    EXTRACT(YEAR FROM Interviews.DateTime),
    EXTRACT(MONTH FROM Interviews.DateTime)
ORDER BY
    RecruiterName,
    "Year",
    "Month";










--  акой максимальное количество резюме было предоставлено дл€ 
-- получени€ должности в определенном отделе? ¬ернуть дл€ всех отделов.
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
            D.DepartmentName
    ) Subquery
GROUP BY
    DepartmentName;



