---
title: Java中的继承
tags: [java]
date: 2017-11-13 12:11:10
categories: java
description:
thumbnail:
keywords:
---
> 语法： `public class Dog extends Animal{}`  
使用`extends`关键字来实现俩个类的继承关系。  
子类可以使用父类中定义的属性和方法。  


**注意** 父类中使用private定义的属性在子类中是不能继承的。  
Animal  
```
public class Animal{
    public int age;
    public String name;
    public void eat(){
        System.out.println("Name: "+name+" Age: "+age +" 动物具有吃的功能");
    }
}
```
<!-- more -->
Dog
```
//使用extends继承Animal
public class Dog extends Animal{
    
}
```
test
```
public class Test{
    public static void main(String[] args){
        Dog dog = new Dog();
        dog.eat();//继承自Animal方法
        dog.age = 5;
        dog.name = "halin";
    }
}
```
#### 方法的重写
1.什么是方法的重写  

如果子类对继承父类的方法不满意，可以重写父类继承的方法，当调用方法时会优先调用子类的方法。  

2.语法规则：  

---

a.返回值类型  

---

b.方法名  

---

c.参数类型及个数  

---

都要与父类继承的方法相同，才叫方法的重写  

上面的例子  
Dog
```
public class Dog extends Animal{
    public void eat(){
        System.out.println("Name: "+name+" Age: "+age +" 狗具有吃的功能");
    }
}
```
#### 继承的初始化顺序
1.初始化父类再初始化子类  
Animal  
```
public class Animal{
    public int age;
    public String name;
    public void eat(){
        System.out.println("动物具有吃东西的能力");
    }
    public Animal(){
        System.out.println("Animal类执行了");
    }
}
```
Dog 
```
public class Dog extends Animal{
    public Dog(){
        System.out.println("Dog类执行了");
    }
}
```
test
```
public class Test{
    public static void main(String[] args){
        Dog dog = new Dog();
        dog.eat();//继承自Animal方法
        dog.age = 5;
        dog.name = "halin";
    }
}
```
输出结果
```
Animal类执行了
Dog类执行了
动物具有吃东西的能力
```
2.先执行初始化对象中的属性，在执行构造方法中的初始化
Animal  
```
public class Animal{
    public int age = 10;
    public String name;
    public void eat(){
        System.out.println("动物具有吃东西的能力");
    }
    public Animal(){
        System.out.println("Animal类执行了");
        age = 20;
    }
}
```
Dog 
```
public class Dog extends Animal{
    public Dog(){
        System.out.println("Dog类执行了");
    }
}
```
test
```
public class Test{
    public static void main(String[] args){
        Animal animal = new Animal();
        System.out.println("animal age: "+animal.age);
        Dog dog = new Dog();
        dog.eat();//继承自Animal方法
        dog.age = 5;
        dog.name = "halin";
    }
}
```
输出结果
```
Animal类执行了
animal age: 20
Animal类执行了
Dog类执行了
动物具有吃东西的能力
```
结论：
先初始化了对象的属性age = 10，然后才执行了 构造方法中的 age = 20

#### final关键字
    使用final关键字做标识有“最终的”含义
#### final可以修饰类、方法、属性和变量
       
- [x]      final修饰类，则该类不允许被继承  
- [x]      final修饰方法，则该方法不允许被覆盖（重写）  
- [x]      final修饰属性 ，     则该类的属性不会进行隐式的初始化（类的初始化属性必须有值）  
或在构造方法中赋值（但只能选其一）（先初始化属性在执行构造函数）
- [x]      final修饰变量 ，则该变量的值只能赋值一次，即变为常量    

#### super关键字
在对象内部使用，可以代表父类

1.访问父类的属性
    ```
    super.age
    ```  
2.访问父类的方法
    ```
    super.eat()
    ```  
如果调用子类的方法、属性，直接输入方法名、属性名即可。
#### super的应用
1.子类的构造过程中必须调用其父类的构造方法。  
2.如果子类的构造方法中没有显示调用父类的构造方法，则系统默认调用父类无参的构造方法。  
3.如果显示的调用构造方法，必须在子类的构造方法第一行。  

Dog
```
public class Dog extends Animal{
    public Dog(){
        super();//显示调用
        System.out.println("Dog类执行了");
    }
}
```
4.如果子类的构造方法中既没有显示调用父类的构造方法，而父类有没有无参的构造方法，则编译出错。（如果没有定义父类的构造方法，系统会默认创建一个无参的构造方法，但是如果自己定义了有参的 构造方法，系统就不会自动创建了）
#### java中的Object类
Object类是所有类的父类，如果一个类没有使用extends关键字明确标识继承另外一个类，那么这个类默认继承Object类。  
Object类中的方法，适合所有子类。
###### Object类中的toString()方法
###### Object类中的equals()方法