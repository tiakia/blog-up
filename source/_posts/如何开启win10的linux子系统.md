---
title: 如何开启win10的linux子系统
abbrlink: 24326
date: 2019-06-14 15:11:58
tags: 工具
categories: 工具
---

转载自 CSDN 备忘一下。

<!-- more -->

### **启用开发者模式**

#### **打开设置**

![](/images/win10-linux-1.png)

#### **点击更新和安全**

![](/images/win10-linux-2.png)

#### **点击开发者选项**

![](/images/win10-linux-3.png)

#### **启用开发人员模式**

![](/images/win10-linux-4.png)

#### **更改系统功能**

使用 `win+X` 快捷键调出系统管理菜单后点击应用和功能，选择程序和功能

![](/images/win10-linux-5.png)

#### **选中启用或关闭 Windows 功能**

![](/images/win10-linux-6.png)

#### **勾选适用于 Linux 的 Windows 子系统**

然后确认并重启就可以了

![](/images/win10-linux-7.png)

### **安装 Linux 系统**

---

打开功能以后系统中其实还没有安装 Linux，需要使用 cmd 完成安装。
首先按`Win+R` 开启 cmd 命令输入框，然后输入`lxrun /install /y` 来下载 Linux 系统（注意斜杠后面前要空一格，要不然无法识别命令）

PS: 这里安装需要翻墙

---

![](/images/win10-linux-8.png)

好了，现在安装成功了，可以为所欲为了！

首先输入 bash 指令进入 Ubuntu 系统

![](/images/win10-linux-9.png)

接着可以输入 passwd 重置密码，重置完密码就可以正常使用 Ubuntu 系统了。至此，基本的安装工作就完成了。

=================================菜鸟分割线===================================

## Linux 进阶

在 Ubuntu 下我们可以通过 `apt-get` 命令 很方便的安装 / 卸载软件，由于默认的软件包仓库是位于国外的，安装软件的时候就可能遇到各种网络问题或者下载到的一些资源不完整，因此就需要切换数据源为国内的镜像站点来改善。

编辑数据源配置文件 `vi /etc/apt/sources.list`

![](/images/win10-linux-10.png)

接着就进入 `vi` 编辑器

![](/images/win10-linux-11.png)

继续按 `enter` 键进入真正的 `vi` 编辑页面

![](/images/win10-linux-12.png)

vi 编辑器一共有三种模式，分别是**命令模式（command mode）**、**插入模式（Insert mode）**和**底行模式（last line mode）**。命令模式下我们只能控制屏幕光标的移动，字符、字或行的删除，移动复制某区段及进入 Insert mode 下，或者到 last line mode 等；插入模式下可以做文字输入，按「ESC」键可回到命令行模式；底行模式下，可以将文件保存或退出 vi，也可以设置编辑环境，如寻找字符串、列出行号等。

当我们进入 vi 编辑器的时候默认是命令行模式，这是后如果想编辑内容，就输入 `i/a` 命令就可以了。现在我们要把镜像源改为阿里的，所以插入如下内容：

```bash
deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
```

复制上面的代码，移动光标到最后一行，按`A`键，然后点击鼠标右键复制
接着按`「ESC」`退到命令行模式，输入命令行 `wq!` 保存退出就好了。

接着输入命令 `apt-get update` 更新配置就可以了，这个过程可能比较长，祝好运！

![](/images/win10-linux-13.png)

---

> 参考链接

[云扬大叔](https://blog.csdn.net/zhangdongren/article/details/82663977)
