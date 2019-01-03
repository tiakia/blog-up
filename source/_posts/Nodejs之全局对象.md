---
title: Nodejs之全局对象
tags:
  - nodejs
categories: nodejs
abbrlink: 23313
date: 2018-04-11 11:01:28
description:
thumbnail:
keywords:
---

### \_\_filename

当前文件被解析过后的绝对路径，该属性其实并非是全局的，而是模块作用域下的

<!-- more  -->

### \_\_dirname

返回当前模块文件所在目录解析后的绝对路径，该属性也不是全局的

### module

- 保存提供和当前模块有关的一些信息
- 在 module 对象，有一个子对象： exports 对象 我们可以通过这个对象把一个模块中的局部变量对象进行提供访问

### process

- node 中的全局对象为**global**而不是 window
- process 就是 global 对象的属性
- 描述了当前 nodejs 进程状态的对象

下面列举几个常用的 process 属性

| 属性     | 描述                                                                    |
| -------- | ----------------------------------------------------------------------- |
| stdout   | 标准的输出流                                                            |
| stdin    | 标准输入流                                                              |
| env      | 返回一个对象，成员为当前 shell 的环境变量                               |
| pid      | 当前进程的进程号                                                        |
| title    | 进程名，默认值为"node"，可以自定义该值。                                |
| arch     | 当前 CPU 的架构：'arm'、'ia32' 或者 'x64'                               |
| platform | 运行程序所在的平台系统 'darwin', 'freebsd', 'linux', 'sunos' 或 'win32' |
| cwd()    | 返回当前进程的工作目录                                                  |

例如：返回 a+b 的值

```javascript
//默认情况下输入流是关闭的，要监听处理输入流数据，首先要开启输入流
process.stdin.resume();

var a, b;

process.stdout.write("请输入a的值： ");

process.stdin.on("data", function(chunk) {
  if (!a) {
    a = Number(chunk);
    process.stdout.write("请输入b的值： ");
  } else {
    b = Number(chunk);

    process.stdout.write("a+b= " + (a + b));
  }
});
```

### setTimeout(cb, ms)

### clearTimeout(t)

### setInterval(cb, ms)

### console

| 方法              | 描述                             |
| ----------------- | -------------------------------- |
| console.log()     |
| console.info()    | 该命令的作用是返回信息性消息     |
| console.error()   | 输出错误消息的                   |
| console.warn()    | 输出警告消息                     |
| console.dir()     | 用来对一个对象进行检查           |
| console.time()    | 输出时间，表示计时开始。         |
| console.timeEnd() | 结束时间，表示计时结束。         |
| console.trace()   | 当前执行的代码在堆栈中的调用路径 |
| console.assert()  | 用于判断某个表达式或变量是否为真 |

```javascript
console.trace();
//当前执行的代码在堆栈中的调用路径，
//这个测试函数运行很有帮助，只要给想测试的函数里面加入 console.trace 就行了。
console.assert();
//接收两个参数，第一个参数是表达式，第二个参数是字符串。
//只有当第一个参数为false，才会输出第二个参数，否则不会有任何结果。
```
