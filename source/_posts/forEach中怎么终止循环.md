---
title: forEach中怎么终止循环
abbrlink: 52107
date: 2019-8-16 17:57:23
tags:
categories:
---

这个问题很有意思，`for` 循环中 `while` 循环中我们知道可以使用`break`来终止循环，那么`forEach`中怎么终止循环呢？

<!-- more -->

`forEach`中不能使用`break`终止循环会直接报错的,网上也有说可以使用`return false`来终止循环，这个方法也是错误。
来看这个例子：

```javascript
let arr = [1, 2, 3];
arr.forEach(val => {
  if (Number(val) === 2) {
    return false;
  }
  console.log(val);
});

// => 1 3
```

`return false`仍然会遍历数组，只是在`val = 2`的时候下面代码不执行而已。

**正确用法：**

用`throw`抛出异常来终止循环：

```javascript
let arr = [1, 2, 3];
try {
  arr.forEach(val => {
    if (Number(val) === 2) {
      throw Error("终止循环");
    }
    console.log(val);
  });
} catch (e) {
  console.log(e);
}

// => 1 Error: 终止循环
```
