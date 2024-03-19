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
            CAST(HierarchicalData.GetAncestor(1) AS NVARCHAR(MAX)) AS ParentNodeValue,
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
CREATE PROCEDURE dbo.AddSubordinate
    @ParentNodeValue hierarchyid,
    @SubordinateEmployeeID INT
AS
BEGIN
    DECLARE @NewNodeValue hierarchyid;

    -- Получаем новый идентификатор узла
    SELECT @NewNodeValue = @ParentNodeValue.GetDescendant(
        NULL,
        NULL
    );

    -- Обновляем иерархические данные для заданного сотрудника
    UPDATE dbo.Employees
    SET HierarchicalData = @NewNodeValue
    WHERE EmployeeID = @SubordinateEmployeeID;
END;




-- Процедура перемещения подчиненных
CREATE PROCEDURE dbo.MoveSubordinate
    @ParentNodeValue hierarchyid,
    @SubordinateEmployeeID INT,
    @NewParentNodeValue hierarchyid
AS
BEGIN
    DECLARE @NewNodeValue hierarchyid;

    -- Получаем новый идентификатор узла для нового родительского узла
    SELECT @NewNodeValue = @NewParentNodeValue.GetDescendant(
        NULL,
        NULL
    );

    -- Обновляем иерархические данные для заданного сотрудника
    UPDATE dbo.Employees
    SET HierarchicalData = @NewNodeValue
    WHERE EmployeeID = @SubordinateEmployeeID;
END;



-- DROP PROCEDURE dbo.MoveSubordinates;

-- =========================================


-- Примеры вызовов процедур
EXEC DisplaySubordinates '/'; -- Передаем значение узла в качестве параметра


EXEC AddSubordinate '/', 4; -- Передаем значение родительского узла и ID подчиненного сотрудника

DECLARE @OldParentNode hierarchyid = '/3/';
DECLARE @SubordinateEmployeeID INT = 4;
DECLARE @NewParentNode hierarchyid = '/2/';

EXEC MoveSubordinate @OldParentNode, @SubordinateEmployeeID, @NewParentNode;

