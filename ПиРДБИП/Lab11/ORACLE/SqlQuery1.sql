DELETE FROM VACANCIES_IMPORT;

CREATE OR REPLACE FUNCTION get_data_by_dates(
    p_start_date IN DATE,
    p_end_date IN DATE
)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT VacancyID, Title, Requirements, Conditions, Salary, PublicationDate
        FROM 
            Vacancies_Export
        WHERE 
            PublicationDate >= p_start_date AND PublicationDate <= p_end_date;
    RETURN v_cursor;
END;
/


SET FEEDBACK OFF
SPOOL 'C:\Users\p1v0var\Desktop\labs_3-2\ÏèÐÄÁÈÏ\Lab11\ORACLE\data.txt'

DECLARE
    v_cursor SYS_REFCURSOR;
    v_vacancyID NUMBER;
    v_title VARCHAR2(100);
    v_requirements VARCHAR2(100);
    v_conditions VARCHAR2(100);
    v_salary NUMBER;
    v_publicationDate DATE;
BEGIN
    v_cursor := get_data_by_dates(TO_DATE('2021-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('VACANCYID|TITLE|REQUIREMENTS|CONDITIONS|SALARY|PUBLICATIONDATE');
    LOOP
        FETCH v_cursor INTO v_vacancyID, v_title, v_requirements, v_conditions, v_salary, v_publicationDate;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_vacancyID || '|' || v_title || '|' || v_requirements || '|' || v_conditions || '|' || v_salary || '|' || TO_CHAR(v_publicationDate, 'YYYY-MM-DD'));
    END LOOP;
    CLOSE v_cursor;
END;
/

SPOOL OFF
SET FEEDBACK ON

SELECT * FROM Vacancies;