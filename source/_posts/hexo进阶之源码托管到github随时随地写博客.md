---
title: hexo进阶之源码托管到github随时随地写博客
tags: hexo
date: 2017-07-28 11:41:33
categories: hexo
description: 如何做到自己随时随地都可以编写自己的博客
thumbnail:
---
前段时间刚刚爬坑出来，记录一下，应该怎么托管自己hexo博客，不要像我一股脑的都push上去，结局就是熬夜加班重新配置了一份博客。
<!-- more -->
1.首先要先弄明白我们每次执行`hexo d -g`这是把你写好的markdown编译成HTML然后提交到git，而我们要做的是，就像随时随地都拿着一个U盘一样，blog的源码就在U盘里，可以在多台电脑上写自己博客。但是做为程序员，到哪都拿着个U盘才能写博客，是不是太low了，哈哈。还好我们有git。
2.我们先分析一下源码的文件
<img src='http://pkafgcch8.bkt.clouddn.com/hexo/file_dir.png'/>


3.不需要提交的 打开`gitignore`文件里面的就是
	  public 和 .deploy_git 文件在每次`hexo g`的时候回自动生成
	  node_modules 文件里的依赖只要有package.json 文件 `npm install`也可以生成
	  debug.log  错误记录日志 可要可不要吧
	  db.json 这个也是
4.必须提交的
	  scaffolds 这里边是一些模板文件，这个在你`hexo new title`的时候会默认加载这里的`post.md`文件
	  source这里边就是你写的博客了，包括一些时间轴，友情链接页面
	  config.yml 这个也肯定是必须的
	  thems文件，最坑的就在这了
5.我们知道主题文件之前都是从作者的github的账号上克隆下来的，所以主题文件的提交地址，就是主题作者的git，所以如果你要是直接`git push`那你就悲剧了，辛辛苦苦弄的主题配置结果已push啥都没有了，在往我们远程提交的时候一定要删除主题文件里.git文件夹,
6.我在我的github上新建了一个repo`hexo-origin`存放hexo源码
7.还有一个repo`blog`用来存放我`hexo d -g`静态网页的仓库
8.修改主题文件远程分支：

``` stylus
cd themes\
git remote -v	//查看你现在主题文件的远程分支 eg：origin
//如果和你的github地址不一样的话，删除主题文件里的.git文件
//退出到blog根目录
cd..
//查看根目录的远程分支
git remote -v
//如果一致的话就可以放心的push了
//git add . 添加所有文件，也可以git add thems/ source/ 一个个添加（推荐）
git add .
//查看一下提交的文件
git status
//如果是你想添加的
git commit -m 'blog first commit '
//先从远程拉一下
git pull hexo-oirgin master --rebase
//如果push不上去，git push hexo-origin master -f 强制推
git push hexo-origin master
```


登录github查看push成功没有

9，到了别的地方怎么写呢？

``` stylus
//找个合适的地方
git clone git@github.com:tiakia/hexo-origin.git
cd hexo-origin
npm install
//等待依赖安装成功
hexo s
```
提示成功，然后浏览器打开`localhost:4000`是不是你的博客呀！

然后就开心的写博客吧`hexo new 我是文章的标题`

写完后`hexo d -g`完记得要把源码提交到`hexo-origin`远程源码分支


  [1]: ./images/file_dir_3.png "file_dir"