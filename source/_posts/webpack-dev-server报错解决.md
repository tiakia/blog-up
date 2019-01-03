---
title: webpack-dev-server报错解决
tags:
  - webpack
categories: webpack
description: webpack-dev-server
keywords: webpack
abbrlink: 54278
date: 2017-09-09 09:58:11
thumbnail:
---

刚刚试了一下 webpack-dev-server --open 本地启服，结果报错，没成功，可是我 webpack 命令却可以成功，后来经查确认是我启服的端口被占用了，在这里贴一下报错的内容和解决办法。

<!-- more -->

![webpack-dev-server](/../images/webpackwebpack-error.png)

```bash
netstat -aon | findsrt 9000  #9000是你启服的端口

taskkill /f -pid 13944  #最后一个就是占用进程的id号，在这里kill掉，再运行就好了
```
