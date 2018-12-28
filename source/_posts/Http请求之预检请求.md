---
title: Http请求之预检请求
tags: [http]
date: 2018-03-01 22:16:48
categories: http
description:
thumbnail:
keywords:
---
写了有一段时间的文章了，拿出来再学习学习
#### 使用options预检请求目的

    - 可以避免跨域请求对服务器的用户数据产生未预期的影响

  #### 不使用options预检请求的情况：

   - 使用简单请求的时候，可以不需要进行预检请求，如 GET POST HEAD 方法
   - Content-Type 为 下列三种情况下  
     `application/x-www-form-urlencoded`  
     `multipart/form-data`  
     `text/plain`
   - 请求时不能使用自定义的`headers`
    <!-- more -->
#### 简单请求
 浏览器在请求服务的过程中，请求头中会发送一个`origin`字段，标明这个请求的来源，  
 服务器在返回响应的过程中，会发送回一个`Access-Control-Allow-Origin： *`，标明，接收所有站点的请求。  

#### 预检请求
 预检请求会先向服务器发送一个`Options`的请求，用来验证是否对指定的服务有访问权限。验证通过后，再发送实际的请求。  
 **特点**：  
 - 除了`GET`,`POST`,`HEAD`请求外，其他的请求都会引发`Options`预检请求。
 - `POST`请求向服务器发送数据时，如果 `Content-Type`使用了   
  `application/x-www-form-urlencoded`、`multipart/form-data`、`text/plain`之外都会引起预检请求
  - 使用了自定义的`Headers`后，也会使用`Opitons`预检请求
#### 附带身份凭证的请求
 对于`XMLHttpRequest`跨域或`Fetch`请求，浏览器不会发送身份凭证信息（cookies）。如果要发送身份凭证信息，需要特殊的设置。
 - `XMLHttprequest`  
 
 设置`withCredentials`为 `true`,从而向服务器发送`Cookies`.但是，服务器端的响应中未携带`Access-Control-Allow-Credentials: true`,浏览器将不会把响应内容返回给请求的发送者。
 - `Fetch` 
 
 对于`Fetch`来说，需要设置`credentials: 'include'`这样才会向服务器发送`Cookies`  
#### 注意
如果请求是附带身份凭证的请求，那么服务器不得设置`Access-Control-Allow-Origin: '*'`,这是因为请求的首部中携带了 Cookie 信息，如果 `Access-Control-Allow-Origin` 的值为“*”，请求将会失败
