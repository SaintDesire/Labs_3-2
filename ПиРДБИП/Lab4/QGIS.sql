use QGIS;

-- ������� �������� ���������������� �������� � ������� WKT.
SELECT [qgs_fid], geom.STAsText() AS wkt_description
FROM [10m_physical]

-- ���������� ����������� ���������������� ��������
SELECT A.[qgs_fid] AS id_A, B.[qgs_fid] AS id_B, A.geom.STIntersection(B.geom) AS intersection
FROM [10m_physical] A, [10m_physical] B
WHERE A.[qgs_fid] <> B.[qgs_fid] AND A.geom.STIntersects(B.geom) = 1;


-- ���������� ��������� ������ ����������������� ��������
SELECT [qgs_fid], geom.STNumPoints() AS num_points
FROM [10m_physical];

-- ���������� ������� ���������������� ��������
SELECT [qgs_fid], geom.STArea() AS area 
FROM [10m_physical]
WHERE geom.STGeometryType() = 'POLYGON';


-- �������� ���������������� ������ � ���� ����� (1) /����� (2) /�������� (3).

-- ������ �������� ������ ������� (�����):
DECLARE @new_point GEOMETRY;
SET @new_point = geometry::STGeomFromText('POINT(2 3)', 0);
INSERT INTO [10m_physical] ([qgs_fid], geom)
VALUES (4, @new_point);


-- �������, � ����� ���������������� ������� �������� ��������� ���� �������
SELECT A.[qgs_fid] AS id_created, B.[qgs_fid] AS id_containing
FROM [10m_physical] A, [10m_physical] B
WHERE A.[qgs_fid] <> B.[qgs_fid] AND A.geom.STWithin(B.geom) = 1;

-- ����������������� �������������� ���������������� ��������
CREATE SPATIAL INDEX idx_spatial_geom ON [10m_physical](geom) 
USING GEOMETRY_GRID WITH (BOUNDING_BOX = (-180, -90, 180, 90), 
GRIDS =(HIGH, HIGH, HIGH, HIGH), CELLS_PER_OBJECT = 64, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, 
		DROP_EXISTING = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


-- ������������ �������� ���������, ������� ��������� ���������� ����� � ���������� ���������������� ������, � ������� ��� ����� ��������
CREATE PROCEDURE FindContainingObject 
    @pointGeometry geometry
AS
BEGIN
    SELECT * 
    FROM [10m_physical]
    WHERE geom.STContains(@pointGeometry) = 1
END
