---
title: thinkjs项目结构简析
date: "2018-06-11 15:59"
categories: nodejs
tags:
  - thinkjs
  - nodejs
keywords:
  - thinkjs
comments: true
abbrlink: 42422
---

thinkjs 项目整合了 koa2.x,兼容了 koa 的所有功能, 同时封装了一些功能,MVC 的架构让开发变的更简单,条理

<!-- more -->

```bash
├── development.js                        # 开发环境启动配置文件
├── nginx.conf                            # NGINX 配置文件
├── package.json
├── pm2.json                              # pm2 配置文件
├── production.js                         # 生产环境启动文件
├── README.md
├── releasenotes.txt
├── runtime
│   └── config
│       └── development.json
├── src
│   ├── apidoc.json
│   ├── bootstrap
│   │   ├── master.js                     # master 进程
│   │   └── worker.js                     # worker 进程
│   ├── config                            # 所有的配置文件
│   │   ├── adapter.js                    # 引入的外部适配器 解决一种功能的多种实现
│   │   ├── config.js                     # 公共配置
│   │   ├── config.production.js          # 生产环境配置
│   │   ├── crontab.js                    # 定时执行的任务
│   │   ├── extend.js                     # 引入的外部扩展配置
│   │   ├── middleware.js                 # 引入的外部中间件
│   │   ├── router.js                     # 自定义路由配置
│   │   └── validator.js                  # 数据校验配置
│   ├── controller                        # 一个页面一个控制器
│   │   ├── common
│   │   │   ├── iotSms.js
│   │   │   └── service.js
│   │   ├── rest.js
│   │   ├── sms_record.js
│   │   ├── sys_area.js
│   │   ├── sys_dict.js
│   │   ├── sys_log.js
│   │   ├── sys_menu.js
│   │   ├── sys_office.js
│   │   ├── sys_role.js
│   │   ├── sys_system.js
│   │   ├── sys_user.js
│   ├── extend                            # 项目里（自定义）的扩展配置
│   │   ├── controller.js                 # 针对 controller 的扩展
│   │   ├── service.js                    # 扩展 service 类
│   │   └── think.js                      # 扩展 think 类
│   ├── logic                             # 控制器之前的数据校验
│   │   ├── common                        # 系统在调用 controller 之前 会先调用
│   │   │   └── service.js                # 同名的 logic 进行数据校验
│   │   ├── index.js
│   │   ├── sys_area.js                   # 和控制器的名字一样
│   │   ├── sys_dict.js
│   │   ├── sys_log.js
│   │   ├── sys_menu.js
│   │   ├── sys_office.js
│   │   ├── sys_role.js
│   │   ├── sys_system.js
│   │   └── sys_user.js
│   ├── middleware                        # 项目中自定义的中间件
│   │   ├── eliPagination.js
│   │   └── jwtAuthentication.js
│   ├── model                             # 数据库操作
│   │   ├── base.js
│   │   ├── index.js
│   │   ├── sms_record.js
│   │   ├── sys_application.js
│   │   ├── sys_area.js
│   │   ├── sys_dict.js
│   │   ├── sys_log.js
│   │   ├── sys_menu.js
│   │   ├── sys_office.js
│   │   ├── sys_role.js
│   │   ├── sys_role_menu.js
│   │   ├── sys_role_office.js
│   │   ├── sys_system.js
│   │   ├── sys_user.js
│   │   └── sys_user_role.js
│   ├── proto
│   │   ├── common.js
│   │   ├── common.proto
│   │   ├── helloworld.js
│   │   ├── helloworld.proto
│   │   ├── jwtAuthorizing.js
│   │   ├── jwtAuthorizing.proto
│   │   ├── sms.js
│   │   ├── sms.proto
│   │   ├── sys_log.js
│   │   ├── sys_log.proto
│   │   ├── sys_system.js
│   │   ├── sys_system.proto
│   │   ├── sys_user.js
│   │   └── sys_user.proto
│   └── service                           # 逻辑操作
│       ├── base.js                       # 调用 model 结果
│       ├── common                        # 返回给 controller
│       │   ├── dataAuth.js
│       │   ├── iotChinaMobileService.js
│       │   ├── iotSmsService.js
│       │   ├── jwtAuthorizingService.js
│       │   ├── jwtService.js
│       │   └── smsService.js
│       ├── rpc_service
│       │   ├── rpcclient.js
│       │   └── rpcserver.js
│       ├── sms_record.js
│       ├── sys_application.js
│       ├── sys_area.js
│       ├── sys_dict.js
│       ├── sys_log.js
│       ├── sys_menu.js
│       ├── sys_office.js
│       ├── sys_role.js
│       ├── sys_system.js
│       ├── sys_user.js
│       └── sys_user_role.js
├── view
│   └── index_index.html
└── www
    └── static
        ├── css
        ├── img
        └── js
```

**thinkjs 将框架需要的配置和项目自定义的配置统一管理放在了 `src/config` 目录下**

- `config.js` 通用的一些配置

- `adapter.js` 适配器的配置

- `router.js` 自定义路由配置

- `middleware.js` 中间件配置

- `validator.js` 数据校验配置,配合 logic

- `extend.js` extends 配置

**系统启动时会合并 config.js 和 adapter.js**

### config.js

通用的配置文件,也可以根据运行环境创建对应的配置文件 `config.development.js`
系统默认配置:

```javascript src/config.js
module.exports = {
  port: 8360, // server port
  // host: '127.0.0.1', // server host, removed from 3.1.0
  workers: 0, // server workers num, if value is 0 then get cpus num
  createServer: undefined, // create server function
  startServerTimeout: 3000, // before start server time
  reloadSignal: "SIGUSR2", // reload process signal
  stickyCluster: false, // sticky cluster, add from 3.1.0
  onUnhandledRejection: err => think.logger.error(err), // unhandledRejection handle
  onUncaughtException: err => think.logger.error(err), // uncaughtException handle
  processKillTimeout: 10 * 1000, // process kill timeout, default is 10s
  jsonpCallbackField: "callback", // jsonp callback field
  jsonContentType: "application/json", // json content type
  errnoField: "errno", // errno field
  errmsgField: "errmsg", // errmsg field
  defaultErrno: 1000, // default errno
  validateDefaultErrno: 1001 // validate default errno
};
```

### Adapter

`Adapter` 是用来解决一类功能的多种实现，这些实现提供一套相同的接口，类似设计模式里的工厂模式。如：支持多种数据库，支持多种模版引擎等。通过这种方式，可以很方便的在不同的类型中进行切换。`Adapter` 一般配合 `Extend` 一起使用。
`Adapter` 都是一类功能的不同实现，一般是不能独立使用的，而是配合对应的扩展(extend)一起使用。如：view Adapter（`think-view-nunjucks`、`think-view-ejs`）配合 `think-view`扩展进行使用。`Adapter` 也支持不同环境的配置文件 `Adapter.development.js`

配置格式:

```javascript src/config/adapter.js
const nunjucks = require('think-view-nunjucks');
const ejs = require('think-view-ejs');
const path = require('path');

exports.view = {
  type: 'nunjucks', // 默认的模板引擎为 nunjucks
  common: { //通用配置
    viewPath: path.join(think.ROOT_PATH, 'view'),
    sep: '_',
    extname: '.html'
  nunjucks: { // nunjucks 的具体配置
    handle: nunjucks
  },
  ejs: { // ejs 的具体配置
    handle: ejs,
    viewPath: path.join(think.ROOT_PATH, 'view/ejs/'),
  }
}
```

- `type` 默认使用的类型,具体调用时可以传递参数改写`display/render方法都可以`
- `common` 配置通用的一些参数，项目启动时会跟具体的 adapter 参数作合并
- `nunjucks ejs` 配置特定类型的 Adapter 参数最终获取到的参数是 common 参数与该参数进行合并
- `handle` 对应类型的处理函数，一般为一个类

**因为最后 `conifg.js`会和 `adapter.js`合并,所以俩个文件的`key`不能重复**

### extend

项目扩展配置,配置文件放在 `src/config/extend.js`

配置格式:

```javascript src/config/extends.js
const view = require("think-view");
const model = require("think-model");
const cache = require("think-cache");
const session = require("think-session");
const email = require("think-email");
const fetch = require("think-fetch");

module.exports = [
  view, // make application support view
  model(think.app),
  cache,
  session,
  email,
  fetch // HTTP request client.
];
```

如果在项目中需要对`think`等对象进行扩展可以放在`src/extend/`目录下

- `src/extend/think.js`扩展 think 对象 `think.xxx`
- `src/extend/application.js`扩展 Koa 里的 app 对象( `think.app`)
- `src/extend/controller.js`扩展 controller 类 ( `think.Controller`)
- `src/extend/request.js`扩展 koa 里的 request 对象 ( `think.app.request`)
- `src/extend/response.js`扩展 koa 里的 response 对象 ( `think.app.response`)
- `src/extend/context.js`扩展 ctx 对象 ( `think.app.context`)
- `src/extend/logic.js`扩展 logic 类 ( `think.Logic`) logic 继承 controller 类,所以 logic 包含 controller 类所有方法
- `src/extend/services.js`扩展 servic 类 ( `think.Services`)

### Middleware

- 中间件的执行顺序是按照 `src/config/middleware.js` 里配置的顺序来执行的

```javascript middleware.js
const isDev = (think.env = "develpoment");
module.exports = [
  {
    handle: "meta", //中间件的处理函数
    options: {
      // 当前中间件需要的配置
      logRequest: isDev
    }
  },
  {
    handle: "resource",
    enable: isDev, //是否开启当前中间件
    options: {
      root: path.join(think.ROOT_PATH, "www"),
      publicPath: /^\/(static|favicon)\.ico/
    }
  }
];
```

- 也可以自定义中间件,放在`src/middleware/`文件下

```javascript jwt.js
module.exports = (options, app) => {
    //这里的 app 为 think.app 对象
    reutrn (ctx,next) => {
    //do something
    }
}
```

- 然后将自定义的中间件引入`src/config/middleware.js`中,注意放置顺序

```javascript middleware.js
const jwt = require("../middleware/jwt.js");

module.exports = [
  {
    handle: "meta", //中间件的处理函数
    options: {
      // 当前中间件需要的配置
      logRequest: isDev
    }
  },
  {
    handle: "resource",
    enable: isDev, //是否开启当前中间件
    options: {
      root: path.join(think.ROOT_PATH, "www"),
      publicPath: /^\/(static|favicon)\.ico/
    }
  },
  {
    handle: "jwt",
    options: {}
  }
];
```

- 一个示例的 middleware.js

```javascript middleware.js
const path = require("path");
const isDev = think.env === "development";
const jwtAuthentication = require("../middleware/jwtAuthentication.js");
const koa_cors = require("koa2-cors");

module.exports = [
  {
    handle: "meta",
    options: {
      logRequest: isDev,
      sendResponseTime: isDev
    }
  },
  {
    handle: koa_cors,
    options: {
      origin: "*",
      exposeHeaders: ["Content-Disposition"]
    }
  },
  {
    handle: "resource",
    enable: isDev,
    options: {
      root: path.join(think.ROOT_PATH, "www"),
      publicPath: /^\/(static|favicon\.ico)/
    }
  },
  {
    handle: "trace",
    enable: !think.isCli,
    options: {
      debug: isDev,
      error: (err, ctx) => {
        //错误处理
        return think.logger.error(err);
      },
      debug: isDev,
      contentType(ctx) {
        return "json";
      }
    }
  },
  {
    handle: "payload",
    options: {}
  },
  {
    handle: "router",
    options: {}
  },
  {
    handle: "jwtAuthentication",
    options: think.config("authOption")
  },
  "logic",
  "controller"
];
```

总结:

- middleware.js 中间件按照从上到下的顺序执行的
- 一些 think 框架内置的中间就可以直接使用不需要引入,例如:
  - `meta:` 显示一些信息,如:发送 ThinkJs 版本号,接口的处理时间
  - `resource:` 处理静态资源,生产环境建议关闭
  - `payload:` 处理表单提交的数据
  - `router:` 路由解析
  - `logic:` logic 调用,数据校验
  - `controller:` controller 和 action 调用

### Logic

当在 `Action` 里处理用户的请求时，经常要先获取用户提交过来的数据，然后对其校验，如果校验没问题后才能进行后续的操作；当参数校验完成后，有时候还要进行权限判断等，这些都判断无误后才能进行真正的逻辑处理。如果将这些代码都放在一个 `Action` 里，势必让 Action 的代码非常复杂且冗长。
为了解决这个问题， ThinkJS 在控制器前面增加了一层 `Logic`，Logic 文件名和 Controller 文件名要相同,Logic 里的 Action 和控制器里的 Action 一一对应，系统在调用控制器里的 Action 之前会自动调用 Logic 里的 Action。

Logic 对应的配置文件是 `src/config/validator.js`文件

一个完整的 logic 校验格式文件:

```javascript src/logic/sys_test.js
/**
 * sys_test logic
 * create by tiankai[lenovo]  2018-06-05 15:07
 * @type {module.exports}
 */
module.exports = class extends think.Logic {
  /**
   * 新增验证
   * create by tiankai[lenovo]  2018-06-05 15:07
   */
  insertAction() {
    this.allowMethods = "POST"; //  只允许 POST 请求类型
    this.rules = {
      // aliasName 起别名,显示 用户名不能为空
      uname: { string: true, required: true, trim: true, aliasName: "用户名" },
      password: { string: true, required: true, trim: true },
      type: { required: true, in: ["1", "2"], trim: true },
      mobile: { mobile: "zh-CN", trim: true, required: true }
    };
  }

  /**
   * 编辑验证
   * create by tiankai[lenovo]  2018-06-05 15:07
   */
  editAction() {
    this.allowMethods = "put";
    this.rules = {
      id: { uuid: true, required: true, trim: true },
      uname: { string: true, required: true, trim: true, aliasName: "用户名" },
      password: { string: true, required: true, trim: true },
      mobile: { mobile: "zh-CN", required: true, trim: true },
      type: { required: true, in: ["1", "2"], trim: true }
    };
  }

  /**
   * 删除验证
   * create by tiankai[lenovo]  2018-06-05 15:07
   */
  removeAction() {
    this.allowMethods = "delete";
    this.rules = {
      id: { uuid: true, required: true, trim: true, method: "GET" }
    };
  }

  /**
   * 获取单条验证
   * create by tiankai[lenovo]  2018-06-05 15:07
   */
  getAction() {
    this.allowMethods = "GET";
    this.rules = {
      id: { uuid: true, required: true, trim: true }
    };
  }

  /**
   * 获取多条验证
   * create by tiankai[lenovo]  2018-06-05 15:07
   */
  getsAction() {
    this.allowMethods = "GET";
    this.rules = {
      //parent_id: {trim: true, uuid: true,},
      //name: {string: true, required: true, trim: true},
      //type: {int: {min: 0, max: 1}, trim: true, required: true,},
      remarks: { string: true, trim: true }
    };
  }
};
```

如代码所示,`logic`应该和 `controller`相对应,不仅文件名对应,相对应的 Action 也该对应

### 自定义的校验规则

代码中有框架默认的校验规则,也有自己定义的校验规则
自己定义的校验规则放到`src/config/validator.js`文件中

```javascript src/config/validator.js
module.exports = {
  messages: {
    ACTION_NON_EXIST: [404, "action 函数不存在."],
    PARENT_DATA_NOT_EXIST: [10001, "父级数据不存在."],
    OPTIONS_REQUEST: [9999, "option 请求。"],
    SUCCESS: [10000, "操作成功。"],
    SERVER_INVALID: [10100, "服务器错误，请重新尝试。"],
    TOKEN_INVALID: [10200, "请核对您的登录信息后重新登录。"],
    NEED_LOGIN: [10201, "您没有权限，请重新登录"],
    TOKEN_EXPIRED: [10202, "TOKEN 过期，请重新登录"],
    NEED_AUTHOR: [10203, "访问资源未授权"],
    DATA_NULL: [10004, "查询不到相关数据"],
    DATA_REPEAT: [10006, "数据重复，请核对数据。"],
    USER_NULL: [10300, "用户不存在"],
    LOGIN_NAME_EXIST: [10301, "登录名已存在."],
    PASSWORD_REPEAT: [10302, "密码与原始密码相同"],
    PASSWORD_ERROR: [10303, "密码错误，请重新登录。"],
    ROLE_NAME_REPEAT: [10330, "角色名称已存在"],
    CAN_NOT_DEL_SELF_ROLE: [10331, "不能删除自己所拥有的角色"],
    CAN_NOT_DEL_ONLY_ROLE: [10332, "该用户的唯一角色，不能移除"],
    NOT_FOUND_ROLE: [10333, "当前用户无角色"],
    NOT_FOUND_PARENT_MENU: [10320, "父菜单不存在"],
    NOT_FOUND_PARENT_OFFICE: [10340, "父机构不存在"],
    LABEL_NAMES_EXIST: [10311, "字典名称已存在"],
    TAG_NAME_EXIST: [10312, "Tag 名称已存在"],
    OFFICE_NAME_EXIST: [10313, "组织机构名称已存在"],
    ADMIN_NOT_ALLOW_DELETE: [10314, "不允许删除管理员"],
    ADMIN_NOT_ALLOW_CHANGEPWD: [10315, "非管理员账户不允许初始化管理员密码"],
    ADMIN_NOT_ALLOW_CHANGEINFO: [10316, "非管理员账户不允许修改管理员资料"],
    NOT_ADMIN_ALLOW_DEL_ADMIN_INFO: [10317, "非管理员账户不允许删除管理员角色"],
    NOT_ADMIN_ALLOW_CHANGE_ADMIN_INFO: [
      10318,
      "非管理员账户不允许修改管理员角色"
    ],
    AREA_DATA_NULL: [10319, "所选区域数据不存在"],
    USER_NOT_EXIST_OR_HASE_PWD: [10320, "用户不存在或已设置密码"],
    SET_PWD_FAIL: [10321, "设置密码失败"],
    CAN_NOT_DELETE_THIS_ROLE: [10322, "已存在该角色的用户，不能删除"],
    CAN_NOT_DELETE_THIS_OFFICE: [10323, "已存在该组织机构的用户，不能删除"],
    NOT_ALLOW_DEL_OWNER_INFO: [10324, "不允许删除自己的信息"],
    "searchObj is not object": [10325, "查询失败，缺少 searchObj 参数"],
    FILE_NOT_EXIST: [10401, "附件不存在或上传失败"],
    MOBILE_EXIST: [10407, "手机号已存在"],
    METHED_ERROR: [403, "methed 错误。"],

    SEND_SMSCODE_BUSY: [10501, "发送验证码操作太频繁，请稍后再试"],
    SMSCODE_EXP: [10502, "验证码已过期，请重新获取验证码"],
    SMSCODE_ERR: [10503, "验证码错误"],
    DAYSENDTOTLE: [10504, "验证码发送量已超过单日最大量"],
    SINGLEPHONESENDTOTLE: [10505, "当前号码发送验证码数量已超出系统限制"],
    SINGLEIPSENDTOTLE: [10506, "当前ip地址发送验证码数量已超出系统限制"],
    // 重写系统错误消息的返回
    required: "{name} 不能为空",
    contains: "{name} 必须包含 {args}",
    mobile: "手机号码格式错误",
    equals: "{name} 的值应该和 {args} 相等",
    different: "{name} 的值应该和 {args} 不相等",
    before: "{name} 应该在 {args} 之前",
    after: "{name} 应该在 {args} 之后",
    alpha: "{name} 的值只能是 [a-zA-Z] 组成",
    alphaDashr: "{name} 的值只能是 [a-zA-Z] 组成",
    alphaNumeric: "{name} 的值只能是 [a-zA-Z0-9] 组成",
    alphaNumericDash: "{name} 的值只能是 [a-zA-Z0-9] 组成",
    ascli: "{name} 的值只能由 ASCII 组成",
    base64: "{name} 的值必须是 base64 编码",
    byteLength: "{name} 的字节长度错误",
    creditcard: "{name} 需要是信用卡数字",
    currency: "{name} 应该是货币格式",
    date: "{name} 应该是日期格式",
    decimal: "{name} 应该是小数格式",
    divisibleBy: "{name} 需要被 {args} 整除",
    email: "{name} 需要是个 email 格式",
    fqdn: "{name} 需要是个合格的域名",
    float: "{name} 浮点数格式错误 {args}",
    fullWidth: "{name} 应该包含宽字节字符",
    halfWidth: "{name} 应该包含半字节字符",
    hexColor: "{name} 需要是个十六进制颜色值",
    hex: "{name} 需要是十六进制",
    ip: "{name} 需要是 ip 格式",
    ip4: "{name} 需要是 ip4 格式",
    ip6: "{name} 需要是 ip6 格式",
    isbn: "{name} 需要是图书编码",
    isin: "{name} 需要是证券识别编码",
    iso8601: "{name} 需要是 iso8601 日期格式",
    in: "{name} 应该在这些值中：{args}",
    noin: "{name} 不应该在这些值中：{args}",
    int: "{name} 整数格式错误：{args}",
    min: "{name} 不能小于 {args}",
    max: "{name} 不能大于 {args}",
    length: "{name} 字符长度错误：{args}",
    minLength: "{name} 长度不能小于 {args}",
    maxLength: "{name} 长度不能大于 {args}",
    lowercase: "{name} 需要都是小写字母",
    uppercase: "{name} 需要都是大写字母",
    mongoId: "{name} 应该是 MongoDB 的 ObjectID",
    multibyte: "{name} 应该包含多字节字符",
    url: "{name} 应该是个 url",
    order: "{name} 数据库查询 order 格式错误",
    field: "{name} 数据库查询 field 格式错误",
    image: "{name} 上传的文件应该是个图片",
    startWith: "{name} 应该以 {args} 打头",
    endWith: "{name} 应该以 {args} 结尾",
    string: "{name} 值为字符串",
    array: "{name} 值为数组",
    boolean: "{name} 值为布尔类型",
    object: "{name} 值为对象"
  }
};
```

配置好后,可以在代码中 使用 来返回错误消息

```javascript
return this.fail("MOBILE_EXIST"); //手机号已存在
```

具体其他的校验规则可以查看 [Thinkjs 的官网](https://thinkjs.org/zh-cn/doc/3.0/logic.html)

### Controller

控制器是处理用户请求逻辑的部分,比如将用户相关的操作都放在 `user.js` 中 ,每一个用户操作就是一个 Action,请求用户首页就是 indexAction 项目中的 controller 继承 `think.Controller`类,也可以创建一个基类,然后其他 controller 继承该类

```javascript src/controller/user.js
const Base = require("./base.js");
module.exports = class extends Base {
  indexAction() {
    this.body = "hello world!";
  }
};
```

创建完成后,框架会监听文件变化然后重启服务.这时访问 `http:/.127.0.0.1:8360/user/index`就可以看到输出的 `hello world`

#### Action 的执行

Action 的执行是通过 `think.controller`来完成的,执行顺序为:

- 实例化 `Controller`类,传入 `ctx`对象
- 如果方法 `__before`存在则调用,如果返回 `false`,则停止继续执行
- 如果方法 `xxxAction`存在则执行,如果返回值为 `false` 则停止继续执行
- 如果方法 `xxxAction`不存在但 `__call`方法存在,则调用 `__call` 如果返回值为 `false`则停止继续执行
- 如果方法`__after`存在则执行

下面是一个完整的 controller 示例, 列举了一般开发中所需要的功能

```javascript src/controller/user.js
// 控制器是一类操作的集合, 用来响应用户同一类的请求
const BaseRest = require("./rest.js");

export default class extends BaseRest {
  //Controller 实例化时会传入 ctx 对象，
  //在 Controller 里可以通过 this.ctx 来获取 ctx 对象
  constructor(ctx) {
    super(ctx); // 调用父级的 constructor 方法，并把 ctx 传递进去
    // 其他额外操作 可以重写 controller 方法
  }
  // 前置操作: 在 action 调用之前自动调用
  // 推荐放在一个 base controller 类中, 其他 controller 继承 base controller
  async __before() {
    // 判断是否已经登录，如果没有登录就不能继续后面行为。
    //此种情况下，可以通过内置的 __before 来实现
    const userInfo = await this.session("userInfo");
    //获取用户的 session 信息，如果为空，返回 false 阻止后续的行为继续执行
    if (think.isEmpty(userInfo)) {
      return false;
    }
  }
  // 后置操作: 在 action 调用之后自动调用
  __after() {
    // 如果 action 里阻止了后续的代码继续执行(return false), 则后置操作不会调用
    console.log("controller __after");
  }
  // 空操作: 当解析后的 URL 对应的控制器存在, 但 action 不存在时调用
  // 一般不需要使用
  __call() {
    console.log("controller __call");
    return this.end("404");
  }
  // 不指定 action 时默认用 indexAction 来处理这个请求
  indexAction() {
    // 获取 URL
    // 获取请求参数
    console.log("GET param", this.get()); // 相当于  this.ctx.param
    // 当上传文件时, 包含 form 表单中除开 file 类型的其他字段的值
    console.log("POST param", this.post());
    console.log("GET param", this.param());
    // 上传的文件保存在临时目录(runtime/upload)中, 可以通过 path 属性看到
    // 使用时需要将其移动到项目里的目录, 否则请求结束时会被删除
    console.log("file", this.file());
    // 获取模型数据
    // 一般放到 Model 文件夹下操作
    // 项目开发中, 经常要操作数据库, 如: 增删改查等操作.
    // 模型就是为了方便操作数据库进行的封装, 一个模型对应数据库中的一个数据表.
    // 模型文件不是必须存在, 如果没有自定义方法可以不创建模型文件,
    // 实例化时会取模型基类的实例
    let model = this.model("city");
    // 操作模型
    model
      .where({ name: "Kabul" })
      .select()
      .then(function(rs) {
        console.log("model", model.name, model.schema, rs);
      });
    // 指定 SQL 语句执行查询
    this.model()
      .query("SELECT * FROM city WHERE name = '%s'", "Kabul")
      .then(function(rs) {
        console.log(rs);
      });
    // View 模板赋值
    this.assign({
      title: "我们一起来学习 ThinkJS",
      author: "Sun"
    });
    // 渲染模板
    return this.display();

    // 返回 JSON/JSONP
    // return this.json({a: 1});
    // return this.jsonp({a: 1});

    // 返回格式化的正常数据, 一般是操作成功后输出
    // return this.success({a: 1});
    // 返回格式化的异常数据, 一般是操作失败后输出
    // return this.fail(1000, 'error...', {e: 1});

    // 跳转页面
    // return this.redirect('https://thinkjs.org');
  }
  // 多模块的
  // http://127.0.0.1:8360/模块/控制器/操作
  // 单模块的
  // http://127.0.0.1:8360/user/insert?callback=abc
  // http://127.0.0.1:8360/控制器/操作
  async insertAction() {
    try {
      let now = think.datetime(new Date());
      let data = this.post(); //post数据json格式化
      // 项目中处理 data 数据的函数,不用理会
      let result = this.convertToEntity(data);
      result.id = think.uuid(); // undefined的数据添加
      result.create_date = now;
      // serviceinstance 是 service 文件夹下同名的文件
      // 调用对应的 model 操作数据库
      // 把结果返回给 controller
      //调用service对应的insert方法
      let id = await this.serviceInstance.insert(result).catch(function(error) {
        throw error;
      });
      // 生成日志记录插入数据库
      this.dbLogInfo("sys_test管理", `【成功】新增单条sys_test:${result.id}`);
      return this.success(result.id);
    } catch (error) {
      return this.fail(error.message);
    }
  }
}
```

### View

thinkjs 框架并没有内置 view/视图功能,如果需要在 `src/config/extend.js`,添加如下的配置:

```javascript src/config/extend.js
const view = require("think-view");
module.exports = [view];
```

添加视图扩展,让项目有渲染模板文件的能力,视图扩展是通过模块 `think-view`实现的. 配置好 extend 后还需要配置 adapter ,在 `src/config/adapter.js`中添加如下的配置:

```javascript src/config/adapter.js
const nunjucks = require("think-view-nunjucks");
const path = require("path");

// 视图的 adapter 名称为 view
exports.view = {
  type: "nunjucks", // 这里指定默认的模板引擎是 nunjucks
  common: {
    viewPath: path.join(think.ROOT * PATH, "view"), //模板文件的根目录
    sep: "*", //Controller 与 Action 之间的连接符
    extname: ".html" //模板文件扩展名
  },
  nunjucks: {
    handle: nunjucks,
    beforeRender: () => {}, // 模板渲染预处理
    options: {
      // 模板引擎额外的配置参数
    }
  }
};
```

这里用的模板引擎是 nunjucks，项目中可以根据需要修改。

#### 使用

配置好 Extend 和 Adapter 后就可以在 Controller 中使用了.如:

```javascript
moduel.exports = class extends think.Controller {
  indexAction() {
    this.assign("title", "thinkjs"); //给模板赋值
    return this.display(); // 渲染模板
  }
};
```

#### 其他方法

**assign: **给模板赋值

```javascript
//单条赋值
this.assign("title", "thinkjs");

//多条赋值
this.assign({
  title: "thinkjs",
  name: "test"
});

//获取之前赋过的值，如果不存在则为 undefined
const title = this.assign("title");

//获取所有赋的值
const assignData = this.assign();
```

**display && render: **渲染模板/切换模板类型
`render:` 获取渲染后的内容,该方法为异步方法,需要通过 async/await 处理
`display:` 调用的是 `render`方法获取 模板内容后 再把内容加到 `ctx.body`内容上
项目中如果使用 display 话,前面要记得加上 `await`或者是 `return`

```javascript render.js
//render
//根据当前请求解析的 controller 和 action 自动匹配模板文件
const content1 = await this.render();

//指定文件名
const content2 = await this.render("doc");
const content3 = await this.render("doc/detail");
const content4 = await this.render("doc_detail");

//不指定文件名但切换模板类型
const content5 = await this.render(undefined, "ejs");

//指定文件名且切换模板类型
const content6 = await this.render("doc", "ejs");

//切换模板类型，并配置额外的参数
//切换模板类型时，需要在 adapter 配置里配置对应的类型
const content7 = await this.render("doc", {
  type: "ejs",
  xxx: "yyy"
});
```

```javascript display.js
//根据当前请求解析的 controller 和 action 自动匹配模板文件
await this.display();

//指定文件名
await this.display("doc");
await this.display("doc/detail");
await this.display("doc_detail");

//不指定文件名切换模板类型
await this.display(undefined, "ejs");

//指定文件名且切换模板类型
await this.display("doc", "ejs");

//切换模板类型，并配置额外的参数
await this.display("doc", {
  type: "ejs",
  xxx: "yyy"
});
```

#### 默认注入的参数

框架在渲染模板的时候,自动注入了 `controller`/`config`/`ctx`变量,可以直接在模板里调用方法,获取配置
`controller`
当前控制器实例,在模板里可以直接调用控制器上的属性和方法.

```html
{{ if controller.type === 'xxx'}}

<p>当前 type 为 xxx</p>

{{ endif }}
```

`config`
所有的配置，在模板里可以直接通过 `config.xxx`来获取配置，如果属性不存在，那么值为 `undefined`。
`ctx`
当前请求的 Context 对象，在模板里可以直接通过 `ctx.xxx`调用其属性或者 `ctx.yyy()`调用其方法。
如果是调用其方法，那么方法必须为一个 `同步方法`。

### Route

在 ThinkJS 中，当用户访问一个 URL 时，最后是通过 `controller`里具体的 `action`来响应的。所以就需要解析出 URL 对应的`controller` 和`action`，这个解析工作是通过 `think-router`模块实现的。

#### think-router 配置

think-router 是一个 middleware，项目创建时默认已经加到配置文件 `src/config/middleware.js`里了，其中 options 支持如下的参数：

```javascript
module.exports = [
  {
    handle: "router",
    options: {
      //多模块项目下，默认的模块名。默认值为 home
      defaultModule: "home",
      //默认的控制器名，默认值为 index
      defaultController: "index",
      //默认的操作名，默认值为 index
      defaultAction: "index",
      //默认去除的 pathname 前缀，默认值为 []
      prefix: [],
      //默认去除的 pathname 后缀，默认值为
      suffix: [".html"],
      //在不匹配情况下是否使用默认路由解析，默认值为 true
      enableDefaultRouter: true,
      //子域名映射下的偏移量，默认值为 2
      subdomainOffset: 2,
      //子域名映射列表，默认为 {}
      subdomain: {},
      //多模块项目下，禁止访问的模块列表，默认为 []
      denyModules: []
    }
  }
];
```

#### 路由对路径的处理

当用户访问一个 URL 时,最终执行那个模块下那个控制器的那个操作,这是由路由解析后来决定的.具体的流程为:

1. 首先路由会将 URL 解析为 pathname
   例如: `http://127.0.0.1:8360/test/index.html`, 将 URL 进行解析(去除 host 信息)得到的 pathname 为 `/test/index.html`
2. 然后会对 pathname 过滤
   因为有时候为了搜索引擎优化或者一些其他的原因, URL 上会多加一些东西. 比如: 当前页面是一个动态页面, 但 URL 最后加了 `.html`, 这样对搜索引擎更加友好. 但这些在后续的路由解析中是无用的, 需要去除.
   默认会去除配置的 pathname 前缀和后缀内容, 以及自动去除左右的 `/`

```javascript
pathname_prefix: "",
pathname_suffix: ".html"
```

因此经过路由处理后, 会拿到干净的 pathname, 我们就可以根据这个 pathname 来判断执行哪个模块下哪个控制器的哪个操作了.

例如:

- `http://127.0.0.1:8360/test/index.html` URL
- `/test/index.html` 解析
- `test/index` 过滤
- 路由识别默认根据 `模块/控制器/操作/参数1/参数1值/参数2/参数2值` 来识别过滤后的 pathname
- 当解析 pathname 没有对应的值时, 便使用对应的默认值
  - 其中`模块`默认值为 `home`, `controller` 默认值为 `index`, `action` 默认值为 `index`
  - 大小写转换
  - 路由识别后, module、controller 和 action 值都会自动转为小写, 如果 action 值里有 `_`, 会作一些转化, 如: 假设识别后的 controller 值为 `index`, action 值为 `user_add`, 那么对应的 action 方法名为 `userAddAction`, 但模版名还是 `index_user_add.html`
- 这里要分项目是单模块还是多模块的
  - 如果是单模块项目的话,上面的 URL 会调用 `home` 模块(module)的 `test` 控制器(controller)的 `index` 操作(action)
    - 即: `src/controller/index.js#indexAction`
  - 如果是多模块项目的话,上面的 URL 会调用 `test` 模块(module)的 `index` 控制器(controller)的 `index` 操作(action)
    - 即: `src/test/controller/index.js#indexAction`
- 默认的视图文件路径为 `view/[module]/[controller]_[action].html` 即 `模块/控制器_操作.html`
- 因此 `display()` 时对应的视图为: `view/home/index_index.html`或者是`view/test/index_index.html`

### Service

项目中，有时候除了查询数据库等操作外，也需要调用远程的一些接口，如：调用 GitHub 的接口、调用发送短信的接口等等。

这种功能放在 Model 下是不太合适的，为此，框架提供了 Service 来解决此类问题。

Service 文件存放在 `src/service/`（多模块在 `src/common/service/`）目录下，文件内容格式如下：

```javascript src/service/test.js
module.exports = class extends think.Service {
  constructor() {}
  xxx() {}
};
```

Service 都继承 think.Service 基类，但该基类不提供任何方法，可以通过 Extend 进行扩展。

可以在项目根目录下通过`thinkjs service xxx`命令创建 service 文件，支持多级目录。
项目启动时,会扫描项目下所有的 services 文件,并存放到 `think.app.services`对象下,实例化 Services 类时,会从该对象上查找对应的文件,可以通过`think.service` `ctx.service` `controller.service` 获取到 Services 的实例,然后使用该实例上定义的方法,具体的获得方法类似于下面 Model 实例的获取.

#### 无参数类的实例化

```javascript src/service/sms.js
module.exports = class extends think.Service {
  xxx() {}
};

// 实例化，没有任何参数
const sms = think.service("sms");
sms.xxx();
// 多模块项目的实例化
// const sms = think.service('sms', 'home');
```

#### 有参数类的实例化

```javascript src/service/sms.js
module.exports = class extends think.Service {
  constructor(key, secret) {
    super();
    this.key = key;
    this.secret = secret;
  }
  xxx() {}
};

// 带参数的实例化
const sms = think.service("sms", key, secret);
sms.xxx();
// 多模块项目的实例化
// 指定从 home 下查找 sms 的 service 类
// const sms = think.service('sms', 'home', key, secret)
```

#### 扩展 Services 类

`think.service`基类没有提供任何方法,如果需要可以在`src/extend/service.js`中定义,然后就可以在项目中直接使用这个方法

```javascript src/extend/service.js
module.exports = {
  getDataFromApi() {}
};
```

```javascript src/service/sms.js
module.exports = class extends think.Service {
  async xxx() {
    // 这个访问 extend/service.js 扩展的方法
    const data = await this.getDatafromApi();
  }
};
```

service 类中,调用 model 数据库操作,或者调用其他接口,然后把得到的数据再返回给 Controller,起到一个承上启下的作用

### Model

thinkjs 默认没有提供模型的功能,需要添加相应的扩展来支持,对应的扩展为 `think-model`.修改的配置文件`src/config/extend.js` 和 `src/config/adapter.js`

```javascript src/config/extend.js
const model = require("think-model");

module.exports = [
  model(think.app) // 让框架支持模型的功能
];
```

添加模型的扩展后,会添加 `think.Model`/`think.model`/`ctx.model`/`controller.model`/`service.model`可以在文件中通过对应的方法获得 model 的实例.

```javascript src/config/adapter.js
const mysql = require('think-model-mysql');

exports.model = {
    type: 'mysql', // 默认使用的类型，调用时可以指定参数切换
    common: { // 通用配置
        logConnect: true, // 是否打印数据库连接信息
        logSql: true, // 是否打印 SQL 语句
        logger: msg => think.logger.info(msg) // 打印信息的 logger
    },
    mysql: { // mysql 配置
        handle: mysql
        user: 'root', // 用户名
        password: '', // 密码
        database: '', // 数据库
        host: '127.0.0.1', // host
        port: 3306, // 端口
        connectionLimit: 1, // 连接池的连接个数，默认为 1
        // 数据表前缀，
        //如果一个数据库里有多个项目，那项目之间的数据表可以通过前缀来区分
        prefix: '',
    },
    mysql2: { // 另一个 mysql 的配置
        handle: mysql
    },
    sqlite: { // sqlite 配置

    },
    postgresql: { // postgresql 配置

    }
}
```

项目中如果需要切换 Model 的类型,可以在调用 model 时通过不同的 type 区分

```javascript
// 使用默认的数据库配置，默认的 type 为 mysql，那么就是使用 mysql 的配置
const user1 = think.model("user");
// 使用 mysql2 的配置
const user2 = think.model("user", "mysql2");
// 使用 sqlite 的配置
const user3 = think.model("user", "sqlite");
// 使用 postgresql 的配置
const user4 = think.model("user", "postgresql");
```

thinkjs 框架有个方便的地方就是 你可以在项目的任何地方获得 Model 的实例,然后使用该实例上定义的方法,这一点和 Service 一样

#### 实例化模型

```javascript
think.model("user"); // 获取模型的实例
think.model("user", "sqlite"); // 获取模型的实例，修改数据库的类型
think.model("user", {
  // 获取模型的实例，修改类型并添加其他的参数
  type: "sqlite",
  aaa: "bbb"
});
// 获取模型的实例，指定为 admin 模块（多模块项目下有效）
think.model("user", {}, "admin");
```

#### ctx.model

实例化模型类，获取配置后调用 think.model 方法，多模块项目下会获取当前模块下的配置.

```javascript
cosnt user = ctx.model('user');
```

#### controller.model

实例化模型类，获取配置后调用 think.model 方法，多模块项目下会获取当前模块下的配置.

```javascript
module.exports = class extends think.Controller {
  async indexAction() {
    const user = this.model("user"); // controller 里实例化模型
    const data = await user.select();
    return this.success(data);
  }
};
```

#### Service.model

实例化模型类,等同于`think.model`

thinkjs 对数据库的增删改查的操作封装具体请查看 think.js 的官网

### Cookie && Session

#### Cookie

thinkjs 中对 cookie 的配置代码在`src/config/config.js`中修改,支持如下的配置:

- `maxAge:` cookie 的超时时间，表示当前时间（Date.now()）之后的毫秒数。
- `expires:` Date 对象，表示 cookie 的到期时间（不指定的话，默认是在会话结束时过期）。
- `path:` 字符串，表示 cookie 的路径（默认是/）。
- `domain:` 字符串，表示 cookie 的域（没有默认值）。
- `secure:` 布尔值，表示是否只通过 HTTPS 发送该 cookie（false 时默认通过 HTTP 发送，true 时默认通过 HTTPS 发送）。
- `httpOnly:` 布尔值，表示是否只通过 HTTP(S)发送该 cookie，而不能被客户端的 JavaScript 访问到（默认是 true）。
- `sameSite:` 布尔值或字符串，表示是否该 cookie 是一个“同源” cookie（默认是 false）。可以将其设置为`'strict'`，`'lax'`，或`true` （等价于 strict）。
- `overwrite:` 布尔值，表示是否覆盖以前设置的同名 cookie（默认为 false）。如果设为 true，在同一个请求中设置的相同名称（不管路径或域）的所有 cookie 将在设置此 cookie 时从 Set-Cookie 头中过滤掉
- `signed:` 布尔值，表示是否要将该 cookie 签名（默认是 false）。如果设为 true，还会发送另一个带有.sig 后缀的同名 cookie，值为一个 27 字节的 url-safe base64 SHA1 值，表示*cookie-name * = * cookie-value*的散列值，相对于第一个 Keygrip 键。 此签名密钥用于在下次接收到 cookie 时检测篡改。

一般配置:

```javascript src/config/config.js
module.exports = {
    cookie: {
        domain: '',//cookie 的域
        path: '/',//cookie 的路径
        maxAge: 10 _ 3600 _ 1000, // 10 个小时过期时间
    }
}
```

thinkjs 支持 cookie 的操作,具体代码如下:

```javascript
// 获取 cookie
const theme = this.cookie("theme");
// 设置 cookie
this.cookie("theme", "gray");
// 设定 cookie 时指定额外的配置
this.cookie("theme", "yellow", {
  maxAge: 10 * 1000,
  path: "/theme"
});
//删除 cookie
this.cookie("theme", null);
//如果设置的时候有 domain 和 path 的操作
//删除的时候同样也要清空,否则会因为不匹配导致操作失败
this.cookie("theme", null, {
  domain: "",
  path: ""
});
```

#### Session

框架通过`think-session`来扩展支持,需要配置的文件:

```javascript src/config/extend.js
const session = require("think-session");
module.exports = [session];
```

```javascript src/config/adapter.js
const fileSession = require("think-session-file");

exports.session = {
  type: "file",
  common: {
    cookie: {
      name: "thinkjs"
      // keys: ['werwer', 'werwer'],
      // signed: true
    }
  },
  file: {
    handle: fileSession,
    sessionPath: path.join(think.ROOT_PATH, "runtime/session")
  }
};
```

cookie 选项为 session 设置 cookie 时的配置项，会和 think.config('cookie') 值进行合并，name 字段值为 session 对应 cookie 的名字。

#### session 操作

```javascript
module.exports = class extends think.Controller {
  async indexAction() {
    //读取 session
    const data = await this.session("name");
    //设置 session
    const data = await this.session("name", "value");
    //删除整个 session
    const data = await this.session(null);
  }
};
```

> 参考链接

- [我的 thinkjs 之旅](https://github.com/f2e-journey/xueqianban/issues/47)
- [thinkjs 官网](https://thinkjs.org/zh-cn/doc/3.0/index.html)
