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

-- ��������� ���������� ������������
CREATE PROCEDURE dbo.AddSubordinate
    @ParentNodeValue hierarchyid,
    @SubordinateEmployeeID INT
AS
BEGIN
    DECLARE @NewNodeValue hierarchyid;

    -- �������� ����� ������������� ����
    SELECT @NewNodeValue = @ParentNodeValue.GetDescendant(
        NULL,
        NULL
    );

    -- ��������� ������������� ������ ��� ��������� ����������
    UPDATE dbo.Employees
    SET HierarchicalData = @NewNodeValue
    WHERE EmployeeID = @SubordinateEmployeeID;
END;




-- ��������� ����������� �����������
CREATE PROCEDURE dbo.MoveSubordinate
    @ParentNodeValue hierarchyid,
    @SubordinateEmployeeID INT,
    @NewParentNodeValue hierarchyid
AS
BEGIN
    DECLARE @NewNodeValue hierarchyid;

    -- �������� ����� ������������� ���� ��� ������ ������������� ����
    SELECT @NewNodeValue = @NewParentNodeValue.GetDescendant(
        NULL,
        NULL
    );

    -- ��������� ������������� ������ ��� ��������� ����������
    UPDATE dbo.Employees
    SET HierarchicalData = @NewNodeValue
    WHERE EmployeeID = @SubordinateEmployeeID;
END;



-- DROP PROCEDURE dbo.MoveSubordinates;

-- =========================================
select * from Employees

-- ������� ������� ��������
EXEC DisplaySubordinates '/'; -- �������� �������� ���� � �������� ���������


EXEC AddSubordinate '/1', 6; -- �������� �������� ������������� ���� � ID ������������ ����������

DECLARE @OldParentNode hierarchyid = '/';
DECLARE @SubordinateEmployeeID INT = 3;
DECLARE @NewParentNode hierarchyid = '/3/';

EXEC MoveSubordinate @OldParentNode, @SubordinateEmployeeID, @NewParentNode;

