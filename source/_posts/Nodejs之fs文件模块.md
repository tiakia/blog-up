---
title: Nodejs之fs文件模块
tags: [nodejs]
date: 2018-04-11 11:03:07
categories: nodejs
description:
thumbnail:
keywords:
---

这里记录几个常用的文件模块，文件模块属于核心模块，使用的时候需要提前引入。

```
fs.open(paht, flags[,mode],callback)
```

<!-- more  -->

异步的打开文件

- **path** - 要打开文件的路径
- **flags** - 要打开文件的方式 读/写
- **mode** - 设置文件的模式（权限） 读/写/执行
- **callback**
  - **err** 打开失败后的错误保存在 err 里，如果成功 err 为 null
  - **fd** 打开文件标识

**flags 常见的有**：

- `r` - 以读取模式打开文件。如果文件不存在则发生异常。
- `r+` - 以读写模式打开文件。如果文件不存在则发生异常。
- `w` - 以写入模式打开文件。文件会被创建（如果文件不存在）或截断（如果文件存在）。
- `a` - 以追加模式打开文件。如果文件不存在，则会被创建。

```

fs.openSync(path, flags[,mode])
```

fs.open 的同步版本，返回一个表示文件描述符的整数

```
fs.read(fd, buffer, offset, length, position, callback)
```

- **fd** - 通过 open 方法成功打开一个文件返回的编号
- **buffer** - 数据将被写入到的 buffer
- **offset** - 是 buffer 中开始写入的偏移量
- **length** - 是一个整数，指定要读取的字节数。
- **position** - 指定从文件中开始读取的位置，如果为 null，则数据从当前文件读取位置开始读取，且文件读取位置会被更新。如果 position 为一个整数，则文件读取位置保持不变。
- **callback**
  - **err**
  - **bytesRead** - 读取的 buffer 的字节长度
  - **newBuffer** - 新的`buffer`对象

```

fs.readSync(fd, buffer, offset, length, position)
```

fs.read 的同步版本，返回 bytesRead 的数量

```
fs.readFile(path[, options], callback)
```

异步的读取一个文件的全部内容

- **path** - 要读取文件的路径
- **options**
  - **encoding** 默认为 null
  - **flag** 默认为 'r'
- **callback**
  - **err**
  - **data** - 文件的内容

```

fs.write(fd, buffer[, offset[, length[, position]]], callback)
```

写入 buffer 到指定文件

- **fd** - 通过 open 方法成功打开一个文件返回的编号
- **buffer** - 将要写入文件的 buffer
- **offset** - 决定 buffer 中被写入的部分
- **length** - 是一个整数，指定要写入的字节数。
- **position** - 指向从文件开始写入数据的位置的偏移量
- **callback**
  - **err**
  - **bytesWritten** - 指定从 buffer 写入了多少字节
  - **newBuffer** - 新的`buffer`对象

```
fs.writeSync(fd, buffer[, offset[, length[, position]]])
```

fs.write()的同步版本

```

fs.writeSync(fd, string[, position[, encoding]])
```

fs.write()的同步版本，返回写入的字节数

```
fs.write(fd, string[, position[, encoding]], callback)
```

写入 string 到 fd 指定的文件。如果 string 不是一个字符串，则该值将被强制转换为一个字符串。

- **encoding** - 是期望的字符串编码。
- **callback**
  - **err**
  - **written** - 指定传入的字符串被写入多少字节。注意，写入的字节与字符字符是不同的不同于写入 buffer，该方法整个字符串必须被写入。不能指定子字符串。 这是因为结果数据的字节偏移量可能与字符串的偏移量不同。
  - **string**

```

fs.writeFile(file, data[, options], callback)
```

异步地写入数据到文件，如果文件已经存在，则替代文件。

- **file** - 文件名或文件描述符
- **data** - 可以是一个字符串或一个 buffer。
- **options**
  - **encoding** - 默认 utf-8
  - **mode** - 默认 0o666
  - **flag** - 默认 w
- **callback**
  - **err**

```
fs.writeFileSync(file, data[, options])
```

fs.writeFile()的同步版本，返回 undefined

```

fs.appendFile(file, data[, options], callback)
```

异步地追加数据到一个文件，如果文件不存在则创建文件。 data 可以是一个字符串或 buffer。

- **file** - 文件名或文件描述符
- **data** - 要添加的内容，字符串或 buffer
- **options**
  - **encoding** - 默认为 utf8
  - **mode** - 默认为 0o666
  - **flag** - 默认为'a'
- **callback**
  - **err**

```
fs.appendFileSync(file, data[, options])
```

fs.appendFile() 的同步版本。 返回 undefined。

```

fs.existsSync(path)
```

如果文件存在，则返回 true，否则返回 false。他的异步版本`fs.exists(paht,callback)`已经被废弃了，如果非要用异步检查，推荐使用`fs.access()`替代

不推荐在调用 fs.open，fs.readFile()，fs.writeFile() 之前使用 fs.exists() 检测文件是否存在。这样做会引起竞争条件，因为在两次调用之间，其他进程可能修改文件。作为替代，用户应该直接开/读取/写入文件，当文件不存在时再处理错误。

```
fs.access(path[, mode], callback)
```

- **path** - 要检查的文件/目录的路径
- **mode** - 一个可选的整数，指定要执行的可访问性检查默认：`fs.constants.F_OK`
  - `fs.constants.F_OK` - path 文件对调用进程可见。 这在确定文件是否存在时很有用，但不涉及 rwx 权限。 如果没指定 mode，则默认为该值。
  - `fs.constants.R_OK` - path 文件可被调用进程读取。
  - `fs.constants.W_OK` - path 文件可被调用进程写入。
  - `fs.constants.X_OK` - path 文件可被调用进程执行。 对 Windows 系统没作用（相当于 fs.constants.F_OK）。
- **callback**
  - **err**

```

fs.accessSync(path[, mode])
```

fs.access() 的同步版本。如果有任何可访问性检查失败则抛出错误，否则什么也不做。

```
fs.unlink(path, callback)
```

删除一个文件

```

fs.unlinkSync(path)
```

同步的`fs.unlink()`,返回 undefined

```
fs.rename(oldPath, newPath, callback)
```

将`oldPath`的文件重命名为`newPath`

- **callback**
  err

```

fs.renameSync(oldPath, newPath)
```

返回`undefined`

```
fs.readir(path[, options], callback)
```

读取一个目录的内容

- **path** - 要读取目录的路径
- **options** - encoding 默认为 utf-8
- **callback**
  - **err**
  - **files** - 目录中不包括 '.' 和 '..' 的文件名的数组

```

fs.rmdir(path, callback)
```

移除文件夹

```
fs.rmdirSync(path)
```

`fs.rmdir()`的同步版本，返回`undefined`

```

fs.mkdir(path[, mode], callback)
```

新建文件夹

- **mode** - 默认为 `0o777`
- **callback**
  - **err**

```
fs.mkdirSync(path[, mode])
```

`fs.mkdir()`的同步版本，返回`undefined`

```

fs.stat(path, callback)
```

返回文件属性

- **path**
- **callback**
  - **err**
  - **stats** - 返回一个如下对象

```test.js %}

<!-- tab js -->

Stats {
dev: 2114,
ino: 48064969,
mode: 33188,
nlink: 1,
uid: 85,
gid: 100,
rdev: 0,
size: 527,
blksize: 4096,
blocks: 8,
atimeMs: 1318289051000.1,
mtimeMs: 1318289051000.1,
ctimeMs: 1318289051000.1,
birthtimeMs: 1318289051000.1,
atime: Mon, 10 Oct 2011 23:24:11 GMT,
mtime: Mon, 10 Oct 2011 23:24:11 GMT,
ctime: Mon, 10 Oct 2011 23:24:11 GMT,
birthtime: Mon, 10 Oct 2011 23:24:11 GMT
}

<!-- endtab -->

```

```

fs.watch(filename[, options][, listener])

```

监测文件的改变

- **filename** - filename 可以是一个文件或一个目录
- **options**
  - **persistent** - 指明如果文件正在被监视，进程是否应该继续运行。默认 = true
  - **recursive** - 指明是否全部子目录应该被监视，或只是当前目录。适用于当一个目录被指定时，且只在支持的平台（详见 Caveats）。默认 = false
  - **encoding** - 指定用于传给监听器的文件名的字符编码。默认 = 'utf8'
- **listener**
  - **evenType** - 'rename' 或 'change'，filename 是触发事件的文件的名称。
  - **filename**

##### 注意，在大多数平台，当一个文件出现或消失在一个目录里时，'rename' 会被触发。

```

```
