-- Удаление представления
DROP VIEW EmployeesObjView;

-- Удаление индекса
DROP INDEX idx_position;

-- Удаление таблицы
DROP TABLE EmployeeTable;

-- Удаление типа данных
DROP TYPE EmployeeObj FORCE;

set SERVEROUTPUT ON;

-- Создание объектного типа данных EmployeeObj
CREATE OR REPLACE TYPE EmployeeObj AS OBJECT (
  EmployeeID NUMBER,
  FullName VARCHAR2(100),
  Position VARCHAR2(100),
  HireDate DATE,
  Salary NUMBER,
  CandidateID NUMBER,
  RecruiterID NUMBER,

  CONSTRUCTOR FUNCTION EmployeeObj(SELF IN OUT NOCOPY EmployeeObj, EmployeeID NUMBER, FullName VARCHAR2, Position VARCHAR2, HireDate DATE, Salary NUMBER, CandidateID NUMBER, RecruiterID NUMBER) RETURN SELF AS RESULT,

  MEMBER FUNCTION compareType (emp2 IN EmployeeObj) RETURN NUMBER,

  MEMBER FUNCTION getDetails RETURN VARCHAR2 DETERMINISTIC,

  MEMBER FUNCTION getSalary RETURN NUMBER,

  MEMBER PROCEDURE updateSalary (newSalary IN NUMBER),
    
  MEMBER FUNCTION get_Name RETURN VARCHAR2 DETERMINISTIC,
  
  ORDER MEMBER FUNCTION compareTypeOrder (emp2 IN EmployeeObj) RETURN NUMBER
);

-- Создание конструктора EmployeeObj
CREATE OR REPLACE TYPE BODY EmployeeObj AS
  CONSTRUCTOR FUNCTION EmployeeObj(SELF IN OUT NOCOPY EmployeeObj, EmployeeID NUMBER, FullName VARCHAR2, Position VARCHAR2, HireDate DATE, Salary NUMBER, CandidateID NUMBER, RecruiterID NUMBER) RETURN SELF AS RESULT IS
  BEGIN
    SELF.EmployeeID := EmployeeID;
    SELF.FullName := FullName;
    SELF.Position := Position;
    SELF.HireDate := HireDate;
    SELF.Salary := Salary;
    SELF.CandidateID := CandidateID;
    SELF.RecruiterID := RecruiterID;
    RETURN;
  END;

  MEMBER FUNCTION compareType (emp2 IN EmployeeObj) RETURN NUMBER IS
  BEGIN
    IF SELF.EmployeeID = emp2.EmployeeID AND SELF.FullName = emp2.FullName AND SELF.Position = emp2.Position THEN
      RETURN 0;
    ELSIF SELF.EmployeeID < emp2.EmployeeID OR (SELF.EmployeeID = emp2.EmployeeID AND SELF.FullName < emp2.FullName) OR (SELF.EmployeeID = emp2.EmployeeID AND SELF.FullName = emp2.FullName AND SELF.Position < emp2.Position) THEN
      RETURN -1;
    ELSE
      RETURN 1;
    END IF;
  END;
  
  MEMBER FUNCTION get_Name RETURN VARCHAR2 DETERMINISTIC IS
    BEGIN
        return FullName;
    END;
    
  MEMBER FUNCTION getDetails RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Employee ID: ' || TO_CHAR(EmployeeID) || ', Full Name: ' || FullName || ', Position: ' || Position;
  END;

  MEMBER FUNCTION getSalary RETURN NUMBER IS
  BEGIN
    RETURN Salary;
  END;

  MEMBER PROCEDURE updateSalary (newSalary IN NUMBER) IS
  BEGIN
    SELF.Salary := newSalary;
  END;

  ORDER MEMBER FUNCTION compareTypeOrder (emp2 IN EmployeeObj) RETURN NUMBER IS
  BEGIN
    RETURN compareType(emp2);
  END;
END;





DECLARE
  emp1 EmployeeObj;
  emp2 EmployeeObj;
  comparison NUMBER;
BEGIN
  -- Создание объектов сотрудников
  emp1 := EmployeeObj(1, 'John Smith', 'Manager', TO_DATE('2022-01-01', 'YYYY-MM-DD'), 5000, 1, 1);
  emp2 := EmployeeObj(2, 'Jane Doe', 'Supervisor', TO_DATE('2022-01-01', 'YYYY-MM-DD'), 4000, 2, 2);

  -- Вызов метода compareTypeOrder для сравнения сотрудников
  comparison := emp1.compareTypeOrder(emp2);

  -- Вывод результата сравнения
  IF comparison = 0 THEN
    DBMS_OUTPUT.PUT_LINE('The employees are equal.');
  ELSIF comparison = -1 THEN
    DBMS_OUTPUT.PUT_LINE('Employee 1 is less than Employee 2.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Employee 1 is greater than Employee 2.');
  END IF;
END;





DECLARE
  emp EmployeeObj;
  details VARCHAR2(200);
  salary NUMBER;
BEGIN
  -- Создание объекта сотрудника
  emp := EmployeeObj(1, 'John Smith', 'Manager', TO_DATE('2022-01-01', 'YYYY-MM-DD'), 5000, 1, 1);

  -- Вызов метода getDetails для получения информации о сотруднике
  details := emp.getDetails();

  -- Вывод информации о сотруднике
  DBMS_OUTPUT.PUT_LINE('Employee Details: ' || details);

  -- Вызов метода getSalary для получения зарплаты сотрудника
  salary := emp.getSalary();

  -- Вывод зарплаты сотрудника
  DBMS_OUTPUT.PUT_LINE('Employee Salary: ' || salary);
END;





-- Создание таблицы EmployeeTable с использованием типа данных EmployeeObjList
create table EmployeeTable(
    EmployeeObj EmployeeObj
);

-- Заполнение таблицы
INSERT INTO EmployeeTable
SELECT EmployeeObj(EmployeeID, FullName, Position, HireDate, Salary, CandidateID, RecruiterID)
FROM Employees;


-- Выборка значений из таблицы
SELECT *
FROM EmployeeTable e;





CREATE OR REPLACE VIEW EmployeesObjView AS
SELECT EmployeeObj(EmployeeID, FullName, Position, HireDate, Salary, CandidateID, RecruiterID) AS Employee
FROM Employees;

SELECT * FROM EmployeesObjView e WHERE e.Employee.get_Name() =  'Молчанов Влас Куприянович';

SELECT * FROM EmployeesObjView e WHERE e.Employee.getSalary() > 100000;
    
    
    

select * from EmployeeTable e
where e.Position = 'Разработчик ПО';

CREATE INDEX idx_position ON EmployeeTable(Position);

-- DROP INDEX idx_position;


SELECT *
FROM EmployeeTable e
WHERE e.EmployeeObj.Salary = 90000;

CREATE BITMAP INDEX emp_salary_idx ON EmployeeTable(EmployeeObj.Salary);

-- Выборка значений из таблицы с использованием метода объекта
SELECT *
FROM EmployeeTable e
WHERE e.EmployeeObj.get_Name() = 'Молчанов Влас Куприянович';

create index IndexField on EmployeeTable (EmployeeObj.get_Name());

