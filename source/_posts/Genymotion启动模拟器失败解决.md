---
title: Genymotion启动模拟器问题集锦
tags: [Genymotion]
date: 2018-04-11 10:30:41
categories:
description:
thumbnail:
keywords: Genymotion
---
### Genymotion ova 文件下载慢
用过的人都知道，genymotion 下载模拟器慢的可以，这里分享一个快速下载ova的方法
1.首先正常打开`genymotion`
2.然后点击`Add`,选择要下载的机型
3.然后点击`Cancel`
4.打开目录啊`C:\Users\lenovo\AppData\Local\Genymobile`找到`genymotion.log`日志文件，在最后找到下载链接
5.打开迅雷，新建下载任务，一会就下载好了，速度超快。
<!-- more -->
### Genymotion 启动 模拟器 报错
报错如下：
```
Unable to start virtual device.

The virtual device got no IP address.

The VirtualBox DHCP server has not assigned an IP address to the virtual device.To find a solution,...
```
解决办法：
- 关机，然后在开机的过程中，按下`f2`键
- 选择 `Security - Virtualization` 设置为 `Enabled`
- 打开 `VirtualBox`,选择要启动的模拟器，在常规中，设置版本为 `Ubuntu (64-bit)`
然后重新启动 Genymotion 就可以了
