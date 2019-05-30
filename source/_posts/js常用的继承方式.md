---
title: js常用的继承方式
abbrlink: 40543
date: 2019-05-22 15:46:36
tags: 继承
categories: javascript
---

我们这里列举几种常见的继承方式

- 组合继承（继承构造函数和原型链）
- 寄生组合继承（继承构造函数和原型链）
- ES6 继承方式

<!-- more -->

### 组合继承

用原型链实现对原型属性和方法的继承，用借用构造函数技术来实现实例属性的继承。

```js
function Parent(name) {
  this.name = name;
  this.colors = ["red", "green", "blue"];
}
// 父类原型上的方法，可以继承给子类
Parent.prototype.sayName = function() {
  console.log(this.name);
};

function Child(name, age) {
  // 调用父类的实例，实现构造函数的继承，继承父类的属性
  Parent.call(this, name);
  this.age = age;
}

// 继承父类的原型链，此时子类的原型已经继承了父类
// 但是子类的构造函数也变成了父类构造函数
Child.prototype = new Parent();
// 重新指定子类的构造函数为子类自己的构造函数
Child.prototype.constructor = Child;
// 子类的原型上添加自己的方法
Child.prototype.sayAge = function() {
  console.log(this.age);
};

var instance1 = new Child("hmm", "23");
instance1.sayAge(); // '23'
instance1.sayName(); // 'hmm'
instance1.color.push("black"); // ['red', 'green', 'blue', 'black'];

var instance2 = new Child("liLei", "25");
instance2.sayAge(); // '25'
instance2.sayName(); // 'liLei'
instance2.color.push("pink"); // ['red', 'green', 'blue', 'pink'];
```

如此，实现了继承了父类的原型上面的方法，也继承了父类的构造函数上面的属性。而且多个子类之间对父类修改属性互不影响。

**缺点：**

- 子类在继承父类构造函数的时候调用了一次父类构造函数`Parent.call(this, name)`,子类的构造函数上加了俩个属性`name/color`
- 子类在继承父类原型的时候调用了一次`Child.prototype = new Parent();`,给子类的原型上加了俩个属性 `name/color`

![js继承](/../images/js-extend.png)

**缺点就是子类的构造函数和原型上存在了相同的属性和方法**

### 寄生组合继承

在子类继承父类原型的时候不调用`new Parent()`，而是创建父类原型的副本，然后实现继承。

```js
function inheritPrototype(child, parent) {
  var prototype = Object.create(parent.prototype); // 创建对象，创建父类原型的一个副本
  prototype.constructor = child; // 增强对象，弥补因重写原型而失去的默认的constructor 属性
  child.prototype = prototype; // 指定对象，将新创建的对象赋值给子类的原型
}

function Parent(name) {
  this.name = name;
  this.colors = ["red", "green", "blue"];
}
// 父类原型上的方法，可以继承给子类
Parent.prototype.sayName = function() {
  console.log(this.name);
};

function Child(name, age) {
  // 调用父类的实例，实现构造函数的继承，继承父类的属性
  Parent.call(this, name);
  this.age = age;
}
// 将父类原型指向子类
inheritPrototype(Child, Parent);
// 子类的原型上添加自己的方法
Child.prototype.sayAge = function() {
  console.log(this.age);
};

var instance1 = new Child("hmm", "23");
instance1.sayAge(); // '23'
instance1.sayName(); // 'hmm'
instance1.color.push("black"); // ['red', 'green', 'blue', 'black'];

var instance2 = new Child("liLei", "25");
instance2.sayAge(); // '25'
instance2.sayName(); // 'liLei'
instance2.color.push("pink"); // ['red', 'green', 'blue', 'pink'];
```

我们来看一看`instance1`的构造函数和原型上是否还有相同的属性`name/colors`
![js继承](/../images/js-extend-1.png)
我们看到子类的原型上没有出现多余的属性，因为我们只在子类的构造函数中使用了`Parent.call(this)`来实现继承，原型上我们是创建了一个父类原型的副本来实现继承的。

### ES6 继承

ES6 的继承依靠关键字 `extends`,我们先来新建一个 ES6 的类。

```js
class Reactangle {
  constructor(width, height) {
    this.width = width;
    this.height = height;
  }
  get area() {
    return this.calcArea();
  }
  calcArea() {
    return this.height * this.width;
  }
}

const reactangle = new Reactangle(10, 20);
console.log(reactangle.area); // 200

// 继承
class Square extends Reactangle {
  constructor(length) {
    super(length, length); // 正方形
  }
  get area() {
    return this.height * this.width;
  }
}

const square = new Square(10);
console.log(square.area); // 100
```
