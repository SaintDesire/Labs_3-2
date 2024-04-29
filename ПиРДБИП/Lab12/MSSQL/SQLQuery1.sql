--  1. �������� ������� Report, ���������� ��� ������� � id � XML-������� � ���� ������ SQL Server.
CREATE TABLE Report (
    id INT IDENTITY(1,1) PRIMARY KEY,
    xmlData XML
);




--  2. �������� ��������� ��������� XML. XML ������ �������� ������ �� ��� ������� 3 ����������� ������, 
--  ��������� ������������� ����� � ����� �������.
CREATE PROCEDURE GenerateXMLWithJoin
(
    @xmlResult XML OUTPUT -- �������� ��� �������� ����������
)
AS
BEGIN
    SET @xmlResult = (
        SELECT 
            (
                SELECT 
                    v.Title AS 'Title',
                    v.Requirements AS 'Requirements',
                    v.Conditions AS 'Conditions',
                    v.Salary AS 'Salary',
                    v.PublicationDate AS 'PublicationDate',
                    va.CandidateID AS 'CandidateID',
                    i.DateTime AS 'InterviewDateTime',
                    i.AnswerID AS 'AnswerID',
                    i.RecruiterID AS 'RecruiterID',
                    i.Results AS 'InterviewResults'
                FROM 
                    Vacancies v
                    INNER JOIN VacancyAnswers va ON v.VacancyID = va.VacancyID
                    INNER JOIN Interviews i ON v.VacancyID = va.AnswerID
                FOR XML PATH('Vacancy'), TYPE
            ),
            GETDATE() AS 'Timestamp'
        FOR XML PATH('Root')
    );
END;


-- DROP PROCEDURE GenerateXMLWithJoin


--  3. �������� ��������� ������� ����� XML � ������� Report.
CREATE PROCEDURE InsertXMLIntoReport
AS
BEGIN
    DECLARE @xml XML;
    ;

    -- �������� ��������������� XML
        EXEC GenerateXMLWithJoin @xml OUTPUT;

    -- ��������� XML � ������� Report
    INSERT INTO Report (xmlData) VALUES (@xml);
END;

-- DROP PROCEDURE InsertXMLIntoReport



--  4. �������� ������ ��� XML-�������� � ������� Report. 
CREATE PRIMARY XML INDEX idx_xmlData ON Report(xmlData);


SELECT 
    i.name AS IndexName,
    OBJECT_NAME(i.object_id) AS TableName,
    i.type_desc AS IndexType,
    c.name AS ColumnName
FROM 
    sys.indexes i
INNER JOIN 
    sys.index_columns ic ON i.index_id = ic.index_id AND i.object_id = ic.object_id
INNER JOIN 
    sys.columns c ON ic.column_id = c.column_id AND ic.object_id = c.object_id
WHERE 
    OBJECT_NAME(i.object_id) = 'Report';


--  5. �������� ��������� ���������� �������� ��������� �/��� ��������� �� XML -������� � ������� Report 
-- (�������� � �������� �������� ��� ��������).
CREATE PROCEDURE ExtractXMLValues
    @xpath NVARCHAR(MAX)
AS
BEGIN
    DECLARE @query NVARCHAR(MAX);

    -- ��������� ������ SELECT � �������������� @xpath ��� ���������� ��������
    SET @query = 'SELECT x.XmlColumn.value(''.'', ''nvarchar(max)'') AS ExtractedValue
                  FROM Report
                  CROSS APPLY xmlData.nodes(''' + @xpath + ''') AS x(XmlColumn)';

    -- ��������� ������
    EXEC sp_executesql @query;
END;


-- DROP PROCEDURE ExtractXMLValues





EXEC GenerateXMLWithJoin;

EXEC InsertXMLIntoReport;

select * from Report;

EXEC ExtractXMLValues '/Root/Vacancy/Title';
