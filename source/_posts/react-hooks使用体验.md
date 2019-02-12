---
title: react-hooks使用体验
abbrlink: 56237
date: 2019-01-30 14:48:52
tags: react
---

`react-hooks`使用必须把`react`/`react-dom`的版本更新到`16.7.0-alpha.2`
如果`node`版本过低的话建议更新一下，windows 可以使用[nvmw](https://github.com/tiakia/nvmw-china)来管理`node`版本
`react-hooks`的出现是为了解决在无状态的组件中（函数类组件）使用`state`和生命周期，在`class`组件中不能使用

<!-- more -->

### 安装

```bash
npm install react@16.7.0-alpha.2 react-dom@16.7.0-alpha.2 --save
```

或者

```bash
yarn add react@16.7.0-alpha.2 react-dom@16.7.0-alpha.2
```

### 使用

#### state hook

```javascript
import { useState } from "react";

function Example() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>Click me</button>
    </div>
  );
}
```

`useState`就是一个 Hooks,他返回一个数组，第一个是`state`的名字`count`，第二个是设置`count state`的方法，`useState`的参数就是初始的`state`，换成 class 类型的组件就是：

```javascript
import React, { Component } from "react";

class Example extends Component {
  constructor(props) {
    super(props);
    this.state = {
      count: 0
    };
  }
  render() {
    return (
      <div>
        <p>You clicked {this.state.count} times</p>
        <button onClick={() => this.setState({ count: this.state.count + 1 })}>
          Click me
        </button>
      </div>
    );
  }
}
```

在一个`function`组件中可以使用多个`useState`

```javascript
function ExampleWithManyStates() {
  // Declare multiple state variables!
  const [age, setAge] = useState(42);
  const [fruit, setFruit] = useState("banana");
  const [todos, setTodos] = useState([{ text: "Learn Hooks" }]);
  // ...
}
```

#### effect hook

Effect Hook 用来处理一些带有副作用的操作，例如，变更 DOM，请求数据，因为它们会影响其他组件，并且在渲染中无法进行。`useEffect hook` 类似于类组件中 `componentDidMount`、`componentDidUpdate`、`componentWillUnmount` 的统一。
`useEffect`的带有副作用的操作通常会在渲染之后进行，包括第一次渲染。

```javascript
import { useState, useEffect } from "react";

function Example() {
  const [width, setWidth] = useState(window.innerWith);
  useEffect(() => {
    const handleResize = () => {
      setWidth(window.innerWith);
    };
    window.addEventListener("resize", handleResize);
  });
  return (
    <div>
      <p> window width is {width}</p>
    </div>
  );
}
```

`useEffect`可以传入第二个操作来避免性能的损耗，如果第二个参数数组中的成员变量没有变化则会跳过此次改变。如果传入一个空数组 ，那么该 effect 只会在组件 mount 和 unmount 时期执行。

```javascript
import { useState, useEffect } from "react";

function Example() {
  const [width, setWidth] = useState(window.innerWith);
  useEffect(() => {
    const handleResize = () => {
      setWidth(window.innerWith);
    };
    window.addEventListener("resize", handleResize);
  }, [width]); //width 没有变化则不处理
  return (
    <div>
      <p> window width is {width}</p>
    </div>
  );
}
```

`useEffect`可以通过返回一个函数来进行清理操作，这些操作会在组件`unmounts`时运行。

```javascript
import { useState, useEffect } from "react";

function Example() {
  const [width, setWidth] = useState(window.innerWith);
  useEffect(() => {
    const handleResize = () => {
      setWidth(window.innerWith);
    };
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize"); //取消监听窗口宽度变化
  });
  return (
    <div>
      <p> window width is {width}</p>
    </div>
  );
}
```
