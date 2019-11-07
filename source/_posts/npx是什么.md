---
title: npx是什么
tags: npm
categories: nodejs
abbrlink: 3356
date: 2019-04-25 10:47:55
---

npm 从 5.2 版开始，增加了 npx 命令,也可以单独下载:

```bash
npm install -g npx
```

npx 的出现是为了解决一些我们平时工作中的一些痛点，本文列举几个常用的场景。

<!-- more -->

### 避免全局安装模块

以`create-react-app`为例，我们在创建脚手架项目时，脚手架一般都是安装到全局环境中，但是这些模块我们有时候只是偶尔用一下，也要安装到全局，这样会占用我们电脑的空间，这种情况我们可以使用`npx`来解决问题。

```bash
$ npx create-react-app myapp
```

`npx`可以做到运行`create-react-app`而不安装它，上面代码运行时，`npx` 将`create-react-app`下载到一个临时目录，使用以后再删除。所以，以后再次执行上面的命令，会重新下载`create-react-app`。

#### 运行指定版本的包

```bash
$ npx create-react-app@3.0 myapp
```

上面代码指定运行`3.0`版本的`create-react-app`

#### 使用本地包还是远程包

- `--no-install`参数
  如果想让 `npx` 强制使用本地模块，不下载远程模块，可以使用**`--no-install`**参数。如果本地不存在该模块，就会报错。

```bash
$ npx --no-install create-react-app myapp
```

    上面代码指定使用本地版本的`create-react-app`来创建`myapp`

- `--ignore-existing`参数
  如果想使用远程的`create-react-app`模块，不使用本地`create-react-app`模块，可以使用**`--ignore-existing`**参数

```bash
$ npx --ignore-existing create-react-app myapp
```

    上面的代码不会调用本地的`create-react-app`去创建`myapp`，而是会从远程调用最新的`create-react-app`

### 调用项目安装的模块

`npx` 想要解决的主要问题，就是调用项目内部安装的模块。比如，项目内部安装了测试工具 `Mocha`。

```bash
$ npm install -D mocha
```

一般来说，调用 `Mocha` ，只能在项目脚本和 `package.json` 的`scripts`字段里面， 如果想在命令行下调用，必须像下面这样。

```bash
# 项目的根目录下执行
$ node-modules/.bin/mocha --version
```

`npx` 就是想解决这个问题，让项目内部安装的模块用起来更方便，只要像下面这样调用就行了。

```bash
$ npx mocha --version
```

`npx` 的原理很简单，就是运行的时候，会到`node_modules/.bin`路径和环境变量`$PATH`里面，检查命令是否存在。

由于 `npx` 会检查环境变量`$PATH`，所以系统命令也可以调用。

```bash
# 等同于 ls
$ npx ls
```

注意，`Bash` 内置的命令不在`$PATH`里面，所以不能用。比如，`cd`是 `Bash` 命令，因此就不能用`npx cd`。

### 使用不同版本的 node

假设你本机安装的`node 10.15.0`的版本

```bash
$ npx node@9 -v
v9.11.2
$ node -v
v10.15.0
```

上面的指令表示，我们使用`npx`安装了`node v9.11.2`版本，使用后再删掉，再次打印`node`的版本变回了我们本机原本安装的`10.15.0`版本，某些情况下可能比`nvm`管理`node`版本更方便些。

- `-p`参数
  `-p`参数用于安装指定版本的模块，所以上面的指令可以写成这样：

```bash
$ npx -p node@9 node -v
v9.11.2
```

上面的指令表示，先安装`node v9.11.2`版本，然后再执行`node -v`命令

---

如果你是`Windows`系统要使用`nvmw`来管理`node`版本的话，可能会出错，这里推荐我修改的 [nvmw-china](https://github.com/tiakia/nvmw-china)来管理版本。

> 参考链接

[阮一峰](http://www.ruanyifeng.com/blog/2019/02/npx.html)
