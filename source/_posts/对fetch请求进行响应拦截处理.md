---
title: 对fetch请求进行响应拦截处理
tags: fetch
categories: http
abbrlink: 62600
date: 2019-12-25 15:08:25
---
最近在修改一个旧项目的时候遇到这个问题，现在的项目我们都是用的自己封装的`axios`，可以对请求或者响应进行拦截。所以就想着把`fetch`也进行一些封装，全局判断一下，响应是否应该返回。
<!-- more -->
先来看一个使用`fetch`请求时候的简单例子：
```javascript
async getData(payload) {
    try {
      let res = await fetch('/data', {
        headers: {
            "Content-Type": 'application/json'
        }
      });
      let resJson = await res.json();
      return resJson;
    } catch(e) {
        console.log(e);
    }
}
```
## 第一步封装：
```
export default async function request(url, options) {
    try {
        let res = await fetch(url, options);
        return res.json();
    } catch(e) {
        console.log(e);
    }
}
```
使用：
```javascript
async getData(payload) {
    let res = await request('/data', {
        headers: {
            "Content-Type": 'application/json'
        }
    });
    if(res.code === '0000') {
        this.setState({
            data: res.data
        });
    } else {
        message.warn(res.msg || '请求错误');
    }
}
```
## 第二步封装：
在项目中我们和后端约定，如果响应成功那么就返回`code = '0000'`标识这次请求是成功的。否则不成功。那么我们就需要对上述的请求做一下处理：
```javascript
export default async function request(url, options) {
    try{
      let res = await fetch(url, options);
      let resJson = await res.json();
      if(resJson.code === '0000') {
          return resJson;
      } else {
          let error = new Error();
          error.name = resJson.code;
          error.msg = resJson.msg || '请求错误';
          throw error;
      }
    } catch(e) {
        console.log(e);
    }
}
```
使用：
```javascript
async getData(payload) {
    let res = await request('/data', {
        headers: {
            "Content-Type": 'application/json'
        }
    });
    // 如果发生错误（code !== '0000'），不会走到这一步
    this.setState({
        data: res.data
    });
}
```
是不是看起来简洁一些了。每次请求的时候不用进行繁琐的判断`code`了。

## 第三步封装：

错误处理。上面的封装我们对错误只是打印在控制台，我们要把一些错误直观给用户展示出来。
```javascript
// 先检查http状态码
const codeMessage = {
  200: "服务器成功返回请求的数据。",
  201: "新建或修改数据成功。",
  202: "一个请求已经进入后台排队（异步任务）。",
  204: "删除数据成功。",
  400: "发出的请求有错误，服务器没有进行新建或修改数据的操作。",
  401: "用户没有权限（令牌、用户名、密码错误）。",
  403: "用户得到授权，但是访问是被禁止的。",
  404: "发出的请求针对的是不存在的记录，服务器没有进行操作。",
  406: "请求的格式不可得。",
  410: "请求的资源被永久删除，且不会再得到的。",
  422: "当创建一个对象时，发生一个验证错误。",
  500: "服务器发生错误，请检查服务器。",
  502: "网关错误。",
  503: "服务不可用，服务器暂时过载或维护。",
  504: "网关超时。"
};

function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response;
  }
  const errortext = codeMessage[response.status] || response.statusText;
  const error = new Error();
  error.name = response.status;
  error.msg = errortext;
  error.url = response.url;
  error.response = response;
  throw error;
}

export default async function request(url, options) {
    try{
      let res = await fetch(url, options);
      let resSuccess = await checkstatus(res);
      let resJson = await resSuccess.json();
      if(resJson.code === '0000') {
          return resJson;
      } else {
          let error = new Error();
          error.name = resJson.code;
          error.msg = resJson.msg || '请求错误';
          throw error;
      }
    } catch(e) {
      // 基于antd
      notification.error({
        message: e.url ? `请求错误 ${e.name} ${e.url}` : `请求错误 ${e.name}`,
        description: e.msg
      });
      // 对于无权限或者token过期处理
      let status = e.name;
      // HTTP状态码为401或者返回的code为9998
      // 那么就可以判定跳转登录页面
      if(status === '401' || status === '9998') {
          router.push('/login');
      }
    }
}
````
## 最后一步:
到这里基本差不多了，但是我们考虑一下，每次请求都需要写`headers`也是麻烦，所以我们给个默认值，同时又支持自己定义。

```javascript
export default async function request(url, options={}) {
    try{
      let defaultOptions = {
          headers: {
              'Content-Type': 'application/json'
          }
      }
      let newOptions = {
          ...defaultOptions,
          ...options
      };
      const access_token = getWeekLocalStorage("access_token")
        ? getWeekLocalStorage("access_token")
        : "";

      newOptions.headers = {
          // 可以在这里自定义
          //比如：给每次请求加token
           Authorization: `bearer ${access_token}`,
          ...defaultOptions.headers,
          ...options.headers
      }
      let res = await fetch(url, newOptions);
      let resSuccess = await checkstatus(res);
      let resJson = await resSuccess.json();
      if(resJson.code === '0000') {
          return resJson;
      } else {
          let error = new Error();
          error.name = resJson.code;
          error.msg = resJson.msg || '请求错误';
          throw error;
      }
    } catch(e) {
      // 基于antd
      notification.error({
        message: e.url ? `请求错误 ${e.name} ${e.url}` : `请求错误 ${e.name}`,
        description: e.msg
      });
      // 对于无权限或者token过期处理
      let status = e.name;
      // HTTP状态码为401或者返回的code为9998
      // 那么就可以判定跳转登录页面
      if(status === '401' || status === '9998') {
          router.push('/login');
      }
    }
}
```
针对实际项目，实际使用情况灵活改变。
