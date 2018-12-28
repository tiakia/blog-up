---
title: java中封装的步骤
tags: [java]
date: 2017-11-13 12:09:12
categories: java
description:
thumbnail:
keywords:
---
#### 概念
    将类的某些信息隐藏在类内部，不允许外部程序直接访问，而是通过该类提供的方法来实现对隐藏信息的操作和访问
#### 好处
    1.只能通过规定的方法访问数据
    2.隐藏类的细节方便修改和实现
#### 步骤
    1.修改属性的可见性 (设为private)
    2. 创建getter/setter方法 (用于属性的读写)
    3.在getter/setter方法中加入属性控制语句 (对属性值的合法性进行判断)
<!-- more -->
##### Telphone.java
```
public class Telphone{
    private float screen;
    private float cpu;
    private float mem;
    
    public float getScreen(){
        return screen;
    }
    
    public void setScreen(float newScreen){
        if(newScreen < 3.5f){
            System.out.println("输入的属性有误，已经自动赋值为默认值");
            screen = 3.5f;
        }else{
            screen = newScreen;
        }
    }
    
    
}
```
##### InitialTelphone
```
public class InitialTelphone{
    public static void main(String[] args){
        Telphone phone = new Telphone();
        phone.setScreen(6.0f);
        System.out.println("Screen: "+ phone.getScreen());
    }
}
```