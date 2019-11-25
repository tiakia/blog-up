---
title: code-split的几种方式
abbrlink: 16200
date: 2019-11-20 12:06:58
tags: code-split
categories: react
---
我们在打包项目的时候有时候会遇到打包后的体积过大的问题，这时候会提醒我们使用
`code-split`来分割我们的代码，今天我们就来认识一下在react中常见的我们使用的代码分割的
方式。
<!-- more -->
## import()
`import()`允许我们按需的导入组件，只有在组件要加载的时候才会导入，配合
`react-router`可以实现我们需要的`code-split`.

我们先来看一下，不使用代码分割的`react-router`代码是怎样的：

```javascript
// 导入组件
import Home form './containers/Home';
import Posts from './containers/Posts';
import NotFound from './containers/NotFound';

export default () => 
<Switch>
  <Route path="/" exact component={Home} />
  <Route path="/posts/:id" component={Posts} />
  <Route component={NotFound} />
</Switch>
```
`react-router`的`Switch`是只有在路由匹配到后才会加载对应的组件,然而我们是在一开
始的时候就导入了所有的组件，当我们的项目很大的时候，这种加载方式会使我们的页面变
的很臃肿。所以我们需要使用代码分割，只有在组件要加载的时候才会导入它。
### create an Async Component
- `src/components/AsyncComponent.js`

```javascript
import React, { Component } from 'react';

export default function AsyncComponent(importComponent) {
  class AsyncComponent extends Component {
    constructor(props) {
      super(props);
      
      this.state = {
        component: null
      }
    }
    
    async componentDidMount() {
      const { default: component } = await importComponent();
      
      this.setState({
        component
      });
    }
    
    render() {
      const C = this.state.component;
      
      return C ? <C {...this.props} /> : null;
    }
  }
  
  return AsyncComponent;
}

```

我们创建了一个高阶组件`AsyncComponent`，它做了这几件事：
- 接受一个组件作为参数
- 在`componentDidMount`中，获得传入的组件，设置到`state`中
- `render`的时候，如果`state`已经被设置了，那么展示设置的组件，如果没有不展示。
- 这样简单的实现了一个按需加载组件

然后我们使用我们封装的这个高阶组件来重新导入一下上面的组件：

```javascript 
import React from 'react';
import { Route, Switch } from 'react-router-dom';
import AsyncComponent from 'src/components/AsyncComponent';
imoprt AppliedRoute from './components/AppliedRoute';
import AuthenticatedRoute from './components/AuthenticatedRoute';
import UnauthenticatedRoute from './components/UnauthenticatedRoute';

const AsyncHome = AsyncComponent(() => imoprt('./containers/Home'));
const AsyncLogin = AsyncComponent(() => import('./containers/Login'));
const AsyncNotes = AsyncComponent(() => import('./containers/Notes'));
const AsyncSignup = AsyncComponent(() => import('./containers/Signup'));
const AsyncNewNote = AsyncComponent(() => import('./containers/NewNote'));
const AsyncNotFound = AsyncComponent(() => import('./containers/NotFound'));

export default ({ childProps }) => 
<Switch>
  <AppliedRoute 
     path="/"
     exact
     component={AsyncHome}
     props={childProps}
  />
  <UnauthenticatedRoute
     path="/login"
     exact
     component={AsyncLogin}
     props={childProps}
  />
  <UnauthenticatedRoute
     path="/signup"
     exact
     component={AsyncSignup}
     props={childProps}
  />
  <AuthenticatedRoute
     path="/notes/new"
     exact
     component={AsyncNewNote}
     props={childProps}
  />
  <AuthenticatedRoute
     path='/notes/:id'
     exact
     component={AsyncNotes}
     props={childProps}
  />
  <Route component={NotFound} />
</Switch>

```
我们的代码只是在每次引入的时候用`AsyncComponent`包裹了一下，现在已经是实现了
`code-split`了，只有在路由匹配到的时候才会加载对应的组件。

## react-loadable
实现组件按需加载，社区有成熟的架子，我们可以使用`react-loadable`来实现上面的功能。

- 安装 

```bash
npm install --save react-loadable
```

- 使用

```javascript
import LoadingComponent from 'src/components/LoadingComponent';

const AsyncHome = Loadable({
  loader: () => import("./containers/Home"),
  loading: LoadingComponent
});
```
在组件加载前，界面会显示我们自定义的`loading`页面。其他的`API`配置可以查看
[`react-loadable`的官网页面](https://github.com/jamiebuilds/react-loadable)

## React.lazy()
`React`现在已经是实现了`code-split`，我们可以通过`Suspense`和`React.lazy()`来实
现和上面一样的功能，这俩个是成对出现的，`loading`页面要在`Suspense`中设置。

```javascript
cosnt AsynHome = React.lazy(() => import('./containers/Home'));

function MyComponent() {
  return (
    <div>
       <Suspense fallback={<div>loading...</div>}>
         <AsynHome/>
       </Suspense>
    </div>
  )
}
```
`React.lazy()`目前只适用于默认导出的模块。如果要对不是默认导出的模块使用的话可以
参考这个：
```javascript
// ManyComponent.js
export const MyComponent = /* ... */;
export const MyUnusedConponent = /* ... */;
```

```javascript
// MyComponent.js
export { MyComponent as default } from './ManyComponents.js';
```

```javascript
// MyApp.js
import React, { lazy } from 'react';
const Mycomponent  = lazy(() => import('./MyComponent.js'));
```
