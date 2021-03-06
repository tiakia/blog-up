---
title: 记录几种不常见的js计算
abbrlink: 16185
date: 2019-05-22 15:50:19
tags: js
categories: javascript
---

总结几种平时不常见的 js 中的计算方式

- 按位与
- 异或
- 添加标志位
- 清除标志位

<!-- more -->

### 进制转换

**十进制转换二进制：**

```js
"5".charCodeAt().toString(2);

// 5 的二进制为 0101
// 1 的二进制为 0001
// 2 的二进制为 0010
// 3 的二进制为 0011
// 4 的二进制为 0100
```

**二进制转换十进制：**

```js
parseInt('0100', 2) = 4;
```

### 按位与

```js
   5 & 1 -> 1
   5 & 2 -> 0
   5 & 3 -> 1
   5 & 4 -> 4
```

**按位与的计算规则：**
只有在相同位置都为 1 时 结果才是 1,其他则为 0

---

| 十进制 | 二进制 | 计算  | 结果 | 转换为十进制 |
| ------ | ------ | ----- | ---- | ------------ |
| 5      | 0101   | 5 & 5 | 0101 | 5            |
| 4      | 0100   | 5 & 4 | 0100 | 4            |
| 3      | 0011   | 5 & 3 | 0001 | 1            |
| 2      | 0010   | 5 & 2 | 0000 | 0            |
| 1      | 0001   | 5 & 1 | 0001 | 1            |

### 异或

**计算规则**
相同则为 0 不同则为 1

---

| 十进制 | 二进制 | 计算  | 结果 | 转换为十进制 |
| ------ | ------ | ----- | ---- | ------------ |
| 5      | 0101   | 5 ^ 5 | 0000 | 0            |
| 4      | 0100   | 5 ^ 4 | 0001 | 1            |
| 3      | 0011   | 5 ^ 3 | 0110 | 6            |
| 2      | 0010   | 5 ^ 2 | 0111 | 7            |
| 1      | 0001   | 5 ^ 1 | 0100 | 4            |

### 添加标志位

```js
5 | 1 => 0101 => 5
```

**计算规则**
只要有 1 就为 1

---

| 十进制 | 二进制 | 计算  | 结果 | 转换为十进制 |
| ------ | ------ | ----- | ---- | ------------ |
| 5      | 0101   | 5 \ 5 | 0101 | 5            |
| 4      | 0100   | 5 \ 4 | 0101 | 5            |
| 3      | 0011   | 5 \ 3 | 0111 | 7            |
| 2      | 0010   | 5 \ 2 | 0111 | 7            |
| 1      | 0001   | 5 \ 1 | 0101 | 5            |

### 清除标志位

```js
5 & ~1 => 0100 => 4
```

**计算规则**
相同则为 0,不同则前面的为准，覆盖

---

| 十进制 | 二进制 | 计算   | 结果 | 转换为十进制 |
| ------ | ------ | ------ | ---- | ------------ |
| 5      | 0101   | 5 & ~5 | 0000 | 0            |
| 4      | 0100   | 5 & ~4 | 0001 | 4            |
| 3      | 0011   | 5 & ~3 | 0100 | 4            |
| 2      | 0010   | 5 & ~2 | 0101 | 5            |
| 1      | 0001   | 5 & ~1 | 0100 | 4            |
