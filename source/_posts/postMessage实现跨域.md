---
title: postMessage实现跨域
abbrlink: 10356
date: 2019-11-29 09:20:54
tags: postMessage
categories: nodejs
---
## 跨域方式介绍
- `JSONP`跨域
- `iframe`+`domain`跨域
- `nginx`反向代理跨域
- `cors`跨域
- `postMessage`跨域

<!-- more -->
  我们一般常用的`cors`跨域，通过后端设置`Access-Control-Allow-Origin`响应头来实现跨域,`JSONP`是利用`script`标签的`src`不受同源策略的约束来实现跨域。`JSONP` 主要由回调函数和数据两部分组成。回调函数的名字一般是在请求中指定的。而数据就是传入回调函数中的 `JSON` 数据。我们一般可以在全局定义一个回调函数，然后在`script`标签里传入回调函数即可：
```javascript
window.handleData = function(data){
    // ...
}

let script = document.createElement("script");
script.src = "https://xxxx.com/v0/search?q=xuxi&callback=handleData";
document.body.insertBefore(script, document.body.firstChild);
```
但是`JSONP`的跨域方式只支持`GET`请求。

## postMessage跨域
使用`postMessage`跨域我们首先要获取页面的引用

```javascript
// window.open方式获取引用
// const popup = window.open("http://localhost:8001/a.html");
// iframe 方式获取引用
// <iframe id="pageA" src="http://localhost:8001/a.html"></iframe>
const popup = document.getElementById("pageA").contentWindow;

// 使用postMessage发送数据，必须加上域名来指定哪些页面可以接收信息
popup.postMessage('hello world', 'localhost:8001');
```
然后监听`message`事件：
```javascript
window.onload = () => {
  let domin = "http://localhost:8001";
  window.addEventListener(
    "message",
    event => {
      // 验证消息发送方是否合格
      if (event.origin === domin) {
        console.log("received message: ", event.data);
         event.source.postMessage('hello', event.origin);
      }
    },
    false
  );
}
```
`event`的几个核心属性：
- **data**:跨域发送的数据
- **origin**:跨域发送数据的窗口
- **source**:对发送数据窗口的引用

> 注意： 必须要在`window.onload`事件完成后postMessage才能生效

## chatRobot
为了试验`postMessage`跨域基于腾讯AI做了一个[聊天机器人项目](https://github.com/tiakia/chatRobot);

![/images/chatRobot.png](/images/chatRobot.png)

1. **PageA**通过`node`启动服务在`localhost:8001`
```javascript
const server = http.createServer((req, res) => {
  if (req.url === "/a.html") {
    res.writeHead(200, { "Content-Type": "text/html" });
    let data = fs.readFileSync(resolve(__dirname, "./a.html"));
    res.end(data);
  }
});

server.listen(8001, "127.0.0.1", () => {
  console.log("listening at port 127.0.0.1:8001");
});

```
2. **PageB**通过`node`启动服务在`localhost:8000`
```javascript
const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-type": "text/html" });
  const data = fs.readFileSync(path.resolve(__dirname, "./b.html"));
  res.end(data);
});

server.listen(8000, "127.0.0.1", () => {
  console.log("pageB listening at port 127.0.0.1:8000");
});
```
在浏览器访问`localhost:8000`就会看到上面的结果。

3. 然后在`PageB`中通过`postMessage`向`PageA`发送数据：
```javascript
      window.onload = () => {
        let domin = "http://localhost:8001";
        let input = document.getElementById("input");
        let btn = document.getElementById("btn");

        btn.addEventListener(
          "click",
          () => {
            if (input.value) {
              // 通过postMessage发送数据
              popup.postMessage(input.value, domin);
              input.value = "";
            }
          },
          false
        );
        //绑定回车事件
        document.onkeydown = function(e) {
          if (e.keyCode === 13) {
            btn.click();
          }
        };
        // window.open方式获取引用
        // const popup = window.open("http://localhost:8000/a.html");
        // iframe 方式获取引用
        const popup = document.getElementById("pageA").contentWindow;
        // 发送初始消息
        // popup.postMessage("你好", domin);

        window.addEventListener(
          "message",
          event => {
            // 验证消息发送方是否合格
            if (event.origin === domin) {
              console.log("received message: ", event.data);
            }
          },
          false
        );
      };

```
4. `PageB`接受到数据后，展示在聊天界面上，然后请求腾讯AI，将返回的数据展示在聊天界面

大体步骤就是这样，其他的关于细节展示方面的问题，有兴趣的可以去[github查看源码](https://github.com/tiakia/chatRobot).

