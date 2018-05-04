-- OLTP Database Normalization

-- to create new databse
CREATE DATABASE OLTP
GO

USE OLTP
GO

-- to create new table
CREATE TABLE Transactions
(
    transaction_id varchar(10),
    timestampsec datetime,
    customer_id varchar(10),
    first_name varchar(100),
    last_name varchar(100),
    shipping_state varchar(100),
    item varchar(100),
    item_description varchar(1000),
    retail_price float,
    loyalty_discount float,
	PRIMARY KEY (transaction_id)
)
GO

-- to import .csv dataset
BULK INSERT [dbo].[Transactions]
FROM 'C:\Users\anshu\Documents\Databases\OLTP.csv'
WITH
(
FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n'
)

SELECT *
FROM [dbo].[Transactions]

-- to check for 1NF
SELECT COUNT(*)
FROM [dbo].[Transactions]

SELECT COUNT(*)
FROM
(
SELECT DISTINCT *
FROM [dbo].[Transactions]
) AS temp
-- 1NF confirmed

-- to check and normalize into 2NF
SELECT [customer_id], [first_name], [last_name], [shipping_state], [loyalty_discount]
INTO Temp
FROM [dbo].[Transactions]

SELECT DISTINCT *
INTO Customers
FROM Temp

ALTER TABLE [dbo].[Transactions]
DROP COLUMN [first_name], [last_name], [shipping_state], [loyalty_discount]

DROP TABLE Temp

SELECT *
FROM Transactions

Select *
FROM Customers
-- 2NF confirmed

-- to check and normalize into 3NF
SELECT [item], [item_description], [retail_price]
INTO Temp2
FROM [dbo].[Transactions]

SELECT DISTINCT *
INTO Items
FROM Temp2

ALTER TABLE [dbo].[Transactions]
DROP COLUMN [item_description], [retail_price]

DROP TABLE Temp2

SELECT *
FROM Transactions

SELECT *
FROM Customers

SELECT *
FROM Items
-- 3NF confirmed

-- to join the tables for viewing data together
SELECT *
FROM Transactions AS A
LEFT JOIN Customers AS B
ON A.customer_id = B.customer_id
LEFT JOIN Items AS C
ON A.item = C.item
