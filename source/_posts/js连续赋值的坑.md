---
title: js连续赋值的坑
abbrlink: 62611
date: 2019-04-08 11:38:38
tags: [js]
categories: javascript
---
思考这个问题:
```javascript
var a = {n:1}; 
var b = a;  
a.x = a = {n:2}; 
console.log(a.x); 
console.log(b.x);
```
<!-- more -->
上面的 代码看似简单,但是执行结果却是出乎我们意料

```javascript
console.log(a.x); // undefined
console.log(b.x) // {n:2}
```

我们知道，内存中数据存储的方式有栈和堆俩种，基本数据类型存放于栈中，以压栈的方式进入存储，引用类型的数据存放于堆中，在栈保存的只是堆的地址。

所以执行完`var b = a;`代码后，`a`和`b`都指向了`{n:1}`这点毋庸置疑，

重点关注的就是最后的连续赋值语句`a.x=a={n:2}`这个语句中到底发生了什么？

我们知道`js`中的赋值语句都是从右向左执行的，但是这里有一个运算符优先级的问题。

**`.`运算符的优先级要高于`=`运输符**

所以`a.x=a={n:2}`首先会执行的是`a.x`，运算结果：

```javascript
a: {
    n: 1,
    x: undefined
};
b: {
    n: 1,
    x: undefined
}
```

然后从右向左执行`a={n:2}`，此时`a`已经被指向了`{n: 2}`的地址，

记住这一点：
**`a.x`已经被解析了， 已经指向了内存中的` {n:1,x=undefined}`中的`x`，目前他正等待被赋值，所以下面在处理赋值表达式 `a = {n: 2}`时候，即使`a`发生了指向的变化，但也不再影响此刻的`a.x`了，因为已经对`a.x`进行了指向的确定，只不过他现在正在等待被赋值。**

此时内存中：
```javascript
a: {
    n: 2
};
b: {
    n: 1,
    x: undefined
}
```
如此，上面的最后操作结果就是`{n:1, x: undefined}.x = {n: 2}`

那么最后内存中，就是这样：
```javascript
a: {
    n: 2
};
b: {
    n: 1,
    x: { n: 2 }
}
```
所以最后的结果就是：
```javascript
console.log(a.x); // undefined
console.log(b.x); // { n: 2 }
```

> 参考链接

[js连续赋值的坑](http://www.cnblogs.com/vajoy/p/3703859.html)
