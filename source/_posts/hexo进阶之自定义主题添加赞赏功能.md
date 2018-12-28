---
title: hexo进阶之自定义material主题添加赞赏功能，版权信息，Gitment评论模块
tags: gitment,hexo
date: 2017-07-28 11:43:25
categories: hexo
description:
thumbnail:
---
折腾hexo有一段时间了，差不多基本的功能都有了，现在分享一下如何给自己的博客添加赞赏功能，版权信息，评论模块。前俩个功能都差不多，都是在模板文件里添加代码，第三个评论使用的gitment,作者使用的是github的`issue`页面,比较坑的是每次加载js都要耗费很多时间，css可以本地加载，js的话我找了一个简便办法，在gitment部分会细说。
<!-- more -->
## Donate 赞赏功能

1.既然是要自定义，肯定也要在主题配置文件里设置，打开`matetial - _config.yml`,在末尾添加一下代码：
```
#打赏
donate:
  enable: true
  text: Enjoy it ? Donate me !  欣赏此文？求鼓励，求支持！ #描述信息
  wechat: "http://pkafgcch8.bkt.clouddn.com/donate/ali.jpg" #微信二维码图片
  alipay: "http://pkafgcch8.bkt.clouddn.com/donate/wechat.jpg" #支付宝二维码图片
```
2.赞赏功能和版权信息都是在每篇博文的底部的，首先就要先找到博文的模板文件，material主题的模板文件就在`material - layout - _partial - post-content.ejs`,打开然后粘贴一下代码：
```
 <% if (theme.donate) { %>
  <!-- css -->
  <style type="text/css">
      .center {
          text-align: center;
      }
      #donate_guide.noActive,#donate_board.noActive  {
          /*display: none;*/
          height:0;
          opacity:0;
          visibility: hidden;
      }
    .donate_bar a.btn_donate{
      display: inline-block;
      width: 82px;
      height: 82px;
      background: url("/img/btn_reward.gif") no-repeat;
      _background: url("/img/btn_reward.gif") no-repeat;

     
      -webkit-transition: background 0s;
      -moz-transition: background 0s;
      -o-transition: background 0s;
      -ms-transition: background 0s;
      transition: background 0s;
     
    }
    #donate_guide{
      opacity:1;
      visibility: visible;
      -webkit-transition: all .3s linear;
      -moz-transition: all .3s linear;
      -o-transition: all .3s linear;
      -ms-transition: all .3s linear;
      transition: all .3s linear;
    }
    .donate_bar a.btn_donate:hover{ background-position: 0px -82px;}
    .donate_bar .donate_txt {
      display: block;
      color: #9d9d9d;
      font: 14px/2 "Microsoft Yahei";
      margin-top:10px;
    }
    .bold{ font-weight: bold; }
    @media screen and (max-width:500px) {
      #donate_guide>a{
        display:block;
      }
    }
  </style>
  <!-- /css -->

    <!-- Donate Module -->
    <div id="donate_module">

    <!-- btn_donate & tips -->
    <div id="donate_board" class="donate_bar center">
        <br>
        ------------------------------------------------------------------------------------------------------------------------------
        <br>
      <a id="btn_donate" class="btn_donate" target="_self" href="javascript:;" title="Donate 打赏"></a>
      <span class="donate_txt">
        <%= theme.donate.text %>
      </span>
        
      
    </div>
    <!-- /btn_donate & tips -->

    <!-- donate guide -->
      
    <div id="donate_guide" class="donate_bar center noActive">
          <br>
        ------------------------------------------------------------------------------------------------------------------------------
        <br>

      <a href="<%= theme.donate.wechat %>" title="用微信扫一扫哦~" class="fancybox" rel="article0">
        <img src="<%= theme.donate.wechat %>" title="微信打赏 Colin" height="190px" width="200px"/>
      </a>
          
          &nbsp;&nbsp;

      <a href="<%= theme.donate.alipay %>" title="用支付宝扫一扫即可~" class="fancybox" rel="article0">
        <img src="<%= theme.donate.alipay %>" title="支付宝打赏 Colin" height="190px" width="200px"/>
      </a>

      <span class="donate_txt">
        <%= theme.donate.text %>
      </span>

    </div>
    <!-- /donate guide -->

    <!-- donate script -->
    <script type="text/javascript">
      document.getElementById('btn_donate').onclick = function() {
        $('#donate_board').addClass('noActive');
        $('#donate_guide').removeClass('noActive');
      }
    </script>
    <!-- /donate script -->

  
  </div>
  <!-- /Donate Module -->
  <% } %>
```
恩，如果有不合适的请自行调整，文章参考自大神，但是自己做了修改，增加了过渡效果和手机端适配，原文链接在末尾会给出。
## Copyright 版权信息
1.打开`matetial - _config.yml`,在末尾添加一下代码
```
#版权信息
copyright:
    enable: true
    img: http://pkafgcch8.bkt.clouddn.com/copyright/copyright.png #版权信息图片
    site: http://www.tiankai.party  #版权信息所属网址
    siteName: tiakia's blog #版权信息网站名字
    siteAuthor: '田凯' #版权归属人
```
2.打开`material - layout - _partial - post-content.ejs`，在赞赏代码的上面插入以下内容：
```
<% if(theme.copyright.enable) { %>
      <style>
        .linkColor{
            color:#258FC6
        }
        .copyrightFont{
            padding-left:10px;
        }
        .copyrightTitle{
          font-weight:bold;
          font-size:15px;
          display:block;
          padding-left:10px;
          margin-top:5px;
          margin-bottom:5px;
        }
      </style>
      <div style="border: 1px solid black">
        <div>
            <span class='copyrightTitle'>版权声明</span>
            <img src="<%= theme.copyright.img %>">
            <br/>
            <p class='copyrightFont'>
              <a href="<%= theme.copyright.site %>" class='linkColor'><%= theme.copyright.siteName %></a> 
              by 
              <a href="<%= theme.copyright.site %>"  class='linkColor'><%= config.author %></a> 
              is licensed under a 
              <a href="https://creativecommons.org/licenses/by-nc-nd/4.0/"  class='linkColor'>Creative Commons BY-NC-ND 4.0 International License</a>.
              <br/>
              由
              <a href="<%= theme.copyright.site %>"  class='linkColor'><%= theme.copyright.siteAuthor%></a>
              创作并维护的
              <a href="<%= theme.copyright.site %>"  class='linkColor'><%= theme.copyright.siteName %></a>
              采用
              <a href="https://creativecommons.org/licenses/by-nc-nd/4.0/"  class='linkColor'>创作共用保留署名-非商业-禁止演绎4.0国际许可证</a>。
              <br/>
              本文首发于
              <a href="<%= theme.copyright.site %>"  class='linkColor'><%= theme.copyright.siteName %></a>
              （ <a href="<%= theme.copyright.site %>"  class='linkColor'><%= theme.copyright.site %></a> ）
              ，版权所有，侵权必究。
            </p>
        </div>
    </div>
    <% } %>
```
版本信息，也是参考自大神，但自己做了一定的修改，链接会放在文章底部。
## Gitment 评论模块
1.Gitment 是作者实现的一款基于 GitHub Issues的评论系统。支持在前端直接引入，不需要任何后端代码，我把作者的css拷贝到了本地，要不每次都去访问网上的话会影响博客的加载速度，css我改了点，适配了手机端的评论,js还没优化，等过段时间会把js弄一下，加快博客的加载速度。
2.首先要在github上注册 [OAuth Application](https://github.com/settings/applications/new)，如下图所示，填入自己的信息，注意这里的`Authorization callback URL`要填入你注册的域名，注册成功后会拿到`client_id`和`client_secret`,后面的配置文件需要写。
![enter description here][1]

3.在github上新建一个repo仓库,用来专门存放blog的评论，登录github账户，点击`New repository`，输入仓库名，我的是`tiakiaBlogComment`（这个后面的配置文件要填写）。

4.修改主题配置文件`thems - material - source - _config.yml`，
```
comment:
    use: gitment
    owner: tiakia #你的github账号 自己增加的选项
    repo: tiakiaBlogComment #github评论的repo 自己增加的选项
    client_id:  #github client_id 位置见图中 自己增加的选项
    client_secret:  #github client_secret 位置见图中 自己增加的选项
```
![enter description here][2]


5.因为主题也带有评论框架，所以我找了一下他自带的评论框架的代码。首先找到的是`material - layout - _partial - comment.ejs`,这里显示他引用的代码源自`material - layout - _widget - comment`然后根据主题配置文件中`theme.comment.use`填写的字段选择加载对应的文件夹  

6.首先，我在`_widget - comment`下新建一个文件夹`gitment`，在里面新建了一个`enter.ejs`
7.然后，贴入以下代码：[更多配置请查看官网](https://github.com/imsun/gitment)

```
<%- css('css/gitmentDefault') %>
<%- js('js/gitment.browser.js') %>

<style>
	#container{
		padding-left: 30px;
		padding-right: 30px;
	}
</style>
<div id="container"></div>

<script>
	const myTheme = {
	  render(state, instance) {
	    const container = document.createElement('div')
	    container.lang = "en-US"
	    container.className = 'gitment-container gitment-root-container'
	    
	     // your custom component
	    container.appendChild(instance.renderSomething(state, instance))
	    
	    container.appendChild(instance.renderHeader(state, instance))
	    container.appendChild(instance.renderEditor(state, instance))
	    container.appendChild(instance.renderComments(state, instance))
	    container.appendChild(instance.renderFooter(state, instance))
	    return container
	  },
	  renderSomething(state, instance) {
	    const container = document.createElement('div')
	    container.lang = "en-US"
	    if (state.user.login) {
	      container.innerText = `Hello, ${state.user.login}`
	    }
	    return container
	  }
	}
	const gitment = new Gitment({
	 // id: 'window.location.pathname', // optional
	  owner: '<%- theme.comment.owner %>',
	  repo: '<%- theme.comment.repo %>',
	  oauth: {
	    client_id: '<%- theme.comment.client_id %>',
	    client_secret: '<%- theme.comment.client_secret %>',
	  },
	 // title: "document.title",
	  theme: myTheme,
	  // ...
	  // For more available options, check out the documentation below
	})

	gitment.render('container')
	// or
	// gitment.render(document.getElementById('comments'))
	// or
	// document.body.appendChild(gitment.render())
</script>

```

8.`gitmentDefault.css`文件我创建在了`theme - source - css - gitmentDefault.css`
内容是[作者的github上拷贝下来的](https://github.com/imsun/gitment/blob/master/style/default.css)，增加了手机端适配代码如下：
```
...其他部分是从作者的github上拷贝下来的，
@media screen and (max-width:400px){
  a.gitment-header-issue-link{
    display:none;
  }
}

@media screen and (max-width:415px) {
  .gitment-editor-login {
    float: right;
    margin-top: -70px;
    margin-right: 15px;
  }
}

```
#### js获取方式，去作者的git上把项目克隆下来，然后在文件夹内运行`npm install`，安装完依赖后，运行`wepback`,在该文件夹内就会出现一个dist文件夹，里面的`gitment.browser.js`,就是js文件。  文件放在和css文件同目录的js文件夹内即可。

9.初始化评论页面编译发布后，你需要访问你发布的页面并使用你的 GitHub 账号登录（请确保你的账号是你在主题配置文件里的 repo 的 owner），点击初始化`initialize comments`按钮,之后其他用户才可在该页面发表评论。


----------

1.打赏功能参考自: [Colin's Net](http://colin1994.github.io/2016/06/02/hexo-copyright-and-donate/)
2.版本信息参考自: [tc9011's Notes](http://tc9011.com/2017/02/02/hexo%E6%96%87%E7%AB%A0%E6%B7%BB%E5%8A%A0%E7%89%88%E6%9D%83%E5%A3%B0%E6%98%8E%E5%8F%8A%E4%B8%80%E4%BA%9B%E7%89%B9%E6%95%88/)
3.[Gitment](https://github.com/imsun/gitment)


  [1]: http://pkafgcch8.bkt.clouddn.com/hexo/registerOauthApplication.png "registerOauthApplication"
  [2]: http://pkafgcch8.bkt.clouddn.com/hexo/clientIDSecret.png "clientIDSecret"