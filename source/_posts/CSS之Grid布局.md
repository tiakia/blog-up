---
title: CSS之Grid布局笔记
tags:
  - grid
categories: css
description: css的grid布局初探
keywords: grid
abbrlink: 35836
date: 2017-09-28 15:36:03
thumbnail:
---

这是我学习 css grid 布局的笔记，我是通过 MDN 和掘金的一篇文章学习的，文章链接会放在文末，学习的最佳路径就是练习，把 MDN 的例子代码敲一遍，然后再一个个的改变属性观察变化，如果不懂的去掘金那个文章里面找，这样可以快速的掌握 grid 布局。

<!-- more -->

> CSS Grid 布局初探

父元素:

##### <font color=#f50> display:grid;</font>

设置父元素布局为 grid

##### <font color=#f50> grid-gap: 10px 15px;</font>

定义每个子元素竖直方向之间分割线为 `10px`,横向之间的分割线为 `15px`,相当于 `margin:10px 15px`，但是只作用于容器内部。

##### <font color=#f50>grid-template-columns: </font>

- ##### [first]100px [second col-2]1fr;

  每行只有俩个元素
  定义第一个个子元素宽为 100px
  第二个元素为剩下的空间
  [first] 定义单元的名字，默认是数字，一个单元可以有多个名字，以空格隔开
  fr 是除了固定宽度剩下的空间

- ##### repeat(3, 200px);

  定义每个子元素宽为 200px
  每一行只能有三个子元素

- ##### 200px repeat(auto-fill, 100px) 300px;

  如果宽度足够的话,第一个 200px,其后都是 100px;
  如果宽度不足另起一行了,那么第一行和第二行从第一个开始
  第一个 200px,最后一个 300px,中间的每个 100px

- ##### minmax(100px, max-content) repeat(auto-fill, 200px) 50%;
  如果宽度不足另起一行的话，
  定义第一个子元素最小宽度 100px,最大宽度为内容宽度
  中间每个 200px，平铺，
  最后一个占 body 宽度的 50%
  如果第一列内容宽度超出 100px,
  第二行的第一个的宽度和第一行的第一个宽度一样，类似于表格的自适应。
  如果宽度足够的话
  第一个子元素最小宽度 100px,最大宽度为内容宽度
  后面的每个都是 200px

##### <font color=#f50>grid-template-rows:</font>

- ##### [row-1]100px [row-2]150px;

  定义俩行元素的高度，第一行为 100px,第二行为 150px,其他的自适应
  对 rows 使用 fr，还是自适应，不产生实际效果

- ##### repeat(3, 100px)

  只定义头三行的高度，每行为 100px,其他的自适应

- ##### 200px repeat(auto-fill, 100px) 300px

  第一行 200px,第二行 100px,第三行 300px;

- ##### minmax(100px, max-content) repeat(auto-fill, 200px) 20%;
  第一行的高度最小为 100px,最高随内容自适应，
  第二行 200px
  剩下的行自适应

##### <font color=#f50> grid-template-areas:</font>

```css
#page {
  display: grid;
  margin-top: 30px;
  margin-bottom: 30px;
  width: 100%;
  height: 250px;
  grid-template-areas:
    "head head"
    "nav main"
    "nav foot";
  grid-template-rows: 50px 1fr 30px;
  grid-template-columns: 150px 1fr;
}
#page header {
  grid-area: head;
  background-color: #8ca0ff;
}
#page nav {
  grid-area: nav;
  background-color: #ffa08c;
}
#page main {
  grid-area: main;
  background-color: #ffff64;
}
#page footer {
  grid-area: foot;
  background-color: #8cffa0;
}
```

- area 的数量每行个数必须一样
- 俩个 nav 会合并,忽略 grid-template-columns 和 grid-template-rows 定义的规则
- 如果 grid-area 的形式和定义的行列规则不一致显示异常
- 如果定义了一行 grid-template-rows: 50px
  - 那么剩下的俩行平分剩下的空间高度
- 如果定义了俩行 grid-template-rows: 50px 1fr，
  - 第三行只有内容的高度，而俩个 nav 会合并，占据减去 50px 之后的 1fr，
  - foot 只有它内容的高度，main 占据减去 50 和 foot 内容高度后的空间
- 如果定义了四行 grid-template-rows: 50px 1fr 30px 20px，
  - 第四行会被空出来 20px 什么也不显示
- 如果定义了一列，剩下的内容占据剩下的空间
- 如果定义了三列 grid-template-columns: 150px 1fr 80px;
  - 但是 area 只写了俩列的结构那么整体会空出第三列 80px 的宽

##### <font color=#f50> grid-auto-columns/grid-auto-rows: （px,百分比,fr 自由空间份数）</font>

自动生成隐式网格轨道(列和行),
你定位网格项超出网格容器范围时，将自动创建隐式网格轨道

```css
    .container{
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      grid-gap: 10px;
      grid-auto-rows: minmax(100px, auto);
    }
    .one{
      grid-column: 1/3;
      grid-row: 1;
    }
    .container定义了行的隐式轨道，最小100px，最大自动缩放
    .one定义在第一列开始，第三列结束
        占据一个行单位
```

完整代码

```html
<!doctype html>
<html>
  <head>
    <title>CSS Grid Layout</title>
    <meta charset="utf-8"/>
    <style>
      .container{
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          grid-gap: 10px;
          grid-auto-rows: minmax(100px, auto);
      }
      .container>div{
          background:orange;
          border: 1px solid red;
          border-radius: 5px;
          opacity: .6;
      }
      .one{
          grid-column: 1/3;
          grid-row: 1;
      }
      .two{
          grid-column: 2/4;
          grid-row: 1/3;
      }
      .three{
          grid-column: 1;
          grid-row: 2/5;
      }
      .four{
          grid-column: 3;
          grid-row: 3;
      }
      .five{
          grid-column: 2;
          grid-row: 4;
      }
      .six{
          grid-column: 3;
          grid-row: 4;
      }
      #grid{
          display: grid;
          width: 100%;
          margin-top: 100px;
          grid-template-columns: minmax(100px, max-content) repeat(auto-fill, 200px) 50%;
          grid-template-rows: minmax(100px, max-content) repeat(auto-fill, 200px) 20%;
      }
      .areaA{
          background-color: #999;
          border: 1px solid #000;
      }
      #page{
          display: grid;
          margin-top: 30px;
          margin-bottom: 30px;
          width: 100%;
          height: 250px;
          grid-template-areas: "head head"
                               "nav main"
                               "nav foot";
          grid-template-rows: 50px 1fr 30px;
          grid-template-columns: 150px 1fr;
      }
      #page header{
          grid-area: head;
          background-color: #8ca0ff;
      }
      #page nav{
          grid-area: nav;
          background-color: #ffa08c;
      }
      #page main{
          grid-area: main;
          background-color: #ffff64;
      }
      #page footer{
          grid-area: foot;
          background-color: #8cffa0;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="one">one</div>
      <div class="two">two</div>
      <div class="three">three</div>
      <div class="four">four</div>
      <div class="five">five</div>
      <div class="six">six</div>
    </div>
    <div id="grid">
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
      <div class="areaA">areaA</div>
    </div>
    <div id="page">
      <header>Header</header>
      <nav>Navigation</nav>
      <main>Main area</main>
      <footer>Footer</footer>
    </div>
  </body>
</html>
```

> 页面

![](/../images/grid.png)

##### 把代码粘贴下来，然后在浏览器里试验各种属性和属性值，这是最快的方法

> 参考链接

- [掘金](https://juejin.im/entry/5894135c8fd9c5a19507f6a1)
- [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout)
