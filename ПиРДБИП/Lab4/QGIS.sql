use QGIS;

-- Верните описания пространственных объектов в формате WKT.
SELECT [qgs_fid], geom.STAsText() AS wkt_description
FROM [10m_physical]

-- Нахождение пересечения пространственных объектов
SELECT A.[qgs_fid] AS id_A, B.[qgs_fid] AS id_B, A.geom.STIntersection(B.geom) AS intersection
FROM [10m_physical] A, [10m_physical] B
WHERE A.[qgs_fid] <> B.[qgs_fid] AND A.geom.STIntersects(B.geom) = 1;


-- Нахождение координат вершин пространственного объектов
SELECT [qgs_fid], geom.STNumPoints() AS num_points
FROM [10m_physical];

-- Нахождение площади пространственных объектов
SELECT [qgs_fid], geom.STArea() AS area 
FROM [10m_physical]
WHERE geom.STGeometryType() = 'POLYGON';


-- Создайте пространственный объект в виде точки (1) /линии (2) /полигона (3).

-- Пример создания нового объекта (точка):
DECLARE @new_point GEOMETRY;
SET @new_point = geometry::STGeomFromText('POINT(2 3)', 0);
INSERT INTO [10m_physical] ([qgs_fid], geom)
VALUES (4, @new_point);


-- Найдите, в какие пространственные объекты попадают созданные вами объекты
SELECT A.[qgs_fid] AS id_created, B.[qgs_fid] AS id_containing
FROM [10m_physical] A, [10m_physical] B
WHERE A.[qgs_fid] <> B.[qgs_fid] AND A.geom.STWithin(B.geom) = 1;

-- Продемонстрируйте индексирование пространственных объектов
CREATE SPATIAL INDEX idx_spatial_geom ON [10m_physical](geom) 
USING GEOMETRY_GRID WITH (BOUNDING_BOX = (-180, -90, 180, 90), 
GRIDS =(HIGH, HIGH, HIGH, HIGH), CELLS_PER_OBJECT = 64, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, 
		DROP_EXISTING = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


-- Разработайте хранимую процедуру, которая принимает координаты точки и возвращает пространственный объект, в который эта точка попадает
CREATE PROCEDURE FindContainingObject 
    @pointGeometry geometry
AS
BEGIN
    SELECT * 
    FROM [10m_physical]
    WHERE geom.STContains(@pointGeometry) = 1
END
