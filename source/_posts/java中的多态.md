---
title: java中的多态
tags: [java]
date: 2017-11-13 12:11:53
categories: java
description:
thumbnail:
keywords:
---
#### 对象的多种形态
##### 1.引用的多态  
    父类的引用可以指向本类的对象  
    父类的引用可以指向子类的对象  
    
**使用多态的时候俩个类一定要有继承关系**
```
Animal animal = new Animal();//父类的引用Animal 指向本类的对象 new Animal();
Animal dog = new Dog();//父类的引用Animal 指向子类的对象 new Dog();
```
<!-- more -->
##### 2.方法的多态
    创建本类对象时，调用的方法为本类方法
    创建子类对象时，调用的方法为子类重写的方法或者继承的方法
    
**注意：**  
如果方法是子类独有的，那么通过父类的引用创建的对象不能调用这个方法。

#### 引用类型的转换
##### 1.向上类型的转换(隐式/自动类型的转换)，是小类型到大类型的转换
##### 2.向下类型转换(强制类型转换)，是大类型到小类型
##### 3.instanceof运算符，来解决引用对象的类型，避免类型转换的安全性问题
```
Dog dog = new Dog();
Animal animal = dog;//向上类型转换 自动转换类型
if(animal instanceof Dog){
    Dog dog2 = (Dog)animal;//强制类型转换。
}else{
    System.out.println("无法进行类型转换 转换成Dog类型");
}
//避免引用类型转换的危险
if(animal instanceof Cat){
    Cat cat = (Cat)animal;//1.编译时 Cat类型 2.运行时 Dog类型
}else{
    System.out.println("无法进行类型转换  转换成Cat类型");
}
```
如果要进行类型转换。使用`instanceof`关键字来进行验证是否可以转换。