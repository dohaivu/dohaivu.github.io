---
layout: post
title: "Enterprise Library 6"
description: ""
categories: [library]
tags: [entlib, logging, unity]
published: true
---
I'm very excited that [Enterprise Library 6 has released](http://blogs.msdn.com/b/agile/archive/2013/04/25/just-released-microsoft-enterprise-library-6.aspx). I have used this library for a long time. It's very useful and powerful, it saves me a lot of time.

I will explore what changes in this release

Links:
- [MSDN Enterprise Library 6](http://msdn.microsoft.com/en-US/library/dn169621.aspx)
- [Enterprise Library 6 Project Home](http://entlib.codeplex.com/wikipage?title=EntLib6&referringTitle=Home)

__What is Enterprise Library?__

Enterprise Library is a collection of application blocks, each aimed at managing specific crosscutting concerns. Crosscutting concerns are task thats you implement in various places in your application. The risk of that is your team will implement differently in your application. Enterprise Library application block make it easy to manage by providing generic and configurable functionality that you can customize and manage.

Enterprise Library 6 contains the following application blocks:
- Data Access
- Exception Handling
- Logging
- Policy Injection
- Semantic Logging
- Transient Fault Handling
- Unity
- Validation

I will develop a Web app to explore how it work

## Install Enterprise Library 6
- Reference assemblies to your project if you [downloaded](http://www.microsoft.com/en-us/download/details.aspx?id=38789) and installed it manually .
- Use NuGet package manager

## Data Access Application Block
The Data Access Application Block provide two key advantages: 
- abstracts the actual database, so you can switch from one database to another
- easy to write the most commonly used tasks.

### Configuring the Block and add assemblies
We can configure the default database in web.config. [Enterprise Library configuration tool](http://www.microsoft.com/en-us/download/details.aspx?id=38789) provide us a GUI interface for easier to config

```xml
<?xml version="1.0"?>
<configuration>
<configSections>
  <section name="dataConfiguration" type="Microsoft.Practices.EnterpriseLibrary.Data.Configuration.DatabaseSettings, Microsoft.Practices.EnterpriseLibrary.Data" requirePermission="true"/>
</configSections>
<dataConfiguration defaultDatabase="BookDatabase"/>
<connectionStrings>
  <add name="BookDatabase" connectionString="Server=SqlServer;Database=Book;User Id=sa;Password=Password@123;Connection Timeout=30;" providerName="System.Data.SqlClient" />
</connectionStrings>
...
</configuration>
```
### Create database instances

```csharp
//load config from web.config
DatabaseProviderFactory dbFactory = new DatabaseProviderFactory();
//create database use default config
SqlDatabase db = dbFactory.CreateDefault() as SqlDatabase;            
```

### Manage connections
ADO.NET often holds a pool of connections. ADO.NET automatically retrieves connections from the pool when possible, otherwise it will create a new connection. It also decide when and whether to close the underlying connections and dispose it.

The Data Access Block helps you manage your database connection automatically.

__ExecuteDataSet__ method will open and close connection automatically. In contrast, __ExecuteReader__ open connection, but do not close it automatically. You can change __CommandBahavior__ property by setting it to __CloseConnection__, so that it will close database connection automatically when you dispose the reader.

#### Transactions
__Connection based transaction__

```csharp
using (DbConnection conn = db.CreateConnection())
{
  conn.Open();
  DbTransaction trans = conn.BeginTransaction();
  try
  {
    // execute commands, passing in the current transaction to each one
    db.ExecuteNonQuery(cmdA, trans);
    db.ExecuteNonQuery(cmdB, trans);
    trans.Commit(); // commit the transaction
  }
  catch
  {
    trans.Rollback(); // rollback the transaction
  }
} 
```
__Distributed Transaction__: access different database as part of the same transaction. Data Access will automatically detect if commands are executed within the scope of a transaction

```csharp
using (TransactionScope scope = new TransactionScope(TransactionScopeOption.RequiresNew))
{
  // perform data access here
} 
```




