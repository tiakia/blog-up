---
title: 响应消息中set-cookie不成功的问题
tags:
  - nodejs
categories: nodejs
abbrlink: 5774
date: 2017-11-27 09:16:47
description:
thumbnail:
keywords:
---

说一下背景，最近在使用 nodejs 的 express 框架开发一个博客，同时学习一些 nodejs 后台的功能，实现了登录注册前后台验证的时候，准备把用户的登录信息保存到 cookie 里，这样下次用户刷新页面的时候，就可以从 cookie 里判断是否有登录信息，然后直接登录，就是在 cookie 设置这里出现问题。

#### nodejs 操作 cookie 的方式

- `cookie`一般是由后台操作响应消息的头部返回一个`Set-Cookie`的响应头
- 浏览器在接收到这个响应头以后会自动的设置`cookie`

#### nodejs 操作响应头的实例

<!-- more -->

`cookie-parser`中间件

```javascript
//没有挂载路径的中间件，应用的每个请求都会执行该中间件
router.use(function(req, res, next) {
  responseData = {
    code: 0,
    msg: ""
  };
  next();
});

router.get("/login", (req, res, next) => {
  //验证数据,如果验证通过
  responseData.code = 1;
  responseData.msg = "登录成功";
  //设置cookie
  res.cookie(
    "userInfo",
    JSON.stringify({
      username: userInfo.username,
      uid: userInfo._id,
      date: userInfo.registerDay,
      identity: identityName
    }),
    {
      maxAge: 90000000,
      httpOnly: false
    }
  );

  res.json(responseData);
  return;
});
```

![Set-Cookie](/../images/setCookiesetCookie.png)
如图，每次请求`login`这个接口都会返回一个`Set-Cookie`字段  
按理说在我刷新页面的时候，浏览器会自动把`cookie`设置好  
然后把`cookie`给我带回来,然而`cookie`设置不成功  
上网查了好多资料，`cookie`的参数也各种设置了一遍还是没有用  
我一直以为的是后台的问题，没想到是前端请求方式的问题  
这次请求我使用了`fetch`请求，然而`fetch`请求是默认不带`cookie`的，如果想携带`cookie`需要设置一个额外的属性**`credentials: 'include'`**,我设置了这个属性后果断的设置`cookie`成功了，又踩了一个坑

```javascript
fetch("/api/user/login", {
  method: "POST",
  mode: "cors",
  headers: {
    Accept: "application/json",
    "Content-type": "application/json"
  },
  body: data,
  credentials: "include" //这里添加这个属性
})
  .then(response => response.json())
  .then(data => {
    //登录成功
    if (data.code === 3) {
      setTimeout(() => {
        this.setState({
          mode: "login-success",
          msg: "",
          userInfo: data.userInfo
        });
      }, 800);
    }
    this.setState({
      msg: data.msg
    });
  })
  .catch(err => console.log(err));
```

#### 关于 cookie 其他参数

- `domain`: cookie 在什么域名下有效，类型为 String,。默认为网站域名
- `expires`: cookie 过期时间，类型为 Date。如果没有设置或者设置为 0，那么该 cookie 只在这个这个 session 有效，即关闭浏览器后，这个 cookie 会被浏览器删除。
- `httpOnly`: 只能被 web server 访问，类型 Boolean。
- `maxAge`: 实现 expires 的功能，设置 cookie 过期的时间，类型为 String，指明从现在开始，多少毫秒以后，cookie 到期。
- `path`: cookie 在什么路径下有效，默认为'/'，类型为 String
- `secure`: 只能被 HTTPS 使用，类型 Boolean，默认为 false
- `signed`: 使用签名，类型 Boolean，默认为 false。`express会使用req.secret来完成签名，需要cookie-parser配合使用`

##### maxAge 和 expires

- 这俩个都是设置`cookie`的过期时间，如果都存在的话`maxAge`的优先级高
