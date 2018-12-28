---
title: java中的抽象类
tags: [java]
date: 2017-11-13 12:12:33
categories: java
description:
thumbnail:
keywords:
---
##### 1.抽象类的定义
在java中使用abstract关键字用来修饰抽象类

##### 2.应用场景
a.在某些情况下，某个父类只是知道其子类应该包含怎样的方法，但无法准确知道这些

子类如何实现这些方法。（只是约束子类必须有哪些方法，而并不关注子类如何去实现它）  
<!-- more -->
b.从多个具有相同特征的类中抽象出一个抽象类，以这个抽象类作为子类的模板，从而

避免了子类设计的随意性。
##### 3.作用
限制子类必须实现某些方法，但不关注子类怎么实现
##### 4.使用规则
a. abstract定义抽象类  

b. abstract定义抽象方法，只有声明，不需要实现  

c. 包含抽象方法的类是抽象类。  

d. 抽象类中可以包含普通的方法，也可以没有抽象方法。

e. 抽象类不能直接创建，可以定义引用变量。

Telphone(抽象类)
```
public abstract class Telphone{
    //抽象方法没有方法体以分号结束
    //抽象方法。默认是public，可以不写，其他权限都不可以使用
    ////如果在抽象类中定义了   普通方法，必须实现，
    public abstract void call();
    public abstract void sendMsg();
}
```
CellPhone
```
public calss CellPhone extends Telphone{
    @Override
    public void call(){
        System.out.println("通过键盘来打电话");
    }
    @Override
    public void sendMsg(){
        System.out.println("通过键盘来发短信");
    }
}
```
SmartPhone
```
public calss SmartPhone extends Telphone{
    @Override
    public void call(){
        System.out.println("通过语音来打电话");
    }
    @Override
    public void sendMsg(){
        System.out.println("通过语音来发短信");
    }
}
```
Initial
```
public class Initial{
    pbulic static void main(String[] args){
        Telphone tel1 = new CellPhone();
        tel1.call();
        tel1.sendMsg();
        Telphone tel2 = new SmartPhone();
        tel2.call();
        tel2.sendMsg();
    }
}
```

抽象类用来约束子类。


