---
title: canvas加水印
abbrlink: 46670
date: 2019-9-4 19:03:40
tags: canvas
categories: canvas
---

我们都知道用 canvas 加水印的步骤：

1.  创建一个`canvas`，获取它的 2D 画笔`ctx`
2.  获取要加水印的图片`img`
3.  在图片完全加载后，获取图片的宽高设置给`canvas`
    <!-- more -->
4.  把图片画到`canvas`画布上`ctx.drawImage(img, x, y)`
5.  在`canvas`上画水印(`ctx.fillText()`)
6.  把`canvas`导出图片(`ctx.toDataURL('image/jpeg')`)

大体的步骤就是这样，中间可能会加一些，水印的旋转，水印样式的设置，这里介绍一个创建水印平铺的函数：

### createPattern

`ctx.createPattern(image, repetition)`

- `image` 可以是 HTML 的`img`元素/`svg`图片/`video`/`canvas`元素
- `repetition` 标识图片如何进行平铺
  - `repeat`
  - `repeat-x`
  - `repeat-y`
  - `no-repeat`

这里有一个例子，创建平铺的对象是`canvas`元素

```javascript
// 水印canvas
let waterMark = document.getElementById("waterMark");
let waterCtx = waterMark.getContext("2d");
// 水印 canvas 坐标旋转
waterCtx.rotate((-20 * Math.PI) / 180);
// 设置水印字体样式和文字
waterCtx.font = "20px Microsoft Yahei";
waterCtx.fillStyle = "rgba(255,255,255,0.5)";
waterCtx.fillText("晋商银行", -20, 65);
// 水印 canvas 坐标还原
waterCtx.rotate((20 * Math.PI) / 180);
// 新建图片，设置图片的URL
let img = new Image();
img.src = url;
img.onload = () => {
  // 创建展示图片的canvas
  let canvas = document.getElementById("previewImg");
  // 设置展示canvas的宽高为图片的宽高
  canvas.width = img.width;
  canvas.height = img.height;
  let ctx = canvas.getContext("2d");
  ctx.drawImage(img, 0, 0);
  // 创建平铺水印
  let pat = ctx.createPattern(waterMark, "repeat");
  // 填充水印
  ctx.fillStyle = pat;
  // 填充图片
  ctx.fillRect(0, 0, img.width, img.height);
};
```
