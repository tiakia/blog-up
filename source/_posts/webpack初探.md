---
title: webpack初探
tags: []
categories: webpack
keywords: webpack
abbrlink: 26666
date: 2017-08-18 11:15:23
description:
thumbnail:
---

初次接触 webpack 是在构建 react 的时候，那个时候要用到 es6 的语法，浏览器不支持，官网推荐 babel,去了 babel 官网看的也是一脸懵\*，在网上就搜到了 webpack,可以集合 babel,从而支持 es6,现在只要`create-react-app`,就可以构建一个 react 项目了，真是越来越方便了，这里推荐一个[webpack 的简明教程](http://zhaoda.net/webpack-handbook/configuration.html)。

<!-- more -->

### 什么是 webpack

webpack 专业是模块打包的，相比于 gulp,grunt，它更多的是处理资源之间的依赖关系，在需要用到的地方把这些资源打包成一个，也可以减少 http 请求。  
 webpack 的基础是他的配置文件，扩展功能要靠一些`loader`来实现，babel 就是一个他的 loader,通过各种 loaderh 还可以打包 css,图片等。webpack 还可以安装插件来扩展一些功能。

### 安装

```bash
npm install webpack -g

# 然后进入项目目录，

npm init

# 这里我遇到个坑，我的node是8.1版本在init的时候，到了version的时候就走不下去了，我把node降到6.0版本就可以init了。

npm install webpack -save-dev
```

### 使用

我的文件目录是这样的：

```bash
demo
    - node_modules
    - output  bundle.js
    - src  index.js
    index.html
    package.json
    webpack.config.js
```

### 安装 babel 相关组件

```bash
npm install --save-dev babel-loader babel-core
npm install babel-preset-es2015 --save-dev
npm install --save babel-polyfill
```

### webpack.config.js

```javascript
var webpack = require("webpack");
var path = require("path");
var debug = process.env.NODE_ENV !== "production";

module.exports = {
  entry: ["babel-polyfill", "./src/index.js"],
  output: {
    path: __dirname + "/output/",
    filename: "bundle.js"
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /(node_modules|bower_components)/,
        loader: "babel-loader",
        query: {
          presets: ["es2015"]
        }
      }
    ]
  }
};
```

### 运行

在 src 目录下的 index.js 使用 ES6 的语法，在命令行输入：

```bash
webpack
```

然后就会在 output 目录下生成一个 bundle.js,引入 index.html,这样就完成了一个 webpack 的基本功能。
