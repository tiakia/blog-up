---
title: nvmw管理node版本排坑
tags: [node]
date: 2018-12-11 15:24:43
keywords:
  - nvmw
  - node
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

nvmw 是 nvm 专为 Windows 开发的版本，用来管理 node 的版本，这里总结一下排坑记录

<!-- more -->

#### 第一步：安装

```bash
git clone https://github.com/hakobera/nvmw.git
```

#### 第二步：配置环境变量

重新打开命令行窗口，输入`nvmw`查看是否安装正确

#### 排坑

因为墙的原因，会导致我们安装 `node` 不成功，这里在 github 上作者也给出了解决方法，设置淘宝源，可能因为版本原因，网上搜到的答案都是比较过期的不能解决问题，这里我提供一种思路解决。

- 首先是作者给出的解决办法

```bash
set "NVMW_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node"
set "NVMW_IOJS_ORG_MIRROR=http://npm.taobao.org/mirrors/iojs"
set "NVMW_NPM_MIRROR=http://npm.taobao.org/mirrors/npm"

nvmw install 0.11.14
nvmw install node-v0.11.15
nvmw install iojs
nvmw install iojs-v1.0.2
```

但是每次安装都需要执行一下 set 命令，比较麻烦我们直接修改配置文件。

- 打开 get_npm.js 文件，搜索作者让我们这命令行 set 的那几个变量，

  - 修改这俩个变量为以下这样

    ```javascript get_npm.js
    var NVMW_NPM_MIRROR = "http://npm.taobao.org/mirrors/npm";
    var NVMW_IOJS_ORG_MIRROR = "http://npm.taobao.org/mirrors/iojs";
    ```

  - 修改判断`binType === 'iojs'`这个表达式的 else 语句对应的位置：

    ```javascript get_npm.js
    //var pkgUri = util.format(NPM_PKG_JSON_URL, 'joyent/node',
    //binVersion === 'latest' ? 'master' : binVersion);
    var pkgUri = "https://npm.taobao.org/mirrors/node/index.json";
    wget(pkgUri, function(filename, pkg) {
      //if (filename === null) {
      //return noNpmAndExit();
      //}
      //downloadNpmZip(JSON.parse(pkg).version);
      if (filename === null) {
        return noNpmAndExit();
      }
      var _pkg = JSON.parse(pkg);
      for (var i = 0, n = _pkg.length; i < n; i++) {
        var obj = _pkg[i];
        if (obj.version == binVersion) {
          downloadNpmZip(obj.npm);
        }
      }
    });
    ```

* 修改 nvmw.bat 文件

- x64 改为 win-x64

  ```bat nvmw.bat
  set NODE_EXE_URL=%NVMW_NODEJS_ORG_MIRROR%/%NODE_VERSION%/win-x64/node.exe
  ```

- 设置 NVMW_NODEJS_ORG_MIRROR/NVMW_IOJS_ORG_MIRROR 变量

  ```bat nvmw.bat
  原始为:
  if not defined NVMW_NODEJS_ORG_MIRROR (
    set "NVMW_NODEJS_ORG_MIRROR=https://nodejs.org/dist"
  )

  if not defined NVMW_IOJS_ORG_MIRROR (
    set "NVMW_IOJS_ORG_MIRROR=https://iojs.org/dist"
  )
  修改为:
  set "NVMW_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node"
  set "NVMW_IOJS_ORG_MIRROR=http://npm.taobao.org/mirrors/iojs"
  ```

* 修改 `fget.js` 文件 47 行，`XMLHTTP` 更改为 `ServerXMLHTTP`

#### 注意点：

在修改完这几处地方后应该可以正常下载`node.exe`和`npm.zip`文件并解压了，但是一到最后总会提示，找不到该文件或者文件不存在或者进程被占用之类的，然后本来下载好的文件会都给你删掉。。。我仔细研究了一下代码发现问题出在这里

```bat nvmw.bat
 echo Start unzip "%NPM_ZIP_FILE%" to "%NODE_HOME%"
 cscript //nologo "%NVMW_HOME%\unzip.js" "%NPM_ZIP_FILE%" "%NODE_HOME%"
 mkdir "%NODE_HOME%\node_modules"
 rmdir /s /q "%NODE_HOME%\node_modules\npm"
 move npm-* "%NODE_HOME%\node_modules\npm"
 copy "%NODE_HOME%\node_modules\npm\bin\npm.cmd" "%NODE_HOME%\npm.cmd"
 cd "%CD_ORG%"
 if not exist "%NODE_HOME%\npm.cmd" goto install_error
 echo npm install ok
```

先解释一下这段代码的意思，以下载 8.14.0 版本为例(`%NODE_HOME%`变量表示存放 node 的文件夹比如 v8.14.0，在下载的时候会自动创建该文件夹)

1. 在命令行输出 开始解压下载好的 npm.zip 文件
2. 调用`unzip.js`文件开始解压缩 npm.zip,后面俩个是参数列表
3. 新建 v8.14.0/node_modules 文件夹
4. 删除 v8.14.0/node_modules 文件夹下的 npm 文件
5. 将解压缩成功的 npm-\* 文件夹移动到 新建好的 node_modules 文件夹下
   问题出在这里安装 5.x 版本没有问题因为 npm.zip 的压缩包里就是 npm-5.6.1 类似的
   而 8.14.0 版本 npm.zip 压缩包里面就是 cli-6.4.1 了
   找不到文件自然就报错了，然后就会把下载好的 node 和 npm 压缩包一起删掉
6. 将 node_modules/npm/bin/npm.cmd 拷贝到 v8.14.0 文件夹下

##### 解决：

- 可以把第五步第六步的代码注释了自己操作
- 也可以修改第五步代码 自动操作
  ```bat nvmw.bat
    move *-* "%NODE_HOME%\node_modules\npm"
  ```

#### 使用步骤

安装 nodejs

```bash
nvmw insall 6.9.2
```

展示

```bash
nvmw ls
```

使用

```bash
nvmw use 6.9.2
```

[我修改后的版本](https://github.com/tiakia/nvmw-china)
