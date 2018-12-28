---
title: java中的自动类型转换和强制类型转换
tags: [java]
date: 2017-11-13 11:56:32
categories: java
description:
thumbnail:
keywords:
---
在 Java 程序中，不同的基本数据类型的数据之间经常需要进行相互转换。例如：
```
int score1 = 82;
double score2 = score1;
System.out.println(score2);
```
代码中 int 型变量 score1 可以直接为 double 型变量 score2 完成赋值操作，运行结果为： 82.0 

 这种转换称为`自动类型转换`。  
 当然自动类型转换是需要满足特定的条件的：
<!-- more -->
1.  目标类型能与源类型兼容，如 double 型兼容 int 型，但是 char 型不能兼容 int 型
 2.  目标类型大于源类型，如 double 类型长度为 8 字节， int 类型为 4 字节，因此 double 类型的变量里直接可以存放 int 类型的数据，但反过来就不可以了
 ```
 public class HelloWorld{
     public static void main(String[] args){
         double avg1 = 78.5;
         int rise = 5;
         //init avg2 = avg1+rise;//错误
         double avg2 = avg1+rise;//正确
         System.out.println("考试平均分："+avg1);
         System.out.println("调整后的平均分："+ avg2);
     }
 }
 ```
 ### 强制类型转换
 当程序中需要将 double 型变量的值赋给一个 int 型变量，该如何实现呢？

显然，这种转换是不会自动进行的！因为 int 型的存储范围比 double 型的小。此时就需要通过强制类型转换来实现了
> 语法： **(数据类型)数值**
```
double avg1 = 75.8;
int avg2 = (int)avg1;
System.out.println(avg1);//75.8
System.out.println(avg2);//75
```

可以看到，通过强制类型转换将 75.8 赋值给 int 型变量后，结果为 75，数值上并未进行四舍五入，而是直接将小数位截断。