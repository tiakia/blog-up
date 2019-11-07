---
title: antd引出的文件上传
abbrlink: 57419
date: 2019-8-2 15:02:07
tags:
categories:
---

`antd`的`upload`组件可以实现文件上传，在实现自己控制的文件上传时，用到了`FormData`对象,趁此机会好好了解一下。

<!-- more -->

文件上传需要设置`http`的 `header`字段为`Content-Type: multipart/form-data`

### FormData

`FormData`对象把数据用表单的形式来发送。

**方法：**

- `append(name, value, filename)`

  向 FormData 中添加新的属性值，FormData 对应的属性值存在也不会覆盖原值，而是新增一个值，如果属性不存在则新增一项属性值。

  - `name`: `value` 中包含的数据对应的表单名称。

  - `value`: 发送的数据可以是 `String` 、`file` 或者 `Blob` 类型

  - `filename`: 传给服务器的文件名称（当`value`是`Blob`或`File`时 `Blob`的默认文件名称是`blob`,`File` 对象的默认文件名是该文件的名称。

    ```javascript
    // 新增数组
    let formData = new FormData();
    formData.append("files[]", file);
    ```

- `get(name)`

  返回在 FormData 对象中与给定键关联的第一个值。

- `getAll(name)`

  返回一个包含 FormData 对象中与给定键关联的所有值的数组。

- `has(name)`

  返回一个布尔值表明 FormData 对象是否包含某些键。

- `set(name, value, filename)`

  给 FormData 设置属性值，如果 FormData 对应的属性值存在则覆盖原值，否则新增一项属性值。

- `values()`

  返回一个包含所有值的 iterator 对象。

#### 创建`FromData`对象

```javascript
let formData = new FormData();
formData.append("username", "TK");
formData.append("phone", 1343232343); // 数字会被转换成字符串

// HTML 文件类型input，由用户选择
formData.append("userfile", fileInputElement.files[0]);

// JavaScript file-like 对象
var content = '<a id="a"><b id="b">hey!</b></a>'; // 新文件的正文...
var blob = new Blob([content], { type: "text/xml" });

formData.append("webmasterfile", blob);

var request = new XMLHttpRequest();
request.open("POST", "http://foo.com/submitform.php");
request.send(formData);
```

**注意：字段 "userfile" 和 "webmasterfile" 都包含一个文件.
字段 "accountnum" 是数字类型，它将被 FormData.append()方法转换成字符串类型
(FormData 对象的字段类型可以是 Blob, File, 或者 string:
如果它的字段类型不是 Blob 也不是 File，则会被转换成字符串类)。**

#### HTML 中的 FormData 对象

```javascript
// 获取 form 表单
let form = document.getElementById("form");
// 创建 FormData 对象
var formData = new FormData(form);
// 发起XML请求
var request = new XMLHttpRequest();
request.open("POST", "submitform.php");
// 发送数据前添加额外的数据
formData.append("serialnumber", serialNumber++);
request.send(formData);
```

### FileReader

类似`FormData`都可以用来处理文件上传，不过它是异步的。

```javascript
const reader = new FileReader();
```

根据 MDN 文档的阐释:

> FileReader 对象允许 Web 应用程序异步读取存储在用户计算机上的文件（或原始数据缓冲区）的内容，使用 File 或 Blob 对象指定要读取的文件或数据。
> 其中 File 对象可以是来自用户在一个元素上选择文件后返回的 FileList 对象,也可以来自拖放操作生成的 DataTransfer 对象,还可以是来自在一个 HTMLCanvasElement 上执行 mozGetAsFile()方法后返回结果。

**方法：**

- `readAsDataURL()`

  开始读取指定的 `Blob` 中的内容。一旦完成，`result` 属性中将包含一个 `data: URL` 格式的 `Base64` 字符串以表示所读取文件的内容。

- `readAsText()`

  开始读取指定的`Blob`中的内容。一旦完成，`result`属性中将包含一个字符串以表示所读取的文件内容。

- `readAsArrayBuffer()`

  开始读取指定的 `Blob`中的内容, 一旦完成, `result` 属性中保存的将是被读取文件的 `ArrayBuffer` 数据对象.

- `readAsBinaryString()`

  开始读取指定的`Blob`中的内容。一旦完成，`result`属性中将包含所读取文件的原始二进制数据。

- `abort()`

  中止读取操作。在返回时，`readyState` 属性为 `DONE`。

**onload 事件**: FileReader 实例读取文件是异步的，该事件在读取操作开始时触发

#### 使用 FileReader

```javascript
const reader = new FileReader();
// 读取文件内容，结果用data:url的字符串形式表示
reader.readAsDataURL(e.target.files[0]);
// 异步读取，等待读取操作的完成
reader.onload = function(e) {
  console.log(e.target.result); // 上传的图片的base64编码
};
```

读取多个文件：

```html
<input id="browse" type="file" onchange="previewFiles()" multiple>
<div id="preview"></div>
```

```javascript
function previewFiles() {
  var preview = document.querySelector("#preview");
  var files = document.querySelector("input[type=file]").files;

  function readAndPreview(file) {
    // 确保 `file.name` 符合我们要求的扩展名
    if (/\.(jpe?g|png|gif)$/i.test(file.name)) {
      var reader = new FileReader();

      reader.addEventListener(
        "load",
        function() {
          var image = new Image();
          image.height = 100;
          image.title = file.name;
          image.src = this.result;
          preview.appendChild(image);
        },
        false
      );

      reader.readAsDataURL(file);
    }
  }

  if (files) {
    [].forEach.call(files, readAndPreview);
  }
}
```

> 参考链接

- [FormData 对象的使用（MDN）](https://developer.mozilla.org/zh-CN/docs/Web/API/FormData/Using_FormData_Objects)
- [FileReader(MDN)](https://developer.mozilla.org/zh-CN/docs/Web/API/FileReader)
