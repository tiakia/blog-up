---
title: js如何清除cookie
tags:
  - cookie
categories: javascript
description: js如何清除cookie
abbrlink: 35574
date: 2017-12-11 09:16:36
thumbnail:
keywords:
---

使用 `cookie` 保存用户信息，然后根据用户信息判断用户是否可以登录管理员后台。我把用户信息存到了 `localStorage` 里面，然后在用户退出的时候清除 `localStorage` 里的用户信息，但是现在用户还是可以通过地址栏访问到后台页面，这是因为 `cookie` 还没有清除， 这里记录一下如何使用 `js` 来清除 `cookie`

<!-- more -->

> 最好的清除`cookie`的方式就是设置`cookie`的过期时间

```javascript
let cookies = document.cookie.split(";"), //拿到所有cookie 并且转变为数组
  userInfo = "";
cookies.map((val, item) => {
  //遍历所有的cookie
  if (val.indexOf("userInfo") === 0) {
    //找到 userInfo 的字段 切割
    userInfo = val.split("=");
  }
});
var exp = new Date(); //设置过期时间
exp.setTime(exp.getTime() - 1);
document.cookie =
  userInfo[0] + "=" + userInfo[1] + ";expires=" + exp.toGMTString();
```
