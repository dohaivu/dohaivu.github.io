---
layout: post
title: "Python Package Installation"
description: ""
categories: [guide]
tags: [python, setup]
published: true
---
This is a short note how to install package from [PyPi](https://pypi.python.org)

<!--break-->

__Support Python 2.7__

## Install Setuptool
Download [setuptools](https://pypi.python.org/pypi/setuptools)

If you run Windows 64bit, download and run `python ez_setup.py`. It will automatically install easytool.exe in Scripts folder

Install download package, run this command

```python
python setup.py install
```

### Install package by easy_install
[Reference](http://peak.telecommunity.com/DevCenter/EasyInstall#using-easy-install)

Install package by name

```python
easy_install SQLObject
```

Download a source, automatically build and install it

```python
easy_install http://example.com/path/to/MyPackage-1.2.3.tgz
```

Install an already-downloaded .egg file

```python
easy_install /my_downloads/OtherPackage-3.2.1-py2.3.egg
```

Upgrade installed package to latest version

```python
easy_install --upgrade PyProtocols
```

### Upgrade packages

Upgrade a specific version

```python
easy_install "SomePackage==2.0"
```

Upgrade package that a version greater than

```python
easy_install "SomePackage>2.0"
```

Upgrade to latest version on PyPi

```python
easy_install --upgrade SomePackage
```

### Uninstall packages

```python
easy_install -mxN PackageName
```