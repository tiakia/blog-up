---
title: d3.js画地图项目总结
tags:
  - javascript
  - d3
categories: javascript
thumbnail: 
keywords: d3
abbrlink: 17900
date: 2018-03-12 11:00:58
description:
---

![航油](/../images/d3hangyou.png)

<!--more-->

### 项目背景

需要展示中国地图和世界地图，并且在地图上标点，画线路图，然后需要点击效果。
地图需要有拖拽和缩放的功能。
展示的设备为 ipad 只需要适配一个固定的 pad 设备。

### 技术栈

d3/react

### 项目历程

项目刚开始只是先用`d3+jq`试验了一下，以前用 d3 做个树状图没做过地图，把基本的功能弄出来后，就找了个`react`的脚手架来开始使用`react`来开发，github 上找到一个 react-d3 但是遗憾的是没有地图的封装，然后就自己半 d3 半 react 的开始开发了。
开发的时候`svg`的知识很重要，遇到解决的难题多搜搜 svg 的相关知识。
记录一下开发过程遇到的坑，地图的数据是在网上找好的，开发过程中参考了一个大神的博客，包括地图的显示，标点，线路图，拖拽和缩放功能的实现。

#### 拖拽

开发前期用时最长的就是拖拽的功能，地图的拖拽和`circle`、`rect`的拖拽不一样，他们有具体的坐标来规定显示的位置，而地图是生成的`path`，外层套一个`g`，你在调用`drag`事件的时候可以获取到鼠标当前的坐标，但是你给`g`设置了坐标不会起作用，所以选择了一个给外层的`g`设置`translate`，代码如下：

```javascript
const dragListener = d3.behavior
  .drag() //开启拖拽行为
  .on("dragstart", function(d, i) {
    //开始拖拽
    d3.event.sourceEvent.stopPropagation();
  })
  .on("drag", dragmove); //拖拽过程

function dragmove(d, i) {
  (x = d3.event.x - startX), (y = d3.event.y - startY);

  d3.select(this).attr("transform", function(d, i) {
    return `translate(${x}, ${y})`;
  });
}
```

第一次做的时候是在拖动开始的时候，获取鼠标的位置设置给 `startX`, 然后在拖动过程中，获取当前鼠标的位置再减去开始位置，设置给外层的`g`,这样做的话在拖动开始的时候会有一个卡顿，这是因为你在拖动开始的时候，获取的坐标会有一个偏差，最终你获取到的坐标不是你最开始的时候想要获取的，解决方法就是监听鼠标按下事件，在鼠标按下的时候获取坐标，然后就可以了。

```javascript
g.attr("transform", "translate(0,0)")
  .on("mousedown", function() {
    startX = d3.mouse(this)[0];
    startY = d3.mouse(this)[1];
  })
  .call(dragListener);
```

在 pc 端可以了，但是在 pad 上的时候出现了问题，pad 上需要绑定触摸事件,后来找到了一个很棒的代替拖拽的事件，`zoom`缩放事件，自带拖拽功能，如果是整体拖拽的话缩放事件完全可以。

#### 缩放

缩放事件和拖拽差不多，在你开启缩放事件后，d3 会自动记录下你当前缩放的参数，

```javascript
translate_x = d3.event.transform.x;
translate_y = d3.event.transform.y;
scale_cur = d3.event.transform.k;
//设置拖拽的参数
d3.select(".group").attr(
  "transform",
  `translate(${translate_x},${translate_y})scale(${scale_cur},${scale_cur})`
);
```

缩放事件还有一个`scaleExtent([1,10])`方法可以设置放到最大和最小的级别
完整的代码

```javascript
const zoom = d3
  .zoom()
  .scaleExtent([1, 10])
  .on("zoom", () => {
    translate_x = d3.event.transform.x;
    translate_y = d3.event.transform.y;
    scale_cur = d3.event.transform.k;
    d3.select(".group").attr(
      "transform",
      `translate(${translate_x},${translate_y})scale(${scale_cur},${scale_cur})`
    );
  });

d3.select(".rootSvg").call(zoom);
```

关键的是最后调用的这个`zoom`的元素,调用 zoom 的元素不是包裹 path 的 g,而是最外层的 svg,这样缩放行为才能实现。

```html
<svg class="rootSvg">
    <g class="group">
        ...
    </g>
</svg>
```

svg 比 canvas 方便的一点就是我可以用操作 dom 的方式来操作我画出来的图形，我还可以给我的图形加`class`，然后通过`class`来设置图形的显示

### 地图

d3.js 绘制地图需要用到它封装好的投影功能，项目中使用的墨卡托投影

```javascript
const projection = d3
  .geoMercator() //设置地图的二维投影
  .center(center) //设置地图的中心点
  .scale(scale) //设置地图的初始缩放级别
  .translate([viewWidth / 2, viewHeight / 2]); //设置地图平移距离
const path = d3
  .geoPath() //地理路径生成器
  .projection(projection);
```

#### 几个关于 projection 和 path 的应用技巧

- projection 可以将地图的坐标 转换为像素坐标并且在地图上显示出来
  利用这个可以在地图上渲染出点，添加图片或者显示文字都可以

```javascript
//d.cp是点坐标数组，经度在前，纬度在后
//经度转换为x坐标
projection(d.cp)[0];
```

- path 可以获取中心，也可以渲染 geoJson 数据直接渲染成 path 图形，比如说渲染出中国地图，部分代码如下
  利用这个可以直接生成地理路径，

```javascript
g.selectAll("path")
  .data(geoData) //geoJson的数据
  .enter() //遍历所有数据
  .append("g") //把所有的path都添加到这个g中
  .attr("class", function(d) {
    //设置g的class
    return d.properties.ename || d.properties.name;
  })
  .append("path") //在g中添加path
  .attr("stroke", "#858384") //path描边
  .attr("stroke-dasharray", "5,5") //path描虚线
  .attr("stroke-width", 1) //path描边的宽度
  .attr("fill", fillColor) //path填充的颜色 各个省份的填充颜色 可以通过class设置 fill
  .attr("fill-opacity", ".8")
  .attr("d", function(d) {
    return path(d); //通过path函数直接渲染出路径图形来 d必须是geoJson格式的数据
  });
if (fillColor == "none") {
  g.append("g")
    .attr("class", "townName")
    .selectAll("text")
    .data(geoData)
    .enter()
    .append("text")
    .attr("transform", d => {
      //path.centroid(d)可以获取路经的中心点，比如说获取山西省的中心点，然后把text平移到中心点，显示省份名称
      return `translate(${path.centroid(d)[0]},${path.centroid(d)[1]})`;
    })
    .text(d => {
      if (d.properties.ename == "taiwan") {
        return "";
      } else if (!/[区,县]/g.test(d.properties.name)) {
        return d.properties.name;
      } else {
        return "";
      }
    })
    .attr("font-size", "10px")
    .attr("fill", "#A9A9A9");
}
```

渲染出地图来了，然后说一下地图的数据

### 地图数据的获取

这里有俩种数据格式，`geoJson`和`topoJson`的数据格式,topoJson 的数据小，但是需要引入`import * as topojson from 'topojson';`然后在渲染的时候调用 topojson 提供的方法把 topojson 格式的数据转换成 geojson 的数据

```javascript
//china_top.json 是由 china_geo.json 文件转换成的 topojson
chinaData = require("./../data/common/china_top.json");
//在使用数据前需要转换成 geoJson 格式的数据 进行渲染
geoData = topojson.feature(chinaData, chinaData.objects.china_geo).features;
```

#### 福利网站

[geoJson 和 topojson 数据转换](http://mapshaper.org/) GeoJson 和 topojson 数据的转换
[geoJson 地图数据的获取](https://geojson-maps.ash.ms/) 这个网站可以获取到地图的 geojson 数据
[地图上线路图和国家名称数据的制作](http://geojson.io/#map=2/20.0/0.0) 如果中国地图划分了大区显示，需要显示大区名称，或者需要在地图上显示从太原到北京的路线图，真心推荐这个网站，你可以在地图上画线 标点，然后 网站会给你自动生成数据，再然后你就可以开心通过`path(d)`渲染出来了，不用再苦逼的去找坐标点。
![来油方式路线图](/../images/d3oliSource.png)
项目中最开心的事情就是用 nodejs 做各种处理数据的事情了，各种操作，然后在生成一个新的文件，过程简直爽的不要不要的，比如说我拿到的是中国各个省份的数据，我需要把各个省份的数据合并到一起，并且还需要给各个县市加上省份的名称，用 nodejs 只需要写写逻辑，运行一下代码，就可以拿到自己想要的数据。

#### 路径增加运动点

这里就需要用到 svg 的一个运动图标的知识了`animateMotion`

```html
<circle>
    <animateMotion dur="3s" repeatCount="indefinite" rotate="auto">
        <mpath href="pathId"></mpath>
    </animationMotion>
</circle>
```

- 外层可以是 circle 也可以是 图片 是运动的图标
- animateMotion 属性 dur 运动的时间
  repeatCount 重复次数
  rotate 运动时 外层运动图标的朝向
- mpath 这个元素的 href 属性放置的是路径 path 的 id
  如果有一个已经定义好的 path，那么外层的 circle 就会沿着这个 path 运动
