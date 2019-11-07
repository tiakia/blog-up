---
title: 针对不同的请求地址封装axios
abbrlink: 17294
date: 2019-07-30 18:02:24
tags: axios
categories: http
---

遇到这个问题的背景是项目的登录接口要做统一登录，和项目中其他接口地址不一样，所以衍生出这个问题。

---

新增取消请求，针对遇到组件已经卸载了但是请求还在继续的情况

<!-- more -->

### 针对不同地址封装

以前封装好的`axios`一直很好用，直到遇到这个需求后，做了一些修改：

我们借助请求拦截器来完成这个需求

```javascript
// 请求拦截器
instance.interceptors.request.use(
  config => {
    const token = localStorage.getItem("token");
    if (token) {
      config.headers.authorization = `Bearer ${token}`;
    }
    if (config.method === "post" || config.method === "put") {
      config.headers["Content-Type"] = "application/json;charset=UTF-8";
    }
    if (config.method === "get") {
      config.data = stringify(config.data);
    }
    // 处理不同请求
    // 在请求拦截器中拦截到登录请求后改变请求路径
    if (config.url === "/login" && config.method === "post") {
      config.baseURL = window.loginApi;
    }
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);
```

针对这个思路也可以配置生产环境和开发环境不同的请求地址：

```javascript
export const config = {
  // `baseURL` 将自动加在 `url` 前面，除非 `url` 是一个绝对 URL。
  // 它可以通过设置一个 `baseURL` 便于为 axios 实例的方法传递相对 URL

  baseURL:
    process.env.NODE_ENV === "production" ? window.proApi : window.devApi,
  // 在请求发送前，可以根据实际要求，是否要对请求的数据进行转换
  // 仅应用于 post、put、patch 请求
  transformRequest: [
    function(data, headers) {
      // Do whatever you want to transform the data
      return JSON.stringify(data);
    }
  ],
  //  `transformResponse` 在传递给 then/catch 前，允许修改响应数据
  // it is passed to then/catch
  transformResponse: [
    function(data) {
      // Do whatever you want to transform the data
      return JSON.parse(data);
    }
  ],
  // 请求头信息
  // headers: {
  // 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8;',
  // },
  // 设置超时时间
  timeout: 50000, // 携带凭证(cookie)
  withCredentials: false
};
```

### 取消请求

如果一个组件已经卸载了但是它发出的请求仍在进行，如果请求回来时候我们有`setState`操作，`react`会报告给我们一个警告。针对这种情况我们可以在组件卸载后取消请求。

我们利用`axios`的`CancelToken`封装一个取消请求的函数，在组件卸载的时候调用这个函数，传入要取消请求的`url`来取消对应的请求

俩种实现方式具体代码如下：

#### 精准取消

```typescript
// 取消请求
const CancelToken = axios.CancelToken;
// 存放每个请求url和对应的取消函数
let pending: Array<{ url: any; c: any; method: any }> = [];
// 取消函数 调用方式 传入请求的路径 cancel('/getData')
export function cancel(url: Array<string>) {
  pending.length > 0 &&
    pending.forEach((item: any, idx: any) => {
      // 处理这种情况 branch/treeBranch?
      if (url.find(val => val.split("?")[0] === item.url)) {
        // 执行取消函数
        item.c("method: " + item.method + " url: " + item.url);
        // 移除这个请求
        pending.splice(idx, 1);
      }
    });
}
// 在请求拦截器中添加如下代码：
// 请求拦截器取消请求封装
config.cancelToken = new CancelToken(function executor(c) {
  // An executor function receives a cancel function as a parameter
  pending.push({ url: config.url, c, method: config.mehtod });
});
```

调用方式：

```jsx harmony
import React, { useEffect, useState } from "react";
import request, { cancel } from "axios";

export default () => {
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    let isUnmounted = false;
    (async () => {
      await request({
        url: "/getData",
        method: "POST",
        data: { page: 1 }
      });
      if (!isUnmounted) {
        setLoading(false);
      }
    })();
    return () => {
      isUnmounted = true;
      // 取消请求
      cancel(["/getData"]);
    };
  }, []);
  return <>{loading ? <div>{"Loading..."}</div> : <div>{...}</div>}</>;
};
```

> 另一种方式：这种方式会取消后续的请求，不知道为什么，这里写到这作为一个思路，项目中采用第一种方式精准取消

```jsx harmony
// 取消请求
const CancelToken = axios.CancelToken;
// 取消全部请求
export const source = CancelToken.source();

//在请求拦截器中添加如下代码：
config.cancelToken = source.token;
```

调用方式：

```jsx harmony
import React, { useEffect, useState } from "react";
import request, { cancel } from "axios";

export default () => {
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    let isUnmounted = false;
    (async () => {
      await request({
        url: "/getData",
        method: "POST",
        data: { page: 1 }
      });
      if (!isUnmounted) {
        setLoading(false);
      }
    })();
    return () => {
      isUnmounted = true;
      // 取消请求
      // 这里会取消页面所有的请求
      source.cancel();
    };
  }, []);
  return <>{loading ? <div>{"Loading..."}</div> : <div>{...}</div>}</>;
};
```

### 完整封装 Axios

```typescript
/*
 *  功能：封装 axios
 *  create by tiankai on 05/16/18 17:15:07
 */
import axios from "axios";
import { stringify } from "qs";
import { Modal, notification } from "antd";
import router from "umi/router";

// 取消请求
const CancelToken = axios.CancelToken;
// 存放每个请求url和对应的取消函数
let pending: Array<{ url: any; c: any; method: any }> = [];
// 取消函数 调用方式 传入请求的路径 cancel('/getData')
export function cancel(url: Array<string>) {
  console.log(pending, url);
  pending.length > 0 &&
    pending.forEach((item: any, idx: any) => {
      // 处理这种情况 branch/treeBranch?
      if (url.find(val => val.split("?")[0] === item.url)) {
        // 执行取消函数
        item.c("method: " + item.method + " url: " + item.url);
        // 移除这个请求
        pending.splice(idx, 1);
      }
    });
}

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
  if (!response) {
    throw new Error("response is undefined");
  }
  if (
    (response.status >= 200 && response.status < 300) ||
    response.code !== "9998"
  ) {
    // notification.success({
    //   message: response.msg,
    // });
    return response;
  }
  const errorText = codeMessage[response.status] || response.statusText;
  const error = new Error(errorText);
  error.name = response.status;
  // @ts-ignore
  error.response = response;
  // @ts-ignore
  error.text = errorText;
  throw error;
}

export const config = {
  // `baseURL` 将自动加在 `url` 前面，除非 `url` 是一个绝对 URL。
  // 它可以通过设置一个 `baseURL` 便于为 axios 实例的方法传递相对 URL
  // @ts-ignore
  baseURL: window.api, // 在请求发送前，可以根据实际要求，是否要对请求的数据进行转换
  // 仅应用于 post、put、patch 请求
  transformRequest: [
    function(data, headers) {
      // Do whatever you want to transform the data
      return JSON.stringify(data);
    }
  ],
  //  `transformResponse` 在传递给 then/catch 前，允许修改响应数据
  // it is passed to then/catch
  transformResponse: [
    function(data) {
      // Do whatever you want to transform the data
      return JSON.parse(data);
    }
  ],
  // 请求头信息
  // headers: {
  // 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8;',
  // },
  // 设置超时时间
  timeout: 50000, // 携带凭证(cookie)
  withCredentials: false
};

const instance = axios.create(config);
export const upload = axios.create({
  // @ts-ignore
  baseURL: window.api,
  headers: { "Content-Type": "multipart/form-data" }
});
// 请求拦截器
instance.interceptors.request.use(
  config => {
    // Do something before request is sent
    // 可以在这里做一些事情在请求发送前
    // config.headers['TOKEN']=''// 在这里设置请求头与携带token信息;
    console.log(config);
    const token = localStorage.getItem("token");
    if (token) {
      config.headers.authorization = `Bearer ${token}`;
    }
    if (config.method === "post" || config.method === "put") {
      config.headers["Content-Type"] = "application/json;charset=UTF-8";
    }
    if (config.method === "get") {
      config.data = stringify(config.data);
    }
    // 处理上传文件请求
    if (config.url === "/upload" && config.method === "post") {
      // &&String(config.data).indexOf('files') >= 0
      config.headers["Content-Type"] =
        "multipart/form-data;boundary=" + new Date().getTime();
    }
    // 请求拦截器取消请求封装
    config.cancelToken = new CancelToken(function executor(c) {
      // An executor function receives a cancel function as a parameter
      pending.push({ url: config.url, c, method: config.method });
    });
    return config;
  },
  error => {
    // Do something whit request error
    // 请求失败可以做一些事情
    return Promise.reject(error);
  }
);

// 响应拦截器
instance.interceptors.response.use(
  response => {
    // Do something with response data
    // 在这里你可以判断后台返回数据携带的请求码
    // console.dir(response);
    return checkStatus(response);
  },
  error => {
    // Do something whit response error
    // 根据 错误码返回信息
    // console.dir(error);
    // return error;
    // return checkStatus(error.response);
    return Promise.reject(error);
  }
);

/* method GET/POST/PUT
 * url
 * params/data
 * headers { 'content-type': 'application/x-www-form-urlencoded'}
 */
const request = options => {
  return new Promise((resolve, reject) => {
    instance(options)
      .then(response => {
        resolve(response.data);
      })
      .catch(error => {
        console.dir(error);
        // 如果用户取消了请求
        if (axios.isCancel(error)) {
          console.log("Request canceled", error.message);
        } else {
          let status = error.response && error.response.status;
          let code =
            error.response && error.response.code && error.response.code;
          if (status === 401 || code === "9998") {
            router.push("/login");
            notification.warn({
              message: "请重新登录",
              description: error.message
            });
            // alert('请重新登录');
          } else {
            Modal.error({ title: "请求错误", content: error.message });
            // alert(error);
          }
          reject(error);
        }
      });
  });
};

export default request;
```
