---
title: redux-saga处理异步请求(初级篇)
date: 2018-09-05 16:56
categories: react
tags: [redux-saga, react]
keywords:
  - react
  - redux
  - saga
clearReading: true
thumbnailImage:
thumbnailImagePosition: left  //缩略图显示的位置，上下左右都可以
autoThumbnailImage: true
metaAlignment: center  //文章页图片上的文字居中显示
coverImage: http://pkafgcch8.bkt.clouddn.com/cover/cover.jpg
coverCaption:
coverMeta: in
coverSize: full
comments: true
---

redux 是 react 中处理数据的方式，数据的获取有时候需要通过请求后台来获得，这个操作就是副作用，`redux-saga` 就是用来处理副作用的方式。

<!-- more -->

使用 `redux-saga` 的方式：
``` main.js  %}

<!-- tab js -->

import React from 'react';
import ReactDOM from 'react-dom';
import { createStore, applyMiddleware } from 'redux';
import { createSagaMiddleware } from 'redux-saga';

import reducer from './reducers';

import rootSaga from './sagas';
//创建 saga 中间件
const sagaMiddleware = createSagaMiddleware();
//redux 应用 saga 中间件
const store = createStore(
reducer,
applyMiddleware(sagaMiddleware)
);

sagaMiddleware.run(rootSaga);

const action = type => store.dispatch({type})

const Counter = ({value, onIncrement, onDecrement, onIncrementasync}) =>
(<div>

<button onClick={onIncrementAsync}>
increment after 1 second
</button>
{' '}
<button onClick={onIncrement}>
Increment
</button>
{' '}
<button onClick={onDecrement}>
Decrement
</button>

<hr />
<div>
Clicked: {value} times
</div>
</div>);

function render() {
ReactDOM.render(
<Counter
value={store.getState()}
onIncrement={() => action('INCREMENT')}
onDecrement={() => action('DECREMENT')}
onIncrementAsync={() => action('INCREMENTASYNC')} />,
document.getElementById('root')
)
}

render();

<!-- endtab -->

```
``` reducers.js  %}
<!-- tab js -->
export default function reducers(state = 0, {type}){
    switch(type){
       case 'INCREMENT':
           return state + 1;
       case 'DECREMENT':
           return state - 1;
       default:
           return state;
    }
}
<!-- endtab -->
```

增加一个点击按钮 1s 后增加 1 的 saga
``` sagas.js  %}

<!-- tab js -->

import { put, takeEvery, all } from 'redux-saga/effects';

export function\* incrementAsync(){
yield delay(1000);
yield put({type: "INCREMENT"});
}

export function\* watchIncrementAsync(){
yield takeEvery('INCREMENTASYNC', incrementAsync);
}

export default function\* rootSaga(){
yield all([

helloSaga(),

watchIncrementAsync()

]);
}

<!-- endtab -->

```

##### Effects
saga 提供的工具函数，可以用来进行异步操作。
- call 函数用来发起异步请求 阻塞的 阻塞函数执行知道返回 resolve 或 reject
- fork 无阻塞的发起异步请求，函数可以继续执行，而不会等待fork发起的异步任务结束
- put 类似 redux 的 dispatch 发起一个 action
- take 监听这个 action 的发生,一般放到一个 `while(true)`循环中，否则只能监听到第一次的 action
- cancel() fork 返回一个 task 列表，使用 cancel 可以中止任务执行
- takeEvery  监听每次触发的操作
- takeLatest 只监听最后一次触发的操作

##### 创建一个 logger 日志记录 saga
``` sgas.js  %}
<!-- tab js -->
export function* logger(){
    while(true){
       const action = yield take('*');
       const state = yield select();
       console.log('actions： '+ JSON.stringify(action));
       console.log('state after: '+ state);
    }
}

export default function* rootSaga(){
    yield all([
        helloSaga(),
        watchIncrementasync(),
        logger()
    ]);
}
<!-- endtab -->
```

```
take(*)可以监听所有的action，搭配 while(true) 可以监听所有的 操作，记录日志
```

使用了 saga， 那么逻辑就可以放在 saga 中，数据的状态和绑定数据到 react 放在 reducer 里面 而 react 只负责 UI 界面展示

```

```
