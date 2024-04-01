alter session set "_ORACLE_SCRIPT"=true; --������� � ������ �����

-- �������� ��������������
CREATE USER AdminUser1 IDENTIFIED BY StrongPassword123;

-- ���������� ���������� ��������������
GRANT DBA TO AdminUser;

-- �������� ������-�������������
CREATE USER BusinessUser1 IDENTIFIED BY StrongPassword123;
CREATE USER BusinessUser2 IDENTIFIED BY StrongPassword456;

-- �����������, ��� ����� � ��������� ���������� HiringStaff � �������, � ������� ��������������� ����������, ���������� Employees, Departments � ��� �����
-- ���������� ���� ������ ��� ������ ��� ������-�������������
GRANT SELECT ON Employees TO BusinessUser1;
GRANT SELECT ON Departments TO BusinessUser1;

GRANT SELECT ON Employees TO BusinessUser2;
GRANT SELECT ON Departments TO BusinessUser2;


select username from dba_users;
