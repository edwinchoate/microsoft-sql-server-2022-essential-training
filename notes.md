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
    1. Run > `sqlcmd`
    2. Run Command Prompt then type `sqlcmd` and hit enter
* [mssql-cli command-line query tool for SQL Server](https://learn.microsoft.com/en-us/sql/tools/mssql-cli?view=sql-server-ver16)
* SQL Server Management Studio (SSMS) is Windows-Only
* SQL Server Installation Center
* Azure Data Studio (Windows, Mac, and Linux)

How to check SQL version via SQLCMD: 

```shell
1> select @@Version
2> go
```

How to list all databases on the server via SQLCMD: 

```shell
1> sp_databases
2> go
```

(`sp_` stands for stored procedure.)

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
2> go
```

SQL Server creates the database on disk here: `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\`.

_.mdf file_ - SQL Server Database Primary Data File

_.ldf file_ - SQL Server Database Transaction Log File

_Filegroup_ - You can split a database across multiple files by using filegroups. Interesting use case: sequestering your east-coast data into a separate database so that the physical servers serving the East coast are closer to the relevant customers. 

### Tables

Types of Tables

* Table
* Memory Optimized Table - can work with data in-memory, improving read/write speeds 
* Temporary Table - has a built-in change history mechanism that tracks all changes that have been made to the data
* Ledger Table - an encrypted table that can show evidence of tampering as well as maintains a record of previous data values 
* Graph Table - stores data like a node-connected graph
* External Table - for Hadoop and Azure
* File Table - for storing files inside of a database 

`dbo.` stands for "database owner" and is the default schema that will be used in your table names if you don't provide a schema name.

How to create a simple table: 

```SQL
CREATE TABLE Customers (
	FirstName nvarchar(50) NOT NULL, 
	LastName nvarchar(50) NOT NULL,
	Address nvarchar(100),
	City nvarchar(50),
	State nvarchar(50)
);
```

It's difficult to change Tables after they are created so try your best to think through the table design thoroughly beforehand. 

Inserting a row of data into a table:

```SQL
INSERT INTO Customers
(FirstName, LastName, State)
VALUES ('Bob', 'Smith', 'TN');
```

Updating data: 

```SQL
UPDATE Customers
SET
    City = 'Chicago'
WHERE FirstName = 'Billy';
```

How to limit # of results in the query in T-SQL:

```SQL 
SELECT TOP(5) * 
FROM Customers;
```

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
