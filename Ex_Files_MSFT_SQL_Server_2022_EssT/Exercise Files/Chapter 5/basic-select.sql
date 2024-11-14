SELECT CustomerID, FirstName, LastName
FROM Customers;

SELECT *
FROM Sandbox.dbo.Customers; -- using the db and schema names

SELECT TOP(10) CustomerID, FirstName, LastName
FROM Customers;

SELECT CustomerID, FirstName, LastName
FROM Customers
WHERE CustomerID > 1500 OR LastName = 'Smith';

SELECT TOP(25) *
FROM Customers
ORDER BY FirstName DESC;
