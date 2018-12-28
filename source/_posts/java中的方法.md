---
title: java中的方法
tags: [java]
date: 2017-10-26 18:37:53
categories: java
description:
thumbnail:
keywords:
---
所谓方法，就是用来解决一类问题的代码的有序组合，是一个功能模块。

一般情况下，定义一个方法的语法是：
```
访问修饰符 返回值类型 方法名(参数列表){
    方法体
}
```
其中：
<!-- more -->
1、 访问修饰符：方法允许被访问的权限范围， 可以是 public、protected、private 甚至可以省略 ，其中 public 表示该方法可以被其他任何代码调用，其他几种修饰符的使用在后面章节中会详细讲解滴

2、 返回值类型：方法返回值的类型，如果方法不返回任何值，则返回值类型指定为 void ；如果方法具有返回值，则需要指定返回值的类型，并且在方法体中使用 return 语句返回值

3、 方法名：定义的方法的名字，必须使用合法的标识符

4、 参数列表：传递给方法的参数列表，参数可以有多个，多个参数间以逗号隔开，每个参数由参数类型和参数名组成，以空格隔开 

根据方法是否带参、是否带返回值，可将方法分为四类：

Ø 无参无返回值方法

Ø 无参带返回值方法

Ø 带参无返回值方法

Ø 带参带返回值方法

#### 无参无返回值的方法
如果方法不包含参数，且没有返回值，我们称为无参无返回值的方法。

方法的使用分两步：
#### 1.定义方法
例如：下面代码定义了一个方法名为 show ，没有参数，且没有返回值的方法，执行的操作为输出 “ welcome to imooc. ”
```
public void show(){
    System.out.println("Weclocm to imooc");
}
```
注意：   
1.函数没有返回值，所以返回值得类型指定为`void`;
#### 2.调用方法
当需要调用方法执行某个操作时，可以先创建类的对象，然后通过**对象名.方法名();**  来实现.
例如：在下面的代码中，我们创建了一个名为 hello 的对象，然后通过调用该对象的 show( ) 方法输出信息。
```
public class HelloWorld{
    public static void main(String[] args){
        //创建类HelloWorld的对象hello
        HelloWorld hello = new HelloWorld();
        //通过 对象名.方法名();调用方法
        hello.show();
    }
    public void show(){
        System.out.println("Welcom to imooc!");
    }
}
```
#### 无参带返回值的方法
如果方法不包含参数，但有返回值，我们称为无参带返回值的方法。  
例如：下面的代码，定义了一个方法名为 calSum ，无参数，但返回值为 int 类型的方法，执行的操作为计算两数之和，并返回结果。
```
public int calcSum(){
    int a=5;
    int b=9;
    int sum = a + b;
    return sum;
}

```
**注意**
1.这是一个返回值为整型的方法。所以 返回值的类型为 void;
2.函数有返回值，因此必须使用`return`返回一个整型的数值;
3.调用带返回值的方法时，由于方法执行后会返回一个结果，因此在调用待返回值的方法时一般都会接收其返回值并进行处理。如：
```
public class HelloWorld{
    public static void main(String[] args){
        //创建类HelloWorld的对象hello
        HelloWorld hello = new HelloWord();
        //调用方法并接收方法的返回值，保存在sum中
        int sum = hello.calcSum();
        System.out.println("俩数之和为："+ sum);
    }
    public int calcSum(){
        int a = 5;
        int b = 9;
        int sum = a + b;
        return sum;
    }
}
```
#####  不容忽视的小陷进
1.如果方法的返回类型为void,则方法中不能使用return返回值。  
2.方法的返回值只能有一个，`return sum`。不能返回多个值。  
3.方法的返回值类型必须和方法定义的返回值类型相同。例如：定义返回值类型是`int`时，则不能返回`String`类型。
#### 带参无返回值的方法
我们先来看一个带参数，但没有返回值的方法：
```
public void show(String name){
    System.out.println("欢迎您："+ name+"!");
}
```
1.带参的方法在定义的时候，要规定参数的类型`String name`。  
2.在调用的时候必须传入符合定义类型的参数。
```
HelloWorld hello = new HelloWorld();
hello.show("北京");
```
**注意**  
1.调用带参方法的时候，必须保证实参的数量、类型、顺序与形参一一对应。定义的是`String`类型，在传入的时候就必须传入`String`;  
2.调用方法时实参不需要指定类型。
```
hello.show("北京");
```
3. 方法的参数可以是基本数据类型，如 int、double 等，也可以是引用数据类型，如 String、数组等
```
import java.util.Arrays;
public class HelloWorld{
    public static void main(String[] args){
        HelloWorld hello = new HelloWorld();
        int scores[] = {84,91,74,62};
        hello.print(scores);
    }
    public void print(int[] scores){
        System.out.println(Arrays.toString(scores));
    }
}
```
4. 当方法参数有多个时，多个参数间以逗号分隔
```
public int calc(int num1,int num2){
    int num3 = num1 + num2;
    return num3;
}
```
#### 带参带返回值的方法
如果方法既包含参数，又带有返回值，我们称为带参带返回值的方法。  
例如：下面的代码，定义了一个 show 方法，带有一个参数 name ，方法执行后返回一个 String 类型的结果
```
public String show(String name){
    return "欢迎您：" + name + "!";
}
```
1.`show`方法定义了一个`String`的返回值,所以方法中必须使用`return`返回一个`String`类型的值.  
2.`show`方法还带了一个`String`类型的参数。
> 调用带参带返回的方法：
```
HelloWorld hello = new HelloWorld();
String welcom = hello.show("慕课网");
System.out.println(welcom);
```
#### java中方法的重载
如果同一个类中包含了两个或两个以上方法名相同、方法参数的个数、顺序或类型不同的方法，则称为方法的重载，也可称该方法被重载了。如下所示 4 个方法名称都为 show ，但方法的参数有所不同，因此都属于方法的重载
```
public void show(){ //无参无返回值
    System.out.println("Welcom");
}
public void show(String name){//重载show方法，带参无返回值
    System.out.println("Welcom:"+name);
}
public void show(String name, int age){//重载show方法 带参俩个参数无返回值
    System.out.println("Welcom:"+name);
    System.out.println("Age:"+age);
}
public void show(int age,String name){//重载show方法，俩个参数顺序不同
    System.out.println("Welcom1:"+ name);
    System.out.println("Age1:"+age);
}
```
问： 如何区分调用的是哪个重载方法呢？

答： 当调用被重载的方法时， Java 会根据参数的个数和类型来判断应该调用哪个重载方法，参数完全匹配的方法将被执行。
```
public static void main(String[] args){
    HelloWorld hello = new HelloWorld;
    hello.show();//Welcom
    hello.show("tom");//Welcom tom
    hello.show("jack",20);//Welcom jack Age: 20
    hello.show(30,"Marry");//Welcom1 Marry Age1:30
}
```
**判断方法重载的依据**  
1.必须是在同一个类中。  
2.方法名相同。  
3.方法的参数个数、顺序、类型不同。  
4.与方法的修饰符或返回值没有关系。  
