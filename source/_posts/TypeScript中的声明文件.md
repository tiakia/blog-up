---
title: TypeScript中的声明文件
abbrlink: 61798
date: 2019-9-25 19:03:12
tags: ts
categories: typescrit
---

在写`Typescript`的时候老是会碰到这样的错误：
`Could not find a declaration file for module './hello'. 'src/hello.js' implicitly has an 'any' type.`

- [ts] 无法找到模块“./hello”的声明文件

<!-- more -->

这里是缺少了`hello.ts`的声明文件，这篇文章记录一下关于`TS`的声明文件。

## 声明文件(x.d.ts)

<u>TypeScript 作为 JavaScript 的超集，在开发过程中不可避免要引用其他第三方的 JavaScript 的库。虽然通过直接引用可以调用库的类和方法，但是却无法使用 TypeScript 诸如类型检查等特性功能。为了解决这个问题，需要将这些库里的函数和方法体去掉后只保留导出类型声明，而产生了一个描述 JavaScript 库和模块信息的声明文件。通过引用这个声明文件，就可以借用 TypeScript 的各种特性来使用库文件了。</u>

在开始描述各种问题之前，列举一下我所知道的声明文件存放的方式（常规配置下）：

- `src/@types/`，在 `src` 目录新建`@types` 目录，在其中编写`.d.ts` 声明文件，声明文件会自动被识别，可以在此为一些没有声明文件的模块编写自己的声明文件；
  实际上在 `tsconfig` `include` 字段包含的范围内编写 `.d.ts`，都将被自动识别。
- 在 `x.js` 相同目录创建同名声明文件 `x.d.ts`，这样也会被自动识别；
- `node_modules/@types/`下存放各个第三方模块的声明文件，通过 `yarn add @types/react` 自动下载到此处，自己编写的声明文件不要放在这里；
- 作为 `npm` 模块发布时，声明文件可捆绑发布，需在 `package.json` 中指明`"types": "./types/index.d.ts"`；

> 隐式 any 类型（implicitly has an ‘any’ type）

当 `tsconfig.json` 中关闭`"noImplicitAny": false` 时，可以直接在 `TypeScript` 中引用 `JavaScript`（无声明文件）的库，所有的引入都会被默认为 `any` 类型。但为了规范编码，总是打开`"noImplicitAny": true`，这样当发生上述情况时，编译器会阻止编译，提示我们去加上类型规范。

## declare

- 导入自己写的工具类函数
  在工具`utils.js`同级编写`utils.d.ts`

```typescript
// util.d.ts
export declare const getAllType: (
  sourceType: any,
  targetType: any,
  filter?: any
) => any;
```

- 导入图片/css/json 模块
  在`tsconfig` `include` 字段包含的范围内编写`index.d.ts`

```typescript
// index.d.ts
declare module "*.png";
declare module "*.json";
declare module "*.css";
declare module "*.less";
```

- 安装第三方插件的时候提示找不到模块
  一般使用第三方不是 `TypeScript` 编写的模块时，我们可以直接下载对应的声明文件：`yarn add @types/{模块名}`。然而有些模块是没有对应的声明文件的，这时候就需要我们自己编写声明文件，以 `rc-form` 为例：
  在`tsconfig`的`include` 字段包含的范围内编写`{任意名称}.d.ts`

```typescript
declare module "rc-form" {
  // 在此只是简单地进行类型描述
  export const createForm: any;
  export const createFormField: any;
  export const formShape: any;
}
```

## webpack 别名

有时候会遇到设置了`webpack`别名，但是在导入的时候会遇到找不到模块

```javascript
// webpack.config.js
const config = {
  // ...
  alias: {
    utils: path.resolve(__dirname, "src/utils")
  }
};

// index.ts
import { ua } from "utils/broswer";
// Cannot find module 'utils/browser'
```

只需在 `tsconfig.json` 添加 `baseUrl` 和`paths` 的配置即可：

- tsconfig.json

```json
{
  "compilerOptions": {
    "noImplicitAny": true,
    "baseUrl": ".",
    "paths": {
      "utils/*": ["/src/utils/*"]
    }
  },
  "include": ["./src/*", "./src/**/*"],
  "exclude": ["node_modules"]
}
```

## Window.X

有时需要在`window`上挂载一个属性的时候会遇到`The property ‘X’ does not exist on value of type ‘window’`
这时需要对`window`进行扩展：
在`tsconfig`的`include` 字段包含的范围内编写`{任意名称}.d.ts`

```typescript
// index.d.ts
interface Window {
  X: any;
}
```

> 参考链接

[TypeScript 中的声明文件](https://daief.tech/2018-09-04/declaration-files-of-typescript.html)
