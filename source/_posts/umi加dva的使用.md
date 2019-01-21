---
title: umi+dva的使用
date: '2018-11-15 17:20'
categories: javascript
tags:
  - umi
  - dva
keywords:
  - umi
  - dva
comments: true
abbrlink: 59635
thumbnailImage:
coverCaption:
---

`umi`和`dva`都是阿里出的简化`react`开发的架构，以前都是直接开发的没使用这套，后来接触下来以后发现，开发感觉挺舒适的，刚开始使用的`dva`，有一个缺陷就是基于`roadhog`搭建的`webpack`架子，给我们自定义的接口实在有限,后来`umi`加入了`webpack-chain`可以自己添加、修改`webpack`的配置，值得一试。

<!-- more -->

`umi+dva` 的架构中，`dva`被当成了数据流，集合了`redux`/`redux-saga`，处理异步操作,而且还有个方便的是集合了`dva-loading`这个插件，不用我们去手动的写`loading`状态的`show/hide`了

### dva

`dva` 首先是一个基于 `redux` 和 `redux-saga` 的数据流方案，然后为了简化开发体验，`dva` 还额外内置了 `react-router` 和 `fetch`，所以也可以理解为一个轻量级的应用框架。
我们只是用他集合`redux`和`redux-saga`的部分，其他的我们使用`umi`的就行，`dva` 将文件分为了`model`、`services`，`model`文件夹下建立的就是我们的 `redux` 文件，`services`下建立的是我们的`api`接口，我们看一下`dva`的`model`文件

```javascript models/login.js
import { queryLogin } from "../services/login"; //导入loginService API 接口
import { Toast } from "antd-mobile";

export default {
  // namespace 用来标识reducer文件，connect的时候使用
  // 类似redux整合所有reducer文件中的key值
  namespace: "login",

  state: {
    //相当于redux的InitialState
    login: ""
  },

  subscriptions: {
    //可以在这里进行监听
  },
  //这里进行的就是异步操作了，集成了 redux-saga
  effects: {
    *fetch({ payload, callback }, { call, put }) {
      // eslint-disable-line
      try {
        const response = yield call(queryLogin, payload);
        if (response.code === "0000") {
          yield put({ type: "save", payload: response.data });
        } else {
          const errorObj = new Error();
          errorObj.msg = response.data.msg;
          throw errorObj;
        }
      } catch (e) {
        console.log(new Error(e));
        Toast.fail(e.msg || "登录请求失败，请重试");
      }
    }
  },
  // redux的 reducer 函数
  reducers: {
    save(state, action) {
      return { ...state, ...action.payload };
    }
  }
};
```

在组件中使用`dva`的`model`,只显示主要代码

```javascript
class Login extends Base {
  login = async () => {
    const { dispatch, form } = this.props;
    form.validateFields(async (err, fieldsValues) => {
      let { phone, password } = fieldsValues;
      if (err) {
        return handleError(err, fieldsValues);
      } else {
        await dispatch({
          type: "login/fetch",
          payload: {
            user_no: phone,
            user_pass: password
        });
      }
    });
  };

  render() {
    const {
      loading: { effects }
    } = this.props;
    return (
      <div>
        ...
        <WingBlank className={styles.logbox}>
          <Button
            type="primary"
            className={styles.login}
            onClick={() => {
              this.login();
            }}
          >
            登录
          </Button>
        </WingBlank>
        <ActivityIndicator
          toast
          text="登录中..."
          animating={effects["login/fetch"] || false}
        />{" "}
      </div>
    );
  }
}

export default connect(({ login, loading }) => ({
  login,
  loading
}))(createForm()(Login));
```

- 首先和`redux`一样我们需要`connect`组件注入你需要使用的`model`这里我们注入了`login`和`loading`
- 在`connect`注入了`login`模块后，点击登录时，会调用 `login/fetch`的异步操作（调用 loginModels 下面的 fetch 方法），如此完成一次完整的流程操作
- 这个组件中我们可以看到`dva-loading`的使用，用户在点击登录后会调用`login`中的`fetch`异步操作，在`dva-loading`中就会自动监听这个 effects 直到他完成，我们就可以直接判断`effects[loing/fetch]`来监听这个异步操作是否完成，十分的方便

### umi

对与`umi`来说，最大的优势就是采用了 `next.js` 的约定式路由，文件目录即路由， 省却了我们自己去配置路由了，对与之前我们的路由这样的

```javascript
const RouteConfig = [
  {
    path: "/",
    component: Index,
    exact: true
  },
  {
    path: "/home",
    component: Home,
    exact: true
  },
  {
    path: "/home/detail",
    component: NoticeDetail,
    exact: true
  },
  {
    path: "/home/card",
    component: CardListDetail,
    exact: true
  },
  {
    path: "/news",
    component: NewScheduleList,
    exact: true
  },
  {
    path: "/type/:type", //重点关注这，umi处理动态路由
    component: TypeList,
    exact: true
  }
];
```

而现在我们只需要在`page`文件夹下创建相应的文件就可以了

```bash
+ pages/
  + home/
    - index.js # Home.js
    + detail/
      - index.js # NoticeDetail.js
    + card/
      - index.js # CardListDetail.js
  + news/
     - index.js # NewScheduleList.js
  + type/
    - $type.js # TypeList.js 文件名加$标识是个动态路由
  - index.js # Index.js
```

其他具体的路由约定规则，可以参考[umi 官网](https://umijs.org/zh/guide/router.html#%E7%BA%A6%E5%AE%9A%E5%BC%8F%E8%B7%AF%E7%94%B1)

#### `webapck-chain`配置

umi 最大的优点我觉得就是加入了`webapck-chain`可以自己扩展`webpack`配置，配置的地方在根目录的`config.js`或者`.umirc.js`
具体的配置如下：

```javascript .umirc.js
// ref: https://umijs.org/config/
import path from "path";

export default {
  plugins: [
    // ref: https://umijs.org/plugin/umi-plugin-react.html
    [
      "umi-plugin-react",
      {
        antd: true,
        dva: {
          immer: true
        },
        title: "answers-mobile",
        dll: true,
        routes: {
          exclude: []
        },
        hardSource: true,
        fastClick: true,
        library: "react",
        dynamicImport: {
          loadingComponent: "./components/Loading.js",
          webpackChunkName: true
        }
      }
    ]
  ],
  theme: {},
  alias: {
    src: path.resolve(__dirname, "src")
  },
  //添加 webpack-bundle-analyzer 插件
  //更多的添加方式请查看 webpack-chain
  chainWebpack(config, { webpack }) {
    config.merge({
      plugin: {
        bundleAnalyzer: {
          plugin: require("webpack-bundle-analyzer").BundleAnalyzerPlugin,
          args: [{ analyzerPort: 9999 }]
        }
      }
    });
  }
};
```

### umi 和 dva 架构对比

dva 项目之前通常都是这种扁平的组织方式，

```bash
+ models
  - global.js
  - a1.js
  - a2.js
  - b.js
+ services
  - a.js
  - b.js
+ routes
  - PageA.js
  - PageB.js
```

用了 umi 后，可以按页面维度进行组织，

```bash
+ models/global.js
+ pages
  + a
    - index.js
    + models
      - a1.js
      - a2.js
    + services
      - a.js
  + b
    - index.js
    - model.js
    - service.js
```

好处是更加结构更加清晰了，减少耦合，一删全删，方便 copy 和共享。

> 参考链接

[dva 官网](https://dvajs.com/guide/)
[umi 配置](https://umijs.org/zh/config/#%E5%9F%BA%E6%9C%AC%E9%85%8D%E7%BD%AE)
[umi 和 dva 更配](https://github.com/sorrycc/blog/issues/66)
[webpack-chain](https://github.com/neutrinojs/webpack-chain)
