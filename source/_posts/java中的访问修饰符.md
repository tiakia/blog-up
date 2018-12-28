---
title: java中的访问修饰符 && java中的内部类
tags: [java]
date: 2017-11-13 12:02:17
categories: java 
description:
thumbnail:
keywords:
---
##### 访问修饰符 --- 可以修饰属性和方法的访问范围

访问修饰符 | 本类 | 同包 | 子类 | 其他
---|---|---|---|---|
private | √ | | | 
默认 | √ | √ | |
protected | √ | √ | √ |
public | √ | √ | √ | √
<!-- more -->
#### 内部类
内部类就是定义在另外一个类里面的类。与之对应，包含内部类的类被称为外部类
##### 内部类的作用
1.内部类提供了更好的封装，可以把内部类隐藏在外部类之内，不允许同一个包中的其他类访问该类  
2.内部类的方法可以直接访问外部类的所有数据，包括私有的数据  
3.内部类所实现的功能使用外部类同样可以实现，只是使用内部类更方便
##### 内部类的分类  
-     成员内部类
-     静态内部类
-     方法内部类
-     匿名内部类
#### 成员内部类
```
//外部类Outer
public class Outer{
    private int a = 9;//外部类的私有属性
    //内部类 Inner
    public class Inner{
        int b = 2;//内部类的成员
        public void test(){
            System.out.println("访问外部类的a：" + a);
            System.out.println("访问内部类中的b：" + b");
        }
    }
    
    //测试成员内部类
    public static void main(String[] args){
        Outer o = new Outer(); //创建外部类对象，对象名为o
        Inner i = o.new Inner(); //使用外部类对象创建内部类对象，对象名为i
        i.test(); //调用内部类对象的test方法
    }
}
```
运行结果：
```
访问外部类的a：9
访问外部类的b：2
```
##### 成员内部类的使用方法
1. Inner 类定义在 Outer类的内部，相当于Outer类的一个成员变量的位置，Inner 类可以使用任意访问控制符，如 public 、 protected 、 private 等  

---

2. Inner 类中定义的test()方法可以直接访问Outer类中的数据，而不受访问控制符的影响，如直接访问 Outer 类中的私有属性a  

---

3. 定义了成员内部类后，必须使用外部类对象来创建内部类对象，而不能直接去 new 一个内部类对象，即：内部类 对象名 = 外部类对象.new 内部类( );  

---

4. 编译上面的程序后，会发现产生了两个 .class 文件 其中，第二个是外部类的 .class 文件，第一个是内部类的 .class 文件，即成员内部类的 .class 文件总是这样：`外部类名$内部类名.class`

---
###### 友情提示
1.外部类是不能直接使用内部类的成员方法的，需要先创建内部类的对象，然后通过内部类的对象来访问其成员变量和方法。
```
//外部类HelloWorld
public class HelloWorld{
    //内部类Inner
    public class Inner{
        //内部类的方法
        public void show(){
            System.out.println("Welcome to imooc");
        }
    }
    public static void main(String[] args){
        //创建外部类对象
        HelloWorld hello = new HelloWorld();
        //创建内部类的对象
        Inner o = hello.new Inner();
        //通过内部类的对象访问内部类的属性和方法
        o.show();
    }
}
```
2.如果外部类和内部类具有相同的成员变量或方法，内部类默认访问自己的成员变量或方法，如果要访问外部类的成员变量，可以使用 this 关键字。如：
```
//外部类Outer
public class Outer{
    int b = 1;//外部类中的变量b
    //内部类Inner
    public class Inner{
        int b = 2;//内部类的成员属性b
        public void test(){
            System.out.println("访问外部类中的变量b"+ Outer.this.b);
            System.out.println("访问内部类中的b："+ b);
        }
    }
    public static void main(String[] args){
        HelloWorld hello = new HelloWorld();
        Inner inn = hello.new Inner();
        inn.show();
    }
}
```
#### 静态内部类
静态内部类是static 修饰的内部类，这种内部类的特点是：  
1.静态内部类不能直接访问外部类的非静态成员，但可以通过`new 外部类().成员`访问  
2.如果外部类的静态成员和内部类的静态成员名称相同，可通过`类名.静态成员`访问外部类的静态成员;  
如果外部类的静态成员和内部类的静态成员名称不相同，则可通过`成员名`直接调用外部类的静态成员  
3.创建静态内部类的对象时，不需要外部类的对象，可以直接创建 `内部类 对象名 = new 内部类();`
```
//创建外部类
public class Outer{
    private int a = 20;//外部类的私有成员
    static int b = 1;//和内部类同名的静态成员
    static int c = 10;//和内部类不同名的静态成员
    //创建静态内部类
    public static class Inner{
        int b = 2;//和外部类同名
        public void show(){
            System.out.println("访问外部类的普通成员a:  "+ new Outer().a);
            System.out.println("访问外部类中同名静态成员b： "+Outer.b);
            System.out.println("访问内部类的成员b： "+ b);
            System.out.println("访问外部类的不同名的静态成员c： "+ c);
        }
    }
    public static void main(String[] args){
        //创建静态内部类对象
        Inner inn = new Inner();
        inn.show();
    }
}
```
#### 方法内部类
方法内部类就是内部类定义在外部类的方法中，方法内部类只在该方法的内部可见，即只在该方法内可以使用。
```
//外部类
public class Outer{
    //外部类中的方法
    public void show(){
        final int a = 25; // 常量
        int b = 13; //  变量
        //方法内部类
        class Inner{
            int c = 2; //内部类中的变量
            public void print(){
                System.out.println("访问外部类的方法中的常量a: "+ a);
                System.out.println("访问内部类中的变量c: "+ c);
            }
        }
        Inner inn = new Inner();//创建方法内部类对象
        inn.print();//调用内部类的方法
    }
    public static void main(String[] args){
        Outer mo = new Outer(); //创建外部类的对象
        mo.show(); //调用外部类的方法
    }
}
```
**注意** 由于方法内部类不能在外部类的方法以外的地方使用，因此方法内部类不能使用访问控制符和static修饰符。