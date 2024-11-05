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
    * Run > SQLCMD
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

SQL Server Services

* SQL Server Browser - used to help end users browse instances to connect to 
* SQL SERVER
* SQL Server Agent - used for scheduling automated processes 

_Right-click (on a service) > Properties > Service > Start Mode_ - sets the default behavior of the service: Automatic vs. Manual. 

How to create a Docker container for your SQL Server instance: 

```shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=YourPasswordHere" -p 1401:1433 --name sqlserver2022 -d mcr.microsoft.com/mssql/server:2022-latest
```
