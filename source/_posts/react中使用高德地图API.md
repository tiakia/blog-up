---
title: 使用高德地图API
abbrlink: 60639
date: 2019-10-24 15:08:53
tags: ["高德地图"]
categories: javascript
---

以前一直使用的都是百度地图的 API，这次换了高德地图尝试了一下，真香。高德地图它的 API 种类很全，文档例子也很清楚，相比较于百度地图感觉百度好像不常更新维护了。

<!-- more -->

列举一下用到的功能：

1. 地图展示，设置中心点、缩放级别
2. 设置地图遮罩
3. 设置可视范围
4. 获取 geoJson 数据画图
5. 自定义信息展示窗体

### 地图的创建

```javascript
let map;
map = new AMap.Map("container", {
  resizeEnable: true, // 是否监控地图容器尺寸变化
  zoom: 6,
  zooms: [6, 16], // 初始化地图层级
  center: [112.565972, 37.865858] // 初始化地图中心点
});
```

### 设置遮罩

```javascript
// 设置遮罩
new AMap.DistrictSearch({
  extensions: "all",
  subdistrict: 0
}).search("山西省", function(status, result) {
  // 外多边形坐标数组和内多边形坐标数组
  let outer = [
    new AMap.LngLat(-360, 90, true),
    new AMap.LngLat(-360, -90, true),
    new AMap.LngLat(360, -90, true),
    new AMap.LngLat(360, 90, true)
  ];
  let holes = result.districtList[0].boundaries;

  let pathArray = [outer];
  pathArray.push.apply(pathArray, holes);
  let polygon = new AMap.Polygon({
    pathL: pathArray,
    strokeColor: "#00eeff",
    strokeWeight: 1,
    fillColor: "#ddd",
    fillOpacity: 0.5
  });
  polygon.setPath(pathArray);
  map.add(polygon);
});
```

![amap-react-5](/../images/amap-react-5.png)

### 设置可视范围

```javascript
// 设置可视范围
//通过 new AMap.Bounds(southWest:LngLat, northEast:LngLat) 或者 map.getBounds() 获得地图Bounds信息
let bounds = map.getBounds();
map.setLimitBounds(bounds);
```

### 设置分管片区

`mapJson`为`GeoJSON`地图数据，这里提供几个网站：

- [获取需要的 GeoJSON 数据](http://geojson.io/)
- [获取世界、国家的地图 GeoJSON 数据](https://geojson-maps.ash.ms/)
- [GeoJSON 数据精简](https://mapshaper.org/)

```javascript
// 设置分管片区
let geojson = new AMap.GeoJSON({
  geoJSON: mapJson,
  // 还可以自定义getMarker和getPolyline
  getPolygon: function(geojson, lnglats) {
    // 计算面积
    let {
      properties: { color }
    } = geojson;

    return new AMap.Polygon({
      path: lnglats,
      fillOpacity: 0.1, // 面积越大透明度越高
      strokeColor: "white",
      fillColor: color
    });
  }
});
geojson.setMap(map);
```

![amap-react-2](/../images/amap-react-2.png)

### 添加坐标点

```javascript
// 添加点坐标
// marker 为每个坐标点的信息
addMarker = marker => {
  let { areaName, longitude, latitude, branchName } = marker;
  let icon;

  if (!Number(longitude) || !Number(latitude)) {
    message.warn(
      `${branchName}: 坐标错误 - longitude: ${longitude},latitude: ${latitude}`
    );
    return;
  }
  // 百度坐标转换为高德坐标
  AMap.convertFrom(
    [Number(longitude), Number(latitude)],
    "baidu",
    (status, result) => {
      if (status === "complete") {
        let _marker = new AMap.Marker({
          position: [result.locations[0].lng, result.locations[0].lat], // [Number(longitude), Number(latitude)],
          icon: `${require("./../../../assets/default.png")}`
        });
        _marker.setTitle(branchName + "-" + areaName);
        // 根据不同的分区设置不同的坐标点
        switch (areaName) {
          case "并州分管区":
            icon = require("src/assets/area1.png");
            break;
          case "晋阳分管区":
            icon = require("src/assets/area2.png");
            break;
          case "龙城分管区":
            icon = require("src/assets/area3.png");
            break;
          case "综改分管区":
            icon = require("src/assets/area4.png");
            break;
          default:
            icon = require("src/assets/default.png");
        }
        _marker.setIcon(icon);
        _marker.setMap(map);

        // 鼠标点击marker弹出自定义的信息窗体
        let that = this;
        AMap.event.addListener(_marker, "click", () => {
          that.showInfo(marker).open(map, _marker.getPosition());
        });
      }
    }
  );
};
```

![amap-react-1](/../images/amap-react-1.png)

![amap-react-4](/../images/amap-react-4.png)

### 自定义显示窗体

```javascript
// 点击坐标点显示信息
showInfo = item => {
  // 实例化信息窗体
  let that = this;
  let title = `${item.branchName}- ${item.branchNo}`,
    content = [];
  content.push(
    `<b>机构名称：</b><strong>${item.branchName}(${item.branchNo})</strong>`
  );
  content.push(`<b>地址：</b>${item.address}`);
  content.push(`<b>地区：</b>${item.areaName}`);
  let infoWindow = new AMap.InfoWindow({
    isCustom: true, // 使用自定义窗体
    content: createInfoWindow(title, content.join("<br/>")),
    offset: new AMap.Pixel(16, -25)
  });

  // 构建自定义信息窗体
  function createInfoWindow(title, content) {
    var info = document.createElement("div");
    info.className = "custom-info input-card content-window-card";

    // 可以通过下面的方式修改自定义窗体的宽高
    // info.style.width = "400px";
    // 定义顶部标题
    var top = document.createElement("div");
    top.className = "info-top";

    let logoImg = document.createElement("img");
    logoImg.src = require("src/assets/logo.jpg");
    logoImg.style.width = "100px";

    var closeX = document.createElement("i");
    closeX.innerText = "×";
    closeX.className = "closeImg";
    closeX.onclick = closeInfoWindow;

    top.appendChild(logoImg);
    top.appendChild(closeX);
    info.appendChild(top);

    // 判断是涨是跌
    function judge(before, current) {
      if (!current) {
        return "无数据";
      } else if (Number(before) > Number(current)) {
        return `<div class="down">${current}</div>`;
      } else if (Number(before) < Number(current)) {
        return `<div class="up">${current}</div>`;
      } else {
        return `<div>${current}</div>`;
      }
    }

    // 定义中部内容
    let middle = document.createElement("div");
    middle.className = "info-middle";
    middle.style.backgroundColor = "white";
    middle.innerHTML = content;

    let branchInfoHtml = document.createElement("table");
    branchInfoHtml.className = "branchInfoMap";

    let htmlTpl = `
          <tr><td>存款</td><td>贷款</td><td>客户数</td><td>发卡数</td></tr>
          <tr><td>`;
    htmlTpl += judge(item.deposit_1, item.deposit_0) + "</td><td>";
    htmlTpl += judge(item.loan_1, item.loan_0) + "</td><td>";
    htmlTpl += judge(item.customer_1, item.customer_0) + "</td><td>";
    htmlTpl += judge(item.card_1, item.card_0) + "</td></tr>";
    branchInfoHtml.innerHTML = htmlTpl;
    middle.appendChild(branchInfoHtml);
    info.appendChild(middle);

    // 定义底部内容
    let bottom = document.createElement("div");
    bottom.className = "info-bottom";
    bottom.style.position = "relative";
    bottom.style.top = "0px";
    bottom.style.margin = "0 auto";
    let aTag = document.createElement("a");
    aTag.innerText = "详细信息";
    aTag.onclick = function(e) {
      e.preventDefault();
      router.push({
        pathname: "/branch/manage",
        state: {
          branchNo: item.branchNo
        }
      });
    };
    bottom.appendChild(aTag);
    info.appendChild(bottom);

    return info;
  }

  // 关闭信息窗体
  function closeInfoWindow() {
    map.clearInfoWindow();
  }
  return infoWindow;
};
```
![amap-react-3](/../images/amap-react-3.png)

css 部分

```css
.content-window-card {
  position: relative;
  box-shadow: none;
  bottom: 0;
  left: 0;
  width: auto;
  padding: 0;
}

.content-window-card p {
  height: 2rem;
}

.custom-info {
  border: solid 1px silver;
  min-width: 210px;
}

div.info-top {
  position: relative;
  background: none repeat scroll 0 0 #f9f9f9;
  border-bottom: 1px solid #ccc;
  border-radius: 5px 5px 0 0;
}

div.info-top div {
  display: inline-block;
  color: #333333;
  font-size: 14px;
  font-weight: bold;
  line-height: 31px;
  padding: 0 10px;
}

div.info-top .closeImg {
  position: absolute;
  top: -10px;
  right: 10px;
  font-size: 30px;
  transition-duration: 0.25s;
}

div.info-top .closeImg:hover {
  transform: scale(1.2);
}

div.info-middle {
  font-size: 12px;
  padding: 10px 6px;
  line-height: 20px;
}

div.info-bottom {
  width: 100%;
  clear: both;
  text-align: center;
  background-color: #f9f9f9;
  border-top: 1px solid #ddd;
}
div.info-bottom a {
  display: inline-block;
  width: 100%;
  padding: 5px 0;
}
.branchInfoMap {
  margin-top: 5px;
}
.branchInfoMap td {
  padding: 5px 10px;
  border: 1px solid #ddd;
  text-align: center;
}
.branchInfoMap .up:after {
  content: "↑";
  display: inline-block;
  color: green;
  margin-left: 5px;
  font-size: 20px;
}
.branchInfoMap .down:after {
  content: "↓";
  display: inline-block;
  color: red;
  margin-left: 5px;
  font-size: 20px;
}
```


