---
layout: post
title: "Logging Application Block"
description: ""
categories: [library]
tags: [entlib, logging]
published: true
---
The Logging block in Enterprise Library 6 is enhanced with some nice features:
- Support asynchronous
- JSON formatter
- Priority filter
- LoggingEnabled

<!--break-->

### Purpose of logging
- Monitoring application performance: errors, failure
- Providing information: audit user behavior, what tasks are processed, what information are read

The logging application block is highly flexible and configurable solution that allow you to create and store log messages in a wide variety of location, categorize and filter messages

### Configuring the Logging block
We can configure logging block by using programmatic configuration or configuring in web.config

```csharp
// Formatter
TextFormatter briefFormatter = new TextFormatter(...);
// Trace Listener
var flatFileTraceListener = new FlatFileTraceListener(
@"C:\Temp\FlatFile.log", "----------------------------------------", "----------------------------------------", briefFormatter);
// Build Configuration
var config = new LoggingConfiguration();
config.AddLogSource("DiskFiles", SourceLevels.All, true).AddTraceListener(flatFileTraceListener);
LogWriter defaultWriter = new LogWriter(config);
```

### Logging Asynchronously
In this new version, Logging block support asynchronous trace lister. You should you this when you have high volume of trace messages, or performance is critical you.

```csharp
var databaseTraceListener = new FormattedDatabaseTraceListener(
DatabaseFactory.CreateDatabase("ExampleDatabase"),"WriteLog", "AddCategory",extendedFormatter);
config.AddLogSource("AsyncDatabase", SourceLevels.All, true).AddAsynchronousTraceListener(databaseTraceListener);
```


```xml
<listeners>
 <add name="Rolling Flat File Trace Listener" type="..." listenerDataType="..." formatter="Text Formatter" rollInterval="Day" asynchronous="true" />
</listeners>
```

### Log category
Categories are the way that Enterprise Library routes events sent to the block to the appropriate target, such as a database, the event log, an e-mail message, and more.

### Filter
#### Filter by category
Use __CategoryFilter__ class to send log entries to a category. You can add multiple categories to your configuration to manage filtering.

#### Filter by priority
This filter has two properties: __Minimum Priority__ and __Maximum Priority__. Only entry that has priority between two values will be logged. Default value is __-1__, mean does not block any log entry.

#### Filtering by Severity in a Trace Listener
We can filter log entries by severity in listener: Error, Information, Debug, Critical

### Formatters
The Logging log provide some formatter: XmlLogFormatter, JsonFormatter, FlatFileFormatter

### Capturing Unprocessed Events and Logging Errors
Capture log that don't match any categories. Configure listener for the following categories

- All Events: receives all events
- Unprocessed Category: receives any log entry that has a category that does not match any configured categories.
- Logging Errors & Warnings:  receives any log entry that causes an error in the logging process

### Testing Logging Filter Status
__ShowDetailsAndAddExtraInfo__ shows whether it is block by specific filters and shows how you can obtain information about the way that the Logging block will handle the log entry.

```csharp
var entry1 = new LogEntry(...);
ShowDetailsAndAddExtraInfo(entry1);

void ShowDetailsAndAddExtraInfo(LogEntry entry)
{
  // Display information about the Trace Sources and Listeners for this LogEntry. 
  IEnumerable<LogSource> sources = defaultWriter.GetMatchingTraceSources(entry);
  foreach (LogSource source in sources)
  {
    Console.WriteLine("Log Source name: '{0}'", source.Name);
    foreach (TraceListener listener in source.Listeners)
    {
      Console.WriteLine(" - Listener name: '{0}'", listener.Name);
    }
  }
  // Check if any filters will block this LogEntry.
  // This approach allows you to check for specific types of filter.
  // If there are no filters of the specified type configured, the GetFilter 
  // method returns null, so check this before calling the ShouldLog method.
  CategoryFilter catFilter = defaultWriter.GetFilter<Ca tegoryFilter>();
  if (null == catFilter || catFilter.ShouldLog(entry.Categories))
  {
    Console.WriteLine("Category Filter(s) will not block this LogEntry.");
  }
  else
  {
    Console.WriteLine("A Category Filter will block this LogEntry.");
  }
  PriorityFilter priFilter = defaultWriter.GetFilter<PriorityFilter>();
  if (null == priFilter || priFilter.ShouldLog(entry.Priority))
  {
    Console.WriteLine("Priority Filter(s) will not block this LogEntry.");
  }
  else
  {
    Console.WriteLine("A Priority Filter will block this LogEntry.");
  }
  // Alternatively, a simple approach can be used to check for any type of filter
  if (defaultWriter.ShouldLog(entry))
  {
    Console.WriteLine("This LogEntry will not be blocked by config settings.");
    // Add context information to log entries after checking that the log entry
    // will not be blocked due to configuration settings. See the following
    // section 'Adding Additional Context Information' for details.
  }
  else
  {
    Console.WriteLine("This LogEntry will be blocked by configuration settings.");
  }
}
```

### Add additional information
Collect some useful information from environment. Some helper classes
- DebugInformationProvider
- ManagedSecurityContextInformationProvider
- UnmanagedSecurityContextInformationProvider: user name and process account name
- ComPlusInformationProvider

```csharp
...
// Create additional context information to add to the LogEntry. 
Dictionary<string, object> dict = new Dictionary<string, object>();
// Use the information helper classes to get information about 
// the environment and add it to the dictionary.
DebugInformationProvider debugHelper = new DebugInformationProvider();
debugHelper.PopulateDictionary(dict);

ManagedSecurityContextInformationProvider infoHelper = new ManagedSecurityContextInformationProvider();
infoHelper.PopulateDictionary(dict);

UnmanagedSecurityContextInformationProvider secHelper = new UnmanagedSecurityContextInformationProvider();
secHelper.PopulateDictionary(dict);

ComPlusInformationProvider comHelper = new ComPlusInformationProvider();
comHelper.PopulateDictionary(dict);

// Get any other information you require and add it to the dictionary.
string configInfo = File.ReadAllText(@"..\..\App.config");
dict.Add("Config information", configInfo);

// Set dictionary in the LogEntry and write it using the default LogWriter.
entry.ExtendedProperties = dict;
defaultWriter.Write(entry);
....
```

### Creating Custom Trace Listeners, Filters, and Formatters
- Custom __Filter__: implement __ILogFilter__
- Custom __Listener__: inherit from the abstract base class __CustomTraceListener__
- Custom __Formatter__: implement __ILogFormatter__, or inherit __LogFormatter__