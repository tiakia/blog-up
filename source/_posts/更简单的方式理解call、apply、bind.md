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

``` js
  let foo = {
    value: 1
  };
  let value = 2;
  let bar = function() {
    console.log(this.value);
  };

  bar.call(foo); // 1;
```

**调用call的过程我们可以这样解析**

``` js
  let foo = {
    value: 1,
    bar: function(){
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

>  tips: 当 `call` 的参数是 `null `或者` undefined` 的时候 `this` 被改变指向到了 `Window`

```js
let scope = 'global';
function bar(name){
    return {
        scope: this.scope,
        name: name
    }
}
let foo = {
    scope: 'foo'
}
bar.call(null, "Hmm"); // { scope: 'global', name: 'Hmm' }
bar.call(foo, "Hmm"); // { scope: 'foo', name: 'Hmm' }
```

