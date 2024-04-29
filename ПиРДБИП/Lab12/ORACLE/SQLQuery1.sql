--  1. �������� ������� Report, ���������� ��� ������� � id � XML-������� � ���� ������ SQL Server.
CREATE TABLE Report (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    xmlData CLOB
);


SET SERVEROUTPUT ON;

--  2. �������� ��������� ��������� XML. XML ������ �������� ������ �� ��� ������� 3 ����������� ������, 
--  ��������� ������������� ����� � ����� �������.
CREATE OR REPLACE PROCEDURE GenerateXMLWithJoin
(
    xmlResult OUT XMLTYPE -- �������� ��� �������� ����������
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



--  3. �������� ��������� ������� ����� XML � ������� Report.
CREATE OR REPLACE PROCEDURE InsertXMLIntoReport AS
    xml CLOB;
BEGIN
    -- �������� ��������������� XML
    DECLARE
        xmlResult XMLTYPE;
    BEGIN
        GenerateXMLWithJoin(xmlResult);
        xml := xmlResult.getClobVal();
    END;

    -- ��������� XML � ������� Report
    INSERT INTO Report (xmlData) VALUES (xml);
END;
/




--  4. �������� ������ ��� XML-�������� � ������� Report. 
CREATE INDEX idx_xmlData ON Report(xmlData) INDEXTYPE IS CTXSYS.CONTEXT;


SELECT index_name, table_name, column_name
FROM all_ind_columns
WHERE table_name = 'REPORT';


--  5. �������� ��������� ���������� �������� ��������� �/��� ��������� �� XML -������� � ������� Report 
-- (�������� � �������� �������� ��� ��������).
CREATE OR REPLACE PROCEDURE ExtractXMLValue (
    pPath VARCHAR2, -- ���� � �������� ��� �������� ��� ����������
    pResult OUT VARCHAR2 -- �������� ��� ������������� ��������
)
AS
    v_xml CLOB;
    v_xmltype XMLTYPE;
BEGIN
    -- �������� XML �� ������� xmlData � ������� Report
    SELECT xmlData INTO v_xml
    FROM Report
    WHERE ROWNUM = 1; -- ������ �������� ���� ������ �� �������

    -- ������� XMLTYPE �� CLOB
    v_xmltype := XMLTYPE.createXML(v_xml);

    -- ��������� �������� �������� ��� �������� �� ��������� ����
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





