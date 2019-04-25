---
title: ios-h5页面焦点错位问题
abbrlink: 22361
date: 2019-02-21 17:37:32
tags: 移动端
categories: 移动端
---

前几天同事遇到一个 bug,解决完觉得挺有意思，移动端 h5 页面弹出层上有几个 input 输入框，点击输入的时候键盘出来后，弹出框会被顶上去，然后点击别处键盘收起，弹出框回到原来的位置，这时候再次点击输入框输入的时候，android 上是正常的，ios 的就会出现卡的假象，点击输入框的时候一直没反应，其实是焦点依然停留在了键盘弹出后顶起的位置，这就是 ios-h5 页面焦点错位现象。

<!-- more -->

这里没有截图我大概画了几张图片：
![ios-h5-focus焦点错位](/../images/ios-h5-fouce.png)
解决方法： 既然焦点还停留在原来的位置，那么我们判断一下如果用户是在第一个输入框输入完，点击别处收起键盘的时候，我们把页面滚动会原来的位置，焦点归位就行了，如果用户是在第一个输入框输入完继续下一个输入框输入的时候我们就不需要进行滚动。
这里再插入一张图解释一下为什么是`scrollTo(0,0)`
![ios-h5-scroll滚动页面焦点归位](/../images/ios-h5-scroll.png)
思路就是这样，具体代码可以参考：

```javascript
let isScroll = false,
  timer = null;
let focusEvent = e => (isScroll = false);
let blurEvent = e => {
  isScroll = true;
  clerTimeout(timer);
  timer = setTimeout(() => {
    if (isScroll) {
      Window.scrollTo(0, 0);
      clearTimeout(timer);
    }
  }, 300);
};
```
