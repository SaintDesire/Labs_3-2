SET SERVEROUTPUT ON;

-- �������� ���� ��������� ��������
DROP TABLE t1;
DROP TABLE t2;
DROP TYPE EmployeeType;
DROP TYPE EmployeeList;
DROP TYPE DepartmentType;
DROP TYPE DepartmentList;
DROP TYPE EmployeeDepartmentType;

-- ��������� - ��� ��������� �����, ���������� ��������� �������� ����������� ����
-- ��� 1: �������� ��������� �� ������ ������
-- ��� ��� ��������� Employee t1
CREATE TYPE EmployeeType AS OBJECT (
    ID NUMBER,
    ����� NVARCHAR2(255)
);

-- ��� ��� �������� ������ Employee
CREATE TYPE EmployeeList AS TABLE OF EmployeeType;

-- ��� ��� ��������� Department t2
CREATE TYPE DepartmentType AS OBJECT (
    ID NUMBER,
    ����� NVARCHAR2(255)
);
-- ��� ��� �������� ������ Department��
CREATE TYPE DepartmentList AS TABLE OF DepartmentType;

-- ��� ��� ��������� Employee-Department
CREATE TYPE EmployeeDepartmentType AS OBJECT (
    Employee EmployeeType,
    Department DepartmentList
);

-- ������� t1
CREATE TABLE t1 (
    Employee EmployeeList
) NESTED TABLE Employee STORE AS Employee_table;

-- ������� t2 (DepartmentType) ��� ������������ �����
CREATE TABLE t2 OF DepartmentType;

-- ������� ����� � ������� t2
INSERT INTO t2 VALUES (DepartmentType(1, 'Department 1'));
INSERT INTO t2 VALUES (DepartmentType(2, 'Department 2'));
INSERT INTO t2 VALUES (DepartmentType(3, 'Department 3'));

-- ������� ����� � ������� t1
INSERT INTO t1 VALUES (EmployeeList(EmployeeType(1, 'Employee 1'), EmployeeType(2, 'Employee 2')));
INSERT INTO t1 VALUES (EmployeeList(EmployeeType(3, 'Employee 3')));

-- ��� 2: ��������� ����� �� ��������� (����� b � c)
DECLARE
    K1 EmployeeList;
BEGIN
    SELECT Employee INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- ��������, �������� �� ������� EmployeeType(1, 'Employee 1') ������ ��������� K1
    DECLARE
        v_question_exists BOOLEAN := FALSE;
    BEGIN
        FOR i IN 1..K1.COUNT LOOP
            IF K1(i).ID = 1 AND K1(i).����� = 'Employee 1' THEN
                v_question_exists := TRUE;
                EXIT;
            END IF;
        END LOOP;

        IF v_question_exists THEN
            DBMS_OUTPUT.PUT_LINE('2b');
            DBMS_OUTPUT.PUT_LINE('EmployeeType(1, ''Employee 1'') �������� ������ K1');
        END IF;
    END;
END;
/


-- �������� �� ������� ���������
DECLARE
    K1 EmployeeList;
BEGIN
    SELECT Employee INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- �������� �� ������ ���������
    IF K1 IS NULL OR K1.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('��������� K1 �����');
    ELSE
        DBMS_OUTPUT.PUT_LINE('��������� K1 �� �����');
    END IF;
END;
/

-- ��� 3: ������������� ��������� � ������� ���� (� ��������� ������� ����, � ���������� �����).
DECLARE
    K1 EmployeeList;
    NewEmployeeList EmployeeList := EmployeeList(); -- ������� ������ ��������� ��� ���� ���������
BEGIN
    -- ������������ K1 ��������� Employee�� �� ������ ������ t1
    SELECT Employee INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- ��������� ������� �� K1 � ID > 1 � ����� ��������� NewEmployeeList
    FOR i IN 1..K1.COUNT LOOP
        IF K1(i).ID > 1 THEN
            NewEmployeeList.EXTEND; -- ����������� ������ ���������
            NewEmployeeList(NewEmployeeList.LAST) := K1(i); -- ����������� ������� � ���������
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('2c');
    -- ������ ���������� ����� ��������� NewEmployeeList
    FOR i IN 1..NewEmployeeList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewEmployeeList(i).ID || ', �����: ' || NewEmployeeList(i).�����);
    END LOOP;
END;
/

-- ��� 4: ��������� ����� � ��������� (����� d)
DECLARE
    K1 EmployeeList;
    NewEmployeeList EmployeeList := EmployeeList(); -- ������� ������ ��������� ��� ���� ���������
BEGIN
    -- ������������ K1 ��������� Employee�� �� ������ ������ t1
    SELECT Employee INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- ��������� ������� �� K1 � ID > 1 � ����� ��������� NewEmployeeList
    FOR i IN 1..K1.COUNT LOOP
        IF K1(i).ID > 1 THEN
            NewEmployeeList.EXTEND; -- ����������� ������ ���������
            NewEmployeeList(NewEmployeeList.LAST) := K1(i); -- ��������� ������� � ���������
        END IF;
    END LOOP;

    -- ������ ���������� ����� ��������� NewEmployeeList
    DBMS_OUTPUT.PUT_LINE('Contents of NewEmployeeList:');
    FOR i IN 1..NewEmployeeList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewEmployeeList(i).ID || ', �����: ' || NewEmployeeList(i).�����);
    END LOOP;
END;
/

-- ��� 4: ��������� ����� � ��������� (����� d)
CREATE GLOBAL TEMPORARY TABLE temp_table (
    ID NUMBER,
    ����� NVARCHAR2(255)
) ON COMMIT PRESERVE ROWS;

DECLARE
    NewEmployeeList EmployeeList := EmployeeList(); -- ������� ������ ��������� ��� ���� ���������
BEGIN
    NewEmployeeList.EXTEND;
    NewEmployeeList(NewEmployeeList.LAST) := EmployeeType(4, '����� Employee 1');
    NewEmployeeList.EXTEND;
    NewEmployeeList(NewEmployeeList.LAST) := EmployeeType(5, '����� Employee 2');

    -- ���� ����������� ��������� NewEmployeeList ����� ��������� �������� �������
    DBMS_OUTPUT.PUT_LINE('���������� NewEmployeeList:');
    FOR i IN 1..NewEmployeeList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewEmployeeList(i).ID || ', �����: ' || NewEmployeeList(i).�����);
    END LOOP;

    -- ���������� �������� BULK COLLECT ��� ��������� ���������� ����� �� 
    -- ��������� NewEmployeeList �� ��������� �������
    -- FORRALL - BULK ��������
    FORALL i IN 1..NewEmployeeList.COUNT
        INSERT INTO temp_table VALUES (NewEmployeeList(i).ID, NewEmployeeList(i).�����);

    INSERT INTO t1 (Employee)
    SELECT EmployeeList(EmployeeType(ID, �����))
    FROM temp_table;

    -- ���� ��������� �� �������� �������
    DBMS_OUTPUT.PUT_LINE('�������� ������� �������� �������.');
END;
/