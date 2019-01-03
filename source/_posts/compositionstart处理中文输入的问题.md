---
title: compositionstart/end 处理中文输入问题
date: '2018-09-06 15:43'
categories: javascript
tags:
  - js
keywords:
  - compositionstart
clearReading: true
coverMeta: in
coverSize: full
comments: true
abbrlink: 38500
thumbnailImage:
coverCaption:
---

问题的引出在上一次写的 防抖 节流中，在防抖的 input 框输入的时候发现我输入的中文结果控制台显示出来的是拼音，然后就找到这俩个函数 `compositionstart` 和 `compositionend`

<!-- more -->

### compositionstart

该事件仅在若干可见字符的输入之前，而这些可见字符的输入可能需要一连串的键盘操作、语音识别或者点击输入法的。

### compositionend

该事件触发于可见字符输入完成之后。

和`input`三个事件发生的顺序是:

- `compositionstart`
- `input`
- `compositionend`

触发`compositionstart`时，会同时触发`input`事件；最后输入完成时，触发`compositionend`。

选词结束的时候`input`会比`compositionend`先一步触发，此时 isLock 还未调整为 false，所以不能触发到 console，所以这里需要 `setTimeout` 的无阻塞模式，让 console 优先级排到最后，才能在`compositionend` 事件触发后打印出值

```javascript
//处理中文输入的问题
let inputChina = document.getElementById("inputChina"),
  isLock = true,
  timer = null;
inputChina.addEventListener("compositionstart", function(e) {
  isLock = true;
  console.log("compositionstart: " + e.target.value);
});
inputChina.addEventListener("input", function(e) {
  console.log("input: " + e.target.value);
  timer = setTimeout(() => {
    if (!isLock) {
      console.log("correct: " + e.target.value);
    }
  }, 0);
  timer = null;
});
inputChina.addEventListener("compositionend", function(e) {
  isLock = false;
  console.log("compositionend: " + e.target.value);
});
```

> 参考链接

[博客园大神](https://www.cnblogs.com/lonhon/p/7643095.html)
