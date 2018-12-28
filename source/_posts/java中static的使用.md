---
title: java中static的使用
tags: [java]
date: 2017-11-13 12:01:40
categories: java
description:
thumbnail:
keywords:
---
#### static的使用之变量

java中被static修饰的成员称为静态成员或类成员。它属于整个类所有，而不是某个对象所有，即被类的所有对象所共享。静态成员可以使用类名直接访问，也可以使用对象名进行访问。推荐使用类名访问。
> 使用static可以修饰变量、方法和代码块
```
public class HelloWorld{
    //static 修饰的变量是静态变量，所有HelloWorld类的对象共享hobby
    static String hobby = "imooc";
    
    public static void main(String[] args){
        //静态变量可以直接使用类名来访问，无需创建类的对象
        System.out.println("通过类名访问hobby:"+ HelloWorld.hobby);
        //创建类的对象
        HelloWorld hello = new HelloWorld();
        //使用对象名来访问静态变量
        System.out.println("通过对象名来访问hobby: "+ hello.hobby);
        //使用对象名的形式修改静态变量的值
        hello.hobby = "爱慕课";
        //再次使用类名访问静态变量，值已被修改
        System.out.println("通过类名访问hobby: "+ HelloWorld.hobby);
    }
}
```
<!-- more -->
运行结果
```
通过类名访问hobby： imooc
通过对象名访问hobby：imooc
通过类名访问hobby： 爱慕课
```
>要注意哦：静态成员属于整个类，当系统第一次使用该类时，就会为其分配内存空间直到该类被卸载才会进行资源回收！~~

#### static的使用之方法
```
public class HelloWorld(){
    //使用static关键字声明静态方法
    public static void print(){
        System.out.println("欢迎您：爱慕课");
    }
    public static void main(String[] args){
        //直接使用类名调用静态方法
        HelloWorld.print();
        //也可以通过对象名调用，当然更推荐使用类名调用的方式
        HelloWorld demo = new HelloWorld();
        demo.print();
    }
}
```
需要注意：
##### 1.静态方法中可以直接调用同类中的静态成员，但不能直接调用非静态成员。
```
public class HelloWorld{
    String name = "爱慕课";//非静态变量name
    static String hobby = "imooc";//静态变量hobby
    
    //在静态方法调用静态变量
    public static void print(){
        Sytem.out.println("欢迎您： "+name + "！");//这里不能直接调用非静态变量
        
        System.out.println("爱好： "+ hobby + "! ");//可以直接调用静态变量
    }
}
```
**如果希望在静态方法中调用非静态的变量，可以通过创建类的对象，然后通过对象来访问非静态变量**
```
//在静态方法中调用非静态变量
public static void print(){
    //创建类的对象
    HelloWorld hello = new HelloWorld();
    //通过对象来实现在静态方法中访问非静态的变量
    System.out.println("欢迎您： "+ hello.name + " !");
    System.out.println("爱好：" + hobby + " !");
}
```
##### 2.在普通成员方法中，则可以直接访问同类的非静态变量(方法)和静态变量(方法)
```
String name = "爱慕课" //非静态变量name
static String hobby = "imooc" // 静态变量hobby

//普通成员方法可以直接访问非静态变量和静态变量
public void show(){
    System.out.println("欢迎您："+ name + " !");
    System.out.println("爱好: "+ hobby + " !");
    print();
}
public static void print(){
    System.out.println("静态方法print");
}
```
##### 3.静态方法中不能直接调用非静态方法，需要通过对象来访问非静态方法。
```
//普通成员方法
public void show(){
    System.out.println("Welcom to imooc");
}
//静态方法
public static void print(){
    System.out.println("欢迎来到慕课网");
}
public static vod main(String[] args){
    //普通成员方法必须通过对象调用
    HelloWorld hello = new HelloWorld();
    hello.show();
    //可以直接调用静态方法
    print();
}
```
#### java中的初始化块
java中可以使用初始化块进行数据赋值：
```
public class HelloWorld{
    String name;//定义一个成员变量
    //通过初始化块为成员变量赋值
    {
        name = "爱慕课";
    }
}
```
在类的声明中，可以包含多个初始化块，当创建类的实例是，就会依次执行这些代码块。如果用static修饰初始化块，就称为静态初始化块。  
**注意：**     静态初始化块只在类加载时执行，且只会执行一次，同时静态初始化块只能给静态变量赋值，不能初始化普通的成员变量。
```
public class HelloWorld{
    int num1;//声明变量num1
    int num2;//声明变量num2
    static int num3;//声明变量num3
    public HelloWorld(){ //构造方法
        num1 = 91;
        System.out.println("通过构造方法为变量num1赋值");
    }
    {//初始化块
        num2 = 74;
        System.out.println("通过初始化块为变量num2赋值);
    }
    static{//静态初始化块
        num3 = 86;
        System.out.println("通过静态初始化块为静态变量num3赋值");
    }
    public static void main(String[] args){
        HelloWorld hello = new HelloWorld();//创建类对象hello
        System.out.println("num1:" + hello.num1);
        System.out.println("num2:" + hello.num2);
        System.out.println("num3:" + num3);
        HelloWorld hello2 = new HelloWorld();//再创建类的对象hello2
    }
}
```
运行结果
```
通过静态初始化块为静态变量num3赋值
通过初始化块为变量num2赋值
通过构造方法为变量num1赋值
num1: 91
num2: 74
num3: 86
通过初始化块为变量num2赋值
通过构造函数为变量num3赋值
```
程序运行时静态初始化块最先被执行，然后执行普通初始化块，最后才执行构造方法。由于静态初始化块只在类加载时执行一次，所以当再次创建对象 hello2 时并未执行静态初始化块。