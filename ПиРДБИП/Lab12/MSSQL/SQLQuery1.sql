--  1. Создайте таблицу Report, содержащую два столбца – id и XML-столбец в базе данных SQL Server.
CREATE TABLE Report (
    id INT IDENTITY(1,1) PRIMARY KEY,
    xmlData XML
);




--  2. Создайте процедуру генерации XML. XML должен включать данные из как минимум 3 соединенных таблиц, 
--  различные промежуточные итоги и штамп времени.
CREATE PROCEDURE GenerateXMLWithJoin
(
    @xmlResult XML OUTPUT -- параметр для возврата результата
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


--  3. Создайте процедуру вставки этого XML в таблицу Report.
CREATE PROCEDURE InsertXMLIntoReport
AS
BEGIN
    DECLARE @xml XML;
    ;

    -- Получаем сгенерированный XML
        EXEC GenerateXMLWithJoin @xml OUTPUT;

    -- Вставляем XML в таблицу Report
    INSERT INTO Report (xmlData) VALUES (@xml);
END;

-- DROP PROCEDURE InsertXMLIntoReport



--  4. Создайте индекс над XML-столбцом в таблице Report. 
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


--  5. Создайте процедуру извлечения значений элементов и/или атрибутов из XML -столбца в таблице Report 
-- (параметр – значение атрибута или элемента).
CREATE PROCEDURE ExtractXMLValues
    @xpath NVARCHAR(MAX)
AS
BEGIN
    DECLARE @query NVARCHAR(MAX);

    -- Формируем запрос SELECT с использованием @xpath для извлечения значений
    SET @query = 'SELECT x.XmlColumn.value(''.'', ''nvarchar(max)'') AS ExtractedValue
                  FROM Report
                  CROSS APPLY xmlData.nodes(''' + @xpath + ''') AS x(XmlColumn)';

    -- Выполняем запрос
    EXEC sp_executesql @query;
END;


-- DROP PROCEDURE ExtractXMLValues





EXEC GenerateXMLWithJoin;

EXEC InsertXMLIntoReport;

select * from Report;

EXEC ExtractXMLValues '/Root/Vacancy/Title';
