CREATE FUNCTION GetEmployeesData(@StartDate DATE, @EndDate DATE)
RETURNS TABLE
AS
RETURN 
(
    SELECT *
    FROM Employees
    WHERE HireDate BETWEEN @StartDate AND @EndDate
);


-- Выборка данных о сотрудниках за определенный период
SELECT *
FROM GetEmployeesData('2023-01-01', '2024-12-31');

SELECT 
    EmployeeID, 
    FullName, 
    Position, 
    CONVERT(NVARCHAR(MAX), HireDate, 120) AS HireDate, 
    CONVERT(NVARCHAR(MAX), Salary) AS Salary, 
    DepartmentID, 
    CandidateID, 
    RecruiterID
FROM GetEmployeesData('2023-01-01', '2024-12-31');


SELECT *
FROM GetEmployeesData('2023-01-01', '2024-12-31')
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER

DECLARE @sql VARCHAR(1000);
SET @sql = 'bcp "SELECT * FROM (' +
           'SELECT * FROM dbo.GetEmployeesData(''2023-01-01'', ''2024-12-31'')' +
           ') AS subquery FOR JSON PATH, WITHOUT_ARRAY_WRAPPER" ' +
           'queryout "C:\Users\p1v0var\Desktop\labs_3-2\ПиРДБИП\Lab11\MSSQL\export.json" -c -S MACWIN2 -d WideWorldImporters -T';
EXEC xp_cmdshell @sql;
GO

