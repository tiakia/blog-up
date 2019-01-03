---
title: Emacs的配置和使用
tags:
  - emacs
date: '2018-06-06 17:00'
categories: emacs
keywords: emacs
abbrlink: 51002
description:
thumbnail:
---

### 修改的配置

#### 垃圾回收机制修改

purcell 的老是报错 就参考了 spacemacs 的配置

```lisp init.el
  (setq gc-cons-threshold 100000000)
```

<!--more-->

#### 设置中文环境,日期正常显示

```lisp init-preload.el
    (set-language-environment 'Chinese-GBK)
    (prefer-coding-system 'utf-8-unix)
```

#### 设置启动时的大小及位置

```lisp init-preload.el
    ;;设置窗口位置为屏库左上角(0,0)
    (set-frame-position (selected-frame) 0 0)

    (set-frame-width (selected-frame) 110)
    (set-frame-height (selected-frame) 33)
```

#### ivy 搜索到时候取消显示匹配的数字

```lisp init-ivy.el
   ivy-count-format ""
```

#### mode-line 自定义显示

#### 增加`yasnippet`模板

#### 增加全局搜索差价 `ag`

#### 增加中文输入法 `pyim`

#### 增加`web-mode`支持 jsx/js/css/html&#x2026;

### 改变 emacs 的透明度

- 类似 mac 下的效果
- init-alph.el

1.  具体的配置见[My GitHub](https://www.github.com/tiakia/.emacs.d)

### Org-mode 的使用

`tap键:` show/hide 展示/隐藏 一级标题下的其他 item
`* 一级标题`
`** 二级标题`

#### 链接

- [Here's my Blog](http://www.tiankai.party)

#### 插入链接的快捷键

`C-c & C-l`: add link

`C-c & C-o`: open the Link

#### 标记文本

**bold text**, `*bold text*`

_italic text_, `/italic text/`

<u>underlined text</u>, `_underline text_`

<del>strikethrough line</del>, `+strikethrough line+`

`verbatim` `=verbatim=`

#### Table use Tab to enter

|Name|Age|Occupation|生成表格然后 使用 tab 来输入 会自动对齐自动添加

```markdown
| Name     | Age   | Occupation      |
| -------- | ----- | --------------- |
| Allen    | 15    | Teacher         |
| Clyve    | 34    | Office-worker   |
| Barney   | 65    | Worker          |
| -------- | ----- | --------------- |
```

| Name   | Age | Occupation    |
| ------ | --- | ------------- |
| Allen  | 15  | Teacher       |
| Clyve  | 34  | Office-worker |
| Barney | 65  | Worker        |

#### org 导出为其他文件

`C-c & C-e` 选择一个模板导出 (例如: h - o 导出为 html 并打开)

标题文件声明

```markdown
    #+STARTUP: overview
    #+TITLE: org-lesson
    #+OPTIONS: toc:nil
    #+CREATOR: Tiankai
```

> toc:nil 忽略导航,导出为 HTML 的时候会忽略

#### org 输入代码

- 输入 `<s` 敲 tab 键 生成代码块,填写 mode
- `C-c '` 到相应的 mode 编写代码,编写完成后 `C-c '`返回

```markdown
    #+BEGIN_SRC js2
      function add(x, y){
        return x + y
      }
      let sum = add(3,4);
    #+END_SRC
```

#### Todo

```lisp todo.org
** DONE cycle through states
CLOSED: [2018-06-06 Wed 16:24]

** TODO explain todo lists
DEADLINE: <2018-06-07 Thu>
** NEXT 写周报
DEADLINE: <2018-06-08 Fri>
```

- `C-c & C-t` 来改变当前事项是完成还是未完成
- `shift & 上/下/左/右` 可以调整时间
- `C-c & C-d` 调出日历选择日期
- `C-c & a & L` 显示所有待做事情
