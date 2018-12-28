---
title: nodejs的魅力-fs模块
tags: [nodejs,fs]
date: 2018-03-01 09:10:40
categories: nodejs
description: nodejs读取文件、表格数据处理数据
thumbnail:
keywords: node-xlsx
---
nodejs的魔法之fs模板  
好久没有更新博客了，最近事真多，手头上又有外包项目，又有公司的项目，过段时间会出一个d3的总结，现在公司使用的就是d3描绘地图，记录一下踩过的坑和注意事项。前端时间为了学习node做了一个博客的后台，那会是第一次感受到了node的魅力，第一次使用是在做地图这个项目的时候，要处理大量的数据，都是一些重复性的操作，后来突然想到了node的fs模板，当时心就痒痒的，然后就试着跑了一段node。读出文件中的数据，然后再对数据处理，最后再把数据写入文件中。
<!-- more -->
```
/*
精简 world.json
生成的 world_m.json 只保留当前国家的名字
*/

const fs = require('fs');

fs.readFile('./../data/originData/world.json', function(err, data){
  if(err){
    return console.error(err);
  }
  //这里转换一下这样在命令行才可以看到数据
  const countrys = JSON.parse(data.toString());
  //可以随时打印一下看看数据格式
  //console.log(countrys); return;
  var type,
      geometry = {},
      properties = {};
      data = {
        "type": "FeatureCollection",
        "features": [

        ]
      }
  //遍历数据获取自己想要属性
  countrys.features.map(val => {
    type = val.type;
    geometry = val.geometry;
    properties = val.properties.NAME_LONG;
    data.features.push({
      "type": type,
      "properties": {"name": properties},
      "geometry": geometry
    });
  });
  //写入文件这里是同步写入
  fs.writeFile('./../data/world_m.json', JSON.stringify(data), {'encoding': 'utf8'},function(err){
    if(err){
      console.error(err);
    }else{
      console.log('文件写入成功');
    }
  })
});

```
当时，第一次打开`world_m.json`的时候浑身上下特别的通透，我好像掌握了什么了不得的技能，可能对后端来说这不是什么难事，但对于我一个前端来说，做到这真真是感受到了代码的魅力。紧随其后又存生成的world_m.json数据里面提取出与中国接壤的数据
```
/*
  从 world_m.json 世界地图数据中 提取出与中国接壤的国家的数据
  并生成 other.json 文件
*/
const fs = require('fs');

fs.readFile('./../data/world_m.json', function(err, data){
  if(err){
    return console.error(err);
  }
  const countrys = JSON.parse(data.toString());
  //console.log(countrys); return;
  var type,
      geometry = {},
      properties = {},
      data = {
        "type": "FeatureCollection",
        "features": [

        ]
      },
      countryName  = [
        "Afghanistan",
        "Bhutan",
        "Dem. Rep. Korea",
        "Iran",
        "Japan",
        "Kazakhstan",
        "Kyrgyzstan",
        "Lao PDR",
        "Mongolia",
        "Myanmar",
        "Nepal",
        "Pakistan",
        "Tajikistan",
        "Thailand",
        "Turkmenistan",
        "Uzbekistan",
        "Vietnam",
        "India",
        "Russian Federation",
        "Republic of Korea"
      ];//要提取的国家的名字

  countrys.features.map(val => {
    if(countryName.indexOf(val.properties.name) >= 0){
      console.log(val.properties.name);
      type = val.type;
      geometry = val.geometry;
      properties = val.properties.name;
      data.features.push({
        "type": type,
        "properties": {"name": properties},
        "geometry": geometry
      });
    }
  });
  fs.writeFile(`./../data/other.json`, JSON.stringify(data), {'encoding': 'utf8'},function(err){
    if(err){
      console.error(err);
    }else{
      console.log('文件写入成功:  '+ countryName);
    }
  })
});

```
第一次觉得数据处理这么有趣，也是第一次发现代码离我们这么近，昨天晚上帮我对象做Excel表格数据处理的时候，心血来潮我能不能用node读取表格中的数据，然后对数据处理好后，再写入表格中，这样就不用一个个的复制粘贴了，说干就干，网上招了个入门简单的`node-xlsx`插件，然后就开始了。。。，悲剧的是，有时候真的Excel表格的功能真的是很强大，它有去重，有排序的功能，所以我只要把数据对应的找出来然后生成表格复制到原来的表格中，使用人家自带的功能三俩下就出来了，偏偏自己走了弯路非要把没有对应的数据也要提出来，唉。。。以后再处理表格数据的时候就知道了，一些没必要代码做的东西，尽量不用。。。  
### node-xlsx
这个插件主要就是俩个功能，一个读取表格数据，还有一个就是写入表格数据。上手容易。
#### 读取表格
```
const xlsx = require('node-xlsx');
const fs = require('fs');

var list = xlsx.parse("./../data/myData/1.xlsx")[0].data;
```
读取的结果是一个大的数组，如果你的一个`xlsx`文件里有多个表格的话，那么就会以数组的形式读取出来  
```
[
    {
        name: "sheet1",//表格一的名字
        data: [
            //每一行的数据，包括表头
            //如果需要空几个单元格，赋值的时候直接 data[数组下标隔开几个] 
            //然后在生成表格的时候就会自动空开单元格
            //时间的话也完全不需要转，表格中的设置单元格式就可以转过来
        ]
    },
    {
        name: "sheet2",//表格二的名字
        data: [

        ]
    }
]
```
#### 写入表格
直接`fs.writeFile`写入的话是不会生成表格的。
```
var buffer = xlsx.build([
    {
        name:'sheet1',
        data: origin //写入数据
    }        
]);
fs.writeFile('./result.xlsx',buffer,function(err){
  if(err){
    console.log(err);
  }else{
    console.log("导出成功");
  }
})
```
好像是掌握了了不得的技能呢。。。哈哈，程序路漫漫呐