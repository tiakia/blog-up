---
title: typeScript查漏补缺
abbrlink: 4914
date: 2019-10-11 10:38:13
tags: ["ts", "never", "泛型", "interface"]
categories: typeScript
---

今天群组讨论的时候，发现了 typeScript 有很多功能不是很清楚，所以查找了些资料，这里整理一下：

1. `ts` 中的 `type` 和 `interface` 有什么区别
2. `ts` 中的泛型使用
3. `never` 类型的使用

<!--more-->

## `type` 和 `interface` 有什么区别

### 相同点

> 都可以描述一个对象或者函数

- interface

```typescript jsx
interface User {
  name: string;
  age: number;
}
interface SetUser {
  (name: string, age: number): void;
}
```

- type

```typescript
type User = { name: string; age: number };
type SetUser = (name: string, age: number) => void;
```

> 都允许扩展

`interface`和`type`都可以扩展，并且俩者之间可以相互`extends`

- interface extends interface

```typescript jsx
interface Name {
  name: string;
}
interface User extends Name {
  age: number;
}
```

- type extends type

```typescript jsx
type Name = {
  name: string;
};
type User = Name & { age: number };
```

- interface extends type

```typescript jsx
type Name = {
  name: string;
};
interface User extends Name {
  age: number;
}
```

- type extends interface

```typescript jsx
interface Name {
  name: string;
}
type User = Name & {
  age: number;
};
```

### 不同点

> `type`可以而`interface`不行

- `type`可以声明基本类型别名、联合类型，元组等类型

```typescript jsx
// 基本类型别名
type Name = string;

// 声明联合类型
interface Dog {
  wong();
}
interface Cat {
  miao();
}
type Pet = Dog | Cat;

// 具体定义数组每个位置的类型
type PetList = [Dog, Cat];
```

- `type`语句中还可以使用`typeof`获取实例的类型进行赋值

```typescript jsx
// 当你想获取一个变量的类型时，用typeof
let div = document.createElement("div");
let B = typeof div;
```

- 其他骚操作

```typescript jsx
type StringOrNumber = string | number;
type Text = string | { text: string };
type NameLookup = Dictionary<string, Person>;
type Callback<T> = (data: T) => void;
type Pair<T> = [T, T];
type Coordinates = Pair<number>;
type Tree<T> = T | { left: Tree<T>; right: Tree<T> };
```

> `interface`可以而`type`不行

- `interface`可以声明合并

```typescript jsx
interface User {
  name: string;
  age: number;
}
interface User {
  sex: string;
}

/*
* User {
*   name: string;
*   age: number;
*   sex: string;
* }
* */
```

一般来说，如果不清楚什么时候用 `interface/type`，能用 `interface` 实现，就用 `interface` , 如果不能就用 `type` 。

## ts 中的泛型

通俗理解：泛型就是解决 类 接口 方法的复用性、以及对不特定数据类型的支持(类型校验)

### 泛型函数

如果一个函数既可以返回`number`又可以返回`string`类型，我们在规定函数类型的时候，可能会使用`any`类型，但是这种是不确定的，函数参数和返回类型都不确定，这个时候我们就可以使用泛型来解决这个问题。

```typescript jsx
// 只能返回 string 类型
function getData(value: string): string {
  return value;
}
// 同时支持返回string和number，代码冗余
function getData1(value: number): number {
  return value;
}
function getData2(value: string): string {
  return value;
}
```

可以使用泛型来解决这个问题：

```typescript jsx
function getData<T>(value: T): T {
  return value;
}

// 返回 number
const getNumData = getData<number>(1);
// 返回 string
const getStrData = getData<string>("1");
```

### 泛型接口

```typescript jsx
interface ConfigFn<T> {
  (value: T): T;
}
function getData<T>(value: T): T {
  return value;
}
let myGetData: ConfigFn<string> = getData;
myGetData("1"); // 正确
// myGetData(1); // 错误
```

### 泛型类

在`react`中可以看到我们运用泛型类的例子。

```typescript jsx
import React from "react";
type Props = {
  className?: string;
};
type State = {
  current?: number;
};
class MyComponent extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      current: 1
    };
  }
}
```

获取最小值的例子：

```typescript jsx
class GetMin<T> {
  public args: T[];
  constructor(args: T[]) {
    this.args = args;
  }
  add(ele: T) {
    this.args.push(ele);
  }
  min(): T {
    let min: T = this.args[0];
    this.args.forEach((val: T) => {
      if (val < min) {
        min = val;
      }
    });
    return min;
  }
}
// Number
const getMin1 = new GetMin<number>([1, 2, 3]);
getMin1.add(4);
const min1 = getMin1.min();
console.log(min1); // 1
// String
const getMin2 = new GetMin<string>(["a", "b", "c"]);
getMin2.add("d");
const min2 = getMin2.min();
console.log(min2); // a
```

### 泛型约束

简而言之就是限制泛型的类型。
一个很好的例子是处理字符串或者数组时，我们假设`length`属性是可用的。

```typescript jsx
// this will cause an error
function identity<T>(arg: T): T {
  console.log(arg.length);
  return arg;
}
```

在这种情况下，编译器不会知道 `T` 确实有`.length`属性，特别是在任何类型都可以分配给`T`的情况下。我们需要做的是将类型变量扩展到一个包含所需属性的接口。大概是这样：

```typescript jsx
interface Length {
  length: number;
}
function identity<T extends Length>(arg: T): T {
  // length property can now be called
  console.log(arg.length);
  return arg;
}
```

在尖括号内使用`extends`关键字加上我们要扩展的类型来约束 `T`。本质上，我们是在告诉编译器，我们可以支持在`Length`内实现属性的任何类型。
现在，当我们使用不支持`.length` 类型的函数时，编译器会通知我们。不仅如此，`.length` 现在可以识别并用于实现属性的类型。

注意:我们还可以通过用逗号分隔约束来扩展多个类型。举个例子，`<T extends Length, Type2, Type3>`.

### 使用约束检查对象的属性

约束的一个很好的用例是通过使用另一段语法:`extends keyof`来查验对象的属性。以下示例检验了我们传入函数的对象是否存在这个属性:

```typescript jsx
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}
```

第一个参数是我们获取值的对象，第二个参数是该值的属性。返回类型描述了与`T[K]`的这种关系。

我们的泛型在这里所做的是确保对象的属性的存在，这样运行时就不会发生错误。这是一个类型安全的解决方案，而不是简单地调用`let value = obj[key];`之类的东西。

## never 类型

### 返回非 never 类型

题目是这样的：

如何在`{ a: number; b: never }`中获取非`never`类型，也就是`{a: number}`

解决这个问题前我们先来学习来个知识点：

> Pick<T,K>

从 T 中提取出键为 K 的类型

```typescript jsx
interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

type TodoPreview = Pick<Todo, "title" | "completed">;

const todo: TodoPreview = {
  title: "Clean room",
  completed: false
};
```

> never | number 返回什么？

```typescript jsx
type A = never | number; // number
type D = never | string | number; // string | number
```

那么问题的解决方案就是这样：

```typescript jsx
export type NoNever<T> = Pick<
  T,
  { [K in keyof T]: T[K] extends never ? never : K }[keyof T]
>;

type C = { a: number; b: never };
type B = NoNever<C>;
// 解析：
type Ex<T> = { [K in keyof T]: T[K] extends never ? never : K };
type Test = Ex<C>; // { a: "a", b: never}

type EX1<T> = Ex<T>[keyof T];
type Test1 = EX1<C>; // "a"
```

### never 类型处理错误

举个具体点的例子，当你有一个 union type:

```typescript jsx
interface Foo {
  type: "foo";
}

interface Bar {
  type: "bar";
}

type All = Foo | Bar;
```

在 `switch` 当中判断 `type`，`TS` 是可以收窄类型的 (discriminated union)：

```typescript jsx
function handleValue(val: All) {
  switch (val.type) {
    case "foo":
      // 这里 val 被收窄为 Foo
      break;
    case "bar":
      // val 在这里是 Bar
      break;
    default:
      // val 在这里是 never
      const exhaustiveCheck: never = val;
      break;
  }
}
```

注意在 `default` 里面我们把被收窄为 `never` 的 `val` 赋值给一个显式声明为 `never` 的变量。如果一切逻辑正确，那么这里应该能够编译通过。
但是假如后来有一天你的同事改了 All 的类型：`type All = Foo | Bar | Baz` 然而他忘记了在 `handleValue` 里面加上针对 `Baz` 的处理逻辑，
这个时候在 `default branch` 里面 `val` 会被收窄为 `Baz`，导致无法赋值给 `never`，产生一个编译错误。所以通过这个办法，你可以确保 `handleValue` 总是穷尽 (exhaust) 了所有 All 的可能类型。

##  非空断言操作

```javascript
X.getY()!.a()
```

这个操作是什么意思？ 它是告诉编译器`X.getY()`不是`Nulll`;

类似的：

```javascript
<div
        style={{
          width: '100%',
          height: document.documentElement!.clientHeight,
          display: 'flex',
          justifyContent: 'center',
        }}
      >
        <ActivityIndicator size="large" animating={effects['mobileMapModel/fetchBranchTreeList']} />
</div>
```



> 参考链接

- [Typescript 中的 interface 和 type 到底有什么区别详解](https://www.jb51.net/article/163299.htm)
- [typescript(九)--ts 中泛型、泛型方法、泛型类、泛型接口](https://blog.csdn.net/jasnet_u/article/details/81144199)
- [typescript 中的泛型](https://www.cnblogs.com/longailong/p/10608913.html)
- [关于 TypeScript 泛型的解释](https://blog.csdn.net/songfens/article/details/98114588)
- [尤雨溪 never 类型处理错误](https://www.zhihu.com/question/354601204/answer/888551021)
