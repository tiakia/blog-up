---
title: css实现八卦阵盘
abbrlink: 60796
date: 2019-04-02 14:30:52
categories: [css]
tags: [css3]
---

在实现八卦阵盘前，我们先实现一些基本形状。

<!-- more -->

## 三角形

我们使用的是`border`属性，设置宽高为零，然后设置`border`,可以实现不同类型的三角形

{% codepen tiakia xNJgVR light html.result 465 %}

## 四边形

这里使用了俩种实现方式，

- 一个矩形俩个三角形拼接成一个平行四边形
- 第二种是俩个三角形拼接

{% codepen tiakia NVOapd light html.result 465 %}

## 梯形

给元素一个固定宽，高度设置为零，然后设置边框，可以得到梯形

{% codepen tiakia OYBxgN light html.result 465 %}

## 五边形

一个梯形俩个三角形或者一个梯形一个三角形组成
{% codepen tiakia vwVeJY light html.result 465 %}

## 六边形

{% codepen tiakia MdPEzX light html.result 465 %}

## 八边形

一个矩形和俩个梯形构成
{% codepen tiakia PvyOPj light html.result 465 %}

## 五角星

三个三角形旋转，位置不好调
{% codepen tiakia XwxzXw light html.result 465 %}

## 六角星

一个正立的三角形和一个倒立的三角形
{% codepen tiakia yWRPOQ light html.result 465 %}

## 半圆

`border-radius` 需要使用具体的数值来设置
{% codepen tiakia WBaXxJ light html.result 465 %}

## 扇形

{% codepen tiakia pmxdEQ light html.result 465 %}

## 球体

`background: radial-gradient` 背景颜色渐变来实现
{% codepen tiakia yWRPVG light html.result 465 %}

## 爱心

也是有俩种方式实现

- 俩个圆和一个正方形
- 俩个半圆矩形

{% codepen tiakia rgqYjE light html.result 465 %}

## 无穷大符号

使用神奇的`border-radius`实现
{% codepen tiakia yWRPow light html.result 465 %}

## 钻石

梯形加上一个 倒三角
{% codepen tiakia ZNqaad light html.result 465 %}

## 八卦图

俩个半圆拼接起来，然后以大圆的半径为直径画俩个圆

{% codepen tiakia KLGyZJ light html.result 465 %}

## 八卦阵盘

{% codepen tiakia EzddxE light html,result 465 %}
