---
title: hexo+github+域名搭建自己的博客二
date: 2017-07-16 21:10:05
tags: 教程
categories: hexo
---
 最近真的是有点懈怠了，隔了这么久才开始第二篇，最近在王老师的要求下开始做 react-native 做为一个刚开始了解react的新人来说，各种坑呀！生命周期，组件的设计，组件间传值，一个个的难题，哎，慢慢走吧！言归正传开始hexo部分。
### [hexo官网传送地址](https://hexo.io)
 #### hexo 是什么
 hexo是一个基于nodejs的搭建自己博客框架，使用它你可以快速创建一个漂亮的博客，配合上自己的域名+github 就是一个完美的个人空间。
 <!-- more -->
 ### 第一步 安装软件
##### [Git](https:///git-scm.com/downloads)

1.选择对应的版本下载安装
2.安装完成后，在开始菜单里找到“Git”->“Git Bash”，蹦出一个类似命令行窗口的东西，就说明Git安装成功！
3.然后开始配置本地git和远程的github账户联系起来。
	```
	$ git config --global user.name "你的账户名"
	$ git config --global user.email "你注册时候的邮箱"
	```

4.这个时候你是不能往你的github推东西的，还需要配置ssh秘钥，只有配置好ssh了你才可以用这台电脑往你的github账号上推东西
    ```
    ssh-keygen -t rsa -C "你注册的邮箱"
    ```
5.一路回车，在用户主目录下（一般是Win+R 打开运行，输入cmd 回车，显示的路径），找到.ssh文件夹，	在文件夹内找到 **id_rsa** 和 **id_rsa.pub** 这两个文件，id_rsa.puh就是我们要的公钥，打开这个文件，***Ctrl+A    Ctrl+C***
6.打开[gitHub添加SSH Key](https://github.com/settings/keys),点击 **New SSH Key**,随便起个Title,把刚才复制的内容添加到Key里，就可以了。

##### [NodeJs](https://nodejs.org/en/download)
1.下载，并安装对应的版本，
2.安装好后，应该会自动配置好环境变量，Win+R,输入 cmd ,输入 node -v 如果出现NodeJs的版本号，说明安装成功了。
### 第二步 安装Hexo
 真正的重头戏来了，推荐是去看官网，教程。
1.找到一个放你博客的文件夹，eg:E盘，
```
e: #进入E盘
npm install -g hexo-cli #安装hexo
hexo init blog	#初始化并创建一个blog的文件夹
cd blog	#进入blog文件夹
npm install	#安装必要的依赖
hexo server	# 开启本地服务器
```
2.到这你已经可以看一个雏形了，输入` hexo server `命令成功后，会提示你，打开`localhost：4000`在浏览器输入`localhost：4000`，就可以看到一个初始化的博客页面了
### 第三步 自定义配置博客
打开_config.yml文件，这个就是自定义的文件，自定义配置可以自己玩 [传送门](https://hexo.io/docs/configuration.html)，要注意每个配置项` ：`后都要加一个空格 我只说几个必须配置的


1.URL 这个写的就是你申请的域名
2.deploy 配置部署
```
deploy:
        type: git
        repo: git@github.com:tiakia/blog.git  #这个地址要填写ssh的不要填写https的
        branch: gh-pages  #git上你设置CNAME的分支
        message: "{{ now('YYYY-MM-DD HH:mm:ss') }}"
```
3.[配置主题](https://hexo.io/themes/) 可以在这找找自己心仪的主题，我使用的是[Material主题](https://material.viosey.com/start/#install-material/),官方文件中文的可以跟着去看一下。主体文件一般都是压缩文件，放到根目录的thems文件加下，并且还要修改`_config.yml`文件，找到`theme`字段，写上你的主题文件夹名称即可。
### 第四步 配置部署


配置好一个主题后，就是要新建一篇博客，并且发布到自己的git上了，
这里要先安装一个扩展
```
$ npm install hexo-deployer-git --save
```


1.新建一篇文章
```
hexo new "我的第一篇博客"
```
2.建好后，会提示路径，然后使用MarkDown编辑器打开，"我的第一篇博客" ，编辑吧，你可能需要学习一下[MarkDown](http://wowubuntu.com/markdown/index.html) 的语法，5分钟就学会了。

3.编辑好后保存，`hexo server`,打开浏览器输入`localhost:4000`,查看你新写的文章吧！
4.接下来就是发布到github上，然后你再通过你的域名访问你刚刚写的博客了，需要这样一行命令
```
hexo d -g
```
注意：这里有个坑，这里，要本地新建一个CNAME文件，内容是你的域名，然后把它放到博客根目录的source文件夹内，这样每次部署到Git就可以直接访问网站了，不需要去重新增加一个CNAME文件，或者去`setting gh-page`去再填写自己的域名了。
 这样就大功告成了，你的一篇博客就成功发布到你自己github上，然后可以通过你申请的域名访问了！