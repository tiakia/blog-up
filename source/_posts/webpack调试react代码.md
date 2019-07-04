---
title: webpack调试react代码
abbrlink: 12906
date: 2019-06-24 09:39:24
tags:
  - webstorm
  - 工具
categories: 工具
---

前端工作总我们必不可少的操作就是`debug`学会`debug`可以帮助我们更好的理解程序的运行方式，也方便我们寻找`bug`,今天我们一起来了解一下直接使用`webstorm`来调试`react`代码。

<!-- more -->

### 安装 Chrome 插件

- [谷歌浏览器 JetBrains IDE Support 插件 地址](https://chrome.google.com/webstore/detail/hmhgeddbohgjknpmjagkdomcpobmllji)

  - 安装插件需要翻墙，不会翻墙的可以到[这里取谷歌访问助手（只能访问谷歌和插件市场）](https://github.com/tiakia/-)，来到谷歌插件市场下载插件

- 配置插件端口
  ![](/images/jet-ide-support.png)
  我的项目启动时的端口就是`8000`所以这里配置成`localhost:8000`这里根据自己项目实际进行配置

### webstorm 调试

- webstrom 调试的入口在右上角
  ![](/images/jet-ide-1.png)
- 打开后按图示，点击`＋`选择`javascript debug`名称自己随意取，`URL`处填写自己项目启动的`http://localhost:8000`,在下面的项目目录选择`src`目录后的`RemoteURL`填写`webapck:///src`,然后点击确定
  ![](/images/jet-ide-2.png)
- 这样就配置成功了，然后点击甲虫按钮，就可以开始调试了,在 webstorm 中打断点可以直接看到每一步的执行过程和变量变化情况
  ![](/images/jet-ide-3.png)
