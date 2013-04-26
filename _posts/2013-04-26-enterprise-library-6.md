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

Enterprise Library is a collection of application block, each managing a specific crosscutting concern. Crosscutting concerns are task thats you implement in various places in your application. The risk of that is your team will implement differently in your application. Enterprise Library application block make it easy to manage by providing generic and configurable functionality that you can customize and manage.

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


