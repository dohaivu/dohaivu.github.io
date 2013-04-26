---
layout: post
title: "How to localize API"
description: ""
categories: []
tags: []
published: false
---
Terms:
- __Internationalization(I18n)__: structure your application in a way that makes it possible to be localized
- __Localization(L10n)__: make an application work for a particular culture

ISO standards:
- ISO 639: language codes
- ISO 3166-1 alpha-2: country codes
- ISO 4217: currency codes
- ISO 8601: dates/time format

__How to implement in REST API?__

Use HTTP header _Accept-Language_

Example:

```
  GET /movie/gone_with_the_wind HTTP/1.1
  Host: www.example.org
  Accept-Language: en,en-US,fr;q=0.6  
```

For currency we can use: HTTP header: X-Currency

