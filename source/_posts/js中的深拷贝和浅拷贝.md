---
title: js中的深拷贝和浅拷贝
tags: [javascript]
date: 2017-10-17 12:36:37
categories: javascript
description:
thumbnail:
keywords:
---

面试的时候一个老生常谈的话题，什么是浅拷贝，什么是深拷贝，优缺点，写一个函数实现深拷贝。

> 首先深复制和浅复制只针对像 Object, Array 这样的复杂对象的。简单来说，浅复制只复制一层对象的属性，而深复制则递归复制了所有层级。

<!-- more -->

这里要和赋值运算区分开，以前认为‘obj1 = obj2‘就是浅拷贝，其实不是。

```
eg:

var obj = [1,2,3];
var obj1 = obj;
obj1[0] = 4;
console.log(obj);//  ​[4,2,3]
console.log(obj1);//[4,2,3]
```

在 js 中声明一个引用类型的数据（array 或 object），变量名保存的其实是一个地址，这个地址指向了真正存放数据的地方。obj 和 obj1 中存放的是一个相同的地址，地址指向同一个数据，所以在修改了其中一个的值后，另一个的值也会跟着改变。这不是浅拷贝。

> 浅拷贝

​ 一起看一下知乎上的一个例子

```
var obj1 = {
  "name": "lili",
  "age": "18",
  "friends": ["hanmeimei","xiaoming","xiaohong"]
};

var obj2 = obj1;

var obj3 = shallowCopy(obj1);

function shallowCopy(src){
  var dst = {};
  for(var key in src){
    if(src.hasOwnProperty(key)){
      dst[key] = src[key];
    }
  }
  return dst;
}

obj2.name = 'lisi';
obj3.age = "20";

obj2.friends[1] = ['1','2'];
obj3.friends[2] = ['3','4'];

console.log(obj1);

obj1 = {
    "name": "lisi",
    "age": "18",
    "friends": ["hanmeimei",["1","2"],["3", "4"]]
}

console.log(obj2);

obj2 = {
    "name": "lisi",
    "age": "18",
    "friends": ["hanmeimei",["1","2"],["3", "4"]]
}

console.log(obj3);

obj3 = {
    "name": "lili",
    "age": "20",
    "friends": ["hanmeimei",["1","2"],["3", "4"]]
}
```

##### 来说一下大体的过程:

1.先定义 obj1,然后赋值给了 obj2,然后浅拷贝 obj3。
2.obj2 改变"name"属性
3.obj3 改变"age"属性
4.obj2 改变"friends"数组第二个数据
5.obj3 改变"friends"数组第三个数据

##### 最后打印出的结果得出结论：

1.obj2 改变的 name 属性同样改变了 obj1 的，但是 obj3 改变 age 属性没影响到 obj1。
2.obj2 和 obj3 改变的 friends 属性的数组，同样改变了 obj1 的 friends 数组。

##### 所以我们最后得出了结论：

1.浅拷贝和赋值不一样，浅拷贝是在内存中新建了一个空间，变量存储的新的地址，
改变浅拷贝的基础属性的值不会影响到原来的值， 2.改变引用类型的值会改变原始的值，这是因为，浅拷贝只会赋值一层，对于 obj1 里面的
friends(引用类型)的值不会进行复制。

> 深拷贝

深拷贝的意义不言而喻了。
浅拷贝： 将 obj1 的值拷贝的 obj3 中，但是不包括 obj1 里面的子对象，obj3 中复制的只是 friends 中保存的地址。
深拷贝： 将 obj1 的值拷贝的 obj3 中，包括 obj1 里面的子对象。（并不是复制引用）

深拷贝的实现：

```
   var cloneObj = function(obj){
    var str, newObj = obj.constructor === Array ? [] : {};
    if(typeof obj !== 'object'){
              return;
    }else if(window.JSON){
          str = JSON.stringify(obj);
          newObj = JSON.parse(str);
    }else {
          for(var i in obj){
            if(obj.hasOwnProperty(i)){
              newObj[i] = typeof obj[i] === "object" ? cloneObj(obj(i)) : obj[i];
            }
          }
    }
    return newObj;
}
```

> 最暴力的写法：

```
 var newObj = JSON.parse(JSON.stringify(obj));
```

> 补充

```
Object.assign({},obj)
```

- 如果要拷贝 obj 只有一层数据结构的话那么他可以实现深拷贝

```
obj = {
    name: 'xxx',
    year: 1988
}
var newObj = Object.assign({},obj);
newObj.name = 'yyy';
console.log(obj);

obj = {
  name: 'xxx',
  year: 1988
}

console.log(newObj);

newObj = {
  name: 'yyy',
  year: 1988
}
```

- 如果 obj 中有对象或者数组的话，只能拷贝他们的引用，不能用来深拷贝

```
obj = {
    name: 'xxx',
    year: 1988,
    friends: ['hmm','zmm']
}
var newObj = Object.assign({},obj);
newObj.name = 'yyy';
newObj.friends[0] = 'tmm';
console.log(obj);

obj = {
    name: 'xxx',
    year: 1988,
    friends: ['tmm','zmm']
}

console.log(newObj);

newObj = {
    name: 'yyy',
    year: 1988,
    friends: ['tmm','zmm']
}
```

> 参考链接:

[Cherry's Blog](http://cherryblog.site/deepcopy.html)

[知乎](https://www.zhihu.com/question/23031215)
