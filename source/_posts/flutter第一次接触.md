---
title: flutter第一次接触
abbrlink: 801
date: 2019-03-28 15:37:47
tags: [flutter]
---

去年大热的混合开发 APP 的框架`flutter`，最近体验了一把，在这里记录一些值得注意的东西。相比较于`React Native`来说，可能对前端不是很友好，但是也不是很难，可能很多同学因为要学`Dart`语言就怕了，其实写的时候，很少会用到`Dart`的语法，我们也只需要了解一点就行，本文不是教程，纯粹的是自己学习`Flutter`的笔记。

<!-- more -->

### 新建项目

`Android Studio`需要提前安装`flutter`和`dart`这俩个依赖，然后就可以通过`Android Studio`直接新建`Flutter`项目。具体的安装方式[查看这里](https://flutterchina.club/setup-windows/)

### 配置文件

`pubspec.yaml`相当于`js`的`package.json`,里面有相关的依赖，还有版本号，如果要添加依赖可以直接在这个文件中添加，然后`Android Studio`上面就会有一个`Packages get`的操作帮助我们安装依赖。

### main.dart

源文件在`lib/main.dart`，我们可以在这个文件中修改代码，有个`main()`函数就是我们对外展示的根函数。

```java main.dart
void main() {
    runApp(new MaterialApp(
        home: new MyApp()// 自己写的组件
    ));
}
```

在首页就会展示我们写的`MyApp`组件的内容

### 组件类型

`flutter`的组件类型有俩种，`StatelessWidget`无状态的组件，`StatefulWidget`有状态的组件。有状态的组件需要重写它的`createState`方法

```java main.dart
class MyApp extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        return new MyAppState();
    }
}

class MyAppState extends State<MyApp> {
    @override
    Widget build(BuildContext context) {
        ....
    }
}
```

### build 方法

组件中有一个重要的方法，`build`中返回的就是我们要展示的界面，我们这里实现一个页面中加减按钮的例子：

```java main.dart
class MyApp extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        return new MyAppState();
    }
}
class MyAppState extends State<MyApp> {
    int count = 0;
    void _increment() {
        setState(() {
        count++;
        });
    }
    void _remove() {
        setState(() {
        if(count >0) {
            count--;
        }
        });
    }
    @override
    Widget build(BuildContext context) {
        return new Scaffold( // 组件
            appBar: new AppBar(
                title: new Text('Add-Count')
            ),
            body: new Column( // column 布局
                mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(
            child: Text('计算后的 Count 值为:',
              style: TextStyle(
                  fontSize: 24.0,
              ),
            ),
          ),
          new Divider(),
          new Center(
              child: Text('$count',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold
                ),
              ),
          ),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new IconButton(icon: Icon(Icons.remove_circle),
                    iconSize: 45.0,
                    color: Colors.lightBlue,
                    padding: EdgeInsets.all(16.0),
                    onPressed: () {
                  _remove();
                }),
                new IconButton(icon: Icon(Icons.add_circle),
                    iconSize: 45.0,
                    color: Colors.lightBlue,
                    padding: EdgeInsets.all(16.0),
                    onPressed: (){
                  _increment();
                }),
              ],
            ),
        ],
            )
        )
    }
}
```

### 学习路径

其他的比如`flutter`的常用组件，布局方式等可以学习[官网](https://flutterchina.club/docs/)，教程可以去看看

- [技术胖的视频教程](https://jspang.com/post/flutter1.html)，
- [`github`有一个`flutter UI`](https://github.com/efoxTeam/flutter-ui)
