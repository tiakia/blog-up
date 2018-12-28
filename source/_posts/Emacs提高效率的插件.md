---
title: Emacs提高效率的插件
tags: [emacs]
date: 2018-01-08 11:36:32
categories: emacs
description:
thumbnail:
keywords: emacs
---
推荐一些可以提高效率的`emacs`使用效率的插件，使用后可以实现一些 `IDE` 的基本功能了。  

### pyim
我是使用`cmder`终端启动的`emacs`,其他功能很流畅，唯一别扭的就是在`cmder`中使用`emacs`没办法输入中文,这个困扰了我很久的时间，  
后来偶然的机会发现了这个`pyim`它是使用的`emacs`自带的输入法。安装完这个以后，直接`C - Space`就可以切换到中文输入法了,    
然后在终端不能输入中文的问题就完美的解决了，解决了一大心病呀。
<!-- more -->
#### install
RET - 回车键  
C - ctrl  
M - alt  
```
M - x package-install RET pyim RET
```
#### 配置
```
;; 灵拼
(require 'pyim)
(require 'pyim-basedict)
(pyim-basedict-enable)
(setq default-input-method "pyim")
(setq pyim-default-scheme 'quanpin)
(global-set-key (kbd "C-\\") 'toggle-input-method)


```
其他配置，[详见github](https://github.com/tumashu/pyim)
### ivy
一个强大的搜索插件，这个只限当前打开的文件，全局文件搜索推荐使用 `ag`
`ivy`需要配合`swiper`和`cousel`
#### install
```
M - x package-install RET ivy RET
```
#### 配置
```
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
;;(global-set-key (kbd "M-x") 'counsel-M-x)
;;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)


```
这只是我的配置，其他的配置可以去查看[github](https://github.com/abo-abo/swiper)  
这个我主要用的是`C - s`这个可以在buffer的地方,显示出当前文件中关键词以及关键词所在的位置和缩略图。  
**ps:purcell的配置以及集成了如果是使用的他的配置只需要修改以下的部分就行**
```
(when (maybe-require-package 'swiper)
  (after-load 'ivy
    (defun sanityinc/swiper-at-point (sym)
      "Use `swiper' to search for the symbol at point."
      (interactive (list (thing-at-point 'symbol)))
      (swiper sym))
    (global-set-key "\C-s" 'swiper) ;;修改这里
    ;;(define-key ivy-mode-map (kbd "\C-s") 'sanityinc/swiper-at-point)
    ))

```
**我不喜欢每次搜索的时候显示数字**
```
(when (maybe-require-package 'ivy)
  (after-load 'ivy
    (setq-default ivy-use-virtual-buffers t
                  ivy-virtual-abbreviate 'fullpath
                  ivy-count-format "" ;; 修改这里
                  projectile-completion-system 'ivy
                  ivy-initial-inputs-alist
                  '((man . "^")
                    (woman . "^")))

```
### ag
全局搜索的大杀器，使用了这个就和`sublime`的`find in file`的功能一样。  
额 这个的话 我只能说我还不会配，当时弄这个的时候，是大佬直接给我发的`ag.exe`然后我配到环境变量  
然后`package-install`安装就能用了.[我的ag.exe](https://github.com/tiakia/.emacs.d/tree/master/tk-quick)

### yas
这个东西超级好用，他可以事先编辑一个模板,然后模板有个关键词，在你使用emacs的过程中，只要输入这个关键词，然后使用 tab 键，然后直接就会显示出这个模板 在模板里还可以定义 变量，等你新建好后再进行填写。
### install
```
 cd ~/.emacs.d/plugins
 git clone --recursive https://github.com/joaotavora/yasnippet
```

### 配置
```
;; YASnippet
(add-to-list 'load-path
             "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(provide 'init-yas)

```
### 使用
```
M - x  yas-new-snippet
```
然后就开始编辑模板
```
# -*- mode: snippet -*-
# name: 这个模板的名称
# key: 启用模板的关键字，如果没有默认使用 name
# --

```
我的 `react` 模板
```
# -*- mode: snippet -*-
# name: react
# key: react
# --
/*
 Author: tiankai
 Github: https://github.com/tiakia
 Email: tiankai0426@sina.com
*/

import React, { Component } from 'react';

export default class $1 extends Component {
     constructor(props){
        super(props);
        this.state = {

        };
     }
     componentWillMount(){

     }
     componentDidMount(){

     }
     componentWillReceiveProps(nextProps){

     }
     render(){
         return(

         );
     }
}
```
在`js`文件中敲击`react`然后敲击`tab`键，就可以显示出来编辑的模板了  
`$1`就是在新建模板后，你自己需要填写的东西。  
也可以自己定义`html5`的模板，这样和`sublime`一样，直接输入`html5`然后摁`tab`键  
一键生成了 `html5` 的代码结构。

### 总结
`emacs`真是一个神奇的编辑器，可能你刚开始使用的时候会有各种不习惯，但是你要知道，`emacs`所有的东西都是可以自定义的，通过自己磕磕碰碰的配置，把编辑器打造成属于自己的东西，这种感觉真的是很舒服。  
建议大家刚开始使用大神的配置，然后在[purcell](https://github.com/purcell/emacs.d)大神上面的改。
