---
title: react-redux脚手架搭建问题总结
date: 2018-07-23 16:27
categories: react
tags: [react]
keywords:
  - react
  - redux
  - redux-saga
  - react-router-config
clearReading: true
thumbnailImage:
thumbnailImagePosition: left  //缩略图显示的位置，上下左右都可以
autoThumbnailImage: true
metaAlignment: center  //文章页图片上的文字居中显示
coverImage: http://pkafgcch8.bkt.clouddn.com/cover/cover.jpg
coverCaption:
coverMeta: in
coverSize: full
comments: true
---

先列举功能点：

1. react 热更新 react-hot-loader
2. css 提取
3. webpack4 的 splitcommonchunk
4. react-router-dom 和 redux 整合
5. redux-saga
6. react-router 动态配置 react-loadable
7. react-router-config 静态路由
8. sass/less
9. 重复渲染问题处理
10. webpack 打包第三方库

<!-- more -->

<h5>babel配置</h5>

``` .babelrc  %}

<!-- tab js -->

{
"presets":[
"react",
["env", {
"targets": {
"browsers": ["last 2 versions", "safari >= 7"],
"node": "current"
},
"modules": false,
"debug": true,
"include": [

"transform-es2015-arrow-functions", //箭头函数

"transform-es2015-spread" //扩展运算符

],
"exclude": [],
"useBuiltIns": true
}]
],
"plugins":[
["transform-runtime", {

"helpers": false,

"polyfill": false,

"regenerator": true,

"moduleName": "babel-runtime"

}],
["transform-object-rest-spread", {"useBuiltIns": true}],
"syntax-dynamic-import" // import() 函数
]
}

<!-- endtab -->

```

##### resolve 配置
在文件中可以直接使用 `src` 关键字 来引入文件
``` webpack.common.js  %}
<!-- tab js -->
resolve: {
  alias: {
      static: Path('../static'),
      src: Path('../src')
  }
}
<!-- endtab -->
```

`Path`是自己封装的
``` webpack.common.js  %}

<!-- tab js -->

const Path = (filePath) => path.join(path.resolve(\_\_dirname,filePath));

<!-- endtab -->

```

##### react-hot-loader
热更新使用的是 `react-hot-loader` 这个插件，可以在不刷新 state 的时候，刷新页面
入口文件配置：
``` webpack.dev.js  %}
<!-- tab js -->
  entry: {
      index: [
          `webpack-dev-server/client?http://localhost:${AppPort}`,
          'webpack/hot/only-dev-server',
          'react-hot-loader/patch',
          'babel-polyfill',
          Path('../src/main.js')
      ]
  },
<!-- endtab -->
```

`transform-runtime` 只会对 es6 的语法进行转换，而不会对新 api(Set、Maps 等)进行转换。如果需要转换新 api，就要引入`babel-polyfill`

##### 为什么需要引入 babel-runtime ?

`babel-polyfill` 通过帮助函数(helper) 实现 es6 功能后，会重复出现在一些模块里，导致编译后的代码体积变大。Babel 为了解决这个问题，提供了单独的包 `babel-runtime` 供编译模块复用工具函数。这时候就需要使用 `transform-runtime`：启用 `babel-runtime`，以避免编译输出的重复问题

###### 热更新还需俩个插件

``` webpack.dev.js  %}

<!-- tab js -->

// 显示 模块的 相对路径
new webpack.NamedModulesPlugin(),
// 浏览器 刷新
new webpack.HotModuleReplacementPlugin(),

<!-- endtab -->

```

##### 代码分割配置
``` webpack.dev.js  %}
<!-- tab js -->
  optimization: {
    minimize: false,
    runtimeChunk: true,
    mergeDuplicateChunks: true,
    removeEmptyChunks: true,
    splitChunks: {
      chunks: 'async',
      cacheGroups: {
        commons: {
            test: /[\\/]node_modules[\\/]/,
            name: "vendor",
            chunks: "all"
        }
      }
    }
  }
<!-- endtab -->
```

这个暂定这个配置，后期优化后，会更新上来

##### HthmlWebpackPlugin

插入 js 使用 assetHtmlPlugin
``` webpack.dev.js  %}

<!-- tab js -->

new HtmlWebpackPlugin({
title: 'React-Redux-App',
inject: true,
template: Path('../static/tpl.html'),
chunksSortMode: 'none'
}),
new AddAssetHtmlPlugin([

{

filepath: Path('../static/js/vendors_lib.js'),

includeSourcemap: false

},

{

filepath: Path('../build/\*.js'),

includeSourcemap: false

}

]),

<!-- endtab -->

```


##### webpack.dll.config.js
打包第三方公共的库
webpack.dev.js
``` webpack.dev.js  %}
<!-- tab js -->
new webpack.DllReferencePlugin({
      context: __dirname,
      manifest: require(path.resolve(__dirname, '../static/vendors-manifest.json'))
  }),
<!-- endtab -->
```

webpack.dll.config.js

``` webpack.dll.config.js  %}

<!-- tab js -->

module.exports = {
entry: {
vendors: [

'react',

'react-dom',

'react-router-dom',

'redux',

'react-redux'

]
},
output:{
filename: '[name]\_lib.js',
path: path.resolve(**dirname, '../static/js'),
library: '[name]\_lib'
},
plugins: [
new webpack.DllPlugin({
context: **dirname,
path: path.resolve(\_\_dirname,'../static/[name]-manifest.json'),
name: '[name]\_lib'
}),
new UglifyJsPlugin({
parallel: true,
sourceMap: true,
uglifyOptions: {
warnings: false,
output: {
comments: false,
beautify: false
},
compress: {
warnings: false,
drop_console: true,
collapse_vars: true,
reduce_vars: true
}
}
})
],
mode: 'development'
};

<!-- endtab -->

```


项目开始前 要先 运行一下 webpack.dll.config.js

##### 生产配置
css压缩:
loaders
``` webpack.pro.js  %}
<!-- tab js -->
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

    {
        test: /\.css$/,
        use: [
            MiniCssExtractPlugin.loader,
            'css-loader',
            'postcss-loader'
        ]
    },
    {
    test: /\.scss$/i,
    use: [
      MiniCssExtractPlugin.loader,
      'css-loader',
      'postcss-loader',
      'sass-loader'
    ]
  },
  {
    test: /\.less$/i,
    use: [
      MiniCssExtractPlugin.loader,
      'css-loader',
      'postcss-loader',
      'less-loader'
    ]
  }
<!-- endtab -->
```

js 压缩：
plugins

``` webpack.pro.js  %}

<!-- tab js -->

    new UglifyJsPlugin({
        sourceMap: true,
        test: /\.jsx?$/i,
        parallel: true, //使用多进程并行和文件换成提高构建速度
        cache: true,
        uglifyOptions: {
            nameCache: true,
            warnings: false,
            compress: {
                warnings: false,  //删除无用代码时不输出警告
                drop_console: true,  //删除所有console语句，可以兼容IE
                collapse_vars: true,  //内嵌已定义但只使用一次的变量
                reduce_vars: true,  //提取使用多次但没定义的静态值到变量
            },
            output: {
                beautify: false, //最紧凑的输出，不保留空格和制表符
                comments: false, //删除所有注释
            },
            ie8: true
        }
    }),

new MiniCssExtractPlugin({
filename: "[name].css",
chunkFilename: "[id].css"
}),

<!-- endtab -->

```


```

[项目链接](https://github.com/tiakia/react-redux-app)

```

```
