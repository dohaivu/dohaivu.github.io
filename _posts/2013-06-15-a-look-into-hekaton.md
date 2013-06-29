---
layout: post
title: "A look into SQL Server In-Memory Hekaton engine"
description: ""
categories: [database]
tags: [sqlserver]
published: true
---
Hekaton is a new in-memory OLTP database engine in SQL Server 2014. It's inside SQL Server, so it does not require a separate hardware, or seperate database.

<!--break-->

Previous SQL Server stores data on disk, only load data to memory when needed to processing. In Hekaton everything is in memory, it does not need to load data from disk. It also has new HASH INDEX structure, compiled stored procedures. So it's extremely fast.

Hekaton's design goals:

- fitting most or all of data required by a workload into main-memory
- lower latency time for data operations
- specialized database engines that specific types of workloads need to be tuned just for those workloads 

In-Memory OLTP removes the issues of waiting locks to be released using a completely new type of multi-version optimistic concurrency control.

### Memory optimized table
It is no need to read from disk. A set of checkpoint files are used for recovery that keep track the changes of data. Transaction log is stored on disk, the same as disk-based tables. If server crash, the rows of data can be created from checkpoint files and transaction logs.

Non-durable table (SCHEMA_ONLY) is only available on memory. It does not require any IO operations, so data will be lost when server shutdown. But it's useful for temp data, caches, web server sessions.

### Rows
Rows are allocated from structures called heaps. Rows for a single table are not necessarily stored near other rows from the same table and the only way SQL Server knows what rows belong to the same table is because they are all connected using the tables’ indexes.

Each row consists of a header and a payload containing the row attributes.
<img src="/images/posts/2013-06-15-a-look-into-hekaton_rows.png" />

### Indexes on memory-optimized tables: Hash index
They are not stored as traditional B-trees.
Memory-optimized tables are never stored as unorganized sets of rows, like a disk-based table heap is stored.  
Indexes are never stored on disk, operation are not logged. When SQL Server restart, indexes will be rebuilt.

Hash index is an array of hash bucket that is a pointer.  
In the example below, hash function is the length of name, city column. The row with name "Greg" whose length is 4, the hash bucket with value 4 will pointer to this row. Another rows with the same value is linked into the same chain 
<img src="/images/posts/2013-06-15-a-look-into-hekaton_hash-index.png" />

A pointer is 2 bytes in row header that follows IdxLinkCount.

### Native compiled stored procedures
Hekaton translates it to C and then compile it to a DLL. So it does not need compile at run time. Performance improves 10X to 25X time.

### Interpreted TSQL
We can access full TSQL but performance is not good as native compiled stored procedures.

### Transaction Isolation levels
The following isolation levels are supported for transactions accessing memory-optimized tables

- Snapshot
- Repeatable Read
- Serializable

### Validation
Prior to the final commit of transactions involving memory-optimized tables, SQL Server performs a validation step. Because no locks are acquired during data modifications, it is possible that the data 
changes could result in invalid data based on the requested isolation level

### Create database
Add `MEMORY_OPTIMIZED_DATA` filegroups for checkpoint files.

```sql
CREATE DATABASE HKDB
ON 
PRIMARY(NAME = [HKDB_data],
FILENAME = 'Q:\data\HKDB_data.mdf', size=500MB),
FILEGROUP [SampleDB_mod_fg] CONTAINS MEMORY_OPTIMIZED_DATA
(NAME = [HKDB_mod_dir], FILENAME = 'R:\data\HKDB_mod_dir'),
(NAME = [HKDB_mod_dir], FILENAME = 'S:\data\HKDB_mod_dir')
LOG ON (name = [SampleDB_log], Filename='L:\log\HKDB_log.ldf', size=500MB)
COLLATE Latin1_General_100_BIN2;
```

### Create tables
Hekaton support all datatypes except LOB, all rows will be limited to 8060 bytes. Add __MEMORY_OPTIMIZED__ and __DURABILITY__ hints to the create statement.

```sql
CREATE TABLE T1
(
[Name] varchar(32) not null PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1024),
[City] varchar(32) null,
[LastModified] datetime not null,
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA)
```

Limitation:  
- No DML triggers
- No FOREIGN KEY or CHECK constraints
- No IDENTITY columns
- No UNIQUE indexes other than for the PRIMARY KEY
- A maximum of 8 indexes, including the index supporting the PRIMARY KE
- No Schema changes, No DDL command(CREATE INDEX, ALTER INDEX,...) 


Hekaton is very fast database, so it is good to store session data, user profiles, or cached data.