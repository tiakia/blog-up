---
title: 更简单的方式理解call、apply、bind
abbrlink: 62321
date: 2019-05-20 11:54:57
tags: call,apply,bind
categories: javascript
---

`call/apply/bind` 三种方法都是我们改变`this`指向的，`call`、`apply` 是改变指向后顺便执行函数，而`bind` 是改变指向后返回函数不执行。`call`和`apply`差别是`call`接受的是若干个参数的列表，`apply`接受的是一个包含多个参数的数组。我们这里提供一种更简单的思路来理解他们。

<!-- more -->

## call/apply/bind

先来看一个简单的例子

```js
let foo = {
  value: 1
};
let value = 2;
let bar = function() {
  console.log(this.value);
};

bar.call(foo); // 1;
```

`call()`主要有以下两点

1、`call()`改变了 `this` 的指向

2、函数 `bar` 执行了

**调用 call 的过程我们可以这样解析**

```js
let foo = {
  value: 1,
  bar: function() {
    console.log(this.value);
  }
};

foo.bar();
// bar.call(foo); bar 函数的 this 绑定到 foo 上面,  foo 添加 bar 函数属性，然后调用。
```

像我们常用的判断变量类型的方法：

```js
Object.prototype.toString.call(foo);
```

就是将 Object 的 toString 方法 绑定到 foo 上，并且`call`方法自动给我们调用了，

```js
foo.toString(); // 调用的是 Object.prototype.toString()
```

或者用简单的一句话来总结就是： `call`函数前面`this`会被指向到`call`函数里面。

> tips: 当 `call` 的参数是 `null`或者`undefined` 的时候 `this` 被改变指向到了 `Window`

```js
let scope = "global";
function bar(name) {
  return {
    scope: this.scope,
    name: name
  };
}
let foo = {
  scope: "foo"
};
bar.call(null, "Hmm"); // { scope: 'global', name: 'Hmm' }
bar.call(foo, "Hmm"); // { scope: 'foo', name: 'Hmm' }
```

## 实现 call/apply/bind

### call

通过上面介绍我们只要实现下面 3 步就可以模拟实现了。

1、将函数设置为对象的属性：`foo.fn = bar`
2、执行函数：`foo.fn()`
3、删除函数：`delete foo.fn`

```javascript
Function.prototype.myCall = function(context) {
  // 首先要获取调用call的函数bar，用this可以获取
  context.fn = this; // foo.fn = bar
  let result = context.fn(); // foo.fn()
  delete context.fn; // delete foo.fn
  return result;
};
// 测试一下
let value = "global";
let foo = {
  value: "local"
};
function bar() {
  console.log(this.value);
}
bar.myCall(foo); // => local
```

**敲黑板**
还是上面的代码，如果调用`bar()`会不会返回我们预期的`"global"`呢？

```javascript
bar(); // => undefined
```

> 为什么会出现这种问题，就需要知道 ES6 与 ES5 变量声明方面的区别了：

- ES5 声明变量只有两种方式：`var` 和 `function`。
- ES6 有 `let`、`const`、`import`、`class` 再加上 ES5 的 `var`、`function` 共有六种声明变量的方式。
- 还需要了解顶层对象：浏览器环境中顶层对象是`window`，Node 中是 `global` 对象。
- ES5 中，顶层对象的属性等价于全局变量。(敲黑板了啊)
- ES6 中，有所改变：`var`、`function` 声明的全局变量，依然是顶层对象的属性；`let`、`const`、`class` 声明的全局变量不属于顶层对象的属性，也就是说 ES6 开始，全局变量和顶层对象的属性开始分离、脱钩。

所以我们如果想得到预期的`"global"`,那么最外层的 `value`应该用`var`声明

```javascript
var value = "global";
let foo = {
  value: "local"
};
```

这个模拟还有几个问题：

- `bar` 可以接受参数
- 考虑 `this` 参数可以传 `null` 或者 `undefined`，此时 `this` 指向 `window`
- `this` 参数可以传基本类型数据，原生的 `call` 会自动用 `Object()` 转换

---

#### `call` 最终版本

```javascript
Function.prototype.myCall = function(context) {
  context = context ? Object(context) : window; // context为null或undefined
  let fn = Symbol(); // 这里确保fn是唯一的 防止 context 中存在 fn 属性
  context.fn = this;
  let args = [...arguments].slice(1); // 排除第一个this调用的函数
  let result = context.fn(...args);

  delete context.fn;
  return result;
};
// 测试一下
var value = "global";
let foo = {
  value: "local"
};
function bar(name, age) {
  console.log(name);
  console.log(age);
  console.log(this.value);
}
function bar1() {
  console.log(this.value);
}
function bar2() {
  console.log(this);
}

bar.myCall(foo, "tk", 18); // => "tk" 18 "local"
bar1.myCall(null); // => "global"
bar2.myCall(123); // => Number {123, fn: f}
```

### apply

`apply`和`call`的区别在于`apply`可以接受数组参数

```javascript
Function.prototype.myApply = function(context, args) {
  context = context ? Object(context) : window;
  args = args || [];
  let fn = Symbol();
  context.fn = this;
  let result = context.fn(...args);
  delete context.fn;
  return result;
};
// 测试一下
const obj = {
  name: "joy"
};

function getName(a, b) {
  console.log(this.name, a, b);
}

getName.myApply(obj, [1, 2]); // joy 1 2
```

### bind

```javascript
var value = "global";
let foo = {
  value: "local"
};
function bar() {
  console.log(this.value);
}
let bindFun = bar.bind(foo);
bindFun(); // => local
```

`bind`有以下几个特性：

- 绑定`this`
- 返回函数但是不执行
- 可以在绑定函数的时候传入参数，也可以在返回的函数执行的时候传入参数

那么我们根据这个思路来模拟实现：

- 首先实现第一点和第二点

```javascript
Function.prototype.myBind = function(context) {
  let self = this; // 获得 调用myBind 的 bar 函数
  return function() {
    self.apply(context); // 绑定this context: { self }
  };
};
```

- 实现接受参数

```javascript
Function.prototype.myBind = function(context) {
  let self = this;
  // 这里arguments 为绑定的时候传入的参数，第一个是this
  let args = Array.prototype.slice.call(arguments, 1);
  return function() {
    // 这里的arguments 为 bindFun 执行时候传入的参数
    // 即 return function 的参数
    self.apply(context, [...args, ...arguments]);
  };
};

// 测试一下
var value = "global";

var foo = {
  value: "local"
};

function bar(name, age) {
  console.log(this.value);
  console.log(name);
  console.log(age);
}

var bindFun = bar.myBind(foo, "Jack");
bindFun(20);
// local Jack 20
```

到了这已经基本实现了，但是如果使用`new`创建绑定函数的实例的话，`this`的指向会修改，看以下例子：

```javascript
var value = "global";
var foo = {
  value: "local"
};
function bar(name, age) {
  this.habit = "shopping";
  console.log(this.value);
  console.log(name);
  console.log(age);
}

bar.prototype.friend = "kevin";

var bindFoo = bar.bind(foo, "Jack"); // 原生bind函数
var obj = new bindFoo(20);
// undefined
// Jack
// 20
// obj是基于bar创建的实例
obj.habit;
// shopping

obj.friend;
// kevin

var myBindFoo = bar.myBind(foo, "Jack"); // 自己实现的bind函数
var obj1 = new myBindFoo(20);
// local
// Jack
// 20
// obj 是基于内部返回函数创建的实例
obj1.habit;
// undefined

obj1.friend;
// undefined
```

上面例子中，运行结果 `this.value` 输出为`undefined`，这不是全局 `value` 也不是 `foo` 对象中的 `value`，这说明 `bind` 的 `this` 对象失效了，`new` 的实现中生成一个新的对象，这个时候的 `this` 指向的是 `obj`。

这里可以通过修改返回函数的原型来实现，代码如下：

#### `bind` 最终版本

```javascript
Function.prototype.myBind = function(context) {
  let self = this;
  let args = Array.prototype.slice.call(arguments, 1);
  // 使用new创建的是parent的实例,但是原生bind继承的bar(this)
  function parent() {
    // 这里的this是返回函数的this
    // 如果使用new创建的会指向parent
    // 如果是正常的调用会指向windows
    console.log(this);
    if (this instanceof parent) {
      // 直接 new bar 创建实例
      return new self(...args, ...arguments);
    }
    return self.apply(context, [...args, ...arguments]);
  }
  return parent;
};
```

测试一下：

```javascript
var value = "global";
var foo = {
  value: "local"
};
function bar(name, age) {
  this.habit = "shopping";
  console.log(this.value);
  console.log(name);
  console.log(age);
}

bar.prototype.friend = "kevin";

var myBindFoo = bar.myBind(foo, "Jack");
var bindFoo1 = bar.bind(foo, "Jack");
// 测试是否和原生bind返回一致
var obj = new myBindFoo(20);
// undefined
// Jack
// 20
var obj1 = new bindFoo1(20);
// undefined
// Jack
// 20

// 测试和原生bind返回实例的构造函数是否一样
console.log(obj); // => bar
console.log(obj1); // => bar

// 测试正常情况
bindFoo(20);
// local
// jack
// 20
```

> 参考链接

- [简书-土豪码农](https://www.jianshu.com/p/5afd6674f352)

- [yygmind](https://github.com/yygmind/blog/issues/23)
