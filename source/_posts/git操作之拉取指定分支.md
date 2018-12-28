---
title: git操作之拉取指定分支
tags: [git]
date: 2017-09-08 14:12:37
categories: git
description:
thumbnail:
keywords: git
---
这俩天工作总是遇到要拉取指定分支，或者需要提交代码到指定分支上，但是你本地有没有这个分支，这里记录一下加深一下记忆。
<!-- more -->
##### 第一种方法 不删除本地代码
假设你拉取的是master的代码，后来别人又新建一个dev分支，让你在dev分支上进行开发新功能
1、查看远程分支
```
git branch -r
```
2、本地新建一个和远程名字一样的分支
```
git branch dev
```
3、然后切换到这个分支
```
git checkout dev
```
4、从远程分支拉取代码
```
git pull origin dev
```
5、在修改完代码后，提交你的修改到origin dev就可以
###### 或者你在本地的master分支上改了，现在要你提交到dev分支
重命名master分支，然后再推送(git add ,  git commit , git push )
```
git branch -M dev
```
#### 第二种方法 重新克隆一个
```
git clone <remote repo> -b <branch name>
```

#### 彩蛋，如何删除github上的远程分支
```
git push origin :<branch name>
```