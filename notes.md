# Notes

## Ch. 1 Getting Started

You can have multiple _instances_ of SQL Server per server, and within each instance, multiple _databases_. Like:

* Server
    * Instance
        * Database
        * Database
        * ...
    * Instance
        * Database
        * ...

Tools

* SQLCMD - a SQL cli tool
    1. Run > `sqlcmd.exe`, or
    2. Run `sqlcmd` inside of a Command Prompt or Powershell
* [mssql-cli command-line query tool for SQL Server](https://learn.microsoft.com/en-us/sql/tools/mssql-cli?view=sql-server-ver16)
* SQL Server Management Studio (SSMS) is Windows-Only
* SQL Server Installation Center
* Azure Data Studio (Windows, Mac, and Linux)

How to check SQL version via SQLCMD: 

```shell
1> SELECT @@Version
2> GO
```

How to list all databases on the server via SQLCMD: 

```shell
1> sp_databases
2> GO
```

(`sp_` stands for stored procedure.)

Tell sqlcmd to use a specific database: 

```shell
1> USE SomeDatabase
2> GO
```

SQL Server Services

* SQL Server Browser - used to help end users browse instances to connect to 
* SQL SERVER
* SQL Server Agent - used for scheduling automated processes 

_Right-click (on a service) > Properties > Service > Start Mode_ - sets the default behavior of the service: Automatic vs. Manual. 

How to create a Docker container for your SQL Server instance: 

```shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=YourPasswordHere" -p 1401:1433 --name sqlserver2022 -d mcr.microsoft.com/mssql/server:2022-latest
```

## Ch. 3 Creating Databases 

How to see the help options for SQLCMD

1. Launch Command Prompt
2. Run `sqlcmd -?`

```shell
Microsoft (R) SQL Server Command Line Tool
Version 16.0.1000.6 NT
Copyright (C) 2022 Microsoft Corporation. All rights reserved.

usage: Sqlcmd            [-U login id]          [-P password]
  [-S server]            [-H hostname]          [-E trusted connection]
  [-N Encrypt Connection][-C Trust Server Certificate]
  [-d use database name] [-l login timeout]     [-t query timeout]
  [-h headers]           [-s colseparator]      [-w screen width]
  [-a packetsize]        [-e echo input]        [-I Enable Quoted Identifiers]
  [-c cmdend]            [-L[c] list servers[clean output]]
  [-q "cmdline query"]   [-Q "cmdline query" and exit]
  [-m errorlevel]        [-V severitylevel]     [-W remove trailing spaces]
  [-u unicode output]    [-r[0|1] msgs to stderr]
  [-i inputfile]         [-o outputfile]        [-z new password]
  [-f <codepage> | i:<codepage>[,o:<codepage>]] [-Z new password and exit]
  [-k[1|2] remove[replace] control characters]
  [-y variable length type display width]
  [-Y fixed length type display width]
  [-p[1] print statistics[colon format]]
  [-R use client regional setting]
  [-K application intent]
  [-M multisubnet failover]
  [-b On error batch abort]
  [-v var = "value"...]  [-A dedicated admin connection]
  [-X[1] disable commands, startup script, environment variables [and exit]]
  [-x disable variable substitution]
  [-j Print raw error messages]
  [-g enable column encryption]
  [-G use Azure Active Directory for authentication]
  [-? show syntax summary]
```

Create a new database:

```shell
1> CREATE DATABASE MyDatabaseName
2> GO
```

SQL Server creates the database on disk here: `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\`.

_.mdf file_ - SQL Server Database Primary Data File

_.ldf file_ - SQL Server Database Transaction Log File

_Filegroup_ - You can split a database across multiple files by using filegroups. Interesting use case: sequestering your east-coast data into a separate database so that the physical servers serving the East coast are closer to the relevant customers. 

### Tables

Types of Tables

* Table
* Memory Optimized Table - can work with data in-memory, improving read/write speeds 
* Temporal Table - has a built-in change history mechanism that tracks all changes that have been made to the data
* Ledger Table - an encrypted table that can show evidence of tampering as well as maintains a record of previous data values 
* Graph Table - stores data like a node-connected graph
* External Table - for Hadoop and Azure
* File Table - for storing files inside of a database 

`dbo.` stands for "database owner" and is the default schema that will be used in your table names if you don't provide a schema name.

It's difficult to change Tables after they are created so try your best to think through the table design thoroughly beforehand. 

Import a CSV file & create a new table using SSMS: 

* Right-click on db -> Tasks -> Import Flat File...

Import just the data from a CSV file (without creating a new table) using SSMS: 

* Right-click on db -> Tasks -> Import Data...

### Free Sample Databases from Microsoft

[Github repo: microsoft/sql-server-samples](https://github.com/microsoft/sql-server-samples)

* [Wide World Importers sample database](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0)

Restore a database from a `.bak` file: 

1. Place the `.bak` file into the Backup directory: `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup`
2. Right-click on Databases -> Restore Database...

## Ch. 4 Table Design for Healthy Databases 

### Data Types 

* `bit` 0 or 1. Like a boolean (1 bit)
* `tinyint` 0 to 255 (1 byte)
* `smallint` ~-32,000 to ~32,000 (2 bytes)
* `int` ~-2 billion to ~2 billion (4 bytes) 
* `bigint` ~-9x10<sup>18</sup> to ~9x10<sup>18</sup> (8 bytes)

* `decimal(p,s)` aka `numeric(p,s)` (5 to 17 bytes)
    * _precision (p)_ - total number of digits
    * _scale (s)_ - number of those digits right of decimal point 
* `smallmoney` ~-214,000.0000 to ~214,000.0000 (4 bytes)
* `money` ~-922,000,000,000,000.0000 to ~922,000,000,000,000.0000 (8 bytes)

* `time`
* `date`
* `datetime2`
* `datetimeoffset`

* `char(n)` fixed-len text (1 byte per char)
* `varchar(n)` var-len text (1 byte per char)
* `nchar(n)` fixed-len unicode text (2 bytes per char)
* `nvarchar(n)` var-len unicode text (2 bytes per char)
* `varchar(max)`, `nvarchar(max)` (`max` is a literal) gives you the max size to store text (up to 2GB!)

[Data types (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver16)

### IDs

How to set any int column to be an ID using SSMS:

* Design -> Click on column -> Column Properties -> Identity Specification -> set (Is Identity) = Yes
    * _Identity Increment_ - how much the ID changes when you add a new row 
    * _Identity Seed_ - default/starting value of the ID 

You can grab and drop the column order in the Design panel to change the column order in the table.

### Primary Keys

How to set a table's primary key using SSMS: 

* open table Design panel -> select column -> Right-click -> Set Primary Key

_composite key_ - combining multiple columns together and treating that combination as the unique key. 

### Default Values

Setting the default value of a column using SSMS: 

* Design -> select column -> Column Properties -> Default Value or Binding

`N'blah'` - this syntax means unicode (the N) string with a value of "blah"

### Timestamps

How to set a column to be an automated timestamp using SSMS: 

* Design -> select column
    1. Set the column's type to `datetime2`
    2. Column Properties -> Default Value or Binding -> set the value to `GETDATE()`

### Constraints

_Check constraint_ - a table-level check that automatically runs when data is updated. Like a validation rule.

Add a check constraint using SSMS: 

* Design -> Right-click (anywhere) -> Check Constraints...
* _Expression_ is the meat of the constraint. You can run excel-like functions in the expression. Ex: `LEN(LastName) >= 2`
* This appears to be using `ALTER TABLE` under the hood

_index_ - a pre-sorted copy of a column's values that SQL Server uses to perform optimized searches (like looking up if something's in a dictionary)

_Unique constraint_ - SQL Server makes sure only unique values can be inserted in a given column 

How to enforce a unique constraint using SSMS: 

* Design -> Right-click (anywhere) -> Indexes/Keys... -> set Is Unique to Yes

### Foreign Keys

_foreign key_ - the primary key from some other table which associates two tables together

Implementing a foreign key using SSMS:

* Design -> Right-click (anywhere) -> Relationships... -> Add -> Tables and Columns Specification -> ellipsis button
    * Make sure the primary key and foreign key columns have the exact same data type 

Conventional prefixes

* `PK_` - Primary Key
* `FK_` - Foreign Key
* `CK_` - ChecK constraint
* `IX_` - IndeX
* `UX_` - Unique indeX

## Ch. 5 Structured Query Language 

[Transact-SQL reference (Database Engine)](https://learn.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver16)

T-SQL comments:

```SQL
-- Single line comment

/* 
Block
comment
*/
```

How to generate the CREATE TABLE code using SSMS: 

* Right-click (on a table) -> Script Table as -> CREATE To -> New Query Editor Window

```SQL
CREATE TABLE [dbo].[dbo.Red30Tech_Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderDate] [date] NOT NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Red30Tech_Orders] PRIMARY KEY CLUSTERED
...
```

Example of a check constraint: 

```SQL
ALTER TABLE [dbo].[dbo.Red30Tech_Orders] CHECK CONSTRAINT [FK_dbo.Red30Tech_Orders_Red30Tech_Products]
```


Example of a foreign key constraint: 

```SQL
ALTER TABLE [dbo].[dbo.Red30Tech_Orders]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Red30Tech_Orders_Red30Tech_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Red30Tech_Products] ([ProductID])
```

### Creating Tables

```SQL
CREATE TABLE ProductCategories (
	CategoryID int IDENTITY(1, 1) NOT NULL,
	Name varchar(25) NOT NULL,
	Abbrevation char(2) NOT NULL
);
```

* `IDENTITY(X, Y)` - this function means the ID will start at X and increment by Y. 

### Creating New Data with INSERT

Adding one row:

```SQL
INSERT INTO ProductCategories
(Name, Abbrevation)
VALUES ('Blueprints', 'BP');
```

Adding multiple rows:

```SQL
INSERT INTO ProductCategories
(Name, Abbrevation)
VALUES ('Blueprints', 'BP'),
	('Training Videos', 'TV'),
	('eBooks', 'EB');
```

### Reading Data with SELECT

Fully qualifying the table name:

```SQL
SELECT *
FROM SomeDatabase.SomeSchema.SomeTable;
```

How to limit # of results in the query in T-SQL:

```SQL 
SELECT TOP(5) * 
FROM Customers;
```

More topics covered:

* `SELECT *`
* `TOP(N)`
* `AND`
* `OR`
* `<=`, `>=`
* `WHERE`
* `ORDER BY`
    * `ASC`
    * `DESC`

### Updating Data with UPDATE

Updating data: 

```SQL
UPDATE Orders
SET 
    Quantity = 5
WHERE OrderID = 623423;
```

```SQL
-- !! This updates every row in the table
UPDATE Orders
SET 
    Quantity = 5;
```

### Destroying Data with DELETE 

```SQL
DELETE
FROM Customers
WHERE CustomerID = 7324;
```

```SQL
-- !! This deletes everything in the table
DELETE FROM Customer;
```

If you try and delete data that other tables depend on (ex: a foreign key), the constraints of the database can help protect from the data becoming orphaned. Ex: Attemping to delete a Customer who has a CustomerID that's referenced as a foreign key in the Order table. The foreign key constraint of the Order table would force you to delete the order data before deleting the customer.

Deleting all the rows, but keeping the table and its column definitions:

```SQL
TRUNCATE TABLE Customer;
```

Deleting the whole table (and all the data in it):

```SQL
DROP TABLE Customers;

DROP TABLE IF EXISTS Customers;
```

### Combining Multiple Tables with JOIN

Types of JOINs

* `INNER JOIN` - only the intersecting part of the venn diagram
* `LEFT JOIN` - the whole left circle of the venn diagram
* `RIGHT JOIN` - the whole right circle of the venn diagram
* `LEFT OUTER JOIN` - the left "crescent" (circle minus the middle intersecting part) of the venn diagram
* `RIGHT OUTER JOIN` - the right "crescent" of the venn diagram
* `FULL JOIN` - the whole venn diagram
* `FULL OUTER JOIN` - the whole venn diagram minus the center intersecting part (both left + right "crescents")

Basic join: 

```SQL
SELECT
    Customer.FirstName, 
    Customer.LastName, 
    Orders.Quantity
FROM Customers
INNER JOIN Orders 
ON Customers.CustomerID = Orders.CustomerID;
```

Joining more than two tables: 


```SQL
SELECT
    Customer.FirstName, 
    Customer.LastName, 
    Orders.Quantity,
    Products.Name
FROM Customers
INNER JOIN Orders 
ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Products
ON Orders.ProductID = Products.ProductID;
```

## Ch. 6 Writing Efficient Queries 

### Views

Views are read-only tables that allow you save complex queries.

Creating a view using SSMS: 

* Expand database -> "Views" -> Right-click -> New View
* There's a visual designer interface for designing views
    * Click checkboxes to quickly specify columns
    * Draw lines to quickly specify joins
    * UI for adding sort (ORDER BY) and filter (WHERE) using point-and-click
    * SQL code is generated for you

### Indexes

_Heap_ - a table that lacks an index and must be scanned row-by-row to find things (not performant)

_Index_ - optimizing searching data in a column by pre-organizing the data to allow for optimal algorithms to run (ex: BST, sorted list, etc.)

* Primary keys use clustered indexing by default.
* Unique constraints use indexing

_Clustered index_ - index that uses the same order physically on-disk as it does in the index
_Non-clustered index_ - an index that uses pointers (data on disk is mapped to the index)

Creating an index: 

```SQL
CREATE NONCLUSTERED INDEX IX_Customers_LastName
ON dbo.Customers 
(LastName ASC);
```

Creating an index using SSMS: 

* Design -> Right-click a column -> Indexes/Keys...

### Aggregate Functions 

[What are the SQL database functions?](https://learn.microsoft.com/en-us/sql/t-sql/functions/functions?view=sql-server-ver16)

* `COUNT()`
* `MIN()`, `MAX()`
* `AVG()`
* `SUM()`
* `STDEV()`
* `VAR()` - variance
* `UPPER()` - string to uppercase
* `LOWER()`
* `TRIM()` - for strings

How to count how many values of a column occur within an aggregated group: 

```SQL 
-- For each last name, count how many different first names there are 
SELECT COUNT(FirstName)
FROM Customers
GROUP BY LastName;
```

### Subqueries 

Aka nested query

```SQL
-- Get the tall customers
SELECT * 
FROM Customers
WHERE Customers.Height > 
    (SELECT AVG(Customers.Height) FROM Customers);
```

You can look at the system aggregate functions in SSMS: 

* database -> Programmability -> Functions -> System Functions

### User-Defined Functions

```SQL
CREATE FUNCTION Warehouse.ToFahrenheit (@CelsiusTemp decimal(10, 2)) 
RETURNS decimal(10, 2)
AS 
BEGIN 
    DECLARE @FahrenheitTemp decimal(10, 2);
    SET @FahrenheitTemp = (@CelsiusTemp * 1.8 + 32);
    RETURN @FahrenheitTemp
END;
```

* Functions, like tables, go in a schema (e.g. Warehouse)
* Variables use the prefix `@`
* `RETURNS <type>` is the equivalent of a function's return type in code
* `BEGIN` and `END` are the equivalent of curly braces
* `DECLARE` is the equivalent of a variable definition
* `SET` is used for assignment

Calling a user-defined function:

```SQL
SELECT Warehouse.ToFahrenheit(Temperature)
FROM Warehouse.VehicleTemperatures;
```

### Stored Procedures 

_Stored procedure_ - bundling SQL code that can be re-used

Creating a stored procedure:

```SQL
CREATE PROCEDURE MySchema.myStoredProcedure
AS
-- Complex query goes here
```

* You can also use the shorthand `PROC`

Running a stored procedure:

```SQL
EXECUTE MySchema.myStoredProcedure;
```

* You can also use the shorthand `EXEC`

* `sp_` is reserved for System stored procedures
* `p` and `usp` are conventional prefixes ("procedure" and "user stored procedure" respectively)
* Be sure to use a schema name in the stored procedure name 

Where to browse the user-defined stored procedures using SSMS:

* expand database -> Programmability -> Stored Procedures

A SQL query for listing out the stored procedures:

```SQL
SELECT *
FROM sys.procedures;
```

How to open the SQL of a user-defined stored procedure using SSMS: 

* in Object Explorer, Right-click on stored procedure -> Script Stored Procedure as -> CREATE To -> New Query Editor Window

Defining a stored procedure that has input parameters:

```SQL
CREATE PROCEDURE MySchema.myStoredProcedure
    @MyParam int,
    @AnotherParam nvarchar(50)
AS
BEGIN
    ...
END;
```

Giving a parameter a default value:

```SQL
CREATE PROCEDURE MySchema.myStoredProcedure
    @SomeParam int = 5
AS
BEGIN
    ...
END;
```

Passing in parameter values when running a stored procedure: 

```SQL
EXECUTE MySchema.myStoredProcedure 23, 'Hello'
```

Editing an existing stored procedure:

```SQL
ALTER PROCEDURE MySchema.myStoredProcedure
AS
-- Complex query goes here 
```

Delete a stored procedure:

```SQL
DROP PROCEDURE MySchema.myStoredProcedure;
```

Print statements:

```SQL
PRINT 'hello world'
```

Conditionals:

```SQL
IF @SomeParam = 5
BEGIN
    ...
END
```

## Ch. 7 Backup and Restore 

A `.bak` file is media file, like a container, that contains multiple sets of data. This means you can alter it (for example with a differential backup) without overriding/replacing the file.

### Full Backups

Backing up a db in SSMS:

* Right-click on database -> Tasks -> Back Up...
* _Backup type_
    * _Full_ 
    * _Differential_ - only backup records that have changed since last full backup
    * _Transaction Log_

You can convert the backup action to a SQL script using SSMS: 

* Right-click db -> Tasks -> Back Up... -> Script -> Script Action to New Query Window
    * This can be good for scripting automated backups as part of a larger process

Example of a backup SQL script:

```SQL
BACKUP DATABASE [MyDatabase] TO 
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\MyDatabase.bak'
WITH NOFORMAT,
NOINIT,
NAME = N'MyDatabase-Full Database Backup',
SKIP,
...
```

### Differential Backups

1. Tasks -> Back Up... -> Set Backup type to Differential
2. Use the _same_ .bak file as your previous backups
3. Run

Pros: Differential backups save storage space
Cons: Differential backups make the restoration process more complicated 

Example Recommendation: Perform daily full backups once per day and then the rest of the backups throughout the day are differential backups

### Restoring from a Backup

Kick off a restore using SSMS:

* Right-click on db -> Tasks -> Restore -> Database...
    * Timeline...
        * Shows a visual timeline UI 
        * Allows you to restore a backup to an exact time, even between backups

_Availability Groups_ - feature that provides redundancy for the database across multiple servers 

_Log shipping_ - Slower than availability groups but doesn't require as expensive of server requirements. Uses a standby database with a built-in delay which allows you to catch big issues with the backup in time. Higher riks of data loss than Availability Groups

* Link for Azure SQL Managed Instance - MS manages hardware and servers. Functions like a synced cloud backup. The cloud copy is read-only.

## Ch. 8 Security 

View the login accounts in SSMS: 

* expand server -> Security -> Logins

Add a new login account: 

* Right-click on Logins -> New Login...
* _Enforce password policy_ - this allows admins to enforce password strength requirements on the server.
* Security -> Server Roles
    * The roles for role-based permissions
* Login Properties -> User Mapping 
    * lets you control which databases the user login can access
    * lets you set database-level permissions 

Users can see all the db's on the server (even if they can't access them), but SQL Server Authen users can only see the other SQL Server Auth users.

Server Roles

* _sysadmin_ - can do anything. Highest level
* _serveradmin_ - edit server config settings and shutdown server
* _securityadmin_ - can manage user accounts
* _dbcreator_ - can CREATE, ALTER, DROP, or RESTORE databases
* _public_ - default role for all users

Database-level Permissions

Some of the common ones:

* _db_owner_ - can do anything to the db
* _db_backupoperator_ - can perform backups
* _db_ddladmin_ - can edit table structures, datatypes, constraints, and relationships (ddl stands for data definition language)
* _db_datawriter_ - add, update, and delete data in any table
* _db_datareader_ - read data from any table 
