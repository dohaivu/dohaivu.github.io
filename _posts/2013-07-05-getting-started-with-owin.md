---
layout: post
title: "Getting started with OWIN"
description: ""
categories: [dotnet]
tags: [owin, component]
published: true
---
Owin is an Open Web Interface for .NET, it describes how components in a HTTP pipeline should communicate, like NodeJS Connect or Rack.

<!--break-->

Owin has one main interface, every components will communicate through this interface. 

```csharp
Func<IDictionary<string, object>,Task>

//Actual implementation
public Task Invoke(IDictionary<string, object> environment) 
{ 
   var someObject = environment[“some.key”] as SomeObject; 
   // etc… 
}
```

[Owin specs](http://owin.org/spec/owin-1.0.0.html) contains details of IDictionary object.

Owin host will composes multiple middlewares into a application. It will implement the following interface

```csharp
public interface IAppBuilder 
{ 
    IDictionary<string, object> Properties { get; }

    object Build(Type returnType); 
    IAppBuilder New(); 
    IAppBuilder Use(object middleware, params object[] args); 
}
```

We compose middlewares in __Configuration__ method of __Startup__ class. When OwinHost starts, it looks into Configuration method to build up middlewares of our app.

```csharp
public class Startup
{
  public void Configuration(IAppBuilder builder)
  {
      builder.Use(typeof(Logger));      
  }
}
```

Let build a simple logger and a request handler middleware

- Create new blank MVC4 (or MVC5) project __OwinTest__
- Add the following packages:

  __Install-Package Owin__  
  __Install-Package Install-Package Microsoft.Owin.Host.HttpListener -Pre__

- Create a new class __Logger__ and enter the following code

```csharp
using System.Collections.Generic;
using System.Threading.Tasks;
using AppFunc = System.Func<System.Collections.Generic.IDictionary<string, object>, System.Threading.Tasks.Task>;

public class Logger
{
    private readonly AppFunc _next;
    public Logger(AppFunc next)
    {
        if(next == null)
        {
          throw new ArgumentNullException("next");
        }
        _next = next;
    }
    public Task Invoke(IDictionary<string, object> environment)
    {
        System.Diagnostics.Trace.WriteLine(string.Format("{0} {1}",DateTime.Now, environment["owin.RequestPath"]));
        return _next(environment);
    }
}

```

- Create a class __Startup__ and enter the following code

```csharp
public class Startup
{
  public void Configuration(IAppBuilder builder)
  {
      builder.Use(typeof(Logger));      
  }
}
```

- Download [Katana hosting](http://katanaproject.codeplex.com/releases/view/102220), extract to __C:\\__ (or any folder)
- Open Project property, confiure __Start external program__  
![Project property](/images/posts/2013-07-05-getting-started-with-owin_projectproperty.png)
- Press __F5__ and browse __http://localhost:8080__ the console will show like this
![console result](/images/posts/2013-07-05-getting-started-with-owin_consoleresult.png)

- Add a class __HelloRequestHandler__ and enter the following code

```csharp
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Threading.Tasks;
using AppFunc = System.Func<System.Collections.Generic.IDictionary<string, object>, System.Threading.Tasks.Task>;

public class HelloRequestHandler
{
    private readonly AppFunc _next;
    public HelloRequestHandler(AppFunc next)
    {
        if(next == null)
        {
            throw new ArgumentNullException("next");
        }
        _next = next;
    }
    public Task Invoke(IDictionary<string, object> environment)
    {
        IDictionary<string, string[]> responseHeaders =
                (IDictionary<string, string[]>)environment["owin.ResponseHeaders"];
        var responseBytes = System.Text.ASCIIEncoding.UTF8.GetBytes(
                     string.Format("<h1>Hello world</h1>"));
        Stream responseStream = (Stream)environment["owin.ResponseBody"];

        responseHeaders["Content-Length"] = new string[] { responseBytes.Length.ToString(CultureInfo.InvariantCulture) };
        responseHeaders["Content-Type"] = new string[] { "text/html" };
        responseStream.Write(responseBytes, 0, responseBytes.Length);

        return _next(environment);
    }
}
```

- Add __HelloRequestHandler__ middleware to Startup class

```csharp
public class Startup
{
  public void Configuration(IAppBuilder builder)
  {
      builder.Use(typeof(Logger));
      builder.Use(typeof(HelloRequestHandler));
  }
}
```

- Press __F5__ and browse __http://localhost:8080__ we will see the result like this
![browser result](/images/posts/2013-07-05-getting-started-with-owin_hellorequesthandler.png)



ASP.NET MVC5, WEB API 2, SignalR are compatible with OWIN, so we can compose middlewares or develop middlewares for our application's need.