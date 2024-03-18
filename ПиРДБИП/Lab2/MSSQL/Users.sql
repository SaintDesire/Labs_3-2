use HiringStaff;

-- �������� ��������������
CREATE LOGIN AdminUser WITH PASSWORD = 'StrongPassword123';

-- �������� ������������ � ���� ������ (���� ��� �� ������)
USE HiringStaff;
CREATE USER AdminUser FOR LOGIN AdminUser;

-- ���������� ���� �������������� ��� ������������ � ���� ������
ALTER ROLE db_owner ADD MEMBER AdminUser;

-- �������� ������-�������������
CREATE LOGIN BusinessUser1 WITH PASSWORD = 'StrongPassword123';
CREATE LOGIN BusinessUser2 WITH PASSWORD = 'StrongPassword456';

-- �������� ������������� � ���� ������ (���� ��� �� �������)
CREATE USER BusinessUser1 FOR LOGIN BusinessUser1;
CREATE USER BusinessUser2 FOR LOGIN BusinessUser2;

-- ���������� ���� ������ ��� ������ ��� ������-�������������
ALTER ROLE db_datareader ADD MEMBER BusinessUser1;
ALTER ROLE db_datareader ADD MEMBER BusinessUser2;
