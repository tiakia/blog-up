---
title: git操作之拉取指定分支
tags:
  - git
categories: git
keywords: git
abbrlink: 8586
date: 2017-09-08 14:12:37
description:
thumbnail:
---

这俩天工作总是遇到要拉取指定分支，或者需要提交代码到指定分支上，但是你本地有没有这个分支，这里记录一下加深一下记忆。

<!-- more -->

### 第一种方法 不删除本地代码

假设你拉取的是 master 的代码，后来别人又新建一个 dev 分支，让你在 dev 分支上进行开发新功能
1、查看远程分支

```bash
git branch -r
```

2、本地新建一个和远程名字一样的分支

```bash
git branch dev
```

3、然后切换到这个分支

```bash
git checkout dev
```

4、从远程分支拉取代码

```bash
git pull origin dev
```

5、在修改完代码后，提交你的修改到 origin dev 就可以

> 或者你在本地的 master 分支上改了，现在要你提交到 dev 分支

重命名 master 分支，然后再推送(git add , git commit , git push )

```bash
git branch -M dev
```

### 第二种方法 重新克隆一个

```
git clone <remote repo> -b <branch name>
```

#### 彩蛋，如何删除 github 上的远程分支

```
git push origin :<branch name>
```
