use HiringStaff;

-- ���������� ������� ���� hierarchyid � ������� ����������
ALTER TABLE Employees
ADD HierarchicalData hierarchyid;


-- ============================================================


-- ��������� ����������� �����������
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

-- ��������� ���������� ������������
CREATE PROCEDURE AddSubordinate
    @ManagerID int = NULL,
    @EmployeeID int
AS
BEGIN
    DECLARE @ManagerHierarchicalData hierarchyid

    -- ���� @ManagerID ����� NULL, ������� ����� ������� ������� ��������
    IF @ManagerID IS NULL
    BEGIN
        -- ������� ������������ ������������� ����� ���� �����������
        SELECT @ManagerID = MAX(EmployeeID) + 1
        FROM employees

        -- ������������� ����� ������������� ���� � ������
        SET @ManagerHierarchicalData = '/'
    END
    ELSE
    BEGIN
        -- ���� @ManagerID ��� ������, �������� ��� ������������� ����
        SELECT @ManagerHierarchicalData = HierarchicalData
        FROM employees
        WHERE EmployeeID = @ManagerID
    END

    -- ���������� ����� ������������� ���� ��� ������������
    DECLARE @NewEmployeeHierarchicalData hierarchyid
    SELECT @NewEmployeeHierarchicalData = @ManagerHierarchicalData.GetDescendant(NULL, NULL)

    -- ��������� ������������� ���� ������������
    UPDATE employees
    SET HierarchicalData = @NewEmployeeHierarchicalData
    WHERE EmployeeID = @EmployeeID

    -- ��������� ������������� ���� ��� ��������� ����������� ����������
    IF @ManagerID IS NOT NULL
    BEGIN
        UPDATE employees
        SET HierarchicalData = @ManagerHierarchicalData.GetDescendant(HierarchicalData, NULL)
        WHERE HierarchicalData.GetAncestor(1) = @ManagerHierarchicalData
    END
END




-- DROP PROCEDURE dbo.AddSubordinate;



-- ��������� ����������� �����������
CREATE PROCEDURE dbo.MoveSubordinate
    @ManagerEmployeeID INT,
    @SubordinateEmployeeID INT,
    @NewManagerEmployeeID INT
AS	
BEGIN
    DECLARE @CurrentParentNode hierarchyid;
    DECLARE @NewParentNode hierarchyid;

    -- �������� ������������� ���� �������� ������������� ����������
    SELECT @CurrentParentNode = HierarchicalData
    FROM dbo.Employees
    WHERE EmployeeID = @ManagerEmployeeID;

    -- �������� ������������� ���� ������ ������������� ����������
    SELECT @NewParentNode = HierarchicalData
    FROM dbo.Employees
    WHERE EmployeeID = @NewManagerEmployeeID;

    -- �������� ����� ������������� ���� ��� ������ ������������� ����
    DECLARE @NewNodeValue hierarchyid;
    SELECT @NewNodeValue = @NewParentNode.GetDescendant(
        NULL,
        NULL
    );

    -- ��������� ������������� ������ ��� ��������� ����������
    UPDATE dbo.Employees
    SET HierarchicalData = @NewNodeValue
    WHERE EmployeeID = @SubordinateEmployeeID;
END;




-- DROP PROCEDURE dbo.MoveSubordinate;

-- =========================================
select * from Employees

-- ������� ������� ��������
EXEC dbo.DisplaySubordinates @NodeValue = '/';



EXEC dbo.AddSubordinate @ManagerID = 2, @EmployeeID = 7;


EXEC dbo.MoveSubordinate @ManagerEmployeeID = 1, @SubordinateEmployeeID = 3, @NewManagerEmployeeID = 2;


