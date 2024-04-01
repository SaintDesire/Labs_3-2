alter session set "_ORACLE_SCRIPT"=true; --переход в старый режим

-- Создание администратора
CREATE USER AdminUser1 IDENTIFIED BY StrongPassword123;

-- Назначение привилегий администратора
GRANT DBA TO AdminUser;

-- Создание бизнес-пользователей
CREATE USER BusinessUser1 IDENTIFIED BY StrongPassword123;
CREATE USER BusinessUser2 IDENTIFIED BY StrongPassword456;

-- Предположим, что схема с таблицами называется HiringStaff и таблицы, к которым предоставляются привилегии, называются Employees, Departments и так далее
-- Назначение роли только для чтения для бизнес-пользователей
GRANT SELECT ON Employees TO BusinessUser1;
GRANT SELECT ON Departments TO BusinessUser1;

GRANT SELECT ON Employees TO BusinessUser2;
GRANT SELECT ON Departments TO BusinessUser2;


select username from dba_users;
