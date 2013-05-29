---
layout: post
title: "Jasmine Setup"
description: ""
categories: [testing]
tags: [testing, jasmine, frontend]
published: true
---
The first time using Jasmine. This is step by step example:

- [Download the latest version](https://github.com/pivotal/jasmine/downloads)
- Delete files in _/src_ and _/spec_
- Add source files to _/src_: HelloWorld.js

```js
function helloWorld() {
    return "Hello World!";
}
```

- Add test files to _/spec_: HelloWorldSpec.js

```js
describe("Hello world", function() {
    it("says hello", function() {
        expect(helloWorld()).toEqual("Hello world!");
    });
});
```

- Edit file _SpecRunner.html_: include source and spec files in _include source files here_ and _include spec files here_
- Run the _SpecRunner.html_


__References:__

- [Jasmine home](http://pivotal.github.io/jasmine/)
- [How do I Jasmine: a tutorial](http://evanhahn.com/how-do-i-jasmine/)
- [Jasmine wiki](https://github.com/pivotal/jasmine/wiki)
- [Frontend test - stackoverflow](http://stackoverflow.com/questions/11741738/frontend-testing-what-and-how-to-test-and-what-tool-to-use)
- [Test Pyramid](http://martinfowler.com/bliki/TestPyramid.html)