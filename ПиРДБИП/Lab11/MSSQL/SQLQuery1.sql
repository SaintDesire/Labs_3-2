DROP FUNCTION GetDataByDates

CREATE FUNCTION dbo.GetDataByDates(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
	FROM Vacancies
	WHERE 
        PublicationDate >= @StartDate AND PublicationDate <= @EndDate
)

SELECT *
FROM dbo.GetDataByDates('2021-01-01', '2024-12-31')

