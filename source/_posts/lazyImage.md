---
title: 图片懒加载
date: 2018-10-10 17:59
categories: javascript
tags: [js]
keywords:
  - 图片懒加载
  - Intersection Observer
clearReading: true
thumbnailImage: http://pkafgcch8.bkt.clouddn.com/blog/window.png
thumbnailImagePosition: left  //缩略图显示的位置，上下左右都可以
autoThumbnailImage: true
metaAlignment: center  //文章页图片上的文字居中显示
coverImage: http://pkafgcch8.bkt.clouddn.com/cover/cover.jpg
coverCaption:
coverMeta: in
coverSize: full
comments: true
---

一直都想自己实现这个功能而不是知道原理不实践，这次突然看到掘金上的文章后，跟着走了一遍代码，原来不管什么效果只知道原理是远远不够的，你必须亲自实现一下，然后才知道其中的坑，也会学到更多。程序员就要勤于动手。

<!-- more -->

先放一张自己画的图，理清楚这几个高度的关系。

![clientHeight](./../images/window.png)

- 认识一个函数`let rectObj = element.getBoundingClientRect()`
  - 返回的对象`rectObj.top` 表示的是 该元素 距离视口（浏览器窗口）的距离，即图中的 `clientBoundRect.top`
  - 视口的高度 `document.documentElement.clientHeight`
  - `document.body.clientHeight` 获取的 网页的高度

> 这里参考了一下阮一峰大大的 获取元素 的绝对位置 和 相对位置

- 相对位置
  `element.getBoundingClientRect().top`
- 绝对位置
  相对位置 + 网页滚动过的距离
  `element.getBoundingClientRect().top + document.documentElement.scrollTop`

### 传统的 监听 Scroll 事件

在 scroll 事件中 我们只需要判断一下，元素距离浏览器窗口顶部的距离是否小于浏览器窗口的高度，就可以判断出 图片是否进入了 可视区域，
然后再使用节流函数， 每隔 200ms 调用一次 函数， 节省开销

```javascript lazy.js
//所有的图片
this.lazyImg.forEach((val, idx) => {
  let rectObj = val.getBoundingClientRect();
  // 如果当前元素距 视口 的距离 小于 视口的 高度
  // 此时元素处于可见范围
  if (rectObj.top < document.documentElement.clientHeight) {
    let actualSrc = val.dataset.src;
    val.setAttribute("src", actualSrc);
    val.removeAttribute("class");
    // 当滚动到最后一个图片后 移除 scroll 事件
    if (idx === this.lazyImg.length - 1) {
      window.removeEventListener("scroll", window.scrollFun);
    }
  }
});
```

#### 节流函数

> Get: 重新认识了一下 节流函数 记忆理解更深了一层

具体的节流函数可以查看我之前写的一篇[防抖节流的文章](http://www.tiankai.party/%E5%87%BD%E6%95%B0%E7%9A%84%E9%98%B2%E6%8A%96%E5%92%8C%E8%8A%82%E6%B5%81.html)

```javascript throttle.js
function throttle(fn, delay){
  let start = +new Date(),
  that = this,
  timer = null;
  return function(args){
    let _args = args,
    now = +new Date();
    if(now - start > delay){
      start = now;
      clearTimeout(timer);
      timer = setTimeout(() = > {
        fn.apply(that, _args);
      }, delay);
    }
  }
}

//调用方式
let throttleFun = throttle(scrollFun, 200);
window.addEventListener('scroll', () => {
  throttleFun(args);
});

```

### 新的 Intersection Observer API

使用分俩步：

- 新建 `Intersection Observer` 观察对象 `oberver`

```javascript observer.js
// new IntersctionObserver(callback, options)
let observer = new IntersctionObserver((entries, observer) => {
  entries.forEach(entry => {
    // entry.isIntersecting 标识元素是否进入可见区域
    // entry.target 观察的当前元素
    if (entry.isIntersecting) {
      let _target = entry.target;
      let actualSrc = _target.getAttribute("data-src");
      _target.removeAttribute("class");
      _target.setAttribute("src", actualSrc);
    }
  });
});
```

- `observer.observe(element)` 观察元素

```javascript observer.js
this.lazyImg.forEach(img => observer.boserve(img));
```

[完整代码](https://github.com/tiakia/some-demo/blob/master/lazyImg/lazyImage.html)

> 参考链接

[intersectionObserver - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API)

[阮一峰的网络日志](http://www.ruanyifeng.com/blog/2009/09/find_element_s_position_using_javascript.html)

[掘金](https://juejin.im/post/5bbc60e8f265da0af609cd04?utm_source=gold_browser_extension)
