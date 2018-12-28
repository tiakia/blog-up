---
title: java中定义一个类的步骤
tags: [java]
date: 2017-10-31 15:06:30
categories: java
description:
thumbnail:
keywords:
---
#### 1.类是定义对象拥有的属性和方法
#### 类的组成： 属性和方法
#### a. 定义类名 
```
public class 类名{}
```
<!--more-->
#### b.定义属性
```
public class 类名{
    //定义属性部分（成员变量）
    属性1的类型 属性1;
    属性2的类型 属性2;
      ...
    //定义方法部分
    方法1;
    方法2;
      ...
}
```

例如：
```
public class Telphone{
    //定义对象的属性
    float screen;
    float cpu;
    flaot mem;
    //定义对象的方法
    void callPhone(){
        System.out.println("Telphone有打电话的功能");
    }
    void sendMsg(){
        System.out.println("Telphone有发短信的功能");
    }
}
```

### 使用对象步骤
#### 1.创建对象
```
类名 对象名 = new 类名();
Telphone phone = new Telphone();
```
#### 2.使用对象
```
phone.screen = 5;//给screen属性赋值5
phone.sendMsg();//调用sendMsg方法
```

### 成员变量和局部变量
#### 成员变量
> 在类中定义，用来描述对象将要有什么。
#### 局部变量
> 在类的方法中定义，在方法中临时保存数据的。
##### 局部变量和成员变量的区别
1.同一个方法中，不允许有同名局部变量  
2.在不同的方法中，可以有同名局部变量  
3.两类变量同名时，局部变量优先  
4.局部变量的作用域仅限定义它的方法，成员变量的作用域在整个类内部都是可见的  
5.java给成员变量初始值，不给局部变量初始值  

#### 构造方法

1.使用new+构造方法 创建一个新的对象
```
Telphone phone = new Telphone();
//Telphone()就是一个构造方法 
//phone是使用构造方法实例化出来的对象
```
2.构造方法时定义在java类中的一个用来初始化对象的方法，构造方法与类同名且没有返回值。
```
public 构造方法名(){
    //初始化代码
}
//没有返回值
//构造方法名与类名相同
// 可以指定参数
```
3.如果没有指定一个无参的构造方法，系统会自动生成一个无参的构造方法，如果不满意，可以自己定义一个无参的构造方法。
```
main():
    Telphone phone = new Telphone();
class Telphone:
    public Telphone(){
        System.out.println("无参的构造方法执行了！");
    }
```
4.有参的构造方法
```
main():
    Telphone phone2 = new Telphone(1.5f,2.0f,2.0f);
class Telphone:
    public Telphone(float newScreen,float newCpu,float newMem){
        if(newScreen<3.5f){
            System.out.println("参数输入有误，默认为3.5f");            
        }else{
            screen = newScreen;
        }
        cpu = newCpu;
        mem = newMem;
    }
```
> 无参和有参的构造方法可以创建对象，但是通过有参的构造方法可以给对象中的实例变量赋值。

5.构造方法有重载的特性：方法名相同，但参数不同的多个方法调用时会自动根据不同的参数选择相应的方法。