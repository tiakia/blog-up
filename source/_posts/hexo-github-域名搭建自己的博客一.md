---
title: hexo+github+域名搭建自己的博客一
tags: 教程
categories: hexo
thumbnail: "/../images/search.png"
abbrlink: 18790
date: 2017-07-11 21:10:05
---

我是先注册的域名，我们就先从注册域名开始吧

1. 登录[万网](https://wanwang.aliyun.com)
   <!-- more -->
2. 输入一个你喜欢的域名，eg: baidu
   <img src='/../images/search.png'/>

3. 搜索结果会出现一群你输入的域名，区别就是后缀名不一样，com 的一般都被注册了 你可以选择一个没有被注册的你喜欢的，把它买下来。（便宜点就行）
   <img src='/../images/searchResult.png'/>
4. 解析域名，进入控制台 - 域名与网站（万网） - 域名
   <img src='/../images/control.png'/>
5. 开始解析域名
   点击解析
   <img src='/../images/jiexi.png'/>
6. 这里有几个参数要填写对
   - 记录类型 选择 CNAME 因为代码是托管在 github 上的
   - 主机记录 这个是访问你域名的前缀，一般都填 www
   - 解析线路 默认就行
   - 记录值 这个地方填写的是你 github 的地址，（你的账户名).github.io
   - 点击保存，等十分钟后，解析才会成功
     <img src='/../images/jiexi1.png'/>

### 第二步 配置 github

1. 登录[github](https://github.com)，点击 New repository 新建一个项目
   <img src='/../images/repository.png'/>
2. 填写项目名称，默认选择 Public,勾选图中 初始化新建一个 README 文件
   <img src="/../images/create.png"/>
3. 进入项目中，新建一个 gh-pages 分支，图中关键点已经标出
   <img src="/../images/createBranch.png"/>
4. 进入 gh-pages 分支，创建一个 new file，命名为 CNAME，文件内容，是你刚刚解析的域名,eg: www.superMan.party
   <img src="/../images/CNAME1.png"/>
   <img src="/../images/CNAME2.png"/>
   **别忘了提交文件哦**
   <img src="/../images/commit.png"/>
5. 最后一步，进入 setting 页面：
   <img src="/../images/setting.png"/>
   **配置如图**
   分支选择对，就是 gh-pages,域名填写对 www.superman.party,要和 CNAME 文件 一致了
   <img src="/../images/ghPages.png"/>

**静等十分钟后，在地址栏输入你的域名访问你的网站吧，下一篇教你快速打出绚丽的博客**
