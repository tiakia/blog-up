---
title: webpack初探
tags: []
date: 2017-08-18 11:15:23
categories: webpack
description:
thumbnail:
keywords: webpack
---
初次接触webpack是在构建react的时候，那个时候要用到es6的语法，浏览器不支持，官网推荐babel,去了babel官网看的也是一脸懵*，在网上就搜到了webpack,可以集合babel,从而支持es6,现在只要`create-react-app`,就可以构建一个react项目了，真是越来越方便了，这里推荐一个[webpack的简明教程](http://zhaoda.net/webpack-handbook/configuration.html)。
<!-- more -->
### 什么是webpack
  webpack专业是模块打包的，相比于gulp,grunt，它更多的是处理资源之间的依赖关系，在需要用到的地方把这些资源打包成一个，也可以减少http请求。  
  webpack的基础是他的配置文件，扩展功能要靠一些`loader`来实现，babel就是一个他的loader,通过各种loaderh还可以打包css,图片等。webpack还可以安装插件来扩展一些功能。

  ### 安装
  ```
  npm install webpack -g
  
  # 然后进入项目目录，

  npm init

  # 这里我遇到个坑，我的node是8.1版本在init的时候，到了version的时候就走不下去了，我把node降到6.0版本就可以
  init了。

 npm install webpack -save-dev
  ```
### 使用
我的文件目录是这样的：  
```
demo   
    - node_modules  
    - output  bundle.js 
    - src  index.js   
    index.html  
    package.json  
    webpack.config.js
```
### 安装babel相关组件

```
npm install --save-dev babel-loader babel-core
npm install babel-preset-es2015 --save-dev
npm install --save babel-polyfill
```
### webpack.config.js
```
var webpack = require('webpack');
var path = require('path');
var debug = process.env.NODE_ENV !== 'production';

module.exports = {
    entry: [
         "babel-polyfill",
        './src/index.js'
    ],
    output: {
		path: __dirname + '/output/',
		filename: 'bundle.js',
    },
    module:{
		loaders:[
		    {
		    	test: /\.jsx?$/,
		    	exclude: /(node_modules|bower_components)/,
		    	loader: 'babel-loader',
		    	query:{
		    	    presets:['es2015'],
		    	} 
		    }
		]
    }
}

```
### 运行
在src目录下的index.js使用ES6的语法，在命令行输入：
```
webpack
```
然后就会在output目录下生成一个bundle.js,引入index.html,这样就完成了一个webpack的基本功能。