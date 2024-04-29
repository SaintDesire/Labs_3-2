--  1. Создайте таблицу Report, содержащую два столбца – id и XML-столбец в базе данных SQL Server.
CREATE TABLE Report (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    xmlData CLOB
);


SET SERVEROUTPUT ON;

--  2. Создайте процедуру генерации XML. XML должен включать данные из как минимум 3 соединенных таблиц, 
--  различные промежуточные итоги и штамп времени.
CREATE OR REPLACE PROCEDURE GenerateXMLWithJoin
(
    xmlResult OUT XMLTYPE -- параметр для возврата результата
)
AS
BEGIN
    SELECT XMLElement(
                "Root",
                XMLAgg(
                    XMLElement(
                        "Vacancy",
                        XMLForest(
                            v.Title AS "Title",
                            v.Requirements AS "Requirements",
                            v.Conditions AS "Conditions",
                            v.Salary AS "Salary",
                            v.PublicationDate AS "PublicationDate",
                            va.CandidateID AS "CandidateID",
                            i.DateTime AS "InterviewDateTime",
                            i.AnswerID AS "AnswerID",
                            i.RecruiterID AS "RecruiterID",
                            i.Results AS "InterviewResults"
                        )
                    )
                ),
                XMLElement("Timestamp", SYSTIMESTAMP)
            )
    INTO xmlResult
    FROM Vacancies v
    INNER JOIN VacancyAnswers va ON v.VacancyID = va.VacancyID
    INNER JOIN Interviews i ON v.VacancyID = va.AnswerID;

END;
/



--  3. Создайте процедуру вставки этого XML в таблицу Report.
CREATE OR REPLACE PROCEDURE InsertXMLIntoReport AS
    xml CLOB;
BEGIN
    -- Получаем сгенерированный XML
    DECLARE
        xmlResult XMLTYPE;
    BEGIN
        GenerateXMLWithJoin(xmlResult);
        xml := xmlResult.getClobVal();
    END;

    -- Вставляем XML в таблицу Report
    INSERT INTO Report (xmlData) VALUES (xml);
END;
/




--  4. Создайте индекс над XML-столбцом в таблице Report. 
CREATE INDEX idx_xmlData ON Report(xmlData) INDEXTYPE IS CTXSYS.CONTEXT;


SELECT index_name, table_name, column_name
FROM all_ind_columns
WHERE table_name = 'REPORT';


--  5. Создайте процедуру извлечения значений элементов и/или атрибутов из XML -столбца в таблице Report 
-- (параметр – значение атрибута или элемента).
CREATE OR REPLACE PROCEDURE ExtractXMLValue (
    pPath VARCHAR2, -- путь к элементу или атрибуту для извлечения
    pResult OUT VARCHAR2 -- параметр для возвращаемого значения
)
AS
    v_xml CLOB;
    v_xmltype XMLTYPE;
BEGIN
    -- Получаем XML из столбца xmlData в таблице Report
    SELECT xmlData INTO v_xml
    FROM Report
    WHERE ROWNUM = 1; -- Просто получаем одну строку из таблицы

    -- Создаем XMLTYPE из CLOB
    v_xmltype := XMLTYPE.createXML(v_xml);

    -- Извлекаем значение элемента или атрибута по заданному пути
    pResult := v_xmltype.extract(pPath || '/text()').getStringVal();
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            pResult := 'No data found';
        WHEN OTHERS THEN
            pResult := 'Error: ' || SQLERRM;
END;
/






-- **************************************

DECLARE
    xmlResult XMLTYPE;
BEGIN
    GenerateXMLWithJoin(xmlResult);
    DBMS_OUTPUT.PUT_LINE(xmlResult.getClobVal());
END;
/

-- **************************************


BEGIN
    InsertXMLIntoReport;
    COMMIT;
END;
/

select * from Report;

-- **************************************

DECLARE
    v_Result VARCHAR2(4000);
BEGIN
    ExtractXMLValue('/Root/Vacancy/Title', v_Result);
    DBMS_OUTPUT.PUT_LINE('Extracted value: ' || v_Result);
END;
/





