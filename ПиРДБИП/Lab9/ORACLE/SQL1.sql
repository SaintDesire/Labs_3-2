SET SERVEROUTPUT ON;

-- Удаление всех созданных объектов
DROP TABLE t1;
DROP TABLE t2;
DROP TYPE EmployeeType;
DROP TYPE EmployeeList;
DROP TYPE DepartmentType;
DROP TYPE DepartmentList;
DROP TYPE EmployeeDepartmentType;

-- Коллекция - это структура даннх, содержащая множество объектов опреелённого типа
-- Шаг 1: Создание коллекций на основе таблиц
-- Тип для коллекции Employee t1
CREATE TYPE EmployeeType AS OBJECT (
    ID NUMBER,
    Текст NVARCHAR2(255)
);

-- Тип для хранения списка Employee
CREATE TYPE EmployeeList AS TABLE OF EmployeeType;

-- Тип для коллекции Department t2
CREATE TYPE DepartmentType AS OBJECT (
    ID NUMBER,
    Текст NVARCHAR2(255)
);
-- Тип для хранения списка Departmentов
CREATE TYPE DepartmentList AS TABLE OF DepartmentType;

-- Тип для коллекции Employee-Department
CREATE TYPE EmployeeDepartmentType AS OBJECT (
    Employee EmployeeType,
    Department DepartmentList
);

-- Таблица t1
CREATE TABLE t1 (
    Employee EmployeeList
) NESTED TABLE Employee STORE AS Employee_table;

-- Таблица t2 (DepartmentType) для демонстрации даннх
CREATE TABLE t2 OF DepartmentType;

-- Вставка даннх в таблицу t2
INSERT INTO t2 VALUES (DepartmentType(1, 'Department 1'));
INSERT INTO t2 VALUES (DepartmentType(2, 'Department 2'));
INSERT INTO t2 VALUES (DepartmentType(3, 'Department 3'));

-- Вставка даннх в таблицу t1
INSERT INTO t1 VALUES (EmployeeList(EmployeeType(1, 'Employee 1'), EmployeeType(2, 'Employee 2')));
INSERT INTO t1 VALUES (EmployeeList(EmployeeType(3, 'Employee 3')));

-- Шаг 2: Обработка даннх из коллекций (пункт b и c)
DECLARE
    K1 EmployeeList;
BEGIN
    SELECT Employee INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- Проверка, является ли элемент EmployeeType(1, 'Employee 1') членом коллекции K1
    DECLARE
        v_question_exists BOOLEAN := FALSE;
    BEGIN
        FOR i IN 1..K1.COUNT LOOP
            IF K1(i).ID = 1 AND K1(i).Текст = 'Employee 1' THEN
                v_question_exists := TRUE;
                EXIT;
            END IF;
        END LOOP;

        IF v_question_exists THEN
            DBMS_OUTPUT.PUT_LINE('2b');
            DBMS_OUTPUT.PUT_LINE('EmployeeType(1, ''Employee 1'') является членом K1');
        END IF;
    END;
END;
/


-- Проверка на пустоту коллекции
DECLARE
    K1 EmployeeList;
BEGIN
    SELECT Employee INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- Проверка на пустую коллекцию
    IF K1 IS NULL OR K1.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Коллекция K1 пуста');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Коллекция K1 не пуста');
    END IF;
END;
/

-- Шаг 3: Преобразовать коллекцию к другому виду (к коллекции другого типа, к реляционнм даннм).
DECLARE
    K1 EmployeeList;
    NewEmployeeList EmployeeList := EmployeeList(); -- Создаем пустую коллекцию для новх элементов
BEGIN
    -- Присваивание K1 коллекции Employeeов из первой записи t1
    SELECT Employee INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- Добавляем элемент из K1 с ID > 1 в новую коллекцию NewEmployeeList
    FOR i IN 1..K1.COUNT LOOP
        IF K1(i).ID > 1 THEN
            NewEmployeeList.EXTEND; -- Увеличиваем размер коллекции
            NewEmployeeList(NewEmployeeList.LAST) := K1(i); -- Добававляем элемент в коллекцию
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('2c');
    -- Вводим содержимое новой коллекции NewEmployeeList
    FOR i IN 1..NewEmployeeList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewEmployeeList(i).ID || ', Текст: ' || NewEmployeeList(i).Текст);
    END LOOP;
END;
/

-- Шаг 4: Изменение даннх в коллекции (пункт d)
DECLARE
    K1 EmployeeList;
    NewEmployeeList EmployeeList := EmployeeList(); -- Создаем пустую коллекцию для новх элементов
BEGIN
    -- Присваивание K1 коллекции Employeeов из первой записи t1
    SELECT Employee INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- Добавляем элемент из K1 с ID > 1 в новую коллекцию NewEmployeeList
    FOR i IN 1..K1.COUNT LOOP
        IF K1(i).ID > 1 THEN
            NewEmployeeList.EXTEND; -- Увеличиваем размер коллекции
            NewEmployeeList(NewEmployeeList.LAST) := K1(i); -- Добавляем элемент в коллекцию
        END IF;
    END LOOP;

    -- Вводим содержимое новой коллекции NewEmployeeList
    DBMS_OUTPUT.PUT_LINE('Contents of NewEmployeeList:');
    FOR i IN 1..NewEmployeeList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewEmployeeList(i).ID || ', Текст: ' || NewEmployeeList(i).Текст);
    END LOOP;
END;
/

-- Шаг 4: Изменение даннх в коллекции (пункт d)
CREATE GLOBAL TEMPORARY TABLE temp_table (
    ID NUMBER,
    Текст NVARCHAR2(255)
) ON COMMIT PRESERVE ROWS;

DECLARE
    NewEmployeeList EmployeeList := EmployeeList(); -- Создаем пустую коллекцию для новх элементов
BEGIN
    NewEmployeeList.EXTEND;
    NewEmployeeList(NewEmployeeList.LAST) := EmployeeType(4, 'Новый Employee 1');
    NewEmployeeList.EXTEND;
    NewEmployeeList(NewEmployeeList.LAST) := EmployeeType(5, 'Новый Employee 2');

    -- Ввод содержимого коллекции NewEmployeeList перед операцией массовой вставки
    DBMS_OUTPUT.PUT_LINE('Содержимое NewEmployeeList:');
    FOR i IN 1..NewEmployeeList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewEmployeeList(i).ID || ', Текст: ' || NewEmployeeList(i).Текст);
    END LOOP;

    -- Используем оператор BULK COLLECT для массового извлечения даннх из 
    -- коллекции NewEmployeeList во временную таблицу
    -- FORRALL - BULK оператор
    FORALL i IN 1..NewEmployeeList.COUNT
        INSERT INTO temp_table VALUES (NewEmployeeList(i).ID, NewEmployeeList(i).Текст);

    INSERT INTO t1 (Employee)
    SELECT EmployeeList(EmployeeType(ID, Текст))
    FROM temp_table;

    -- Ввод сообщения об успешной вставке
    DBMS_OUTPUT.PUT_LINE('Массовая вставка вполнена успешно.');
END;
/