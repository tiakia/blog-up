---
title: java中数组的使用
tags: [java]
date: 2017-10-26 09:17:40
categories: java
description:
thumbnail: 
keywords:
---
### java中操作数组需要四步
#### 1.声明数组
> 语法：   
    **数据类型[] 数组名**  
    **数据类型 数组名[]**  
```
int[] score; //存储学生成绩 类型为整型
double height[]; //存储学生身高 类型为浮点型
String[] names; //存储学生姓名 类型为字符串
```
<!-- more -->
#### 2.分配空间
简单的说就是指定数组中最多可存储多少个元素
> 语法 **数组名 = new 数据类型[数组长度]**
```
scores = new int[5];//长度为5的整数数组
height = new double[5];
names = new String[5];
```
> 上面俩步可以合并为一个步骤：
```
int[] scores = new int[5]
```
#### 3.赋值
分配空间后就可以向数组中放数据了，数组中元素都是通过下标来访问的，例如向 scores 数组中存放学生成绩
```
scores[0] = 89;
scores[1] = 79;
```
#### 4.处理数组中的数据
我们可以对赋值后的数组进行操作和处理，如获取并输出数组中元素的值
```
System.out.println("scores数组中的第一个元素的值："+ scores[0]);
```
在 Java 中还提供了另外一种直接创建数组的方式，它将声明数组、分配空间和赋值合并完成，如:
```
int[] scores = {78,91,84,68};
```
等价于：
```
int[] scores = new int[]{78,91,84,68};//new int[]后为空不能指定长度
```
**注意：**  
1.`int[] score = new int[5];`声明方式需要指定数组长度  
2.`int[] score = new int[5];`声明方式 int后面的中括号`[]`不能丢  
3.`int[] score = new int[]{1,2,3,4,5}`声明方式`new int[]`中括号里不能写数字
### 二维数组
#### 1.声明数组并分配空间
```
数据类型[][] 数组名 = new 数据类型[行的个数][列的个数];
```
或者：
```
数据类型[][] 数组名;
数组名 = new 数据类型[行的个数][列的个数];
```
#### 2.赋值
二维数组的赋值，和一维数组类似，可以通过下标来逐个赋值，注意索引从 0 开始
```
数组名[行的索引][列的索引] = 值;
int num[0][0] = 1;//第一行第一列的值为1
```
也可以在声明数组的同时为其赋值
```
数据类型[][] 数组名 ={{值1,值2...},{值11,值22...},{值21,值22...}};
```
#### 3.处理数组
二维数组的访问和输出同一维数组一样，只是多了一个下标而已。在循环输出时，需要里面再内嵌一个循环，即使用二重循环来输出二维数组中的每一个元素。如：
```
//定义一个俩行三列的二维数组并赋值
int[][] num={{1,2,3},{4,5,6}};
//定位行
for(int i = 0; i<num.length; i++){
//定位每行的元素
    for(int j = 0; j<num[i].length; j++){
    //依次输出每个元素
        System.out.println(num[i][j]);
    }
    //实现换行
    System.out.println();
}
```
**需要了解的：** 在定义二维数组时也可以只指定行的个数，然后再为每一行分别指定列的个数。如果每行的列数不同，则创建的是不规则的二维数组，如下所示
```
int[][] num = new int[3][];//定义一个三行的二维数组
num[0] = new int[2] //为第一行分配俩列
num[1] = new int[3] //位第二行分配三列
num[3] = new int[4] //为第三行分配四列
```
**注意:**  

1.常见的声明数组并赋值的方式：
```
int[] sum = {1,2,3,4,5,6}; => int[] sum = new int[]{1,2,3,4,5,6};
int[][] scores = {{1,2,3},{4,5,6}};
```
2.如果只是声明数组的长度但是并不赋值  
```
int[] num = new int[6];
int[][] scores = new int[2][3];
```
### java中数组的操作
#### java中提供了一个Arrays类来对数组进行操作。  
第一步：要先导入Arrays包
```
public com.imooc;
improt java.util.Arrays; //导入Arrays包。
```
第二步：使用Arrays包中的方法对数组进行操作
```
package com.imooc;
import java.uitl.Arrays; //导入Arrays包。

public class HelloWorld{
    public static void main(String[] args){
        int[] scores = {79,80,99,50,62};
        //调用Arrays包中的sort方法对数组进行排序
        Arrays.sort(scores);
        //调用Arrays包中的toString将数组转换为字符串
        System.out.println(Arrays.toString(scores));
        //[50, 62, 79, 80, 99]
    }
}
```

#### java中对数组的foreach循环
> 语法
```
for(元素类型 元素变量 : 遍历对象){
    执行代码
}
```
```
package com.imooc;
import java.util.Arrays;

public class HelloWorld{
    public static void main(String[] args){
        int[] scores = new int[]{89, 72, 64, 58, 99};
        Arrays.sort(socres);
        for( int score : scores) {
            System.out.println(score);//58 68 72 89 99
        }
    }
}
```