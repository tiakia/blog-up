---
title: 如何在useEffect中请求数据
abbrlink: 23994
date: 2019-03-15 14:19:24
tags: [react, effect-hook]
categories: react
---

上次介绍了一些`effect`的知识，这次我们来实践操作一下，在`react-hooks`中改如何正确的请求数据。

<!-- more -->

### 请求的无限循环？

如果看过上节的文章那就知道了，我们这里来写个简单的例子，看看为什么会陷入无限循环的请求中。文章中请求使用自己封装的[axios](http://www.tiankai.party/posts/48591/)：

```javascript
import React, { useState, useEffect } from "react";
import ajax from "utils/axios";

function App() {
  const [data, setData] = useState({ hits: [] });

  useEffect(() => {
    const fetchData = async () => {
      const result = await ajax(
        method: 'GET',
        url: "http://hn.algolia.com/api/v1/search",
        params: {query: 'redux'}
      );

      setData(result.data);
    };

    fetchData();
  });

  return (
    <ul>
      {data.hits.map(item => (
        <li key={item.objectID}>
          <a href={item.url}>{item.title}</a>
        </li>
      ))}
    </ul>
  );
}

export default App;
```

然而，当你运行上面的代码的时候，你会陷入到该死的死循环中。`effect hook` 在组件 `mount` 和 `update` 的时候都会执行。因为我们每次获取数据后，都会更新 `state`，组件渲染后 React 会执行`effect`,这会一次又一次的请求数据。这就是`effect`依赖的问题，如果我们只想在`mount`的时候执行，那么我们需要设置`effect`的依赖项`[]`

```javascript
useEffect(() => {
    const fetchData = async () => {
      const result = await ajax(
        method: 'GET',
        url: "http://hn.algolia.com/api/v1/search",
        params: {query: 'redux'}
      );

      setData(result.data);
    };

    fetchData();
  },[]);
```

### 如何手动的控制请求

上面我们完成了如何只在`mount`中发请求，但是如果我们想控制请求的触发呢，或者说我们想动态的给请求传参数。上面的例子中请求参数是`redux`，但是如果我们想参数换成`react`呢？ 我们这里提供一个`input`输入框来提供请求参数。

```javascript
import React, { Fragment, useState, useEffect } from "react";
import ajax from "utils/axios";

function App() {
  const [data, setData] = useState({ hits: [] });
  const [query, setQuery] = useState("redux");
  useEffect(() => {
    const fetchData = async () => {
      const result = await ajax({
        method: "GET",
        url: "http://hn.algolia.com/api/v1/search",
        params: query
      });
      setData(result.data);
    };
    fetchData();
  }, []);
  return (
    <Fragment>
      <input
        type="text"
        value={query}
        onChange={event => setQuery(event.target.value)}
      />
      <ul>
        {data.hits.map(item => (
          <li key={item.objectID}>
            <a href={item.url}>{item.title}</a>
          </li>
        ))}
      </ul>
    </Fragment>
  );
}
```

这样我们可以通过输入框输入内容来手动的控制请求参数了，但是我们发现请求只发生在初始渲染中，我们在输入框修改值的时候，不会发生数据请求，这是因为`effect`依赖参数的问题，虽然请求参数变了，但是 React 在渲染后不会运行`effect`，因为依赖项都是`[]`,我们需要正确的设置依赖项：

```javascript
useEffect(() => {
  const fetchData = async () => {
    const result = await ajax({
      method: "GET",
      url: "http://hn.algolia.com/api/v1/search",
      params: query
    });
    setData(result.data);
  };
  fetchData();
}, [query]);
```

这样后我们在`query`改变后，数据就会重新获取，但是这样也有个问题，`input`的`onChage`事件，只要输入框内容发生变化，就会发生数据请求。我们需要有个开关来控制请求时机。

```javascript
import React, { Fragment, useState, useEffect } from "react";
import ajax from "utils/axios";

function App() {
  const [data, setData] = useState({ hits: [] });
  const [query, setQuery] = useState("redux");
  const [search, setSearch] = useState("redux");
  useEffect(() => {
    const fetchData = async () => {
      const result = await ajax({
        method: "GET",
        url: "http://hn.algolia.com/api/v1/search",
        params: search
      });
      setData(result.data);
    };
    fetchData();
  }, [search]);
  return (
    <Fragment>
      <input
        type="text"
        value={query}
        onChange={event => setQuery(event.target.value)}
      />
      <button onClick={() => setSearch(query)}>search</button>
      <ul>
        {data.hits.map(item => (
          <li key={item.objectID}>
            <a href={item.url}>{item.title}</a>
          </li>
        ))}
      </ul>
    </Fragment>
  );
}
```

这样只有在我们点击按钮后，React 才回去运行`effect`，请求数据，而在输入框输入的时候，组件虽然渲染了，但是不会运行`effect`

### Loading 状态

我们在数据请求的过程中加载一个 loading 状态，提高用户体验：

```javascript
import React, { Fragment, useState, useEffect } from "react";
import ajax from "utils/axios";

function App() {
  const [data, setData] = useState({ hits: [] });
  const [query, setQuery] = useState("redux");
  const [search, setSearch] = useState("redux");
  const [isLoading, setLoading] = useState(false);
  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      const result = await ajax({
        method: "GET",
        url: "http://hn.algolia.com/api/v1/search",
        params: search
      });
      setData(result.data);
      setLoading(false);
    };
    fetchData();
  }, [search]);
  return (
    <Fragment>
      <input
        type="text"
        value={query}
        onChange={event => setQuery(event.target.value)}
      />
      <button onClick={() => setSearch(query)}>search</button>
      {isLoading ? (
        <div>Loading ...</div>
      ) : (
        <ul>
          {data.hits.map(item => (
            <li key={item.objectID}>
              <a href={item.url}>{item.title}</a>
            </li>
          ))}
        </ul>
      )}
    </Fragment>
  );
}
```

现在当组件处于 `mount` 状态或者 请求参数 被修改时，调用 `effect` 获取数据，`Loading` 状态就会变成 `true`。一旦请求完成，`Loading` 状态就会再次被设置为 `false`。

### 错误处理

一般我们使用`try/catch`来捕获请求时的错误，这里我们也增加一个处理错误的状态。

```javascript
import React, { Fragment, useState, useEffect } from "react";
import ajax from "utils/axios";

function App() {
  const [data, setData] = useState({ hits: [] });
  const [query, setQuery] = useState("redux");
  const [search, setSearch] = useState("redux");
  const [isLoading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  useEffect(() => {
    const fetchData = async () => {
      setIsError(false);
      setLoading(true);
      try {
        const result = await ajax({
          method: "GET",
          url: "http://hn.algolia.com/api/v1/search",
          params: search
        });
        setData(result.data);
      } catch (e) {
        setIsError(true);
      }
      setLoading(false);
    };

    fetchData();
  }, [search]);
  return (
    <Fragment>
      <input
        type="text"
        value={query}
        onChange={event => setQuery(event.target.value)}
      />
      <button onClick={() => setSearch(query)}>search</button>

      {isError && <div>Something went wrong ...</div>}

      {isLoading ? (
        <div>Loading ...</div>
      ) : (
        <ul>
          {data.hits.map(item => (
            <li key={item.objectID}>
              <a href={item.url}>{item.title}</a>
            </li>
          ))}
        </ul>
      )}
    </Fragment>
  );
}
```

### 自定义 Hook

我们可以封装个 Hook, 提取出于数据请求有关的代码：

```javascript
function useFecth = (initialData, initialSearch) => {
  const [data, setData] = useState(initialData);
  const [search, setSearch] = useState(initialSearch);
  const [isLoading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  useEffect(() => {
    const fetchData = async () => {
      setIsError(false);
      setLoading(true);
      try {
        const result = await ajax({
          method: "GET",
          url: "http://hn.algolia.com/api/v1/search",
          params: search
        });
        setData(result.data);
      } catch (e) {
        setIsError(true);
      }
      setLoading(false);
    };

    fetchData();
  }, [search]);
  handleFetch= query => {
      setSearch(query)
  }
  return { data, isLoading, isError, handleFetch }
}
```

然后使用我们自己封装的 Hook

```javascript
import React, { Fragment, useState, useEffect } from "react";
import ajax from "utils/axios";

function App() {
  const [query, setQuery] = useState("redux");
  const { data, isLoading, isError, handleFetch } = useFetch(
    { hit: [] },
    "redux"
  );
  return (
    <Fragment>
      <input
        type="text"
        value={query}
        onChange={event => setQuery(event.target.value)}
      />
      <button onClick={() => handleFetch(query)}>search</button>

      {isError && <div>Something went wrong ...</div>}

      {isLoading ? (
        <div>Loading ...</div>
      ) : (
        <ul>
          {data.hits.map(item => (
            <li key={item.objectID}>
              <a href={item.url}>{item.title}</a>
            </li>
          ))}
        </ul>
      )}
    </Fragment>
  );
}
```

这种封装，可以让我们数据和表现分离，但是还不彻底，我们可以使用作弊器`useReducr`。

### useReducer

```javascript
function useFecth() {
  const [search, setSearch] = useState("redux");
  const initialState = {
    data: { hit: [] },
    isLoading: false,
    isError: false
  };
  function fetchReducer(state, action) {
    switch (action.type) {
      case "FETCH_INIT":
        return { ...state, isLoading: true, isError: false };
      case "FETCH_SUCCESS":
        return {
          ...state,
          isLoading: false,
          isError: false,
          data: action.payload
        };
      case "FETCH_FAILURE":
        return { ...state, isError: true, isLoading: false };
      default:
        throw new Error();
    }
  }
  const [state, dispatch] = useRecuder(fetchReducer, intialState);

  useEffect(() => {
    const fetchData = async () => {
      dispatch({ type: "FETCH_INIT" });
      try {
        const result = await axios(url);
        dispatch({ type: "FETCH_SUCCESS", payload: result.data });
      } catch (error) {
        dispatch({ type: "FETCH_FAILURE" });
      }
    };

    fetchData();
  }, [search]);

  handleFetch = query => {
    setSearch(query);
  };
  return { ...state, handleFetch };
}
```

```javascript
import React, { useState, useEffect, useReducer } from "react";
import ajax from "utils/axios";

function App() {

  const [query, setQuery] = useState('redux');
  const { isLoading, isError, data, handleFetch } = useFecth();

    return (
    <Fragment>
      <input
        type="text"
        value={query}
        onChange={event => setQuery(event.target.value)}
      />
      <button onClick={() => handleFetch(query)}>search</button>

      {isError && <div>Something went wrong ...</div>}

      {isLoading ? (
        <div>Loading ...</div>
      ) : (
        <ul>
          {data.hits.map(item => (
            <li key={item.objectID}>
              <a href={item.url}>{item.title}</a>
            </li>
          ))}
        </ul>
      )}
    </Fragment>
}
```

### 在 Effect Hook 中中断数据请求

```javascript
function useFecth() {
  const [search, setSearch] = useState("redux");
  const initialState = {
    data: { hit: [] },
    isLoading: false,
    isError: false
  };
  function fetchReducer(state, action) {
    switch (action.type) {
      case "FETCH_INIT":
        return { ...state, isLoading: true, isError: false };
      case "FETCH_SUCCESS":
        return {
          ...state,
          isLoading: false,
          isError: false,
          data: action.payload
        };
      case "FETCH_FAILURE":
        return { ...state, isError: true, isLoading: false };
      default:
        throw new Error();
    }
  }
  const [state, dispatch] = useRecuder(fetchReducer, intialState);

  useEffect(() => {
    let didCancel = false;
    const fetchData = async () => {
      dispatch({ type: "FETCH_INIT" });
      try {
        const result = await axios(url);
        if (!didCancel) {
          dispatch({ type: "FETCH_SUCCESS", payload: result.data });
        }
      } catch (error) {
        if (!didCancel) {
          dispatch({ type: "FETCH_FAILURE" });
        }
      }
    };

    fetchData();
    return () => (didCancel = true);
  }, [search]);

  handleFetch = query => {
    setSearch(query);
  };
  return { ...state, handleFetch };
}
```

---

`effect hook`都有一个 clean up 函数，它在组件卸载时运行。

---

`didCancel`在`effect`新的渲染完成后，会执行变为`true`，这个操作是防止异步获取数据的时候，在页面更新后，上一次请求的数据才接到，影响当前页面的显示。

> 实际上并没有中止数据获取（不过可以通过 Axios 取消来实现），但是不再为卸载的组件执行状态转换
