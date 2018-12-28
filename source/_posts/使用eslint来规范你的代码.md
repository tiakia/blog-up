---
title: 使用eslint来规范你的代码
date: 2018-10-30 22:30
categories: 工具
tags: 工具
keywords:
  - eslint
comments: true
---

使用自定义的`eslint`规则结合编辑器来规范你平时的代码编写风格，我这里配置了 `vscode` 和 `webstorm` 俩个编辑器的 在校验规则的同时，可以自动把你的代码格式化。如果你的电脑配置可以的话建议你使用`webstorm`，虽然`vscode`可以任意安装插件，但是论功能的完善还是`webstorm`更甚一筹

<!-- more -->

### 准备工作

全局安装

```bash
npm install -g eslint
npm install -g prettier
npm install -g eslint-plugin-prettier
```

react 相关

```bash
npm install -g babel-eslint
npm install -g eslint-plugin-react
npm install -g eslint-plugin-jsx-a11y
npm install -g eslint-plugin-import
```

### 编辑自己的`eslint`规则

```javascript .eslintrc.js
module.exports = {
  root: true,
  parserOptions: {
    // 检查 ES6 语法
    ecmaVersion: 6,
    sourceType: "module",
    ecmaFeatures: {
      experimentalObjectRestSpread: true,
      jsx: true
    }
  },
  parser: "babel-eslint",
  env: {
    browser: true,
    node: true,
    es6: true
  },
  // extending airbnb config and config derived from eslint-config-prettier
  // 这里是 vue
  //extends: ["plugin:vue/essential", "airbnb-base", "prettier"],

  // 选择 eslint 插件
  //plugins: ["prettier", "vue"],

  // react
  extends: ["prettier", "eslint:recommended", "plugin:react/recommended"],
  plugins: ["prettier", "react", "jsx-a11y"],

  // 不需要框架
  // extends: ['airbnb-base', 'prettier'],
  // plugins: ['prettier'],

  // 自定义 eslint 检查规则
  rules: {
    //箭头函数前后俩个空格
    "arrow-spacing": [
      2,
      {
        before: true,
        after: true
      }
    ],
    //大括号前后有空格
    "block-spacing": [2, "always"],
    //规定 else 关键字 要与花括号保持在同一行
    "brace-style": [
      2,
      "1tbs",
      {
        allowSingleLine: true
      }
    ],
    // react 如果在项目中文件名后缀是 .js 而不是 .jsx 避免报错
    "react/jsx-filename-extension": [
      1,
      {
        extensions: [".js", ".jsx"]
      }
    ],
    //react props validation 错误
    "react/prop-types": 0,
    "no-eval": 2,
    "no-console": 0,
    "comma-dangle": 1,
    //规定逗号后面必须加空格
    "comma-spacing": [
      2,
      {
        before: false,
        after: true
      }
    ],
    //规定子类构造函数中必须调用super，非子类不要调用super。
    "constructor-super": 2,
    //规定避免不必要的 .call() 和 .apply()
    "no-useless-call": "error",
    //规定不要定义未使用的变量
    "no-unused-vars": [
      "error",
      {
        vars: "all",
        args: "none",
        ignoreRestSiblings: true
      }
    ],
    //"no-useless-constructor": "error"
    "no-useless-constructor": "error",
    //规定点号操作符须与属性需在同一行
    "dot-location": [2, "property"],
    //使用一致的缩进
    /* 'indent': [2, 2, {
     *     'SwitchCase': 1
     * }], */
    //规定键值对中冒号与值之间要留空白
    "key-spacing": [
      2,
      {
        beforeColon: false,
        afterColon: true
      }
    ],
    //关键字前后实用一致的间距
    "keyword-spacing": [
      2,
      {
        before: true,
        after: true
      }
    ],
    "new-cap": [
      2,
      {
        newIsCap: true,
        capIsNew: false
      }
    ],
    //规定多行 if 语句的 括号不能省略
    curly: [2, "multi-line"],
    //规定文件末尾空一行，以防文件解析错误
    "eol-last": "error",
    //规定函数调用时标识符与括号间不留间隔。第二个参数取值“never”和“always”，"never"表不留空格，"always"表要留空格
    "func-call-spacing": [2, "never"],
    //规定不能混合使用空格与制表符做为缩进
    "no-mixed-spaces-and-tabs": 2,
    //规定除了缩进，不要使用多个空格
    "no-multi-spaces": 2,
    //规定不允许有连续多行空行且文件头部不允许空行
    "no-multiple-empty-lines": [
      2,
      {
        max: 1,
        maxEOF: 0
      }
    ],
    //规定行末不留空格。
    "no-trailing-spaces": 2,
    //规定属性前面不能加空格
    "no-whitespace-before-property": 2,
    //规定对象属性换行时注意统一代码风格(要么都换行，要么都不换)。
    "object-property-newline": [
      2,
      {
        allowMultiplePropertiesPerLine: true
      }
    ],
    //规定对于三元运算符 ? 和 : 与他们所负责的代码处于同一行
    /* "operator-linebreak": [2, "after", {
     *     "overrides": {
     *         "?": "before",
     *         ":": "before"
     *     }
     * }], */
    //规则定义代码中不要出现多余留白,“blocks”表代码块，“classes”表类，“switches”表switch语句，取值都为“never”或“always”，表示是否需要留空行.
    "padded-blocks": [
      2,
      {
        blocks: "never",
        switches: "never",
        classes: "never"
      }
    ],
    //规定展开运算符与它的表达式间不要留空白。第二个参数取值“never”和“always”，表是否需要留白。
    "rest-spread-spacing": [2, "never"],
    //规定分号前不留空格，后面留一个空格。
    "semi-spacing": [
      2,
      {
        before: false,
        after: true
      }
    ],
    //规定必须添加分号
    semi: ["error", "always"],
    //规定代码块收尾需留空格。
    "space-before-blocks": [2, "always"],
    //规定圆括号之间不留空格
    "space-in-parens": [2, "never"],
    //规定字符串拼接操作符 (Infix operators) 之间要留空格
    "space-infix-ops": 2,
    //规定get和set成对出现
    "accessor-pairs": 2,
    //规定不允许多余的行末逗号。
    "comma-dangle": [
      2,
      {
        arrays: "never",
        objects: "never",
        imports: "never",
        exports: "never",
        functions: "never"
      }
    ],
    //规定始终将逗号置于行末。
    "comma-style": [2, "last"],
    //规定始终使用 === 替代 ==，null除外。第二个参数配置是否使用 === ，第三个参数配置是否忽略空值判断。(这里暂时是 warning 状态)
    eqeqeq: [
      1,
      "always",
      {
        null: "ignore"
      }
    ],
    //规定函数里面的异常信息不要忘记处理。第二个参数配置匹配那些参数的正则表达式.
    "handle-callback-err": ["error", "^(err|error)$"],
    //规定避免修改使用 const 声明的变量。
    "no-const-assign": 2,
    //规定避免对类名重新赋值。
    "no-class-assign": 2,
    //规定使用数组字面量而不是构造器
    "no-array-constructor": 2,
    //规定无参的构造函数调用时要带上括号
    "new-parens": 2,
    //规定不要对变量使用 delete 操作。(waring)
    "no-delete-var": 1,
    //规定不要定义重复的函数参数
    "no-dupe-args": 2,
    //规定类中不要定义重复的属性
    "no-dupe-class-members": 2,
    //规定对象字面量中不要定义重复的属性
    "no-dupe-keys": 2,
    //规定switch 语句中不要定义重复的 case 分支
    "no-duplicate-case": 2,
    //规定正则中不要使用空字符。
    "no-empty-character-class": 2,
    //规定不要解构空值
    "no-empty-pattern": 2,
    //定义catch 中不要对错误重新赋值
    "no-ex-assign": 2,
    //规定switch一定要使用 break 来将条件分支正常中断
    "no-fallthrough": 2,
    //规定避免对声明过的函数重新赋值
    "no-func-assign": 2,
    //规定不要对全局只读对象重新赋值
    "no-global-assign": 2,
    //规定不要向 RegExp 构造器传入非法的正则表达式。
    "no-invalid-regexp": 2,
    //规定禁止使用 iterator。
    "no-iterator": 2,
    //规定避免将变量赋值给自己
    "no-self-assign": 2,
    //规定避免将变量与自己进行比较
    "no-self-compare": 2,
    //规定禁止随意更改关键字的值
    "no-shadow-restricted-names": 2,
    //规定禁止使用稀疏数组
    "no-sparse-arrays": 2,
    //规定正确使用 ES6 中的字符串模板
    "no-template-curly-in-string": 2,
    //规定用throw 抛错时，抛出 Error 对象而不是字符串。
    "no-throw-literal": 2,
    //规定不要使用 (, [, or ` 等作为一行的开始。在没有分号的情况下代码压缩后会导致报错，而坚持这一规范则可避免出错。
    "no-unexpected-multiline": 2,
    //规定循环语句中注意更新循环变量
    "no-unmodified-loop-condition": 2,
    //规定return，throw，continue 和 break 后不要再跟代码。
    "no-unreachable": 2,
    //规定finally 代码块中不要再改变程序执行流程
    "no-unsafe-finally": 2,
    //规定未定义前不能使用
    "no-use-before-define": [
      2,
      {
        functions: false,
        classes: false,
        variables: false
      }
    ],
    //规定禁止无用的表达式。
    "no-unused-expressions": [
      2,
      {
        allowShortCircuit: true,
        allowTernary: true,
        allowTaggedTemplates: true
      }
    ],
    //规定禁止在正则表达式中使用控制字符
    "no-control-regex": 2,
    //规定避免使用 arguments.callee 和 arguments.caller
    "no-caller": 2,
    //规定条件语句中赋值语句使用括号包起来。
    "no-cond-assign": 2,
    //规定不要使用 debugger。
    "no-debugger": 2,
    //规定不要扩展原生对象。
    "no-extend-native": 2,
    //规定避免不必要的布尔转换。
    "no-extra-boolean-cast": 2,
    //规定避免多余的函数上下文绑定
    "no-extra-bind": 2,
    //规定不要使用多余的括号包裹函数
    "no-extra-parens": [2, "functions"],
    //规定不要省去小数点前面的0（增强可读性）
    "no-floating-decimal": 2,
    //规定避免使用隐式的 eval()。
    "no-implied-eval": 2,
    //规定嵌套的代码块中禁止再定义函数
    "no-inner-declarations": [2, "functions"],
    //规定不要使用非法的空白符
    "no-irregular-whitespace": 2,
    //规定不要使用标签语句
    "no-labels": [
      2,
      {
        allowLoop: false,
        allowSwitch: false
      }
    ],
    //规定不要书写不必要的嵌套代码块
    "no-lone-blocks": 2,
    //规定不要使用多行字符串
    "no-multi-str": 2,
    //规定new 创建对象实例后需要赋值给变量
    "no-new": 2,
    //规定禁止使用 Function 构造器
    "no-new-func": 2,
    //规定禁止使用 Object 构造器
    "no-new-object": 2,
    //规定禁止使用 new require
    "no-new-require": 2,
    //规定禁止使用 Symbol 构造器
    "no-new-symbol": 2,
    //规定禁止使用原始包装器
    "no-new-wrappers": 2,
    //规定不要将全局对象的属性作为函数调用
    "no-obj-calls": 2,
    //规定不要使用八进制字面量
    "no-octal": 2,
    //规定不要重复声明变量
    "no-redeclare": 2,
    //规定return 语句中的赋值必需有括号包裹
    "no-return-assign": [2, "except-parens"],
    //规定如果有更好的实现，尽量不要使用三元表达式
    "no-unneeded-ternary": [
      "error",
      {
        defaultAssignment: false
      }
    ],
    //规定不要使用 undefined 来初始化变量。
    "no-undef-init": "error",
    "jsx-quotes": [1, "prefer-double"], //强制在JSX属性（jsx-quotes）中一致使用双引号
    "react/display-name": 0, //防止在React组件定义中丢失displayName
    "react/forbid-prop-types": [
      2,
      {
        forbid: ["any"]
      }
    ], //禁止某些propTypes
    "react/jsx-boolean-value": 2, //在JSX中强制布尔属性符号
    "react/jsx-closing-bracket-location": 1, //在JSX中验证右括号位置
    "react/jsx-curly-spacing": [
      2,
      {
        when: "never",
        children: true
      }
    ], //在JSX属性和表达式中加强或禁止大括号内的空格。
    "react/jsx-indent-props": [2, 2], //验证JSX中的props缩进
    "react/jsx-key": 2, //在数组或迭代器中验证JSX具有key属性
    "react/jsx-max-props-per-line": [
      1,
      {
        maximum: 1
      }
    ], // 限制JSX中单行上的props的最大数量
    "react/jsx-no-bind": 0, //JSX中不允许使用箭头函数和bind
    "react/jsx-no-duplicate-props": 2, //防止在JSX中重复的props
    "react/jsx-no-literals": 0, //防止使用未包装的JSX字符串
    "react/jsx-no-undef": 1, //在JSX中禁止未声明的变量
    "react/jsx-pascal-case": 0, //为用户定义的JSX组件强制使用PascalCase
    "react/jsx-sort-props": 0, //强化props按字母排序
    "react/jsx-uses-react": 1, //防止反应被错误地标记为未使用
    "react/jsx-uses-vars": 2, //防止在JSX中使用的变量被错误地标记为未使用
    "react/no-danger": 0, //防止使用危险的JSX属性
    "react/no-did-mount-set-state": 0, //防止在componentDidMount中使用setState
    "react/no-did-update-set-state": 1, //防止在componentDidUpdate中使用setState
    "react/no-direct-mutation-state": 2, //防止this.state的直接变异
    "react/no-multi-comp": 1, //防止每个文件有多个组件定义
    "react/no-set-state": 0, //防止使用setState
    "react/no-unknown-property": 2, //防止使用未知的DOM属性
    "react/prefer-es6-class": 2, //为React组件强制执行ES5或ES6类
    "react/prop-types": 0, //防止在React组件定义中丢失props验证
    "react/react-in-jsx-scope": 2, //使用JSX时防止丢失React
    "react/self-closing-comp": 0, //防止没有children的组件的额外结束标签
    "react/sort-comp": 2, //强制组件方法顺序
    "no-extra-boolean-cast": 0, //禁止不必要的bool转换
    "react/no-array-index-key": 0, //防止在数组中遍历中使用数组key做索引
    "react/no-deprecated": 1, //不使用弃用的方法
    "react/jsx-equals-spacing": 2, //在JSX属性中强制或禁止等号周围的空格
    "import/imports-first": 0,
    "import/newline-after-import": 0,
    "import/no-dynamic-require": 0,
    "import/no-extraneous-dependencies": 0,
    "import/no-named-as-default": 0,
    "import/no-unresolved": 0,
    "import/prefer-default-export": 0,
    "import/extensions": 0,
    "jsx-a11y/aria-props": 2,
    "jsx-a11y/heading-has-content": 0,
    "jsx-a11y/href-no-hash": 2,
    "jsx-a11y/label-has-for": 2,
    "jsx-a11y/mouse-events-have-key-events": 2,
    "jsx-a11y/role-has-required-aria-props": 2,
    "jsx-a11y/role-supports-aria-props": 2
  }
};
```

### vscode

- 安装 `eslint`/`prettier` 插件
- 打开 `文件 --- 首选项 --- 设置 --- 在 settings.json 中 编辑`

```javascript settings.json

"editor.formatOnSave": true,
"prettier.eslintIntegration": true,
"eslint.autoFixOnSave": true,
"eslint.options": {//路径指向自定义的 eslint 规则
"eslintConfig": "c:/Users/TK/.eslintrc.js"
},
"javascript.format.enable": false

```

> tips： 在编辑 react 文件的时候 vscode 需要把右下角的解析器 `Javascript(Babel)` 改为 `JavaScript React`,这样在保存的时候格式才不会乱

### webstorm

相较于`vscode`来说`webstorm`的配置就有点复杂了。

#### 第一步：

编辑器安装`eslint` 和 `pretteir` 插件

- WebStorm 2018.1 和以上的版本
- Webstorm 2017.3 和更早的版本

#### Prettier

1.WebStorm 2018.1 和以上的版本

- 官方已经默认支持了 `prettier`,可以在`File --- settings --- Languages & Frameworks --- JavaScript --- Prettier` 中找到，找到后需要配置一下。
- `Node interpreter` --- 找到你安装的 `node.exe` 的目录。
  - eg: `C:\Pragram Files\nodejs\node.exe`
- `Prettier package` --- 找到你全局安装的 prettier 目录

  - eg: `~\AppData\Roaming\npm\node_modules\prettier`

    2.Webstorm 2017.3 和更早的版本这个没跟着配过，我的版本是 2018 的，这个是从官网扒下来的，文末有链接。

- 转到`首选项 | 工具 | 外部工具`,
- 然后单击`+`添加新工具。`Name`填写为 Prettier,
- `Programs` 填写全局安装的 `prettier.cmd`
  - eg： `C:\Users\user_name\AppData\Roaming\npm\prettier.cmd`
- `Parameters` 填写 `--write $FilePathRelativeToProjectRoot$`
- `Working directory` 填写 `$ProjectFileDir$`
- 按`Cmd/Ctrl-Shift-A`（查找操作），搜索`Prettier`，然后点击`Enter`。
- `prettier` 将针对当前文件运行

### eslint

`eslint`没找以前的版本，直接找的 2018 的，感兴趣的可以去配一下，和`prettier`大同小异

- 在`File --- settings --- Languages & Frameworks --- JavaScript --- Code Quality Tools --- ESLint` 中找到配置`eslint`
- `Node interpreter` --- 找到你安装的 `node.exe` 的目录。
  - eg: `C:\Pragram Files\nodejs\node.exe`
- `ESLint package` --- 找到你全局安装的 prettier 目录
  - eg: `~\AppData\Roaming\npm\node_modules\eslint`
- `Configuration file` 中选择 `Configuration file` 找到你自己配置的`eslintrc.js`文件

#### 第二步

配置 `Ctrl + s` 自动格式化代码

1. `Edit - Macros - Start Macros Recording`
2. 按住 `Ctrl-Shift-Alt-p` 然后 再按 `Ctrl-s`
3. 点击右下角的红色圆点停止录制宏，输入名字 eg: `prettier code and Save`
4. 打开设置 `File --- settings --- Keymap`,搜索刚刚保存的 宏的名字
5. 双击 选择 `Add Keyboard Shortcut` 弹出框出来后 键盘上按 `Ctrl-S`,选择 `Remove`
6. finish 完成了。

> 参考链接

[webstorm 配置 prettier](https://prettier.io/docs/en/webstorm.html)
