---
title: java中float和double的区别，char和string的区别
tags:
  - java
categories: java
abbrlink: 37652
date: 2017-10-24 10:12:58
description:
thumbnail:
keywords:
---

在慕课网学习 java 的时候，遇到一个问题，于是搜了一些相关资料。在这里记录一下。

#### float 和 double 的区别

| float             | double            |
| ----------------- | ----------------- |
| 单精度浮点数      | 双精度浮点数      |
| 内存分配 4 个字节 | 内存分配 8 个字节 |
| 有效小数位 6-7 位 | 有效小数位 15 位  |

<!--more-->

1. java 中默认声明的小数是`double`类型的，如`double d=4.0`
   如果声明： `float x = 4.0`则会报错，需要如下写法：`float x = 4.0f`或者`float x = (float)4.0`其中`4.0f`后面的`f`只是为了区别`double`，并不代表任何数字上的意义
2. 对编程人员而言，double 和 float 的区别是`double精度高，但double消耗内存是float的两倍，且double的运算速度较float稍慢`。

```jsp
float x = 4.1f
double d = 4.0
```

#### char 和 String 的区别

| char             | String                                   |
| ---------------- | ---------------------------------------- |
| 字符             | 字符串                                   |
| 定义时使用单引号 | 定义时使用双引号                         |
| 只能存储一个字符 | 可以存储一个或多个字符                   |
| 是基本数据类型   | 是一个类，具有面向对象的特征可以调用方法 |

```jsp
char c = 'x'
String name = "tom"
```
