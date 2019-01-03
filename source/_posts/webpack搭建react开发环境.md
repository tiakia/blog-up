---
title: webpack搭建react开发环境
tags:
  - webpack
categories: webpack
keywords: 'webpack,react'
abbrlink: 18205
date: 2017-09-06 15:45:22
description:
thumbnail:
---

前俩天刚刚搭建了一个 react 的开发环境，记录一下踩坑之路。

### 主要实现的功能有:

1、支持 es6 的语法
2、支持 sass,css
3、支持 css 自动加浏览器前缀，eg:display:flex 会自动加上各个浏览器前缀
4、自动生成 html 模板，然后把编译好的 js 文件自动引入
5、 react 的热更新
6、 压缩 js
7、 把嵌入 js 代码中的 css 提取出来
8、 提取公共模块的代码
----------待验证的，不确定的-----------------------------
9、 压缩图片和字体文件

<!-- more -->

### 配置记录

#### 热更新

配置过程中，耗时最长的就是在没有浏览器刷新的状态下，实现修改了文件后浏览器自刷新，也叫热加载。
因为用了一个`react-hot-loader`的这个作者早就不更新了，所以一直没配置成功，后来谷歌才知道，真坑，现在选择了一个新的 plugin:

```bash
babel-plugin-react-transgorm
```

还要安装其他的：

```bash
react-transform-hmr 安装这个才能实现热加载
babel-preset-react-hmre  让Babel知道HMR
```

这俩个是为了让错误直接显示在页面上，和`react-native`的提醒错误的方式一样

```bash
react-transform-catch-errors
redbox-react
```

其他的配置还有就是，

#### 提取公共模块

webpack 用插件 CommonsChunkPlugin 进行打包的时候，将符合引用次数(minChunks)的模块打包到 name 参数的数组的第一个块里（chunk）,然后数组后面的块依次打包(查找 entry 里的 key,没有找到相关的 key 就生成一个空的块)，最后一个块包含 webpack 生成的在浏览器上使用各个块的加载代码，所以页面上使用的时候最后一个块必须最先加载

#### css 自动补全前缀的，这用了

```bash
postcss
autoprefixer
```

还要新建一个`postcss.config.js`用了这个 css 热更新不能用了，只有改 jsx,可以使用,只有使用了，不兼容的属性才会添加前缀名

#### html 模板创建的

配置的时候
`htmlWebpackPlugin` 插件名字必须这么写 html 小写，我刚开始写的 HtmlwebpackPlugin 不对  
要是使用模板的话还需要新安装
`ejs-loader`

图片加载和压缩的 这个还需要验证

#### 文件目录

![文件目录](/../images/webapck-dir.png)

#### 贴出自己的配置 webpack.config.js

```javascript
const webpack = require("webpack");
const path = require("path");
const production = process.env.NODE_ENV === "production" ? true : false;
const CommonsChunkPlugin = require("webpack/lib/optimize/CommonsChunkplugin");
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
const htmlWebpackPlugin = require("html-webpack-plugin");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const autoprefixer = require("autoprefixer");
const CleanPlugin = require("clean-webpack-plugin");

const webpackPlugin = [
  //定义全局为开发环境
  new webpack.DefinePlugin({
    "process.env": {
      NODE_ENV: JSON.stringify("dev")
    }
  }),
  //在编译最终的静态资源前，清理output文件夹
  // new CleanPlugin('./output/'),

  new htmlWebpackPlugin({
    title: production ? "react-app" : "dev-react-app",
    date: new Date(),
    template: "./template/index.html",
    inject: true,
    filename: "index.html",
    minify: {
      removeComments: production ? true : false, //生产环境中移除html中的注释
      collapseWhitespace: production ? true : false //生产环境中删除空白符与换行符
    }
  }),
  //开启全局的模块热替换
  new webpack.HotModuleReplacementPlugin(),
  //当模块热替换时在浏览器控制台输出对用户更友好的模块名字信息
  new webpack.NamedModulesPlugin(),
  new webpack.BannerPlugin({
    banner: "Autor: tiakia",
    raw: false
  }),
  //用于提取公共模块common是公共的模块，vender是第三方库，load是webpack打包的再各个浏览器上加载的代码，必须先加载
  new CommonsChunkPlugin({
    name: ["common", "vendor", "load"],
    filename: "[name].js",
    minChunks: 2
  }),
  //css提取
  new ExtractTextPlugin({
    filename: "style.css",
    allChunks: true
  })
];

if (production) {
  webpackPlugin.push([
    //对最终的js进行 Uglify 压缩
    new UglifyJsPlugin({
      compress: true,
      test: /\.jsx?$/i,
      parallel: {
        //使用多进程并行和文件换成提高构建速度
        cache: true,
        workers: 2
      },
      warnings: false
    })
  ]);
}
module.exports = {
  devtool: production ? "eval" : "cheap-module-eval-source-map",
  entry: {
    main: [
      "webpack-dev-server/client?http://localhost:9000",
      "webpack/hot/only-dev-server",
      "./src/index.js"
    ],
    //第三方库
    vendor: ["react", "react-dom", "redux", "react-redux"]
  },
  output: {
    path: __dirname + "/output/",
    filename: "[name].bundle.js",
    publicPath: ""
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /(node_modules|bower_components)/,
        loader: "babel-loader",
        query: {
          presets: ["react", "es2015"]
        }
      },
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: ["css-loader", "postcss-loader"],
          publicPath: "./output/"
        })
      },
      {
        // scss 加载
        test: /\.scss$/i,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: ["css-loader", "postcss-loader", "sass-loader"],
          publicPath: "./output/"
        })
      },
      {
        test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
        //loader: 'url-loader',
        // options: {
        //     limit: 10000, // 10k
        //     name: image/[name]-[hash:5].[ext]
        // },
        // loaders:[
        //     'url-loader?limit=10000&name=image/[name]-[hash:5].[ext]',
        //     'image-webpack-loader'
        // ],
        use: [
          {
            loader: "url-loader",
            options: {
              limit: 10000,
              name: "image/[name]-[hash:5].[ext]"
            }
          },
          "image-webpack-loader"
        ]
      },
      {
        test: /\.(woff|ttf|eot)$/,
        loader: "url-loader",
        query: {
          limit: 20480 //20k
        }
      }
    ]
  },
  plugins: webpackPlugin,
  devServer: {
    //      contentBase: [path.join(__dirname)],
    historyApiFallback: true,
    //      compress: true,
    hot: true,
    port: 9000,
    inline: true,
    publicPath: "/" //和output 的‘publicPath'一致
    //      progress: true,
  }
};
```

- postcss.config.js

```javascript
module.exports = {
  plugins: [require("autoprefixer")]
};
```

- .babelrc

```json
{
  "presets": ["es2015", "react"],
  "env": {
    "development": {
      "presets": ["react-hmre"]
    }
  }
}
```

- package.json

```json
{
  "name": "reduxDemo",
  "version": "1.0.0",
  "main": "index.js",
  "author": "tiakia <www.tiankai.party>",
  "license": "MIT",
  "dependencies": {
    "babel-loader": "^7.1.2",
    "babel-preset-es2015": "^6.24.1",
    "babel-preset-react": "^6.24.1",
    "bable-loader": "^0.0.1-security",
    "css-loader": "^0.28.5",
    "extract-text-webpack-plugin": "^2.1.2",
    "html-webpack-plugin": "^2.30.1",
    "react": "^15.6.1",
    "react-dom": "^15.6.1",
    "react-redux": "^5.0.6",
    "react-router": "^4.1.2",
    "redux": "^3.7.2",
    "redux-thunk": "^2.2.0",
    "sass-loader": "^6.0.6",
    "style-loader": "^0.18.2",
    "uglify-js-plugin": "^0.0.6",
    "uglifyjs-webpack-plugin": "^0.4.6",
    "webpack": "^3.5.5",
    "webpack-dev-server": "^2.7.1"
  },
  "devDependencies": {
    "autoprefixer": "^7.1.2",
    "autoprefixer-loader": "^3.2.0",
    "babel-core": "^6.26.0",
    "babel-plugin-react-transform": "^2.0.2",
    "babel-polyfill": "^6.26.0",
    "babel-preset-react-hmre": "^1.1.1",
    "clean-webpack-plugin": "^0.1.16",
    "cross-env": "^5.0.5",
    "extract-text-webpack-plugin": "^2.1.2",
    "file-loader": "^0.11.2",
    "html-webpack-plugin": "^2.30.1",
    "image-webpack-loader": "^3.3.1",
    "img-loader": "^2.0.0",
    "node-sass": "^4.5.3",
    "postcss-loader": "^2.0.6",
    "react-transform-catch-errors": "^1.0.2",
    "react-transform-hmr": "^1.0.4",
    "redbox-react": "^1.5.0",
    "url-loader": "^0.5.9",
    "webpack-dev-server": "^2.7.1"
  },
  "scripts": {
    "dev": "cross-env NODE_ENV=dev && webpack-dev-server --open --progress --colors --config ./webpack.config.js",
    "build": "webpack --config webpack.config.js",
    "deploy": "cross-env NODE_ENV=production && webpack --config ./webpack.config.js"
  }
}
```

- template/index.html

```html
<!DOCType html>
<html>
  <head>
    <meta charset='utf-8'/>
    <title><%= htmlWebpackPlugin.options.title %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
     <div>页面生成时间：<%= htmlWebpackPlugin.options.date %></div>
     <div id='root'></div>
  </body>
</html>
```

- 再次申明，图片压缩和字体的没有验证，仅供参考，有错误的地方欢迎及时联系我，有交流才有进步。
