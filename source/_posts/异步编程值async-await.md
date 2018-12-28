---
title: 异步编程值async-await
tags: [async-await]
date: 2018-04-11 10:44:27
categories: javascript
description:
thumbnail:
keywords:
---

nodejs 版本 v8.2.1

##### async 函数会返回一个 promise 对象，可以像使用 promise 一样使用 promise 的返回值。

<!-- more -->

```
<!-- tab js -->
const fetch = require('node-fetch');

async function getZhihuColumn(id){
  const url = `https://zhuanlan.zhihu.com/api/columns/${id}`;
  const response = await fetch(url);
  return  await response.json();
}

getZhihuColumn('feweekly')
  .then(column => {
    console.log(`NAME: ${column.name}`);
    console.log(`INTRO: ${column.intro}`);
  })
<!-- endtab -->
```

##### await 接收一个 promise 对象 在 resolve 的 时候，把 resolve 的值返回给接收的值，但是在 reject 的时候会抛出错误

#### async 在全局作用域中使用 async 表达式是非法的

##### 解决办法： 使用匿名立即执行的函数

```
<!-- tab js -->
const fetch = require('node-fetch');

const getZhihuColumn = async (id) => {
    const url = `https://zhuanlan.zhihu.com/api/columns/${id}`;
    const response = await fetch(url);
    return await response.json();
}

(async ()=>{
    const column = await getZhihuColumn('feweekly');
    console.log(`NAME: ${column.name}`);
    console.log(`INTRO: ${column.intro}`);
})();
<!-- endtab -->
```

##### 使用 class

```
<!-- tab js -->
class APIClient{
  async getColumn(id){
    const url = `https://zhuanlan.zhihu.com/api/columns/${id}`;
    const response = await fetch(url);
    return await response.json();
  }
}

(async ()=> {
  const client = new APIClient();
  const column = await client.getColumn('feweekly');
  console.log(`NAME: ${column.name}`);
  console.log(`INTRO: ${column.intro}`);
})();
<!-- endtab -->
```

#### 错误处理

```
<!-- tab js -->
const fetch = require('node-fetch');

async function getZhihuColumn(id){
  const url = `https://zhuanlan.zhihu.com/api/columns/${id}`;
  const response = await fetch(url);
  if(response.status != 200){
    throw new Error(response.statusText);
  }
  return await response.json();
}
<!-- endtab -->
```

`danger %}第一种：使用 promise 的 catch`

```

<!-- tab js -->

getZhihuColumn('feweekl12y')
.then( column => {
console.log(`NAME: ${column.name}`);
console.log(`INTRO: ${column.intro}`);
})
.catch(err => {
console.log(err);
});

<!-- endtab -->

```

`danger %}第二种：写到另一个 async 函数里`

````

<!-- tab js -->

const showColunmInfo = async (id) => {
try{
const column = await getZhihuColumn(id);
console.log(`NAME: ${column.name}`);
console.log(`INTRO: ${column.intro}`);
}catch(err){
console.error(err);
}
}

showColunmInfo('feweekl12y');

<!-- endtab -->

```

#### 并行处理和串行处理

并行比串行速度快。

```

<!-- tab js -->

const fetch = require('node-fetch');
//延迟俩秒再发起 promise
const sleep = (timeout = 2000) => new Promise(resolve => {
setTimeout(resolve, timeout);
});

async function getZhihuColumn(id){
await sleep(2000);
const url = `https://zhuanlan.zhihu.com/api/columns/${id}`;
const response = await fetch(url);
rerturn await response.json();
}

<!-- endtab -->

````

`danger %}串行的`

```

<!-- tab js -->

const showColumnInfro = async () => {
console.time('SHOWCOLUMNINFO');
const feweekly = await getZhihuColumn('feweekly');
const toolingtips = await getZhihuColumn('toolingtips');

console.log(`NAME: ${feweek.name}`);
console.log(`INTRO: ${feweek.intro}`);

console.log(`NAME: ${toolingtips.name}`);
console.log('INTRO: \${toolingtips.intro}');
console.timeEnd('SHOWCOLUMNINFO');
};

showColumnInfro();

<!-- endtab -->
<!-- tab result -->

NAME: 前端周刊
INTRO: 在前端领域跟上时代的脚步，广度和深度不断精进
NAME: tooling bits
INTRO: 工欲善其事必先利其器
SHOWCOLUMNINFO: 4362.290ms

<!-- endtab -->

```

`danger %}并行的(一)，可以先发起 promise 请求然后再 await 结果发起并行`

```

<!-- tab js -->

const showColumnInfro = async () => {
console.time('SHOWCOLUMNINFO');
const feweeklyPromise = getZhihuColumn('feweekly');
const toolingtipsPromise = getZhihuColumn('toolingtips');

const feweekly = await feweeklyPromise;
const toolingtips = await toolingtipsPromise;

console.log(`NAME: ${feweekly.name}`);
console.log(`INTRO: ${feweekly.intro}`);

console.log(`NAME: ${toolingtips.name}`);
console.log(`INTRO: ${toolingtips.intro}`);
console.timeEnd('SHOWCOLUMNINFO');
};

showColumnInfro();

<!-- endtab -->
<!-- tab result -->

NAME: 前端周刊
INTRO: 在前端领域跟上时代的脚步，广度和深度不断精进
NAME: tooling bits
INTRO: 工欲善其事必先利其器
SHOWCOLUMNINFO: 2542.540ms

<!-- endtab -->

```

`danger %}并行(二) 使用 promise.all 执行并行操作`

```

<!-- tab js -->

const fetch = require('node-fetch');

const sleep = (timeout = 2000) => new Promise(resolve => {
setTimeout(resolve, timeout);
})

async function getZhihuColumn(id){
await sleep();
const url = `https://zhuanlan.zhihu.com/api/columns/${id}`;
const response = await fetch(url);
return await response.json();
}

const showColumnInfro = async () => {
console.time('SHOWCOLUMNINFO');
const [feweekly, toolingtips] = await Promise.all([
getZhihuColumn('feweekly'),
getZhihuColumn('toolingtips')
]);

console.log(`NAME: ${feweekly.name}`);
console.log(`INTRO: ${feweekly.intro}`);

console.log(`NAME: ${toolingtips.name}`);
console.log(`INTRO: ${toolingtips.intro}`);
console.timeEnd('SHOWCOLUMNINFO');
};

showColumnInfro();

<!-- endtab -->
<!-- tab result -->

NAME: 前端周刊
INTRO: 在前端领域跟上时代的脚步，广度和深度不断精进
NAME: tooling bits
INTRO: 工欲善其事必先利其器
SHOWCOLUMNINFO: 2532.700ms

<!-- endtab -->

```

```warning %}
如果 await 后面跟的不是 promise 对象，await 会隐式的调用 promise.resolve();成为一个立即 resolve 的 promise

```

```

<!-- tab js -->

async function main(){
const number = await 890;
//const number = await Promise.resolve(890);
console.log(number);
}
main();

<!-- endtab -->

```

```

在循环中使用 async await 的串行和并行

```

在循环中发起多个请求的并行和串行方法

```

<!-- tab js -->

const fetch = require('node-fetch');

const sleep = (timeout = 2000) => new Promise(resolve => setTimeout(resolve, timeout));

async function getZhihuColumn(id){
await sleep(2000);
const url = `https://zhuanlan.zhihu.com/api/columns/${id}`;
const response = await fetch(url);
return await response.json();
}

<!-- endtab -->

```

`danger %}串行`

```

<!-- tab js -->

const showColumnInfo = async () => {
console.time('SHOWCOLUMNINFO');

const names = ['feweekly', 'toolingtips'];
for (let i = 0; i< names.length; i++){
const column = await getZhihuColumn(names[i]);
console.log(`NAME: ${column.name}`);
console.log(`INTRO: ${column.intro}`);
}

console.timeEnd('SHOWCOLUMNINFO');
}

showColumnInfo();

<!-- endtab -->

```

`danger %}并行的`

````

<!-- tab js -->

const promiseArr = names.map(val => getZhihuColumn(val));
for(let promise of promiseArr){
const column = await promise;
console.log(`NAME: ${column.name}`);
console.log(`INTRO: ${column.intro}`)
}

showColumnInfo();

<!-- endtab -->

```

##### 循环中使用 async await 注意点

- await 只能用于 async 声明的函数上下文中。如下 forEach 中, 是不能直接使用 await 的，map，reduce 中也不行

```

<!-- tab js -->

let array = [0,1,2,3,4,5];
(async ()=>{
array.forEach(function(item){
console.log(item);
await wait(1000);//这是错误的写法
});
})();
//因 await 只能用于 async 声明的函数上下文中, 故不能写在 forEach 内.下面我们来看正确的写法
(async ()=>{
for(let i=0,len=array.length;i<len;i++){
console.log(array[i]);
await wait(1000);
}
})();

<!-- endtab -->

```

- async 做异步循环的时候最好用 for ... of ... 或者 Promise.all() 来完成并发请求

**知识点关于箭头函数**

**错误**

```

<!-- tab js -->

const sleep = (timeout = 2000) => {
new Promise(resolve => setTimeout(resolve, timeout);
}

<!-- endtab -->

````

这个是我写的 sleep 函数在测试的时候一直就没执行，这里我以前一直以为的是 arrowFunction 会自动返回，在去掉`{}`后函数正常执行了，在这里补充一下箭头函数的注意点
**正确**

```test.js %}

<!-- tab js -->

const sleep = (timeout = 2000) => new Promise( resolve =>
setTimeout(resolve, timeout);
);

<!-- endtab -->

```

或

```

<!-- tab js -->

const sleep = (timeout = 2000) => {
return new Promise(resolve => setTimeout(resolve, timeout);
}

<!-- endtab -->

```

1.箭头函数只有在省略了`{}`的时候，才会隐式的返回。而且只有在只有一行函数体的时候才可以省略`{}`。 2.如果函数体只有一行，而且也没有省略`{}`的话应该在函数体内加上`return`关键字，手动返回。 3.当函数参数只有一个时，可以省略`()`

```

```
