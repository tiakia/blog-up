---
title: 前端导出Excel文件
abbrlink: 4824
date: 2019-01-30 14:53:30
tags: xlsx
categories: javascript
---

在做项目的过程中遇到一个需求，需要把前端页面的表格导出到本地生成`Excel`文件，一直以为需要靠后端的协助，后来发现了一个非常棒的工具库`js-xlsx`，可以在不依靠后端的情况下，前端自己来生成`Excel`文件，后端只要返回前端表格需要的数据就可以，不需要在进行一次请求，在这里记录一下这个库的使用过程。

<!-- more -->

### 安装

```bash
npm install xlsx
```

`js-xlsx`库很强大，既能导出 EXCEL 文件，也可以将数据导出为 EXCEL，就是官方文档不太友好，这里推荐阅读文末的参考链接

### 使用

```javascript
import xlsx from "xlsx";
```

#### xlsx.utils

`xlsx.utils`提供的工具函数

- `json_to_sheet`: 把一个 JSON 数据转换为`sheet`数据
- `table_to_sheet`: 把表格 DOM 元素转换成可导出的`sheet`数据
- `aoa_to_sheet`: 这个工具类最强大也最实用了，将一个二维数组转成 `sheet`，会自动处理 `number`、`string`、`boolean`、`date` 等类型数据；
- `sheet_add_aoa`: 将一个二维数组添加到已经存在的工作表中
- `sheet_add_json`: 将 JSON 数据添加到已经存在的工作表中

后俩种很少用到，本文的实例中使用的是`json_to_sheet`，同样的还有将表格文件导出为数据的，`sheet_to_json`/`sheet_to_csv`/`sheet_to_txt`/`sheet_to_html`/`sheet_to_formulae`这些见名知意，就不详细的描述了

#### `xlsx.read` 读取表格

`xlsx.read(data,{type:type})`,返回一个叫 WorkBook 的对象，type 主要取值如下：

> - `base64`: 以 base64 方式读取
> - `binary`: BinaryString 格式(byte n is data.charCodeAt(n))
> - `string`: UTF8 编码的字符串
> - `buffer`: nodejs Buffer
> - `array`: Uint8Array，8 位无符号数组
> - `file`: 文件的路径（仅 nodejs 下支持）；

#### `WorkBook`对象

返回的 workBook 对象我们只需关注俩个重要的属性`SheetName`和`Sheets`

- `SheetName` 里存放的是表格的名字，例如：sheet1,sheet2
- `Sheets` 数组存放的是对应 `SheetName` 中每个表格的数据，也就是我们要获取的表格数据,表格数据的具体表现形式请参考文末的参考链接，这里就不赘述了，因为工具库`xlsx.utils`已经给我们封装好了处理函数，获取到表格数据后我们就可以转换为我们需要的数据形式，比如`sheet_to_json`,直接就可以获得我们需要的 JSON 数据

#### `xlsx.write` 导出表格

这里是本文的重点,划重点---使用`json_to_sheet`将后端返回的 JSON 数据转换成我们需要的表格数据，然后生成`Blob`格式的文件，下载，实现导出表格数据功能。

封装了一个工具函数

```javascript src/utils/exportExcel.js
import xlsx from "xlsx";
const jsonToSheet = xlsx.utils.json_to_sheet;

export default function exportExcel(sheetData, saveName, sheetName = "sheet1") {
  let sheet = jsonToSheet(sheetData, {
    skipHeader: true //忽略第一行，表格导出的时候不会显示第一行的数据
  });
  //可以在这里处理单元格合并
  /*
    sheet['!merge'] = [
        // 设置A1-C1的单元格合并
        // s表示开始， e表示结束
        // r表示行， c表示列
        {s: {r: 0, c: 0}, e: {r: 0, c: 2}}
    ]
  */
  let workbook = {
    SheetNames: [sheetName], //表格的名字
    Sheets: {} //表格数据
  };
  workbook.Sheets[sheetName] = sheet;
  //第一种方法：
  /*
  // 生成excel的配置项
  let wopts = {
    bookType: 'xlsx', // 要生成的文件类型
    bookSST: false, // 是否生成Shared String Table，官方解释是，如果开启生成速度会下降，但在低版本IOS设备上有更好的兼容性
    type: 'binary',
  };
  let wbout = xlsx.write(workbook, wopts);
  let blob = new Blob([s2ab(wbout)], { type: 'application/octet-stream' });
  // 字符串转ArrayBuffer
  function s2ab(s) {
    let buf = new ArrayBuffer(s.length);
    let view = new Uint8Array(buf);
    for (let i = 0; i !== s.length; ++i) view[i] = s.charCodeAt(i) & 0xff;
    return buf;
  }*/
  //第二种方法：
  // 生成excel的配置项
  let wopts = {
    bookType: "xlsx", // 要生成的文件类型
    bookSST: false, // 是否生成Shared String Table，官方解释是，如果开启生成速度会下降，但在低版本IOS设备上有更好的兼容性
    type: "array" // 返回一个ArrayBuffer
  };
  let wbout = xlsx.write(workbook, wopts);
  let blob = new Blob([wbout], {
    type: "text/plain" //创建一个装填ArrayBuffer对象的Blob对象
  });
  //第二种方法比较方便，直接创建一个ArrayBuffer的Blob对象
  if (typeof blob == "object" && blob instanceof Blob) {
    blob = URL.createObjectURL(blob); // 创建blob地址
  }
  let aLink = document.createElement("a");
  aLink.href = blob;
  // HTML5新增的属性，指定保存文件名，可以不要后缀，注意，file:///模式下不会生效
  aLink.download = saveName || "导出.xlsx";
  //可以在这里给aLink增加点击事件
  /* aLink.click(); */
  let event;
  if (window.MouseEvent) {
    event = new MouseEvent("click");
  } else {
    event = document.createEvent("MouseEvents");
    event.initMouseEvent(
      "click",
      true,
      false,
      window,
      0,
      0,
      0,
      0,
      0,
      false,
      false,
      false,
      false,
      0,
      null
    );
  }
  //自定义事件的触发dispatchEvent
  //也可以直接给aLink添加点击事件
  aLink.dispatchEvent(event);
}
```

使用封装的工具函数

```javascript
exportSheet = async () => {
  const {
    speedMarket: { archiveDetail }
  } = this.props;
  let sheetData = [
    {
      id: "序号",
      cust_name: "客户姓名",
      certificate_type: "证件类型",
      certificate_no: "证件号码",
      cust_sex: "性别",
      credit_no: "卡号",
      teller_no: "柜员号",
      teller_name: "柜员姓名",
      ab_user: "客户经理号",
      ab_name: "客户经理姓名",
      card_status: "卡片状态"
    },
    ...archiveDetail.map((val, idx) => {
      val.id = idx + 1; //原始数据中增加序号一列
      return val;
    })
  ];
  await exportExcel(sheetData, "快速营销-绩效详情表.xlsx");
  message.info("导出成功");
};
```

> 参考链接

- [js-xlsx](https://github.com/SheetJS/js-xlsx)
- [如何使用 JavaScript 实现纯前端读取和导出 excel 文件](https://www.cnblogs.com/liuxianan/p/js-excel.html#%E5%AF%BC%E5%87%BAexcel)
