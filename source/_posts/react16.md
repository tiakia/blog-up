---
title: react16 生命周期
date: "2018-08-14 15:34"
categories: react
tags:
  - react
keywords:
  - react
  - getDerivedStateFromProps
  - getSnapshotBeforeUpdate
coverSize: full
comments: true
abbrlink: 5777
---

react16 移除的生命周期

<!-- more -->

- componentWillMount

- componentWillReceiveProps

- componentWillUpdate

react16 新的生命周期

- getDerivedStateFromProps

- getSnapshotBeforeUpdate

整体生命周期流程图：
![react16](/../images/react16.png)

完整的生命周期流程（按顺序）

<h3>组件进入挂载阶段（Mounting）</h3>

调用的函数顺序

- constructor
- getDerivedStateFromProps
- render
- componentDidMount

> constructor

组件的构造函数可以在这里进行 state 初始化

```javascript
class ExampleComponent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoading: false,
      goods: []
    };
  }
}
```

> getDerivedStateFromProps

`static getDerivedStateFromProps(nextProps, prevState)`

构造函数初始化后进入该生命周期，取代原先的 `componentWillReceiveProps`

- 不能在该函数中使用 `this`
- 接收新的`props`，然后决定是否更新 旧的 `state`
- 函数会返回一个对象用来更新当前的`state`状态，如果不需要可以返回 `null`

调用时机：

- 组件挂载时
- 接收到新的 props 时
- 调用了 setState 和 forceUpdate 时

```javascript
class ExampleComponent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoading: true,
      goods: []
    };
  }
  static getDerivedStateFromProps(nextProps, prevState) {
    if (nextProps.goods !== prevState.goods) {
      return {
        isLoading: false,
        goods: nextProps.goods
      };
    }
    return null;
  }
}
```

> render

render 方法 返回组件要渲染的东西

> componentDidMount

组件装载后调用，可以在这里请求数据，操作 DOM 节点。

### 更新阶段（Update）

`更新阶段生命周期函数调用：`

- getDerivedStateFromProps
- shouldComponentUpdate
- render
- getSnapshotBeforeUpdate
- componentDidUpdate

> getDerivedStateFromProps

`static getDerivedStateFromProps(nextProps, prevState)`
当组件的 props 改变，或者组件内部调用了 setState 或者 forceUpdate 会发生

> shouldComponentUpdate

`shouldComponentUpdate(nextProps, nextState)`

在组件 触发 render 之前都会调用这个函数 返回一个布尔值，如果返回 true 组件触发 render 渲染，返回 false 组件不触发 render 函数，默认返回 true，所以我们需要在函数中 比较 `this.props` 和 `nextProps` 以及 `this.state` 和 `nextState` 来决定是否需要 触发 render 函数渲染

```javascript
class ExampleComponent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoading: true,
      goods: []
    };
  }
  shouldComponentUpdate(nextProps, nextState) {
    if (this.goods.length !== nextState.goods.length) {
      return true;
    }
    return false;
  }
}
```

官方推荐的是组件继承 `PureComponent` 来减少组件重复渲染的次数，而不是开发者自己手工书写。`PureComponent` 是官方提供的，在内部对 props 和 state 进行了 一层浅比较

```javascript
class ExampleComponent extends PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      isLoading: true,
      goods: []
    };
  }
}
```

> render

根据 `shouldComponentUpdate` 返回的值 是否觉得需要调用 render 渲染

> getSnapshotBeforeUpdate

`getSnapshotBeforeUpdate(prevProps, prevState)`

这个方法在 render 之后，`componentDidUpdate` 之前调用，有两个参数 prevProps 和 prevState，表示之前的属性和之前的 state，这个函数有一个返回值，会作为第三个参数传给 `componentDidUpdate`，如果你不想要返回值，请返回 null，不写的话控制台会有警告

还有这个方法一定要和 `componentDidUpdate` 一起使用，否则控制台也会有警告

```javascript
class ExampleComponent extends PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      messages: []
    };
  }
  componentDidMount() {
    for (let i = 0; i < 20; i++) {
      this.handleMessage();
    }
    this.interval = window.setInterval(() => {
      if (this.state.messages.length > 200) {
        window.clearInterval(this.interval);
        return;
      }
      this.handleMessage();
    }, 1000);
  }
  getSnapshotBeforeUpdate(prevProps, prevState) {
    return this.rootNode.scrollHeight;
  }
  componentDidUpdate(prevProps, prevState, snapshot) {
    const scrollTop = this.rootNode.scrollTop;
    if (scrollTop < 5) return;
    this.rootNode.scrollTop =
      scrollTop + (this.rootNode.scrollHeight - snapshot);
  }
  componentWillUnMount() {
    windows.clearInterval(this.interval);
  }
  handleMessage() {
    this.setState(prev => ({
      message: [`msg ${prev.messages.length}`, ...prev.messages]
    }));
  }
  render() {
    return (
      <div ref={n => (this.listRef = n)}>
        {this.state.message.map((msg, idx) => (
          <div key={idx}>{msg}</div>
        ))}
      </div>
    );
  }
}
```

> componentDidUpdate

`componentDidUpdate(prevProps, prevState, snapshot)`

该方法在`getSnapshotBeforeUpdate`方法之后被调用，有三个参数`prevProps`，`prevState`，`snapshot`，表示之前的 props，之前的 state，和 snapshot。第三个参数是`getSnapshotBeforeUpdate`返回的，在这个函数里我们可以操作 DOM，和发起服务器请求，还可以`setState`，但是注意一定要用 if 语句控制，否则会导致无限循环

### 卸载阶段（UnMount）

组件卸载的时候只有一个生命周期函数

> componentWillUnmount

当我们的组件被卸载或者销毁了就会调用，我们可以在这个函数里去清除一些定时器，取消网络请求，清理无效的 DOM 元素等垃圾清理工作

注意不要在这个函数里去调用 setState，因为组件不会重新渲染了

### 错误收集

在 react16 之前，如果代码报错时候，会直接出现红屏，react16 之后可以直接使用这个函数来收集错误设置错误显示时的`state`，这样在界面上就不会出现红屏,但是这里有个问题，就是在捕获到错误的瞬间，React 会在这次渲染周期中将这个组件渲染为`null`

> componentDidCatch

`componentDidCatch(error, info)`

> getDerivedStateFromError

`static getDerivedStateFromError(error)`

为解决上述问题，react 在 16.6 版本新增了一个生命周期函数
这个方法跟`getDerivedStateFromProps`类似，唯一的区别是他只有在出现错误的时候才触发，他相对于`componentDidCatch`的优势是在当前的渲染周期中就可以修改`state`，以在当前渲染就可以出现错误的 UI，而不需要一个 null 的中间态。
而这个方法的出现，也意味着以后出现错误的时候，修改`state`展现错误时界面的状态应该放在这里去做，而后续收集错误信息之类的放到`componentDidCatch`里面。

> 一个关于 `componentDidCatch` 和 `static getDerivedStateFromError` 的例子

{% codepen tiakia MdzmWJ?editors=0010 light html,css,js,result 465 %}
