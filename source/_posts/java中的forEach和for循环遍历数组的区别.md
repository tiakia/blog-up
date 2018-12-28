---
title: java中的forEach和for循环遍历数组的区别
tags: [java]
date: 2017-11-13 11:59:45
categories: java
description:
thumbnail:
keywords:
---


今天在慕课网做练习的时候遇到一个问题。要求生成一个1-100的随机数组。我用了forEach循环。运行结果都是0。后来改成了for循环结果正常了。上网查到这句话茅塞顿开。
#### foreach虽然能遍历数组或者集合，但是只能用来遍历，无法在遍历的过程中对数组或者集合进行修改，而for循环可以在遍历的过程中对源数组或者集合进行修改。
#### forEach 循环
> 语法   
```
for(数据类型 循环变量 : 循环数组){
    循环体
}
```
例如：
```
int[] scores = {88,95,62,58,77};
for(int socre : scores){
    System.out.println("学生的成绩分别为："+score);
}
```
**换句话说。forEach循环只能遍历数组，不能对数组中的项进行赋值等操作。**
所以如果你新建了一个空数组，然后给数组每一项赋值的时候，只能用for循环，而不能使用forEach循环。

