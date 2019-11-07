---
title: 整理一些常用的lodash工具函数
abbrlink: 51993
date: 2019-07-11 14:56:35
tags: lodash
categories: javascript
---

### compact

作用： 返回数组中有意义的值组成新数组，`false`, `null`,`0`, `""`, `undefined`,`NaN` 被忽略掉。

<!-- more -->

```javascript
/*
 * _.compact([0, 1, false, 2, '', 3]);
 * // => [1, 2, 3]
 */
function compact(array) {
  var index = -1,
    length = array == null ? 0 : array.length,
    resIndex = 0,
    result = [];

  while (++index < length) {
    var value = array[index];
    if (value) {
      result[resIndex++] = value;
    }
  }
  return result;
}
```

### 随机取值

- `_.sample(collection)`

  从数组或对象中随机取出一个元素(对象的话取的是 value 值)

```javascript
_.sample([1, 2, 3, 4]);
// => 3
_.sample({ a: "1", b: "2", c: "3" });
// => "2"
```

---

- `_.sampleSize(collection,[n=1])`

  从数组或对象中随机取出 n 个元素组成的数组

```javascript
_.sampleSize([1, 2, 3, 4], 2);
// => [2,4]
_.sampleSize({ a: "1", b: "2", c: "3" }, 2);
// => ["1", "2"]
```

### 数组筛选

#### 返回新数组

- `_.without(array, [values])`

  创建一个剔除所有给定值的新数组

```javascript
_.without([2, 1, 2, 3], 1, 2);
// => [3]
```

---

- `_.difference(array,[values])`

  创建一个具有唯一 array 值的数组，每个值不包含在其他给定的数组中

```javascript
_.difference([3, 2, 1], [4, 2]);
// => [3,1]
```

#### 修改原数组

- `_.pull(array, [values])`

  移除数组 array 中所有和给定值相等的元素

```javascript
var array = [1, 2, 3, 1, 2, 3];

_.pull(array, 2, 3);
console.log(array);
// => [1, 1]
```

---

- `_.pullAll(array,values)`

```javascript
var array = [1, 2, 3, 1, 2, 3];

_.pullAll(array, [2, 3]);
console.log(array);
// => [1, 1]
```

### 数组降维

- `_.flattten(array)`

  减少一级 array 嵌套深度。

```javascript
_.flatten([1, [2, [3, [4]], 5]]);
// => [1, 2, [3, [4]], 5]
```

---

- `_.flattenDeep(array)`

  将 array 递归为一维数组。

```javascript
_.flattenDeep([1, [2, [3, [4]], 5]]);
// => [1, 2, 3, 4, 5]
```

---

- `_.flattenDepth(array, [depth=1])`

  根据 depth 递归减少 array 的嵌套层级

```javascript
const array = [1, [2, [3, [4]], 5]];

_.flattenDepth(array, 1);
// => [1, 2, [3, [4]], 5]

_.flattenDepth(array, 2);
// => [1, 2, 3, [4], 5]
```

### 快速生成数组

- `_.range([start=0], end, [step=1])`

  返回一个包含`start`,不包含`end`的数组，

  - 参数：
    - `[start=0](number)`: 开始的范围。
    - `end (number)`: 结束的范围。
    - `[step=1](number)`: 范围的增量 或者 减量。

```javascript
_.range(4);
// => [0, 1, 2, 3]

_.range(-4);
// => [0, -1, -2, -3]

_.range(1, 5);
// => [1, 2, 3, 4]

_.range(0, 20, 5);
// => [0, 5, 10, 15]

_.range(0, -4, -1);
// => [0, -1, -2, -3]

_.range(1, 4, 0);
// => [1, 1, 1]

_.range(0);
// => []
```

- 原生方法：

```javascript
const arr = [...new Array(100).keys()];
console.log(arr); // [0, 1, 2, ... 99]
```

### 枚举渲染

```jsx harmony
function Loading(props) {
  const { loadingText, LOADING_STATUS, loadingStatus, onRetry } = props;
  return (
    <View className="loading-status">
      {
        {
          loading: loadingText,
          fail: <View onClick={onRetry}> 加载失败, 点击重试 </View>,
          "no-more": "没有更多了"
        }[
          loadingStatus
        ] /** loadingStatus 是 `loading`、`fail`、`no-more`  其中一种状态 **/
      }
    </View>
  );
}
```

### before/after

- `_.after(n, func)`

  before 的反向函数;此方法创建一个函数，当他被调用 n 或更多次之后将马上触发 func 。

```javascript
var saves = ["profile", "settings"];

var done = _.after(saves.length, function() {
  console.log("done saving!");
});

_.forEach(saves, function(type) {
  asyncSave({ type: type, complete: done });
});
// => Logs 'done saving!' after the two async saves have completed.
```

---

- `_.before(n, func)` 超过多少次不再调用`func`

  创建一个调用 func 的函数，通过 this 绑定和创建函数的参数调用 func，调用次数不超过 n 次。 之后再调用这个函数，将返回一次最后调用 func 的结果。

```javascript
jQuery(element).on("click", _.before(5, addContactToList));
// => allows adding up to 4 contacts to the list
```

### 柯里化

- `_.curry(func,[arity=func.length])`

  - 参数：

    - `func`:用来柯里化的函数

    - `[arity=func.length]`:需要提供给 func 的参数数量。

  - 返回值：返回新的柯里化函数

```javascript
function add(a, b, c) {
  return a + b + c;
}

var curried = _.curry(abc);

curried(1)(2)(3);
// => 6

curried(1, 2)(3);
// => 6

curried(1, 2, 3);
// => 6
```

### 防抖

所谓防抖，就是指触发事件后在 n 秒内函数只能执行一次，如果在 n 秒内又触发了事件，则会重新计算函数执行时间。
单反也有相似的概念，在拍照的时候手如果拿不稳晃的时候拍照一般手机是拍不出好照片的，因此智能手机是在你按一下时连续拍许多张， 能过合成手段，生成一张。翻译成 JS 就是，事件内的 N 个动作会变忽略，只有事件后`由程序触发`的动作有效。

- `_.debounce(func, [wait=0], [options={}])`

  debounced（防抖动）函数提供一个 `cancel` 方法取消延迟的函数调用以及 `flush` 方法立即调用

  - 参数：
    - `func (Function)`: 要防抖动的函数。
    - `[wait=0] (number)`: 需要延迟的毫秒数。
    - `[options={}] (Object)`: 选项对象。
    - `[options.leading=false] (boolean)`: 指定在延迟开始前调用。
    - `[options.maxWait] (number)`: 设置 func 允许被延迟的最大值。
    - `[options.trailing=true] (boolean)`: 指定在延迟结束后调用。

```javascript
// 避免窗口在变动时出现昂贵的计算开销。
jQuery(window).on("resize", _.debounce(calculateLayout, 150));

// 当点击时 `sendMail` 随后就被调用。
jQuery(element).on(
  "click",
  _.debounce(sendMail, 300, {
    leading: true,
    trailing: false
  })
);

// 确保 `batchLog` 调用1次之后，1秒内会被触发。
var debounced = _.debounce(batchLog, 250, { maxWait: 1000 });
var source = new EventSource("/stream");
jQuery(source).on("message", debounced);

// 取消一个 trailing 的防抖动调用
jQuery(window).on("popstate", debounced.cancel);
```

### 节流

所谓节流，就是指连续触发事件但是在 n 秒中只执行一次函数。节流会稀释函数的执行频率。节流的概念可以想象一下水坝，你建了水坝在河道中，不能让水流动不了，你只能让水流慢些。换言之，你不能让用户的方法都不执行。如果这样干，就是 `debounce` 了。

- `_.throttle(func, [wait=0], [options={}])`

  该函数提供一个 cancel 方法取消延迟的函数调用以及 flush 方法立即调用

  - 参数：
    - `func (Function)`: 要节流的函数。
    - `[wait=0](number)`: 需要节流的毫秒。
    - `[options={}](Object)`: 选项对象。
    - `[options.leading=true](boolean)`: 指定调用在节流开始前。
    - `[options.trailing=true](boolean)`: 指定调用在节流结束后。

```javascript
// 避免在滚动时过分的更新定位
jQuery(window).on("scroll", _.throttle(updatePosition, 100));

// 点击后就调用 `renewToken`，但5分钟内超过1次。
var throttled = _.throttle(renewToken, 300000, { trailing: false });
jQuery(element).on("click", throttled);

// 取消一个 trailing 的节流调用。
jQuery(window).on("popstate", throttled.cancel);
```

### once

创建一个只能调用 func 一次的函数。 重复调用返回第一次调用的结果。

- `_.once(func)`

```javascript
var initialize = _.once(createApplication);
initialize();
initialize();
// `initialize` 只能调用 `createApplication` 一次。
```

### delay

- `_.delay(func, wait, [args])`

延迟 wait 毫秒后调用 func。 调用时，任何附加的参数会传给 func。

```javascript
_.delay(
  function(text) {
    console.log(text);
  },
  1000,
  "later"
);
// => 一秒后输出 'later'。
```

### 深拷贝

- `_.cloneDeep(value)`

  返回深拷贝后的值

### isEmpty

- `_.isEmpty(value)`

```javascript
_.isEmpty([]);
// => true

_.isEmpty({});
// => true

_.isEmpty(null);
// => true

_.isEmpty(true);
// => true

_.isEmpty(1);
// => true

_.isEmpty([1, 2, 3]);
// => false

_.isEmpty({ a: 1 });
// => false
```

### isEqual

- `_.isEqual(value, other)`

  执行深比较来确定两者的值是否相等。如果 两个值完全相同，那么返回 true，否则返回 false。

```javascript
var object = { a: 1 };
var other = { a: 1 };

_.isEqual(object, other);
// => true

object === other;
// => false
```

###
