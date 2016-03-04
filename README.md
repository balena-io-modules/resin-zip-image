resin-zip-image
===============

> Resin.io Zip image manipulation utilities

[![npm version](https://badge.fury.io/js/resin-zip-image.svg)](http://badge.fury.io/js/resin-zip-image)
[![dependencies](https://david-dm.org/resin-io/resin-zip-image.svg)](https://david-dm.org/resin-io/resin-zip-image.svg)
[![Build Status](https://travis-ci.org/resin-io/resin-zip-image.svg?branch=master)](https://travis-ci.org/resin-io/resin-zip-image)
[![Build status](https://ci.appveyor.com/api/projects/status/d23c10y3o8lxgjbw/branch/master?svg=true)](https://ci.appveyor.com/project/resin-io/resin-zip-image/branch/master)
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/resin-io/chat)

Role
----

The intention of this module is to provide low level utilities to work with Resin.io Zip images.

**THIS MODULE IS LOW LEVEL AND IS NOT MEANT TO BE USED BY END USERS DIRECTLY**.

Installation
------------

Install `resin-zip-image` by running:

```sh
$ npm install --save resin-zip-image
```

Documentation
-------------


* [zip](#module_zip)
    * [.getImageEntries(zip)](#module_zip.getImageEntries) ⇒ <code>Array.&lt;Object&gt;</code>
    * [.isValidZipImage(zip)](#module_zip.isValidZipImage) ⇒ <code>Boolean</code>
    * [.extractImage(zip)](#module_zip.extractImage) ⇒ <code>Promise</code>
    * [.isZip(file)](#module_zip.isZip) ⇒ <code>Boolean</code>

<a name="module_zip.getImageEntries"></a>
### zip.getImageEntries(zip) ⇒ <code>Array.&lt;Object&gt;</code>
This function returns an array of objects that represent
the "image" files found in the zip archive.

**Kind**: static method of <code>[zip](#module_zip)</code>  
**Summary**: Get Zip image entries  
**Returns**: <code>Array.&lt;Object&gt;</code> - image entries  
**Throws**:

- Will throw if the zip is not a zip archive

**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| zip | <code>String</code> | zip file path |

**Example**  
```js
zipImage = require('resin-zip-image')

imageEntries = zipImage.getImageEntries('path/to/archive.zip')

imageEntries.forEach (imageEntry) ->
  console.log(imageEntry.name)
  console.log(imageEntry.size)
```
<a name="module_zip.isValidZipImage"></a>
### zip.isValidZipImage(zip) ⇒ <code>Boolean</code>
A Zip is considered a Zip image if it contains only one
`*.iso` or `*.img` file.

It is still considered valid if it contains an image file
and many other non-image files.

**Kind**: static method of <code>[zip](#module_zip)</code>  
**Summary**: Check if a Zip is a Zip image  
**Returns**: <code>Boolean</code> - whether the zip is a zip image  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| zip | <code>String</code> | zip file path |

**Example**  
```js
zipImage = require('resin-zip-image')

if zipImage.isValidZipImage('path/to/archive.zip')
  console.log('This is a Zip image!')
```
<a name="module_zip.extractImage"></a>
### zip.extractImage(zip) ⇒ <code>Promise</code>
**Kind**: static method of <code>[zip](#module_zip)</code>  
**Summary**: Extract the image file from a Zip image  
**Throws**:

- Will throw if the zip is not a zip image

**Access:** public  
**Fulfil**: <code>ReadableStream</code> - image file  

| Param | Type | Description |
| --- | --- | --- |
| zip | <code>String</code> | zip file path |

**Example**  
```js
zipImage = require('resin-zip-image')

zipImage.extractImage('path/to/archive.zip').then (stream) ->
  stream.pipe(fs.createWriteStream('output.img'))
```
<a name="module_zip.isZip"></a>
### zip.isZip(file) ⇒ <code>Boolean</code>
**Kind**: static method of <code>[zip](#module_zip)</code>  
**Summary**: Check if a file is a zip archive  
**Returns**: <code>Boolean</code> - whether the file is a zip archive  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| file | <code>String</code> | file path |

**Example**  
```js
zipImage = require('resin-zip-image')

if zipImage.isZip('path/to/file')
  console.log('This file is a Zip archive!')
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-zip-image/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/resin-zip-image/issues](https://github.com/resin-io/resin-zip-image/issues)
- Source Code: [github.com/resin-io/resin-zip-image](https://github.com/resin-io/resin-zip-image)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the Apache 2.0 license.
