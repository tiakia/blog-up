---
title: effect-hook详解
abbrlink: 63515
date: 2019-03-10 17:23:27
tags: [react, effect-hook]
---

之前写过一篇关于 react-hook 的文章，但也只是大略的简述了一下`useState`，这俩天在掘金看到一篇关于`effect-hook`的觉得很有必要来写写。相比于`useState`来说`useEffect`更难理解一些。如果不想看我写的，推荐阅读文末参考链接的文章，写的真好。

<!-- more -->

可能在你深入了解`useEffect`之前，觉得自己已经了解了，但是请你考虑一下一下几个问题：

- 为什么有时候会取到旧的`props`和`state`
- 如何用`useEffect`模拟`componentDidMount`
- 如何在`useEffect`中正确的请求数据
- 函数可以做`useEffect`的依赖吗
- 为什么会出现无限重复的数据请求

### 为什么有时候会取到旧的`props`和`state`

#### **每一次渲染都会有它自己的`props`和`state`**

以组件`Counter`为例

```javascript
function Counter() {
  const [count, setCount] = useState(0);
  return (
    <div>
      <div>{count}</div>
      <button onClick={() => setCount(count + 1)}>Add</button>
    </div>
  );
}
```

代码运行时候，我们点击`button`相应的`count`的值也会增加，运行的过程实际上是这样的

组件第一次渲染的时候，拿到的`count`初始值是 `0`，当我们点击`button`的时候，调用`setCount(1)`,`React`再次渲染组件，这一次`count`是 `1`。

```javascript
// 组件第一次渲染
function Counter(){
    const count = 0; // 初始的state
    ...
    <div>{count}</div>
    ...
}
// 点击按钮后
function Counter(){
    const count = 1;
    ...
    <div>{count}</div>
    ...
}
// 再次点击后
function Counter(){
    const count = 2;
    ...
    <div>{count}</div>
    ...
}
```

当我们更新状态后，`React`每次渲染都会得到一个独立的`count`的值，这个状态值是函数中的一个常量。当`setCount`执行后，又会返回一个新的`count`值，再次调用组件。然后`React`更新 DOM 比保持输出和渲染一致。

这里关键的点在于任意一次渲染中的 `count` 常量都不会随着时间改变。渲染输出会变是因为我们的组件被一次次调用，而每一次调用引起的渲染中，它包含的 `count` 值独立于其他渲染。
这个理解了的话，那我们来看一下这个例子，会更有助于理解，每次渲染都会有自己`props`和`state`这一特性。

```javascript
function showCount() {
  const [count, setCount] = useState(0);
  function handleAlert() {
    setTimeout(() => alert(count), 3000);
  }
  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}> addCount</button>
      <button onClick={handleAlert}>showCount 3s later</button>
    </div>
  );
}
```

如果按照以下步骤操作：

- 点击`3`次`addCount`按钮，`count`加到`3`
- 点击`showCount 3s later`按钮
- 在计时器结束前，点击俩次`addCount`按钮，`count`加到`5`

你猜最后弹出来的是多少？

我们来分析一下操作过程，函数执行步骤：

```javascript
// 初始渲染
function showCount() {
  const count = 0;
  function handAlert() {
    setTimeout(() => alert(count), 3000);
  }
  ...
  <div>{count}</div>
  ...
}
// 点击三次按钮
function showCount() {
    const count = 1;
    function handleAlert(){...}
    ...
    <div>{count}</div>
    ...
}
function showCount() {
    const count = 2;
    function handleAlert(){...}
    ...
    <div>{count}</div>
    ...
}
function showCount() {
    const count = 3;
    function handleAlert(){...}
    ...
    <div>{count}</div>
    ...
}
```

实际上每次在渲染的时候都会有一个新的`handleAlert`函数，也会有他独有的`count`值

```javascript
function showAlert(){
    ...
    function handleAlert(){
        setTimeout(()=>alert(0), 3000);
    }
}
function showAlert(){
    ...
    function handleAlert(){
        setTimeout(()=>alert(0), 3000);
    }
    ...
}
function showAlert(){
    ...
    function handleAlert(){
        setTimeout(()=>alert(1), 3000);
    }
    ...
}
function showAlert(){
    ...
    function handleAlert(){
        setTimeout(()=>alert(2), 3000);
    }
    ...
}
function showAlert(){
    ...
    function handleAlert(){
        setTimeout(()=>alert(3), 3000);
    }
    ...
}
```

答案显而易见了，最后弹出的`count`值是`3`而不是`5`。

### 每次渲染都有它自己的 effects

接下来正式开始深入`useEffect`，我们先了解一下执行时间：

- `effect`会在初始渲染和组件每次更新后执行。

来看一下官网的例子：

```javascript
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    document.title = `You Clicked ${count} Times`;
  });

  return (
    <div>
      <p>You Clicked {count} Times</p>
      <button onClick={() => setCount(count + 1)}>Click Me</button>
    </div>
  );
}
```

我们知道每次渲染的过程中`count`都是特定的独特的常量。事件处理函数看到的是独属于它那次渲染特定的`count`值，对于`effect`来说也是如此。并不是`count`值在不变的`effect`中发生了改变，而是每次渲染中`effect`都是不同的。每次渲染中`effect`都有独属于它那次的`count`值。

```javascript
function Counter() {
  const count = 0;
  useEffect(() => {
    document.title = `You Clicked ${0} Times`;
  });
  ...
}
function Counter() {
  const count = 1;
  useEffect(() => {
    document.title = `You Clicked ${1} Times`;
  });
  ...
}
function Counter() {
  const count = 2;
  useEffect(() => {
    document.title = `You Clicked ${2} Times`;
  });
  ...
}
```

> React 会记住你提供的 effect 函数，并且会在每次更改作用于 DOM 并让浏览器绘制屏幕后去调用它。

---

我觉得有必要来回顾一下操作流程，更方便我们巩固记忆：

- **React**: 给我状态为`0`时的 UI
- **你的组件**：
  - 给你需要渲染的 UI 组件 `<p>You clicked 0 Times</p>`
  - 记得在渲染完后，调用这个`effect: () => {document.title = 'You Clicked 0 Times'}`
- **React**: 没问题。开始更新 UI，喂浏览器，我要给 DOM 添加一些东西。
- **浏览器**：我已经把它绘制到屏幕上了。
- **React**： 好的， 我现在开始运行给我的 effect

  - 运行`() => document.title='You Clicked 0 Times`

---

现在我们看一下，在点击后发生了什么：

- **你的组件**： 把我的状态更新为`1`
- **React**: 给我状态为`1`时候的 UI
- **你的组件**:
  - 给你需要渲染的 UI 组件 `<p>You clicked 1 Times</p>`
  - 记得在渲染完后，调用这个`effect: () => {document.title = 'You Clicked 1 Times'}`
- **React**: 没问题。开始更新 UI，喂浏览器，我要修改 DOM。
- **浏览器**：我已经把它绘制到屏幕上了。
- **React**： 好的， 我现在开始运行给我的 effect
  - 运行`() => document.title='You Clicked 1 Times`

---

#### **每一次渲染都会有它自己的所有**

思考如下的代码：

```javascript
function Counter() {
  const [count, setCount] = useState(0);
  useEffect(() => {
    setTimeout(() => console.log(`You Clicked ${count} Times`), 3000);
  });
  return (
    <div>
      <button onClick={() => setCount(count + 1)}>clicked me</button>
    </div>
  );
}
```

如果我点击了多次，那么会输入什么？
有个上面的结论，我们会很快说出结果，每次渲染的时候都会有它固定的`props/state`,每次渲染的`effect`都是不同的都有属于它那次的`count`值，那么再控制台的就会输出：

```bash
You Clicked 0 Times
You Clicked 1 Times
You Clicked 2 Times
You Clicked 3 Times
You Clicked 4 Times
```

但是这里如果是`class`组件中，输出的结果就会不一样

```javascript
componentDidUpdate() {
    setTimeout(() => console.log(`You Clicked ${this.state.count} Times`), 3000);
}
```

这里`this.state.count`会指向最终的值，而不是每次固定的值，控制台输出的结果是输出 4 次同样的：

```bash
You Clicked 4 Times
```

##### 这里我们可以得出一个结论

> 组件内的每一个函数（包括事件处理函数，effects，定时器或者 API 调用等等）会捕获定义它们的那次渲染中的 props 和 state

#### **useRef()**

如果我们也想要在`effect`中，也获取到最终的值，那我们可以借助`useRef()`

```javascript
function Counter() {
  const [count, setCount] = useState(0);
  const lastCount = useRef(count);
  useEffect(() => {
    setTimeout(
      () => console.log(`You Clicked ${lastCount.current} Times`),
      3000
    );
  });
  return (
    <div>
      <button onClick={() => setCount(count + 1)}>clicked me</button>
    </div>
  );
}
```

我们使用了`useRef(count)`获取点击 4 次后最终的状态，控制台输出`lastCount.currnt` 4 次同样的：

```bash
You Clicked 4 Times
```

### 回收机制

有些 effects 可能需要有一个清理步骤。本质上，它的目的是消除副作用（effect)，比如取消订阅。
那么这个清除步骤是什么时候执行的呢？
思考一下代码：

```javascript
useEffect(() => {
  ChatAPI.subscribeToFriendStatus(props.id, handleStatusChange);
  return () => {
    ChatAPI.unsubscribeFromFriendStatus(props.id, handleStatusChange);
  };
});
```

假设,第一次渲染的时候`props.id = 10`，然后`props.id = 20`,那么这个清除步骤是在什么时候进行的？
你可能会认为是这样的：

- React 执行了`props.id = 10`的清除
- React 渲染了 `props.id = 20`的 UI
- React 运行了`props.id=20`的`effect`

事实上并非如此： 我们知道`effect`是在浏览器渲染后执行的，这使得你的应用更流畅因为大多数`effects`并不会阻塞屏幕的更新。`Effect`的清除同样被延迟了。上一次的`effect`会在重新渲染后被清除：

- React 渲染了 `props.id = 20`的 UI
- React 执行了`props.id = 10`的清除
- React 运行了`props.id=20`的`effect`

至于这里为什么在`props.id`变为`20`后，`effect` 的清除还能取到`props.id = 10`，这就是上面**结论**说的，组件的`effect`，会捕获那次渲染中的`props`和`state`。只不过是清除被延后了。

### useEffect 的第二个参数

现在我们大概了解了`effect`的执行过程，我们也知道`effect`是在首次渲染和更新后执行的，类似于`Class`组件的`DidMount`和`DidUpDate`,但是有时候也会遇到组件渲染后执行`effect`，陷入无限循环中，这种情况我们就需要靠`useEffect`的第二个参数来，告诉 React 什么时候执行`effect`。
举个例子：

```javascript
function Demo({ name }) {
  const [count, setCount] = useState(0);
  useEffect(() => {
    document.title = "Hello," + name;
  });
  return (
    <div>
      Hello, {name}
      <button onClick={() => setCount(count + 1)}>click me</button>
    </div>
  );
}
```

`Demo`组件中，我们并没有用到`count`状态，但是我们在每次点击按钮后，都会引起页面的渲染，这种渲染就是不必要的浪费的，如果我们要避免这种不必要的浪费，就需要用到`useEffect`的第二个参数

```javascript
useEffect(() => {
  document.title = "Hello," + name;
}, [name]);
```

这样，如果当前渲染中，依赖项`name`并没有变化，那么在这次渲染过后，React 会跳过这次`effect`。

#### **设置错误依赖项**

如果我们设置错误了依赖项，React 就不会按我们的期望运行`effect`，所以这里我们不要对依赖项撒谎。
比如这个例子：

```javascript
useEffect(() => {
    document.title = 'Hello, " + name;
},[])
```

这样设置的话，那么在`name`改变后，React 不会运行`effect`，`document.title`只会是我初始化渲染时候的状态，这显然不是我们期望的。
再来看一个典型的定时器的例子：因为它是定时器，所以我们只想在函数挂载的时候执行一次就行了，那么我们可能会这样写

```javascript
function Counter() {
  const [count, setCount] = useState(0);
  useEffect(() => {
    let timer = setInterval(() => setCount(count + 1), 1000);
    return () => clearInterval(timer);
  }, []);
  return <h1>{count}</h1>;
}
```

我们的本意是让定时器在函数挂载的时候执行一次就行，然后每秒`count`递增`1`。事实上是这样运行的：

```javascript
// 第一次渲染 会调用 Effect
function Counter() {
  const count = 0;
  useEffect(() => {
    let timer = setInterval(() => setCount(0 + 1), 1000);
    return () => clearInterval(timer);
  }, []);
  return <h1>{0}</h1>;
}
// 第二次渲染 react 比对了俩次的 依赖 [] === [] 所以不会再调用 effect
function Couonter() {
  const count = 1;
  return <h1>{1}</h1>;
}
// 之后每一秒都会渲染，但是不会调用Effect了
```

#### 还是那个结论

---

**组件内的每一个函数（包括事件处理函数，effects，定时器或者 API 调用等等）会捕获定义它们的那次渲染中的 props 和 state**

---

`setInterval`函数每隔一秒调用的函数都是`setCount(0+1)`，因为依赖项一样，所以每秒更新都不会再走`effect`

#### 俩种正确告知依赖的方法

**第一种就是在依赖中包含所有 effect 中用到的组件内的值**

```javascript
useEffect(() => {
  let timer = setInterval(() => setCount(count + 1), 1000);
  return () => clearInterval(timer);
}, [count]);
```

现在依赖正确了，每次渲染都会运行`effect`方法，定时器都会获得新的`count`值，同时每次定时器也会被清除和重新赋值。
**第二种策略是修改 effect 内部的代码以确保它包含的值只会在需要的时候发生变更，也就是尽量的减少依赖**

```javascript
useEffect(() => {
  let timer = setInterval(() => setCount(c => c + 1), 1000);
  return () => clearInterval(timer);
}, []);
```

我们真正想要的是把`count`转换为`count+1`，然后返回给 React,我们其实并不需要`setCount(count + 1)`，因为 React 已经知道了`Count`的值，我们只是需要告诉 React，`count` 要处于递增的状态就行了。
这样在执行的时候，因为依赖变回了`[]`,那么`effect`只会在开始的时候执行一次，然后定时器这次每次执行的不再是`setCount(0 + 1)`，而是`setCount(c => c + 1)`，你可以认为它是在给 React 发送指令告知如何更新状态。

---

思考一下：如果有多个依赖项呢?

```javascript
useEffect(() => {
  let timer = setInterval(() => setCount(c => c + step), 1000);
  return () => clearInterval(timer);
}, [step]);
```

这个例子目前的行为是修改`step`会重启定时器 - 因为它是依赖项之一。在大多数场景下，这正是你所需要的。清除上一次的`effect`然后重新运行新的`effect`并没有任何错。除非我们有很好的理由，我们不应该改变这个默认行为。

不过，假如我们不想在`step`改变后重启定时器，我们该如何从`effect`中移除对`step`的依赖呢？

**当你想更新一个状态，并且这个状态更新依赖于另一个状态的值时，你可能需要用 `useReducer` 去替换它们。**

---

### useReducer()

`effect`如果有多个依赖,而且我们不想他们互相影响，那么我们可以考虑使用作弊器`useReducer`，用`dispatch`来当作依赖，上面的代码可以这样写：

```javascript
const [state, dispatch] = useReducer(reducers, initialState);
const { count, step } = state;

useEffect(() => {
  const timer = setInterval(() => {
    dispatch({ type: "tick" });
  }, 1000);
  return clearInterval(timer);
}, [dispatch]);
```

**React 会保证 dispatch 在组件的声明周期内保持不变。所以上面例子中不再需要重新订阅定时器。**
相比于直接在 `effect` 里面读取状态，它 `dispatch` 了一个 `action` 来描述发生了什么。这使得我们的 `effect` 和 `step` 状态解耦。我们的 `effect` 不再关心怎么更新状态，它只负责告诉我们发生了什么。更新的逻辑全都交由 `reducer` 去统一处理:

```javascript
function Counter() {
  const intialState = {
    count: 0,
    step: 1
  };

  function reducers(state, action) {
    const { count, step } = state;
    try {
      switch (action.type) {
        case "tick":
          return { count: count + 1, step };
        case "step":
          return { count, step: action.step };
        default:
          return { count, step };
      }
    } catch (e) {
      throw Error(e);
    }
  }

  const [state, dispatch] = useReducer(reducers, intialState);

  const { count, step } = state;

  useEffect(() => {
    let timer = setInterval(() => dispatch({ type: "tick" }), 1000);
    return () => clearInterval(timer);
  }, [dispatch]);

  return (
    <div>
      <p>Count: {count}</p>
      <p>Step: {step}</p>
      <input
        type="number"
        value={step}
        onChange={e => dispatch({ type: "step", step: Number(e.target.value) })}
      />
    </div>
  );
}
```

### useCallback()

函数也可以作为`effect`的依赖项，这也是`useCallback()`的功能。
想像一下下面这个例子：

```javascript
function SearchResults() {
  const [query, setQuery] = useState("react");

  function getFetchUrl() {
    return "https://hn.algolia.com/api/v1/search?query=" + query;
  }

  async function fetchData() {
    const result = await axios(getFetchUrl());
    setData(result.data);
  }

  useEffect(() => {
    fetchData();
  }, []);

  // ...
}
```

这段代码，在初始渲染的时候是可以执行的，但是如果我们改变了`query`的值，那么因为`effect`的依赖项是`[]`所以`React`不会运行`effect`，这样的结果显然不是我们想要的，我们也可以考虑一个简单的解决办法，如果`getFetchUrl`函数只在`effect`中使用了那我们可以把它写在`effect`里面.

```javascript
function SearchResults() {
  const [query, setQuery] = useState("react");

  useEffect(() => {
    function getFetchUrl() {
      return "https://hn.algolia.com/api/v1/search?query=" + query;
    }

    async function fetchData() {
      const result = await axios(getFetchUrl());
      setData(result.data);
    }

    fetchData();
  }, [query]); // 依赖记得加上

  // ...
}
```

这样那我们在`query`变化的时候，`React`会运行`effect`，这个时候我们的方案是可行的。但是如果组件内有几个`effect`使用了相同的函数，你不想在每个 `effect` 里复制黏贴一遍这个逻辑。也或许这个函数是一个 `prop`。

在这种情况下你应该忽略对函数的依赖吗？我不这么认为。再次强调，**`efffects` 不应该对它的依赖撒谎。**通常我们还有更好的解决办法。一个常见的误解是，“函数从来不会改变”。但是这篇文章你读到现在，你知道这显然不是事实。实际上，**在组件内定义的函数每一次渲染都在变。**

**函数每次渲染都会改变这个事实本身就是个问题**。这就需要我们的`useCallback`了，一起来看一下例子：

```javascript
function SearchResults() {
  const [query, setQuery] = useState("react");

  const getFetchUrl = useCallback(() => {
    return "https://hn.algolia.com/api/v1/search?query=" + query;
  }, [query]);

  async function fetchData(url) {
    const result = await axios(url);
    setData(result.data);
  }

  useEffect(() => {
    const url = getFetchUrl();
    fetchData(url);
  }, [getFetchUrl]);

  // ...
}
```

我们把 `query` 添加到 `useCallback` 的依赖中，任何调用了 `getFetchUrl` 的 `effect` 在 `query` 改变后都会重新运行,如果`query` 保持不变，`getFetchUrl`也会保持不变，我们的`effect`也不会重新运行。但是如果`query`修改了，`getFetchUrl`也会随之改变，因此会重新请求数据。

---

`useCallback`本质上是添加了一层依赖检查。它以另一种方式解决了问题 - **我们使函数本身只在需要的时候才改变，而不是去掉对函数的依赖。**

---

对于通过属性从父组件传入的函数这个方法也适用：

```javascript
function Parent() {
  const [query, setQuery] = useState("react");

  const fetchData = useCallback(() => {
    const url = "https://hn.algolia.com/api/v1/search?query=" + query;
  }, [query]);
  return <Child fetchData={fetchData} />;
}

function Child({ fetchData }) {
  let [data, setData] = useState(null);

  useEffect(() => {
    fetchData().then(setData);
  }, [fetchData]);

  // ...
}
```

只有在父组件的`query`变化后`Child`才会去请求数据。

---

现在我们再来看看文章开头提出的几个问题，是不是都有答案了：

- 为什么有时候会取到旧的 `props` 和 `state`
  - 组件内的每一个函数（包括事件处理函数，effects，定时器或者 API 调用等等）会捕获定义它们的那次渲染中的 props 和 state。
- 如何用`useEffect`模拟`componentDidMount`
  - 可以把`effect`的依赖项设置为`[]`，那么组件只会在初始渲染的时候运行`effect`,之后每次渲染，因为依赖项一样所以都不会再运行`effect`
- 如何在`useEffect`中正确的请求数据
- 函数可以做`useEffect`的依赖吗
  - `effect`的依赖项设置正确，不要对 React 撒谎，如果函数只在`effect`中用到那么把函数直接写到`effect`中，当然要注意设置好依赖项，或者可以使用`useCallback`封装请求函数，把函数设置成`effect`依赖
- 为什么会出现无限重复的数据请求

  - 依赖项设置错误

> 参考链接

[useEffect 完整指南](https://overreacted.io/zh-hans/a-complete-guide-to-useeffect/)
