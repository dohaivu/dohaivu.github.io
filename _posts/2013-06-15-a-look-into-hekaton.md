---
layout: post
title: "A look into SQL Server In-Memory Hekaton engine"
description: ""
categories: [database]
tags: [sqlserver]
published: true
---
Introduction
Hekaton is new in-memory OLTP database engine in SQL Server 2014.

<!--break-->

__Why use hekaton__
Previous SQL Server stores data on disk, only load data to memory when needed to processing

Hekaton's design goals:

- fitting most or all of data required by a workload into main-memory
- lower latency time for data operations
- specialized database engines that specific types of workloads need to be tuned just for those workloads 

In-Memory OLTP removes the issues of waiting locks to be released using a completely new type of multi-version optimistic concurrency control.

Competitor

Using
__Create databases__
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

__Create tables__
Support all datatypes except LOB, all rows will be limited to 8060 bytes.

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

__Storage__  
__Memory optimized table__: no need to read from disk. A set of checkpoint files are used for recovery that keep track the changes of data. Transaction log is stored on disk, the same as disk-based tables. If server crash, the rows of data can be created from checkpoint files and transaction logs.

Non-durable table (SCHEMA_ONLY) is only available on memory. It does not require any IO operations, so data will be lost when server shutdown. But it's useful for temp data, caches, web server sessions.

### Indexes on memory-optimized tables: Hash index
They are not stored as traditional B-trees.
Memory-optimized tables are never stored as unorganized sets of rows, like a disk-based table heap is stored.  
Indexes are never stored on disk, operation are not logged. When SQL Server restart, indexes will be rebuilt.

Hash index is an array of hash bucket that is a pointer.  
In the example below, hash function is the length of name, city column.
<img src="/images/posts/2013-06-15-a-look-into-hekaton_hash-index.png" />

### Native compiled stored procedures

### Rows
Rows are allocated from structures called heaps. Rows for a single table are not necessarily stored near other rows from the same table and the only way SQL Server knows what rows belong to the same table is because they are all connected using the tables’ indexes.

Each row consists of a header and a payload containing the row attributes.
<img src="/images/posts/2013-06-15-a-look-into-hekaton_rows.png" />

__Data operation__