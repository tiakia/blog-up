---
title: css设置Scoll滚动条样式
abbrlink: 29511
date: 2019-8-23 19:03:20
tags: css
categories: css
---

这里记录一下设置 scroll 滚动条样式的 css 代码，先来看看设置前后的对比图：

<!-- more -->

![css-scroll-before](/../images/css-scroll-before.png)

---

![css-scroll-after](/../images/css-scroll-after.png)

### css 代码

```css
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
  background-color: rgba(240, 240, 240, 1);
}
/*定义滚动条轨道 内阴影+圆角*/
::-webkit-scrollbar-track {
  box-shadow: inset 0 0 0px rgba(240, 240, 240, 0.5);
  border-radius: 10px;
  background-color: rgba(240, 240, 240, 0.5);
}
/*定义滑块 内阴影+圆角*/
::-webkit-scrollbar-thumb {
  border-radius: 10px;
  -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
  background-color: #b5b1b1;
}
```
