---
title: 使用canvas压缩图片
date: '2018-09-04 14:22'
categories: canvas
tags:
  - canvas
keywords:
  - canvas
  - fileReader
  - img
comments: true
abbrlink: 34974
thumbnailImage:
---

前俩天做了一个图片转 base64 上传的功能，发现如果图片的 base64 过大的话，请求会变的很慢，严重的直接超时了，所以想到了在上传前压缩一下图片，然后再上传到后台，这样可以大大的提高效率，在这里记录一下利用 canvas 压缩图片遇到的几个坑。完整代码会在文末给出。

<!-- more -->

#### 踩坑

1. 第一个坑，在压缩图片的时候没获取图片本身的宽高，给了一个 `600*480` 的定宽定高，因为是手机端的，在上传图片的时候都是几兆的图片，所以这块没任何问题。出问题的地方在 修改头像的时候，测试的时候上传的图片都是小图片，然后就出现了 压缩后的图片显示不完全，大部分都是空白的现象，这就是因为在压缩的时候没有考虑图片原本的宽高的情况。
2. 第二个坑，解决第一个坑的办法就是在图片加载完成后（onload），获取图片本身的宽高，然后赋值给`canvas`,这样进行操作，但是这有个坑就是，图片加载是异步的，在你`return`的时候，返回的可能是 `undefined` 而不是你需要的 压缩后的 base64。这里的解决方法是，新建一个 `Promise`，然后把结果 `resolve()` 返回去，在调用的时候 `.then()` 得到结果。

#### 知识点：

1. `canvas`的`toDataURL('image/png', 0.9)`; 把 canvas 画的图片转换为 base64,第一个参数表示的是图片的类型，第二个参数表示的是图片的清晰度。
2. 规定一个最大尺寸，如果图片本身的宽高大于这个尺寸，按照最大的一个边进行缩放，另一个根据图片的 比例 进行设置，然后设置给 `canvas`.

```javascript miniImage.js
export default async function miniSize(imgData, maxSize = 200 * 1024) {
  // const maxSize = 200 * 1024;

  if (imgData && imgData.files && imgData.files.size < maxSize) {
    return imgData.url;
  } else {
    console.log("----------------压缩图片-------------------");
    const canvas = document.createElement("canvas");
    let img = new Image();
    img.src = imgData.url;
    let ctx = canvas.getContext("2d");
    return new Promise(resolve => {
      img.addEventListener(
        "load",
        function() {
          //图片原始尺寸
          let originWidth = this.width;
          let originHeight = this.height;
          // 最大尺寸限制
          let maxWidth = 400,
            maxHeight = 400;
          // 目标尺寸
          let targetWidth = originWidth,
            targetHeight = originHeight;
          // 图片尺寸超过400x400的限制
          if (originWidth > maxWidth || originHeight > maxHeight) {
            if (originWidth / originHeight > maxWidth / maxHeight) {
              // 更宽，按照宽度限定尺寸
              targetWidth = maxWidth;
              targetHeight = Math.round(
                maxWidth * (originHeight / originWidth)
              );
            } else {
              targetHeight = maxHeight;
              targetWidth = Math.round(
                maxHeight * (originWidth / originHeight)
              );
            }
          }
          canvas.width = targetWidth;
          canvas.height = targetHeight;
          ctx.drawImage(img, 0, 0, targetWidth, targetHeight);
          let base64 = canvas.toDataURL("image/png", 0.9);
          resolve(base64);
        },
        false
      );
    });
  }
}
```

调用：

```javascript
onChangeImg = async (files, type, index) => {
  let previous = this.props.imagePicker.files;
  if (type === "add") {
    let result = miniSize(files[files.length - 1]);
    //使用 .then() 调用获得结果
    await result.then(res => {
      previous.push({ url: res });
    });
  } else if (type === "remove") {
    previous.splice(index, 1);
  }
  await this.props.dispatch({
    type: "imagePicker/saveImage",
    payload: {
      files: previous
    }
  });
};
```
