--CREATE DATABASE NewDatabase;
--GO;

--CREATE SCHEMA persons;
--GO;

--CREATE SCHEMA sales;
--GO;

--CREATE TABLE sales.Orders (OrderNum INT NULL);
--GO;

BACKUP DATABASE NewDatabase
TO DISK = 'D:\University\labs\4.1\DB\labs\lab1\task1'
	WITH FORMAT,
		MEDIANAME = 'SQLBackups',
		NAME = 'Test backup';
GO
