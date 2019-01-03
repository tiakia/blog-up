---
title: hexo进阶之SEO 让博客增加曝光率
tags: hexo
categories: hexo
keywords: 'hexo,SEO'
abbrlink: 55105
date: 2017-07-28 11:42:55
description:
thumbnail:
---

配置折腾的差不多了，终于可以好好的写博客了，今天给大家分享的是 SEO，也叫搜索引擎优化，是指别人在谷歌或百度的时候搜索引擎能把你的文章给显示出来。我们写的博客百度和谷歌是搜不到的，必须要让百度和谷歌收录了，并且搜索的时候还能排名靠前。增加曝光率
**SEO**

### 修改文章链接

- 打开站点配置文件，修改如下配置`permalink: :title.html`，因为默认的是一个四级 url 不利于爬虫爬我们的网站。
  <!-- more -->

### 设置关键字

`keywords`关键词，设置，尽量别用中文，关键词与关键词之间用英文半角逗号分隔，

1. 打开站点配置文件找到`keywords`
2. 在根目录找到`scaffolds`文件下的`post.md`这个是 mardown 的模板文件，`material`主题会默认把`tags`作为`keywords`,但要注意这里标签是数组形式写的(这个配置你也可以自己去修改一下，`thems -> material -> layout -> _partia -> head.ejs`),设置博客的头文件，找到`<meta name="keywords" ...`元标签，然后自己定义吧，照猫画虎

```html
title: {{ title }}
tags: []
categories:
description:
thumbnail:
date: {{ date }}
```

### 安装 sitemap 网站地图

1. 先安装了`site map`网站地图插件

```bash
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
```

2. 在站点配置文件`_config.yml` 中增加以下配置

```yaml
sitemap:
  path: sitemap.xml
baidusitemap:
  path: baidusitemap.xml
```

一个是百度的一个是谷歌的。
配置成功后

```bash
hexo clean
hexo g
```

会在博客根目录生成一个 public 文件夹（这就是你的博客编译打包生成的所有文件），在这里有`sitemap.xml & baidusitemap.xml`这俩个文件

### 添加蜘蛛协议 robots.txt

1. 在博客根目录 sorce 文件夹内新建`robots.txt`粘贴以下内容，注意改成自己的域名

```text
User-agent: *
Allow: /
Allow: /archives/
Allow: /categories/
Allow: /about/
Disallow: /vendors/
Disallow: /js/
Disallow: /css/
Disallow: /fonts/
Disallow: /vendors/
Disallow: /fancybox/

Sitemap: http://www.tiankai.party/sitemap.xml
Sitemap: http://www.tiankai.party/baidusitemap.xml
```

### 让百度和谷歌收录你的网站

1. 验证自己的网站有没有被百度或谷歌收录很简单，输入`site: tiankai.party`
2. `先来百度吧`
3. [点击提交网址](http://zhanzhang.baidu.com/site/index),进入百度站长平台，点击添加网站，输入自己申请的域名，选择一个自己的领域，然后验证网站
4. `百度`提供了三种验证方式，我选择的是 HTML 的验证方式*简单粗暴*谷歌之后也是用的这个方法
5. 我用的是[material 主题](https://github.com/viosey/hexo-theme-material),我说一下思路，首先你要找到渲染模板文件，只要找到模板，一改动，其他的就跟着改变了，material 的模板文件在`thems -> material -> layout -> _partial`这里面就是你博客的模板文件了，你要是自定义也是改动这些文件，找到`head.ejs`,这个就是你博客所有文件的 head 文件了，打开，把刚才 HTML 标签验证的那段`meta`标签粘贴到这（基本的代码能看懂吧，别粘错了，找个合适的地方粘贴）
6. 粘贴好后，重新打包编译部署一下

```bash
hexo clean
hexo d -g
```

7. 回到站长平台，点击完成验证
8. 提交站点地图(百度的在文章最后有更好的提交方式)
9. 然后把刚刚创建的 robots 文件再上传一下
   ![enter description here][1]
10. 然后就，等吧，百度可慢了，过几天站点管理就会出现你的网站信息了。
11. `再来谷歌`
12. 因为被墙所以谷歌弄的话最好还是翻个墙，速度也快（在网页空白地方，右键翻译成中文）
13. 注册 [Google Search Console](https://www.google.com/webmasters/)
14. 注册好后点`Add a property`在弹出窗输入你的域名
    ![enter description here][2]
15. 进行站点验证如图选择好`meta`标签，和百度验证一样的步骤，放入模板 head 文件中
    ![enter description here][3]
16. 然后还是编译打包，点击`VERIFY`立即验证

```bash
hexo clean
hexo d -g
```

17. 点击你的域名进入控制台，测试 robots.txt
    ![enter description here][4]
    ![enter description here][5] 17.提交站点地图，输入`sitemap.xml`点击 submit，然后刷新页面，查看是否提交成功了
    ![enter description here][6]

18. google 抓取网页，这里的 URL 不填这表示抓取首页，抓取方式可以选择桌面(Desktop)，智能手机(Mobile)等等，自行根据需要选择。填好 URL 之后，点击`FETCH AND RENDER`(这里在完成后点击状态可以预览在谷歌上看到的效果)。然后可能会出现几种情况，如:完成(Complete)、部分完成(Partial)、重定向(Redirected)等,点击状态预览，选一个合适的点击`Request indexing`,然后进行人机身份验证，按需选择一个选项，俩个选项分别是
    `Crawl only this URL 仅抓取此网址`
    `Crawl this URL and its direct links 抓取此网址及其直接链接`
    ![enter description here][7] 19.谷歌速度超级快，一会你的网站就被收录了

### 添加 nofollow 标签

nofollow 标签的意思就是网页中其他链接，如果你不需要的话，添加上这个标签搜索引擎就不会去爬这些链接了，一般比如说主题作者的链接，hexo 官网的链接等。

**标签：**`rel='external nofollow'` 外部链接加上这个，就不会被搜索引擎爬了，
全局搜索 `http`,只搜索模板文件就行了，找到带有你不想要的链接，加上这个标记就行，
举一个例子：
`blog\themes\landscape\layout\_partial\footer.ejs:`

```html
<%= __('powered_by') %> <a href="http://hexo.io/" target="_blank">Hexo</a>
```

改为：

```html
<%= __('powered_by') %> <a href="http://hexo.io/" rel='external nofollow' target="_blank">Hexo</a>
```

### 百度主动推送

向网站提交链接有三种方式，

- `主动推动`最为快速的提交方式，建议您将站点当天新产出链接立即通过此方式推送给百度，以保证新链接可以及时被百度收录。
- `sitemap`您可以定期将网站链接放到 Sitemap 中，然后将 Sitemap 提交给百度。百度会周期性的抓取检查您提交的 Sitemap，对其中的链接进行处理，但收录速度慢于主动推送。
- `手工提交`如果您不想通过程序提交，那么可以采用此种方式，手动将链接提交给百度。
  **推荐 主动推送**

安装依赖

```Bash
npm install hexo-baidu-url-submit --save
```

打开站点配置文件增加如下内容：

```yaml
baidu_url_submit:
  count: 10 # 提交最新的链接数
  host: www.tiankai.party # 在百度站长平台中注册的域名,虽然官方推荐要带有 www, 但可以不带.
  token: your_token ## 请注意这是您的秘钥， 请不要发布在公众仓库里!
  path: baidu_urls.txt # 文本文档的地址,新链接会保存在此文本文档里
```

deploy 增加以下内容

```yaml
deploy:
  - type: git
    repo:
      github: git@github.com:tiakia/blog.git,gh-pages #这个地址要填写ssh的不要填写https的
      message: "{{ now('YYYY-MM-DD HH:mm:ss') }}"
  - type: baidu_url_submitter #增加这个
```

token 的获取，登录百度站长平台，点击链接提交
![enter description here][8]
这样在你`hexo d -g`的时候链接就会主动推送给百度
![enter description here][9]

> 参考链接

[Ehcoo](http://www.ehcoo.com/seo.html)

[1]: /../images/SEOseo_10.png "seo_10"
[2]: /../images/SEOaddPropetryGoogle.png "addPropetryGoogle"
[3]: /../images/SEOvaliteGoogle.png "valiteGoogle"
[4]: /../images/SEOrobotsGoogle.png "robotsGoogle"
[5]: /../images/SEOtestRobotGoogle.png "testRobotGoogle"
[6]: /../images/SEOaddSitemapGoogle.png "addSitemapGoogle"
[7]: /../images/SEOfetchGoogle.png "fetchGoogle"
[8]: /../images/SEObaiduToken.png "baiduToken"
[9]: /../images/SEOpushBaiduResult.png "pushBaiduResult"
