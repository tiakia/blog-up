---
title: java中的接口
tags: [java]
date: 2017-11-13 12:13:11
categories: java
description:
thumbnail:
keywords:
---

### 通过接口描述俩个不同类型类之间的共同特性（PSP 和 SmartPhone）
#### 1、接口的概念
##### 接口可以理解为一种特殊的类，由全局常量和公共的抽象方法组成。
##### 类是一种具体实现体，而接口定义了某一批类所需要遵守的规范，接口不关心这些类的内部数据，也不关心这些类里方法的实现细节，他只规定这些类里必须提供的某些方法
<!-- more -->
#### 2.接口定义
##### 语法
```
[修饰符] /*abstract*/ interface 接口名 [extends 父接口1，父接口2...]{
    零到多个常量定义...
    零到多个抽象方法的定义...
}
```
**接口就是用来被继承、被实现的，修饰符一般建议用`public`**  
**注意：不能使用`private`和`protected`修饰接口**  
**接口会继承多个父接口，用逗号隔开。也可不继承父接口。**  
**定义的时候abstract省略了，系统会自动加上**

#### 3.接口的定义
##### 常量：
接口中的属性是常量，即使定义不添加`public static final`修饰符，系统也会自动加上。
##### 方法：
接口中的方法都是抽象方法，总是使用，即使定义时不添加`public abstract`修饰符，系统也会自动加上。
#### 4.使用接口
一个类可以实现一个或多个接口，实现接口使用`implements`关键字。java中一个类只能继承一个类，是不够灵活的，通过实现多个接口可以做补充
**语法：**
```
[修饰符] class 类名 extends 父类 implements 接口1，接口2...{
    类体部分//如果继承了抽象类，需要实现继承的抽象方法。要实现接口中的抽象方法。
}
```
**如果要继承父类，继承的父类必须在实现接口之前**  

定义一个`Telphone`抽象类型,实例化`CellPhone`和`SmartPhone`对象  

Telphone
```
public abstract class Telphone{
    public abstract void call();
    public abstract void sendMsg();
}
```
CellPhone
```
public class CellPhone extends Telphone{
    public void call(){
        System.out.println("诺基亚通过键盘来打电话");
    }
    public void sendMsg(){
        System.out.println("诺基亚通过键盘来发短信");
    }
}
```
SmartPhone
```
public class SmartPhone extends Telphone{
    public void call(){
        System.out.println("智能手机通过语音来打电话");
    }
    public void sendMsg(){
        System.out.println("智能手机通过语音来发短信");
    }
}
```
然后现在又有一个`Psp`对象他可以打游戏`SmartPhone`也可以打游戏，但是他俩

不属于一个类，但是有相同的功能，这样就可以定义一个接口来实现`PlayGame`的

功能  

IPlayGame (通常接口命名以`I`开始)
```
public /*abstract*/ interface IPlayGame{ //省略掉了 abstract 系统会自动加上
    public /*abstract*/ void playGame(); //同样省略掉了 abstract
}
```
Psp
```
//implements 关键字实现一个接口 
public class Psp implements IPlayGame{//IPlayGame的接口
    public void playGame(){
        System.out.println("PSP具有了玩游戏的功能！");
    }
}
```
SmartPhone 重写
```
//implements 关键字实现一个接口
public class SmartPhone extends Telphone implements IPlayGame{
    public void call(){
        System.out.println("智能手机通过语音来打电话");
    }
    public void sendMsg(){
        System.out.println("智能手机通过语音来发短信");
    }
    public void playGame(){
        System.out.println("智能手机具有了玩游戏的功能");
    }
}
```
Initial 测试
```
public class Initial{
    public static void main(String[] args){
		Telphone tel1 = new CellPhone();
		tel1.call();
		tel1.sendMsg();
		Telphone tel2 = new SmartPhone();
		tel2.call();
		tel2.sendMsg();
		
		//接口的引用 指向一个实现了接口的对象
		IPlayGame ip1 = new SmartPhone();
		ip1.playGame();
		IPlayGame ip2 = new Psp();
		ip2.playGame();
    }
}
```
运行结果
```
诺基亚通过键盘来打电话
诺基亚通过键盘来发短信
智能手机通过语音打电话
智能手机通过语音发短信
智能手机具有了玩游戏的功能
PSP具有了玩游戏的功能
```
##### 接口在使用过程中还经常与匿名内部类配合使用，匿名内部类就是没有名字的内部类，多用于关注实现而不关注实现类的名称。
**语法：可以直接`new`一个接口，并且在这个接口里实现这个方法（重点看代码）**
```
Interface i = new Interfacw(){
    public void method(){
        System.out.println("匿名内部类实现接口的方式");
    }
}
```
Initial 测试
```
public class Initial{
    public static void main(String[] args){
		Telphone tel1 = new CellPhone();
		tel1.call();
		tel1.sendMsg();
		Telphone tel2 = new SmartPhone();
		tel2.call();
		tel2.sendMsg();
		
		//接口的引用 指向一个实现了接口的对象
		IPlayGame ip1 = new SmartPhone();
		ip1.playGame();
		IPlayGame ip2 = new Psp();
		ip2.playGame();
		
		//匿名内部类使用
		IPlayGame ip3 = new IPlayGame(){
		    public void playGame(){
		        System.out.println("使用匿名内部类实现接口");
		    }
		};
		ip3.playGame();
		
		//匿名内部类使用 方法二
		new IPlayGame(){
		     public void playGame(){
		        System.out.println("使用匿名内部类实现接口二");
		    }
		}.playGame();
    }
}
```
运行结果
```
诺基亚通过键盘来打电话
诺基亚通过键盘来发短信
智能手机通过语音打电话
智能手机通过语音发短信
智能手机具有了玩游戏的功能
PSP具有了玩游戏的功能
使用匿名内部类实现接口
使用匿名内部类实现接口二
```