---
title: nodejs之利用buffer转换数据
abbrlink: 36498
date: 2019-11-11 09:20:27
tags: nodejs
categories: nodejs
---
Nodejs从8.0版本以后开始对buffer的声明有了区分，原来`new Buffer`的声明方式已经被废弃了，改为了单独的`Buffer.form()`,`Buffer.alloc()`,`Buffer.allocUnsafe()`。
<!-- more -->
- `Buffer.from(array)`返回一个新的`Buffer`，其中包含提供的八位字节数的副本。

- `Buffer.from(arrayBuffer[, byteOffset [, length]])` 返回一个新的`Buffer`,它与给定的 `ArrayBuffer` 共享相同的已分配内存。

- `Buffer.from(buffer)` 返回一个新的`Buffer`,其中包含给定 `Buffer` 的内容的副本。

- `Buffer.from(string[, encoding])` 返回一个新的`Buffer`，其中包含提供的字符串副本。

- `Buffer.alloc(size[, fill [, encoding]])` 返回一个指定大小的新建的已初始化的`Buffer`.此方法比`Buffer.allocUnsafe(size)`慢，但能确保新建的`Buffer`实例永远不会包含可能敏感的旧数据。如果`size`不是数字，则将会跑出`TypeError`

- `Buffer.allocUnsafe(size)` 和 `Buffer.allocUnsafeSlow(size)`分别返回一个指定大小的新建的未初始化的`Buffer`,由于`Buffer`是未初始化的，因此分配的内存片段可能包含敏感的旧数据。

今天我们用到的就是`Buffer.from()`，当字符串数据被存储入`Buffer`实例或从`Buffer`实例中被提取时，可以指定一个编码：
```javascript
const buf = Buffer.from('hello world', 'ascii');

console.log(buf.toString('hex'));
// 打印: 68656c6c6f20776f726c64
console.log(buf.toString('base64'));
// 打印: aGVsbG8gd29ybGQ=

console.log(Buffer.from('fhqwhgads', 'ascii'));
// 打印: <Buffer 66 68 71 77 68 67 61 64 73>
console.log(Buffer.from('fhqwhgads', 'utf16le'));
// 打印: <Buffer 66 00 68 00 71 00 77 00 68 00 67 00 61 00 64 00 73 00>
```
### Nodejs支持的字符编码
- `ascii`
- `utf8`
- `utf16le`
- `ucs2`: `utf16e`的别名
- `base64`
- `latin1`
- `binary`
- `hex`

### 数据转换

数据转换都是通过创建一个`Buffer`,然后通过`buf.toString([encoding])`转换为所需的数据格式.

第一步： 转换`Buffer`数据，`Buffer.from(string[,encoding])`

第二步： `Buffer`数据转换为所需的数据`buf.toString([encoding])`

### 字符串转换为buffer
```javascript
const str = 'hello world';
const buf = Buffer.from(str);

console.log(buf);
// <Buffer 68 65 6c 6c 6f 20 77 6f 72 6c 64>
console.log(buf.toString());
// hello world
```

### 字符串转为base64
- base64编码
```javascript
const str = 'hello world';
const buf = Buffer.from(str);

const base64 = buf.toString('base64');

console.log(base64);
// aGVsbG8gd29ybGQ=
```
- base64解码
```javascript
const base64Buf = Buffer.from(base64,'base64');

const str = base64Buf.toString();

console.log(str);
// hello world;
```
