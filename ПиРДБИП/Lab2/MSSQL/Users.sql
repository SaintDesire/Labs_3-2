use HiringStaff;

-- —оздание администратора
CREATE LOGIN AdminUser WITH PASSWORD = 'StrongPassword123';

-- —оздание пользовател€ в базе данных (если еще не создан)
USE HiringStaff;
CREATE USER AdminUser FOR LOGIN AdminUser;

-- Ќазначение роли администратора дл€ пользовател€ в базе данных
ALTER ROLE db_owner ADD MEMBER AdminUser;

-- —оздание бизнес-пользователей
CREATE LOGIN BusinessUser1 WITH PASSWORD = 'StrongPassword123';
CREATE LOGIN BusinessUser2 WITH PASSWORD = 'StrongPassword456';

-- —оздание пользователей в базе данных (если еще не созданы)
CREATE USER BusinessUser1 FOR LOGIN BusinessUser1;
CREATE USER BusinessUser2 FOR LOGIN BusinessUser2;

-- Ќазначение роли только дл€ чтени€ дл€ бизнес-пользователей
ALTER ROLE db_datareader ADD MEMBER BusinessUser1;
ALTER ROLE db_datareader ADD MEMBER BusinessUser2;
