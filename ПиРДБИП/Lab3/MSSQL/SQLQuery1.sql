use HiringStaff;

-- Добавление столбца типа hierarchyid в таблицу Сотрудники
ALTER TABLE Employees
ADD HierarchicalData hierarchyid;


-- ============================================================


-- Процедура отображение подчиненных
CREATE PROCEDURE dbo.DisplaySubordinates
    @NodeValue hierarchyid
AS
BEGIN
    WITH SubordinatesCTE AS (
        SELECT 
            EmployeeID,
            FullName,
            HierarchicalData.GetLevel() AS HierarchyLevel,
            CASE 
                WHEN HierarchicalData.GetLevel() = 0 THEN NULL 
                ELSE CAST(HierarchicalData.GetAncestor(1) AS NVARCHAR(MAX)) 
            END AS ParentNodeValue,
            ROW_NUMBER() OVER (ORDER BY HierarchicalData) AS NodeNumber
        FROM 
            Employees
        WHERE 
            HierarchicalData.IsDescendantOf(@NodeValue) = 1
    )
    SELECT 
        EmployeeID,
        FullName,
        HierarchyLevel,
        ParentNodeValue,
        NodeNumber
    FROM 
        SubordinatesCTE;
END;






-- DROP PROCEDURE dbo.DisplaySubordinates;

-- Процедура добавления подчиненного
CREATE PROCEDURE AddSubordinate
    @ManagerID int = NULL,
    @EmployeeID int
AS
BEGIN
    DECLARE @ManagerHierarchicalData hierarchyid

    -- Если @ManagerID равен NULL, создаем новый верхний элемент иерархии
    IF @ManagerID IS NULL
    BEGIN
        -- Находим максимальный идентификатор среди всех сотрудников
        SELECT @ManagerID = MAX(EmployeeID) + 1
        FROM employees

        -- Устанавливаем новый иерархический путь в корень
        SET @ManagerHierarchicalData = '/'
    END
    ELSE
    BEGIN
        -- Если @ManagerID был указан, получаем его иерархический путь
        SELECT @ManagerHierarchicalData = HierarchicalData
        FROM employees
        WHERE EmployeeID = @ManagerID
    END

    -- Генерируем новый иерархический путь для подчиненного
    DECLARE @NewEmployeeHierarchicalData hierarchyid
    SELECT @NewEmployeeHierarchicalData = @ManagerHierarchicalData.GetDescendant(NULL, NULL)

    -- Обновляем иерархический путь подчиненного
    UPDATE employees
    SET HierarchicalData = @NewEmployeeHierarchicalData
    WHERE EmployeeID = @EmployeeID

    -- Обновляем иерархический путь для остальных подчиненных начальника
    IF @ManagerID IS NOT NULL
    BEGIN
        UPDATE employees
        SET HierarchicalData = @ManagerHierarchicalData.GetDescendant(HierarchicalData, NULL)
        WHERE HierarchicalData.GetAncestor(1) = @ManagerHierarchicalData
    END
END




-- DROP PROCEDURE dbo.AddSubordinate;



-- Процедура перемещения подчиненных
CREATE PROCEDURE dbo.MoveSubordinate
    @ManagerEmployeeID INT,
    @SubordinateEmployeeID INT,
    @NewManagerEmployeeID INT
AS	
BEGIN
    DECLARE @CurrentParentNode hierarchyid;
    DECLARE @NewParentNode hierarchyid;

    -- Получаем иерархический узел текущего родительского сотрудника
    SELECT @CurrentParentNode = HierarchicalData
    FROM dbo.Employees
    WHERE EmployeeID = @ManagerEmployeeID;

    -- Получаем иерархический узел нового родительского сотрудника
    SELECT @NewParentNode = HierarchicalData
    FROM dbo.Employees
    WHERE EmployeeID = @NewManagerEmployeeID;

    -- Получаем новый идентификатор узла для нового родительского узла
    DECLARE @NewNodeValue hierarchyid;
    SELECT @NewNodeValue = @NewParentNode.GetDescendant(
        NULL,
        NULL
    );

    -- Обновляем иерархические данные для заданного сотрудника
    UPDATE dbo.Employees
    SET HierarchicalData = @NewNodeValue
    WHERE EmployeeID = @SubordinateEmployeeID;
END;




-- DROP PROCEDURE dbo.MoveSubordinate;

-- =========================================
select * from Employees

-- Примеры вызовов процедур
EXEC dbo.DisplaySubordinates @NodeValue = '/';



EXEC dbo.AddSubordinate @ManagerID = 2, @EmployeeID = 7;


EXEC dbo.MoveSubordinate @ManagerEmployeeID = 1, @SubordinateEmployeeID = 3, @NewManagerEmployeeID = 2;


