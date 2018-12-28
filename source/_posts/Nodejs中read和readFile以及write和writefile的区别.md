---
title: Nodejs中read和readFile以及write和writefile的区别
tags: [nodejs]
date: 2017-11-13 10:21:08
categories: nodejs
description:
thumbnail:
keywords:
---

今天在看 nodejs 的时候有个疑惑的事情，前面看到了 read 和 write，后面又看到了 readeFile 和 writeFile 俩个 API，有点疑惑这俩个到底有什么区别。上网查了一下才知道。在这里记录一下它们的区别

#### readFile 和 writeFile

1、readFile 方法是将要读取的文件内容完整读入缓存区，再从该缓存区中读取文件内容，具体操作如下：

```
var fs = require('fs');
fs.readFile('./test.txt',function(err, data){
   if(err){
       console.log('文件读取失败');
   }else{
       console.log(data.toString());
   }
});
```

<!-- more -->

与其对应的同步方法为：

```
var data = fs.readFileSync('./test.txt','utf-8');
console.log(data);
```

同步方法和异步方法的区别是：在使用同步方法执行的操作结束之前，不能执行后续代码的执行；而异步方法将操作结果作为回调函数的参数进行返回，方法调用之后，就可以立即执行后续的代码，读取完毕后会调用对应的回调函数。  
2、writeFile 方法是将要写入的文件内容完整的读入缓存区，然后一次性的将缓存区中的内容写入都文件中，向一个指定的文件中写入数据，如果不存在则新建，如果存在则写入

```
//异步方法
fs.writeFile('./test.txt','hello',function(err){
    if(err){
        console.log('文件写入失败');
    }else{
        console.log('文件写入成功');
    }
});
//同步方法
fs.writeFileSync('./test.txt','hello');
```

以上的读写操作，Node.js 将文件内容视为一个整体，为其分配缓存区并且一次性将文件内容读取到缓存区中，在这个期间，Node.js 将不能执行任何其他处理。所以当读写大文件的时候，有可能造成缓存区“爆仓”。

#### read 和 write

1.read 或 readSync 方法读取文件内容是不断地将文件中的一小块内容读入缓存区，最后从该缓存区中读取文件内容，具体操作如下：

```
var fs = require('fs');
fs.open('./message.txt','r',function(err,fd){
  var buf = new Buffer(225);
  //读取fd文件内容到buf缓存区
  fs.read(fd,buf,0,9,3,function(err,bufLen,newBuffer){
    console.log(newBuffer.toString());
  });
  var buff = new Buffer(225);
  //位置设置为null会默认从文件当前位置读取
  fs.read(fd,buff,0,3,null,function(err,bufLen,newBuffer){
    console.log(newBuffer.toString());
  });

  var buffer = new Buffer(225);
  //同步方法读取文件
  var data = fs.readFileSync(fd,buffer,0,9,3);
  console.log(data);
  console.log(data.toString());
});
```

2、write 或 writeSync 方法写入内容时，node.js 执行以下过程： 1.将需要写入的数据写入到一个内存缓存区； 2.待缓存区写满后再将缓存区中的内容写入到文件中； 3.重复执行步骤 1 和步骤 2，直到数据全部写入文件为止。
具体操作如下：

```
var fs = require('fs');
var buf = new Buffer('我喜爱编程');
fs.open('./message.txt','r+',function(err,fd){
  fs.write(fd,buf,3,9,0,function(err,bufLen,buffer){
      if(err) console.log('写文件操作失败');
      console.log('写文件操作成功');
  });

  //同步写入
  fs.writeSync(fd,buf,3,9,0);
});
```

以上读写操作，node.js 会将文件分成一块一块逐步操作，在读写文件过程中允许执行其他操作。

### 总结

简单的来说就是 read 和 write 是一部分一部分的加入到缓冲区，然后分块处理。而 readFile 和 writeFile 是把所有的都放到缓冲区然后再一起处理。

#### 文中涉及到的语法

```
fs.open(path, flags, [mode], callback);
 path 要打开文件的路径
 flags 要打开文件的方式 读/写
 mode  设置文件的模式（权限） 读/写/执行 4/2/1
 callback  回调
     err 打开失败后的错误保存在err里，如果成功err为null
     fd  打开文件的标识

```

```

fs.read(fd, buffer, offset, length, position, callback)
    fd 通过open方法成功打开一个文件返回到编号
    buffer  buffer对象
    offset  新的内容添加到buffer中的起始位置
    length  添加到buffer中的内容的长度
    position 读取的文件中的起始位置
    callback
        err
        buf的长度
        buf对象
```

```
fs.write(fd, buffer, offset, length[, postion], callback)
    fd : 打开文件的编号
    buffer 要写入的数据
    offset buffer对象中要写入的buffer数据的起始位置
    length 要写入buffer数据的长度
    position fd中的起始位置
    callback 回调
        err
        bufLength
        buffer对象
```

```
fs.writeFile(fileName, data[,options],callback);
 fileName 文件名或文件描述符
 data 要写入文件的数据
 options  该参数是一个对象，包含 {encoding, mode, flag}。默认编码为 utf8, 模式为 0666 ， flag 为 'w'
 callback
    err 写入失败时返回
```

```
fs.readFile(fileName[,options],callback);
 fileName 文件名或文件描述符

 callback
    err 读取失败时返回
    data 读取成功时返回
```
