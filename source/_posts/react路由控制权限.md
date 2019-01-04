---
title: react路由控制权限
date: '2018-12-25 14:09'
categories: react
tags:
  - react
  - react-router
keywords:
  - react
comments: true
abbrlink: 45622
thumbnailImage:
---

react 中可以通过路由来控制用户权限访问，主要使用的 `react-router` 的 `switch` 这里有个实用的例子

<!-- more -->

```javascript
function RouterConfig({ history }) {
  return (
    <Router history={history} basename={config.basename}>
      <Switch>
        {/* onEnter={authenticated(history)} */}
        {/*-----------------------------*/}
        {/*renderRoutes(RouteConfig)*/}
        {/*-----------------------------*/}
        <Route path="/login" exact component={Login} />
        <Authorized
          component={Routes}
          path="/"
          noMatch="/login"
          history={history}
        />
      </Switch>
    </Router>
  );
}
```

这样用户在刚进入的时候，如果访问的不是`/login`那么会进入`/`对应的 `Authorized`组件

```javascript
const Authorized = ({ component: Component, history, noMatch, ...rest }) => (
  <Route
    {...rest}
    render={props => {
      let token = authenticated(history); //获取 token
      console.log("-----------");
      console.log(token);
      console.log("-----authorized------");
      return token ? <Component {...props} /> : <Redirect to={noMatch} />;
    }}
  />
);
```

在`Authorized`组件中，获取`token`,如果`token`存在那么就渲染对应的组件，如果`token`不存在就重定向到`/login`路径,`Authorized`组件渲染的 `Component`是所有的路由集合

```javascript
const Routes = ({ history }) => {
  return <Layout history={history}>{renderRoutes(RouteConfig)}</Layout>;
};
```

这里使用的`react-router-config`的库提供的`renderRoutes`函数，其中的`RouteConfig`是配置的所有的静态路由
大体的思路就是这样，在用户开始访问的时候就控制，如果`token`(这里也可以是其他的判断条件)存在，继续访问，如果不存在就让他访问另一个路由
前端权限控制比较简单，权限更多的还是前后端一起来控制，比较保险
