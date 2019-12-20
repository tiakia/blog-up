---
title: 试验一个npm包的生成
abbrlink: 12567
date: 2019-12-5 09:21:16
tags: [node,npm]
categories: nodejs
---
前段时间看到了一个把有道词典做成命令行的项目[yddict](<https://github.com/kenshinji/yddict>),个人感觉挺有意思的，然后就研究了一下他的代码，萌生了也写一个自己的命令行项目，就产生这个[one](https://github.com/tiakia/one)项目，试验了一把如何发布`npm`包。
<!-- more -->
## 发布npm包
- 注册npm
要发布一个`npm`包首先要在[npmjs.com](https://www.npmjs.com/signup)注册账号。
- 初始化 `npm init`
- 安装依赖包 `npm install <package-name>`
- 编写自己的代码
  - 在根目录新建`index.js`（这个要和`package.json`中的`main`字段一致），最后要将代码导出到这里。
```javascript index.js
module.exports = {
    message: () => {
        console.log('This is my first npm package');
    }
}
```
- 发布`npm`包
  - `npm login` 登录在官网注册过的账号
  - `npm publish`发布（`package.json`的`name`字段为包名）
- 更新版本
  - 更改`package.json`的`version`字段（1.0.0 => 1.0.1）
  - `npm publish`更新成功
- 测试
    - 安装
    ```java
    npm install <package-name>
    ```
    - 使用
    ```javascript
    import hello from '<package-name>';
    hello();
    ```
## tk-one包
如果是全局包的话有点不一样。需要在`package.json`中指定一个`bin`字段用于暴露全局使用的命令：
```javascript package.json
...
"bin": {
    "one": "./index.js"
  },
...
```
然后在`index.js`文件的头部要加上这句话
```javascript index.js
#!/usr/bin/env node
```
这样才能识别命令.
我已经发布为`npm`包了，可以试验一下。
```bash
# 安装
npm install -g tk-one
# 使用
one
# 卸载
npm uninstall -g tk-one
```
这个命令会将One当天的数据作为图片保存到D盘根目录。还参考了这个项目[NodeMail](<https://github.com/Vincedream/NodeMail>)用来爬取ONE网站的数据。有兴趣的可以去看看这俩个项目。

## 知识点
这个用到的知识点有：
- nodejs爬取网站数据
- nodejs将数据返回给前端，或者写入文件中。
- 使用canvas将数据绘制成图片转成base64码，通过nodejs保存在本地
- puppeteer截图保存图片
- ejs相关知识

项目源码在这里可以自己下载下来研究：
```
git clone https://github.com/tiakia/one.git
npm install
node index.js
```
