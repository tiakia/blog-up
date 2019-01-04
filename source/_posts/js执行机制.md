---
title: js中的事件执行机制
date: '2018-11-15 16:58'
categories: javascript
tags:
  - js
  - promise
  - setTimeout
keywords:
  - promise
comments: true
abbrlink: 37168
thumbnailImage:
coverCaption:
---

以前理解的事件只有同步任务和异步任务，后来知道我看到了一篇文章。。。
我们常见到的是这样的给你一段代码，说出执行顺序，

```javascript
setTimeout(() => {
  console.log("异步任务setTimeout");
}, 3000);
console.log("同步任务");
```

按照同步优先，异步靠后的规则，先执行完所有的同步任务后，再开始执行异步任务，很快的得出结论

<!-- more -->

```bash
同步任务
异步任务setTimeout
```

然后有一天你看到了这样的代码

```javascript
setTimeout(() => {
  console.log("setTimeout");
});
console.log("同步任务");
new Promise(resolve => {
  console.log("promise");
  resolve();
}).then(() => console.log("promise-then"));
```

**黑人问号脸.jpg**
这就有点触及到我的知识盲区了。。。

先上答案

```javascript
同步任务;
promise;
promise - then;
setTimeout;
```

### 微任务 && 宏任务

这里其实有个概念我们没认识就是微任务和宏任务，javascript 是一门单线程的语言，除了广义的同步任务和异步任务，我们对任务有更精细的定义：

- macro-task(宏任务)：包括整体代码 script，setTimeout，setInterval
- micro-task(微任务)：Promise，process.nextTick(nodejs)

js 的事件循环是这样的，进入后，进行宏任务事件循环，遇到宏任务异步代码，压入宏任务异步任务栈等待执行，遇到微任务异步压入微任务的异步任务栈等待执行，在完成第一次宏任务循环后，先查看微任务异步栈中有没有任务，如果有先执行所有的异步微任务，然后再开始第二次的宏任务循环，开始执行宏任务的异步任务。
我们跟着文章开始的代码来走一遍：

```javascript
setTimeout(() => {
  console.log("setTimeout");
});
console.log("同步任务");
new Promise(resolve => {
  console.log("promise");
  resolve();
}).then(() => console.log("promise-then"));
```

- 第一次宏任务循环，遇到`setTimeout`，压入宏任务的异步栈，等待执行
- 继续遇到 `console.log` 执行 输出 `同步任务`
- 遇到`Promise`，并且`resolve`直接输出`promise`
- `Promise`的`then`压入微任务的异步栈等待执行
- 第一次宏任务循环结束，查看是否有微任务，执行`then`操作，输出`promise-then`
- 开始第二次宏任务循环，在异步栈中发现了`setTimeout`，输出`setTimeout`

总结来说就是，先进行同步宏任务，宏任务完成后先查看一下是否有`prmise`之类的微任务，执行完微任务后再执行宏任务的异步任务。
我们一起来走一下这个例子看看是否已经搞懂了事件执行机制

```javascript
console.log("1");

setTimeout(function() {
  console.log("2");
  process.nextTick(function() {
    console.log("3");
  });
  new Promise(function(resolve) {
    console.log("4");
    resolve();
  }).then(function() {
    console.log("5");
  });
});
process.nextTick(function() {
  console.log("6");
});
new Promise(function(resolve) {
  console.log("7");
  resolve();
}).then(function() {
  console.log("8");
});

setTimeout(function() {
  console.log("9");
  process.nextTick(function() {
    console.log("10");
  });
  new Promise(function(resolve) {
    console.log("11");
    resolve();
  }).then(function() {
    console.log("12");
  });
});
```

- 事件开始执行，遇到 `console.log` 直接输出`1`
- 遇到 `setTimeout` 压入宏任务异步栈等待执行
- 遇到`process.nextTick`压入微任务异步栈等待执行
- 遇到`Promise`,直接输出`7`，并且已经`resolve`，那么对应的`then`压入微任务异步栈等待执行
- 遇到`setTimeout`压入宏任务异步栈，这里标记为`setTimeout2`
- 第一次宏任务事件结束，我们来查看一下事件栈，是否有微任务，如果有先执行

| 宏任务异步栈 | 微任务异步栈     |
| ------------ | ---------------- |
| setTimeout   | process.nextTick |
| setTimeout2  | promise.then     |

- 执行微任务异步栈，执行`process.nextTick`输出`6`,然后再执行 `promise.then`，输入`8`

- 这样在第一次事件循环结束后，输出了`1`/`7`/`6`/`8`

- 开始第二次的事件循环

- 执行`setTimeout`遇到`console`直接执行，输出`2`,遇到`process.nextTick`压入微任务异步栈

- 遇到`promise`,执行`console`输出`4`,并且已经`resolve`执行，将`then`压入微任务异步栈

- 这一次的宏任务事件执行结束查看一下是否微任务异步栈，是否有微任务等待执行

| 宏任务异步栈 | 微任务异步栈     |
| ------------ | ---------------- |
| setTimeout2  | process.nextTick |
| 空           | promise.then     |

- 执行微任务异步栈，`process.nextTick`输出`3`,执行`promise.then`输出`5`

- 第二次事件循环结束后，输出了`2`/`4`/`3`/`5`

- 开始第三次宏任务事件

- `setTimeout2`中遇到`console`直接输出`9`,`process.nextTick`压入微任务异步栈等待执行

- 遇到`Promise`直接执行，输出`11`,已经`resolve`了把`then`代码压入微任务异步栈等待执行

- 这一次的宏任务事件执行结束查看一下是否微任务异步栈，是否有微任务等待执行

| 宏任务异步栈 | 微任务异步栈     |
| ------------ | ---------------- |
| 空           | process.nextTick |
| 空           | promise.then     |

- 执行`process.nextTick`输出`10`,执行`promise.then`输出`12`

- 这一次事件循环结束后，输出`9`/`11`/`10`/`12`
- 这样三次事件循环下来，依次输出了`1`/`7`/`6`/`8`/`2`/`4`/`3`/`5`/`9`/`11`/`10`/`12`

值得深思：

1. `setInterval(fn,ms)`来说，我们已经知道不是每过`ms`秒会执行一次`fn`，而是每过`m`s 秒，会有`fn`进入`Event Queue`。一旦`setInterval`的回调函数`fn`执行时间超过了延迟时间`ms`，那么就完全看不出来有时间间隔了
2. `setTimeout(fn,0)`的含义是，指定某个任务在主线程最早可得的空闲时间执行，意思就是不用再等多少秒了，只要主线程执行栈内的同步任务全部执行完成，栈为空就马上执行

> 参考链接

[这一次彻底弄懂 JavaScript 执行机制](https://juejin.im/post/59e85eebf265da430d571f89)
