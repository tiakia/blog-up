---
title: Nodejs之URL
tags: [nodejs]
date: 2018-04-11 11:02:09
categories: nodejs
description:
thumbnail:
keywords:
---

### parse

###### 语法

```
url.parse(urlString,bool,bool);

```

<!-- more -->

第二个参数决定 query 部分以字符串返回还是以对象形式返回，默认为字符串返回即第二个参数默认为 false;
第三个参数表示在没有完整协议串的时候（即无 http:/https:）的时候‘//’之后的字符如何解释，若为 false 即将‘//’之后的当做路径解释，若为 true 则会将‘//’与‘/’之间的字符串解释为主机

例子：

```

<!-- tab js -->

var url = require(url);
var \_url = "http://www.imooc.com:8080/course/list?from=scott&course=node#floor1";
url.parse(\_url)

<!-- endtab -->
<!-- tab result -->

{
protocol: 'http',// 表示 url 采用什么协议
slashed: true,// 是否有斜线
auth: null,
host: 'imooc.com:8080',//表示主机
port: '8080',//端口
hostname: 'imooc.com',//主机名称
hash: '#floor1',//#后面的内容，包含#
serach: '?from=scott&course=node',//？后面#之前的内容包含？（查询字符串）
query: 'from=scott&course=node',// search 不包含？的内容（给 http 服务器发送数据）
pathname: '/course/list',//路径的名称，一般指主域名之后的内容
path: '/course/list?from=scott&course=node',//路径
herf: 'http://imooc.com:8080/course/list?from=scott&course=node#floor1'
}

<!-- endtab -->

```

第二个参数

```

<!-- tab js -->

//第二个参数 bool 值，处理 query 字段,默认是 false
url.parse(\_url,true)

<!-- endtab -->
<!-- tab result -->

{
protocol: 'http',
slashed: true,
auth: null,
host: 'imooc.com:8080',
port: '8080',
hostname: 'imooc.com',
hash: '#floor1',
serach: '?from=scott&course=node',
query: {from: 'scott', course: 'node' },//成了对象
pathname: '/course/list',
path: '/course/list?from=scott&course=node',
herf: 'http://imooc.com:8080/course/list?from=scott&course=node#floor1'
}

<!-- endtab -->

```

输出结果（看 query)

没有第三个参数

```

<!-- tab js -->

url.parse('//imooc.com/course/list',true);

<!-- endtab -->
<!-- tab result -->

{
protocol: null,
slashed: null,
auth: null,
host: null,
port: null,
hostname: null,
hash: null,
serach: '',
query: {},
pathname: '//imooc.com/course/list',
path: '//imooc.com/course/list',
herf: '//imooc.com/course/list'
}

<!-- endtab -->

```

有第三个参数

```

<!-- tab js -->

url.parse('//imooc.com/course/list',true,true);

<!-- endtab -->
<!-- tab result -->

{
protocol: null,
slashed: true,
auth: null,
host: 'imooc.com',
port: null,
hostname: 'imooc.com',
hash: null,
serach: '',
query: {},
pathname: '/course/list',
path: '/course/list',
herf: '//imooc.com/course/list'
}

<!-- endtab -->

```

```

```
