---
title: react拾遗
date: '2018-10-23 14:39'
categories: react
tags:
  - react
keywords:
  - react
clearReading: true
comments: true
abbrlink: 17411
thumbnailImage:
coverCaption:
---

总结一些 react 中常见的面试题吧，同时也是让自己多学习学习 react 相关的知识。查漏补缺。

<!-- more -->

### 组件的命名

基于路径命名的方式，举个例子，组件的路径如果是 `components/User/List.jsx`，那么它就被命名为 `UserList`。

### !!()

!!(a)的作用是将 a 强制转换为布尔类型

```javascript
let a = 123;
console.log(!!a); // true

let b = '';
console.log(!!b); //false

let c = 'null';
console.log(!!c); //true

let d = null;
console.log(!!d); //false
<!-- endtab -->
```

### PureComponent

`React.PureComponent` 相较于 `React.Component` 做了一个`shouldComponentupdate()`的浅比较，避免了重复更新

### props 和 state

props 更多的类似是 函数 的 参数
state 类似函数内部声明的变量，在函数内部使用，控制函数状态

### setState 的 callback()

```javascript
this.setState({ name: "Tian" }, () => {
  console.log(this.state.name);
});
```

`setState`是异步的，但是可以在回调函数中获取`setState`后的 `state`

### HTML 和 React 中的事件处理有什么区别

- `react` 事件名称大写，eg: `onClick`/`onChange`
- 在 HTML 中阻止事件可以`return false`,在 `react` 中 必须使用 `e.preventDefault()`

### react 中 函数绑定 this 的方法

- 在 构造函数中

```javascript
class Example extends React.Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }
  handleClick() {
    console.log("click");
  }
}
```

- 箭头函数

```javascript
handleClick = () => {
  console.log("click");
};
```

> react 中函数的使用

- `<button onCLick={this.handleClick}>Click</button>`
- `<input onChange={e => this.handleChange(e)}/>`

### ref 的使用

```javascript MyComponent.js
class MyComponent extends React.Component {
  constructor(props) {
    super(props);
    this.myRef = React.createRef();
  }
  render() {
    return <div ref={this.myRef} />;
  }
}
```

```javascript SearchBar.js
class SearchBar extends Component {
  constructor(props) {
    super(props);
    this.txtSearch = null;
    this.state = { term: "" };
    this.setInputSearchRef = e => {
      this.txtSearch = e;
    };
  }
  onInputChange(event) {
    this.setState({ term: this.txtSearch.value });
  }
  render() {
    return (
      <input
        value={this.state.term}
        onChange={this.onInputChange.bind(this)}
        ref={this.setInputSearchRef}
      />
    );
  }
}
```

### 受控组件 和 非受控组件

使用 `setState` 控制内部状态的组件称为受控组件，

#### controlled

```javascript
class NameForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = { name: "" };
    this.handleNameChange = this.handleNameChange.bind(this);
  }

  handleNameChange(event) {
    this.setState({ name: event.target.value });
  }

  render() {
    return (
      <div>
        <input
          type="text"
          value={this.state.name}
          onChange={this.handleNameChange}
        />
      </div>
    );
  }
}
```

> 当注释 `this.setState({value: event.target.value});` 这行代码，文本框再次输入时，页面不会重新渲染，所产生效果即是文本框输入不了值，即文本框值的改变受到 `setState()` 方法的控制，在未执行时，不重新渲染组件

#### uncontrolled

表单数据由 DOM 本身处理。即不受`setState()`的控制，与传统的 HTML 表单输入相似，input 输入值即显示最新值（使用 `ref` 从 DOM 获取表单值）

```javascript
class NameForm extends React.Component {
  constructor(props) {
    super(props);
    this.input = null;
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(event) {
    alert("A name was submitted: " + this.input.value);
    event.preventDefault();
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          Name:
          <input type="text" ref={input => (this.input = input)} />
        </label>
        <input type="submit" value="Submit" />
      </form>
    );
  }
}
```

### React16 生命周期

[react16 生命周期](http://www.tiankai.party/react16.html)

### React 高阶组件

在组件内部对旧的组件进行封装，返回一个新的组件。

```javascript
function HOC(WrappedComponent) {
  return class Test extends Component {
    render() {
      const newProps = {
        title: "New Header",
        footer: false,
        showFeatureX: false,
        showFeatureY: true
      };

      return <WrappedComponent {...this.props} {...newProps} />;
    }
  };
}
```

### react 16.6 lazy

类似于`react-loadable`

```javascript
import React, { lazy, Suspense } from "react";
const OtherComponent = lazy(() => import("./OtherComponent"));

function MyComponent() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <OtherComponent />
    </Suspense>
  );
}
```

### React Context

```javascript ThemeContext.js
import React from "react";

export const themes = {
  light: {
    foreground: "#000",
    background: "#eee"
  },
  dark: {
    foreground: "#fff",
    background: "#222"
  }
};

export const ThemeContext = React.createContext(themes.dark);
```

```javascript App.js
import React, { PureComponent } from "react";
import Tool from "./Tool";
import { ThemeContext, themes } from "./modules/ThemeContext";

const { Provider } = ThemeContext;

export default class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      theme: themes.light
    };
    this.changeTheme = this.changeTheme.bind(this);
  }
  changeTheme() {
    this.setState(prev => ({
      theme: prev.theme === themes.dark ? themes.light : themes.dark
    }));
  }
  render() {
    return (
      <Provider value={this.state.theme}>
        <Tool changeTheme={this.changeTheme} />
      </Provider>
    );
  }
}
```

```javascript Tool.js
import React, { PureComponent } from "react";
import { ThemeContext, themes } from "./modules/ThemeContext";
import PropTypes from "prop-types";

const { Consumer } = ThemeContext;

class Tool extends PureComponent {
  constructor(props) {
    super(props);
  }
  render() {
    return (
      <Consumer>
        {value => (
          <div
            style={{
              backgroundColor: value.background,
              width: "100%",
              height: "100%"
            }}
          >
            <button
              style={{
                backgroundColor: value.foreground,
                color: value.background,
                outline: "none",
                padding: "5px 8px",
                borderRadius: "5px",
                border: 0,
                margin: "20px"
              }}
              onClick={this.props.changeTheme}
            >
              Toggle - Theme -{" "}
              {value.background === themes.dark.background ? "dark" : "light"}
            </button>
          </div>
        )}
      </Consumer>
    );
  }
}

Tool.propTypes = {
  changeTheme: PropTypes.func,
  errorAction: PropTypes.func
};

export default Tool;
```
