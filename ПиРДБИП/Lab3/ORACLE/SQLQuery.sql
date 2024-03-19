-- ���������� ������� ���� hierarchyid � ������� Employees
ALTER TABLE Employees
ADD HierarchicalData NUMBER


-- ============================================================


CREATE OR REPLACE PROCEDURE DisplaySubordinates (
    NodeValue IN VARCHAR2
)
AS
BEGIN
    FOR SubordinateRow IN (
        SELECT 
            EmployeeID,
            FullName,
            LEVEL AS HierarchyLevel,
            CONNECT_BY_ROOT EmployeeID AS ParentNodeValue,
            ROW_NUMBER() OVER (ORDER BY SYS_CONNECT_BY_PATH(EmployeeID, '/')) AS NodeNumber
        FROM 
            Employees
        START WITH 
            HierarchicalData = NodeValue
        CONNECT BY 
            PRIOR EmployeeID = HierarchicalData
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            SubordinateRow.EmployeeID || ' ' ||
            SubordinateRow.FullName || ' ' ||
            SubordinateRow.HierarchyLevel || ' ' ||
            SubordinateRow.ParentNodeValue || ' ' ||
            SubordinateRow.NodeNumber
        );
    END LOOP;
END;
/





-- ��������� ���������� ������������
CREATE OR REPLACE PROCEDURE AddSubordinate (
    ParentNodeValue IN VARCHAR2,
    SubordinateEmployeeID IN NUMBER
)
AS
BEGIN
    -- ��������� ������������� ������ ��� ��������� ����������
    UPDATE Employees
    SET HierarchicalData = TO_NUMBER(ParentNodeValue)
    WHERE EmployeeID = SubordinateEmployeeID;
END;
/




-- ��������� ����������� ������������
CREATE OR REPLACE PROCEDURE MoveSubordinate (
    ParentNodeValue IN VARCHAR2,
    SubordinateEmployeeID IN NUMBER,
    NewParentNodeValue IN VARCHAR2
)
AS
BEGIN
    -- ��������� ������������� ������ ��� ��������� ����������
    UPDATE Employees
    SET HierarchicalData = TO_NUMBER(NewParentNodeValue)
    WHERE EmployeeID = SubordinateEmployeeID;
END;
/



-- =======================================

SELECT * FROM EMPLOYEES;


SET SERVEROUTPUT ON;

-- ���������� ����������� ����������� ��������� ��������
EXEC DisplaySubordinates(3);

-- ������ �������� - ��������, ������ - ���������
EXEC AddSubordinate(3, 6);

-- ������ �������� - ������ ���. ����, ������ - ���������, ������ - ����� ���. ����
EXEC MoveSubordinate(2, 6, 3);


