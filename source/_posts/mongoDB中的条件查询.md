---
title: mongoDB中的条件查询
tags: [mongodb]
date: 2017-12-22 09:48:34
categories: 数据库
description:
thumbnail:
keywords:
---

mongodb的查找有`find`和`findOne`俩种，`find`是查找数据库中所有的记录，以数组的形式展示出来，`findOne`是只查找符合条件的一条数据。
```
//findOne() 查找contentId的文章
Content.findOne({
    _id: contentId
}).then(content=>{

});
//find() 查找所有的文章
Content.find().then(contentArray=>{

});
```
<!-- more -->
### 条件查询


条件操作符 | 含义
---|---
"$lt" |  <
"$lte" |  <=
"$gt"| >
"$gte"| >=
"$ne"| !=
"$in"| 包含
"$nin"| 不包含
"$or" | 查询匹配多个条件多个值的文档
"$all" | 匹配所有
"$exists"| 判断文档属性是否存在
"$size" | 查询特定长度的数组的
"$slice"| find的第二个参数
正则表达式 | db.B.find({"name":/jack/i})
"$where" | 

某集合B集合中文档有属性x值为整数，需查找`10<x<=30`的文档，写法如下：
```
db.B.find({"x":{"$gt":10,"$lte":30}})
```
#### $ne 
查询数据库中分类`id`不等于当前分类`id`，但是分类名称相同的数据
```
Category.findOne({
    _id: {$ne: id},
    name: newName
});
```
#### $in
可以用来查询一个键的多个值  
查询数据库中特定分类下的文章
```
Content.find({"category":{"$in":["Nodejs","CSS"]}})
```
#### $or 
写法：字段1 = 'xxx' or 字段2 in ( 'xxx')  
```
Content.find({"$or":[{"category":{"$in":["Nodejs","CSS"]},{"author": "admin"}}]})
```
#### $all
完全匹配  
比如文档：要找既有`2`又有`3`的就得用`$all`
```
{"name":jack,"age":[1,2,3]}  
{"name":jack,"age":[1,4,3]} 

db.B.find({"age":{"$all":[2,3]}})
```
结果：
```
{"name":jack,"age":[1,2,3]}
```
#### $exists
```
db.B.find({"name":{"$exists":true}})   --查找属性name存在的文档
db.B.find({"name":{"$exists":false}})  --查找属性name不存在的文档
```
#### 属性值为 null
如下操作并可知道：
```
> db.C.find()
{ "_id" : ObjectId("5018fccd1781352fe25bf511"), "a" : "14", "b" : "14" }
{ "_id" : ObjectId("5018fccd1781352fe25bf512"), "a" : "15", "b" : "15" }
{ "_id" : ObjectId("5018fccd1781352fe25bf510"), "a" : "13", "b" : "13", "c" : null }
> db.C.find({"c":null})
{ "_id" : ObjectId("5018fccd1781352fe25bf511"), "a" : "14", "b" : "14" }
{ "_id" : ObjectId("5018fccd1781352fe25bf512"), "a" : "15", "b" : "15" }
{ "_id" : ObjectId("5018fccd1781352fe25bf510"), "a" : "13", "b" : "13", "c" : null }
```
可见查询属性c值为null文档，包括属性c值为null、该属性c不存在两个部分。若想只查询属性c为null的文档
如下：
```
> db.C.find({"c":{"$in":[null],"$exists":true}})
{ "_id" : ObjectId("5018fccd1781352fe25bf510"), "a" : "13", "b" : "13", "c" : null }
```
#### 查询数组指定位置的元素
```
key.index
```
如下操作：fruits.1 查询 fruits 数组的第二个元素为 orange 的数据
```
db.fruitshop.find();  
{ "_id" : ObjectId("5022518d09248743250688e0"), "name" : "big fruit", "fruits" : [ "apple", "pear", "orange" ] }  
{ "_id" : ObjectId("5022535109248743250688e4"), "name" : "fruit king", "fruits" : [ "apple", "orange", "pear" ] }  
{ "_id" : ObjectId("502253c109248743250688e5"), "name" : "good fruit", "fruits" : [ "apple", "orange", "pear", "banana" ] }  

> db.fruitshop.find({"fruits.1":"orange"});  
{ "_id" : ObjectId("5022535109248743250688e4"), "name" : "fruit king", "fruits" : [ "apple", "orange", "pear" ] }  
{ "_id" : ObjectId("502253c109248743250688e5"), "name" : "good fruit", "fruits" : [ "apple", "orange", "pear", "banana" ] }  
```
#### $size
条件操作符`"$size"`不能和其他操作符连用如`"$gt"`等  
```
> db.C.find()
{ "_id" : ObjectId("501e71557d4bd700257d8a41"), "a" : "1", "b" : [ 1, 2, 3 ] }
{ "_id" : ObjectId("501e71607d4bd700257d8a42"), "a" : "1", "b" : [ 1, 2 ] }
//查询 长度为 2 的 b 数组
> db.C.find({"b":{"$size":2}})
{ "_id" : ObjectId("501e71607d4bd700257d8a42"), "a" : "1", "b" : [ 1, 2 ] }
```
#### $slice
```
find(条件,{key:{$slice:[2,3]}})
```
`"$slice"`也可以从后面截取，用复数即可，如-1表明截取最后一个；还可以截取中间部分，如[2,3]，即跳过前两个，截取3个，如果剩余不足3个，就全部返回！
```
> db.fruitshop.find();  
{ "_id" : ObjectId("5022518d09248743250688e0"), "fruits" : [ "apple", "pear", "orange", "strawberry", "banana" ], "name" : "big fruit" }  
{ "_id" : ObjectId("5022535109248743250688e4"), "fruits" : [ "apple", "orange", "pear" ], "name" : "fruit king" }  
{ "_id" : ObjectId("502253c109248743250688e5"), "fruits" : [ "apple", "orange", "pear", "banana" ], "name" : "good fruit" }  

> db.fruitshop.find({}, {"fruits":{"$slice":-1}});  
{ "_id" : ObjectId("5022518d09248743250688e0"), "fruits" : [ "banana" ], "name" : "big fruit" }  
{ "_id" : ObjectId("5022535109248743250688e4"), "fruits" : [ "pear" ], "name" : "fruit king" }  
{ "_id" : ObjectId("502253c109248743250688e5"), "fruits" : [ "banana" ], "name" : "good fruit" }  

> db.fruitshop.find({}, {"fruits":{"$slice":[3,6]}});  
{ "_id" : ObjectId("5022518d09248743250688e0"), "fruits" : [ "strawberry", "banana" ], "name" : "big fruit" }  
{ "_id" : ObjectId("5022535109248743250688e4"), "fruits" : [ ], "name" : "fruit king" }  
{ "_id" : ObjectId("502253c109248743250688e5"), "fruits" : [ "banana" ], "name" : "good fruit" }  
```
如果第二个参数中有个键使用了条件操作符`"$slice"`，则默认查询会返回所有的键，如果此时你要忽略哪些键，可以手动指明！如：
```
db.fruitshop.find({}, {"fruits":{"$slice":[3,6]}, "name":0, "_id":0});  
{ "fruits" : [ "strawberry", "banana" ] }  
{ "fruits" : [ ] }  
{ "fruits" : [ "banana" ] }  
```
#### $where
`$where`的值可以是function、也可以是字符串等等。 

**注意**: 采用`$where`子句查询在速度上较常规查询慢的多。因文档需要从BSON转换成javascript对象，然后通过`"$where"`的表达式来运行。

##### 最典型的应用：一个文档，如果有两个键的值相等，就选出来，否则不选：
```
> db.fruitprice.find();  
{ "_id" : ObjectId("50226b4c3becfacce6a22a5b"), "apple" : 10, "banana" : 6, "pear" : 3 }  
{ "_id" : ObjectId("50226ba63becfacce6a22a5c"), "apple" : 10, "watermelon" : 3, "pear" : 3 }  
> db.fruitprice.find({"$where":function () {  
... for(var current in this){  
...     for(var other in this){  
...         if(current != other && this[current] == this[other]){  
...             return true;  
...         }  
...     }  
... }  
... return false;  
... }});  
{ "_id" : ObjectId("50226ba63becfacce6a22a5c"), "apple" : 10, "watermelon" : 3, "pear" : 3 }  
```
在实际应用中一般可用常规查询做前置过滤，配置"$where"查询进行调优，可达到不牺牲性能的要求。即将"$where"放最后。