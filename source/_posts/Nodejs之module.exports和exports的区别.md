---
title: Nodejs之module.exports和exports的区别
tags: [nodejs]
date: 2018-04-11 10:44:27
categories: nodejs
description:
thumbnail:
keywords:
---

刚开始看 node 被 module.exports 和 exports 给搞混了，在网上搜到一个很好的例子

<!-- more -->

```
<!-- tab js -->
var a = {num: 1};
var b = a;
console.log(a); //{num: 1}
console.log(b);//{num: 1}

b.name = 2;
console.log(a);//{num: 2}
console.log(b);//{num: 2}

var b = {num: 3}
console.log(a);//{num: 2}
console.log(b);//{num: 3}
<!-- endtab -->
```

**解释** a 是一个对象，b 是对 a 的引用，即 a 和 b 指向同一块内存，所以前两个输出一样。当对 b 作修改时，即 a 和 b 指向同一块内存地址的内容发生了改变，所以 a 也会体现出来，所以第三四个输出一样。当 b 被覆盖时，b 指向了一块新的内存，a 还是指向原来的内存，所以最后两个输出不一样。

明白了上述例子后，我们只需要知道三点就知道 exports 和 module.exports 的区别了：

1. module.exports 初始值为一个空对象 {}
2. exports 是指向的 module.exports 的引用
3. require() 返回的是 module.exports 而不是 exports

```
exports是引用module.exports的值。module.exports被改变的时候，exports不会被改变，而模块导出的时候，真正导出的执行是module.exports，而不是exports
```

foo.js

```foo.js  %}

<!-- tab js -->

module.exports = {a: 2};
exports.a = 1;

<!-- endtab -->

```

test.js

```

<!-- tab js -->

var x = require('./foo.js');
console.log(x.a); //2

<!-- endtab -->

```

**exports 在 module.exports 被改变后，失效。**

#### module.exports = View

导出的整个 View 对象，外面模块调用它的时候，能够调用 View 的所有方法。不过需要注意的是只有是 View 自己的方法才可以调用，如果是继承过来的则不能调用。

foo.js

```foo.js  %}

<!-- tab js -->

function View(){

}

View.prototype.test = function(){
console.log('test');
}

View.test1 = function(){
console.log('test1');
}

module.exports = View;

<!-- endtab -->

```

test.js

```

<!-- tab js -->

var x = require('./foo.js');

console.log(x.test);//undefined
console.log(x.test1);//[Function]
x.test1(); //test1

<!-- endtab -->

```

```

```
