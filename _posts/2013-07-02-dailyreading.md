---
layout: post
title: "Daily Reading - Tuesday, July 02 2013"
description: ""
categories: [dailyreading]
tags: [dailyreading]
published: true
---
[Enough with the JavaScript already!](http://www.slideshare.net/nzakas/enough-withthejavascriptalready)

<!--break-->

[Design Patterns after Design is Done](http://java.dzone.com/articles/design-patterns-after-design)
> A study on design patterns and software quality at the University of Montreal (2008) found that design patterns in practice do not always improve code quality, reusability and expandability; and often makes code harder to understand. Some patterns are better than others: __Composite__ makes code easier to follow and easier to change. __Abstract Factory__ makes code more modular and reusable, but at the expense of understandability. __Flyweight__ makes code less expandable and reusable, and much harder to follow. Most developers don’t recognize or understand the __Visitor__ pattern. __Observer__ can be difficult to understand as well, although it does make the code more flexible and extendible. __Chain of Responsibility__ makes code harder to follow, and harder to change or fix safely. And __Singleton__, of course, while simple to recognize and understand, can make code much harder to change.

> Whether you’re designing and writing new code, or changing code, or refactoring code, the best advice is:  

> - Don’t use patterns unless you need to.
- Don’t use patterns that you don’t fully understand.
- Don’t expect that whoever is going to work on the code in the future to recognize and understand the patterns that you used – stick to common patterns, and make them explicit in comments where you think it is important or necessary.
- When you’re changing code, take some time to look for and understand the patterns that might be in place, and decide whether it is worth preserving (or restoring) them: whether doing this will really make the code better and more understandable.

[Browser Link in VS 2013](http://blogs.msdn.com/b/webdev/archive/2013/06/28/browser-link-feature-in-visual-studio-preview-2013.aspx)  
In order to make this feature work, ensure that we have configured:

```xml
<appSettings>
  <add key="vs:EnableBrowserLink" value="true" />
</appSettings>
...
<compilation debug="true" targetFramework="4.5.1" />
...
<modules runAllManagedModulesForAllRequests="true" />
...
```

[Five Patterns to Help You Tame Asynchronous JavaScript](http://tech.pro/blog/1402/five-patterns-to-help-you-tame-asynchronous-javascript)

- Callbacks
- Observer Pattern
- Messaging
- Promises
- Finite State Machines

