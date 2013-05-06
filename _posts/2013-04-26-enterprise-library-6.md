---
layout: post
title: "Enterprise Library 6"
description: ""
categories: [library]
tags: [entlib, logging, unity]
published: false
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
The Data Access Application Block abstracts the actual database you are using, and exposes a series of methods that make it easy to access that database to perform common tasks.

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

```cs
//load config from web.config
DatabaseProviderFactory dbFactory = new DatabaseProviderFactory();
//create database use default config
SqlDatabase db = dbFactory.CreateDefault() as SqlDatabase;            
```


