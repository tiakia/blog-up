---
title: Emacs使用第一篇
tags: [emacs]
date: 2017-08-04 22:57:27
categories: emacs
description:
thumbnail:
keywords: emacs
---
同事一直在耳旁推荐使用这个编辑器，引用编程界的几句话，来说一下这款编辑器的地位，世界上有三种编辑器，一种是Emacs,一种是Vim,还有一种是其他；Emacs被称作是神用的编辑器，Vim被称作是神一样的编辑器，足以说明Emacs的地位，作为程序猿理想的编辑器，应该是有长远性的，可定制性的，逐渐形成一个符合自己习惯的编辑器，我先用了Vim，老实说有点不习惯它的来回切换模式的做法，只是尝试了一下就放弃了，那会也许是想着这款神用的编辑器，果不其然，只是一会就觉得一个字，爽，比起vim来Emacs用的真是爽爆了，Emacs提倡的所见即所得，不想Vim那样需要来回切换编辑模式，Emacs是输入什么就是什么。
<!-- more -->
1.下载[Emacs](https://www.gnu.org/software/emacs/)，选择对应的版本下载安装，我选择的是`emacs-25.1-x86_64-w64-mingw32.zip`，下载完成后解压到一个盘，记得新建一个文件`emacs`，然后解压到这里，要不就会解压到根目录，然后找到bin目录，配置到环境变量中，比如说我的解压到了D盘一个Pragram文件下的emacs文件中，那我配置到环境变量的路径就是`D:\Pragram\emacs\bin`这样就可以在命令行中运行emacs了，`Win + R` 输入`cmd`,然后输入`emacs`，打开emacs的gui界面，输入`emacs -nw` 直接在命令行打开emacs

2.先来了解一下基本概念，在windows中，Emacs的 `C` 表示的`Ctrl`键，`M` 表示的`Alt`键，一般的命令都是与这俩个命令分不开的，这里建议将`Ctrl`键与大写锁定键`CapsLock`换掉，否则的话对小拇指的压力太大了， 建议先看教程，因为写的太好了，绝对是入门的好东西，而且还是中文，打开教程的快捷键`C-h t`,然后就进入教程了。

3.推荐世界级大神[Purcell](https://github.com/purcell/emacs.d)的配置，windows下ui界面有点卡
```
git clone https://github.com/purcell/emacs.d.git ~/.emacs.d
```
4.Windows下进入`C盘\用户\用户名\.emacs.d`找到`.emacs.d`文件夹配置文件就在这里.如果这里没有的话,到这里找`C盘\用户\用户名\AppData\Roaming\.emacs.d`
5.第一次打开`emacs`的时候要等待一段时间,需要联网下载`package`生成一个`elpa-版本号`的文件夹,里面就是下载的各种包文件
6.purcell的配置提供了自定义配置的文件`init-local.el`,如果你有自定义的东西可以在`lisp`文件夹下新建`init-local.el`,然后在里面填写你的配置,`init-preload-local.el`这个文件是定义要提前加载的包,如果需要也可以自己添加
```
;;; pacakge --- local
;;; Commentary:
;;; Code:

;; 这里是你自定义的 代码

(provide 'init-local)
;;; init-local.el ends here

```
大概就这样了,一起来享受emacs吧~

