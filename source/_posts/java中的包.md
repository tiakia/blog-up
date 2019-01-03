---
title: java中的包
tags:
  - java
categories: java
abbrlink: 26716
date: 2017-11-13 12:10:16
description:
thumbnail:
keywords:
---

##### 1、作用

管理 java 文件  
解决命名冲突

##### 2、定义包： package 包名

**注：**

- 必须放在 java 源文件第一行
- 包名间可以使用“ . ” 号隔开

  `eg: com.imooc.MyClass`

```jsp
例如 ：音乐类 - MyClassMusic
-music
    com.imooc.music.MyClassMusic
-movie
    com.imooc.movie.MyClassMusic
```

<!-- more -->

##### 3、系统中的包

`java.(功能).(类)`

```
java.lang.(类) 包含java语言基础的类
java.util.(类) 包含java语言中各种工具类
java.io.(类) 包含输入、输出相关功能的类
```

##### 4、包的使用

1.可以使用`import`关键字，在某个文件使用其他文件中的类

```jsp
import com.imooc.music.MyClass
```

2.java 中，包的命名规范是全小写字母拼写 S 3.可以使用`*`号加某个包下的所有文件
