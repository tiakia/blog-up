---
title: nginx初见
date: '2018-06-19 09:56'
categories: nginx
tags:
  - nginx
keywords:
  - nginx
  - 负载均衡
  - 反向代理
comments: true
abbrlink: 40486
thumbnailImage:
coverCaption:
---

第一次近距离的接触 `nginx`,今天先来了解一下 nginx 的俩个重要的功能 `反向代理`和`负载均衡`

<!-- more -->

### 正向代理

正向代理隐藏真实请求的客户端
一个经典的例子就是大陆访问谷歌被墙,我们可以在国外搭建一台代理服务器,让代理服务器帮你去请求谷歌,代理服务器再把请求的结果返回来,完成一个正向代理的过程.

### 反向代理

反向代理隐藏真实的服务端
反向代理则正好相反,当我们从客户端请求 一个资源 的时候,背后可能有成千上万台服务器在为我们提供服务,反向代理服务器会将我们的请求转发到真实的服务器上面,至于这个服务器是哪个我们不知道,可以用反向代理来做负载均衡

### 负载均衡

当用户访问网站的时候，先访问一个中间服务器，再让这个中间服务器在服务器集群中选择一个压力较小的服务器，然后将该访问请求引入选择的服务器.这个中间服务器就是反向代理服务器
所以，用户每次访问，都会保证服务器集群中的每个服务器压力趋于平衡，分担了服务器压力，避免了服务器崩溃的情况
一句话：nginx 会给你分配服务器压力小的去访问

### windows 安装 nginx

[nginx 官网下载](http://nginx.org/en/download.html)

- 下载后,解压到文件目录
- 命令行进入该文件目录
- 运行`nginx`命令

这个时候命令行没有任何显示,打开浏览器,输入`localhost:80`,然后就可以看到 nginx 的欢迎页面,一个简单的见面会.

### nginx 简单命令

- `nginx -v` 查看 nginx 的版本号
- `start nginx` 启动 nginx 服务
- `nginx -s reload` 重新启动服务
- `nginx -s stop` 停止 nginx 服务
- `nginx -s quit` 退出 nginx
- `nginx -t` 测试配置文件的有效性

windows 上如果修改了配置文件需要先`nginx -s quit` 退出 nginx ,然后再 `nginx -s reload` ,然后再`start nginx`启动 nginx 服务

### nginx 配置文件

找到 nginx 的配置文件`conf/nginx.conf`

```nginx conf/nginx.conf
# 全局配置
user nobody;  # nginx子进程运行的用户和用户组
worker_processes 1;  # 开启一个 nginx 工作进程,一般 CPU 几核就写几

error_log logs/error.log;  # 错误日志存放地址
pid logs/nginx.pid;  # 主进程pid存放地址
# events 配置
events {
    worker_connections 1024; # 一个进程能同时处理 1024 个请求
}
# HTTP 配置
http {
    ...此处省略默认配置
    server {
        listen 80;  # 监听本机上的 80 端口
        server_name localhost;  # 域名 localhost
        location / { # 匹配路由
            root html; # 站点根目录
            index index.html index.htm; # 首页的配置
        }
        error_page 500 502 503 504 /50x.html; # 错误页面的重定向
        location = /50x.html {
            root html;  # 站点根目录文件夹
        }
    }
}
```

### proxy_pass

nginx 的反向代理主要通过`proxy_pass`来实现,比如说实现访问`localhost:80`然后反向代理到我的博客.进行以下的配置:

```nginx nginx.conf
server {
    listen 80;
    server_name localhost;
    location / {
        proxy_pass http://www.tiankai.party;
    }
}
```

然后重新启动 nginx 服务,在浏览器输入 `localhost:80` 就发现被反向代理到了我的博客地址

### upstream

实现负载均衡就要用到这个模块了.

```nginx nginx.conf
server {
   upstream www.tiankai.party {
     ip_hash;
     server tiankai1.example.com; # 服务器的地址
     server tiankai2.example.com;
     server tiankai3.example.com;
     server tiankai4.example.com;
   }
   localtion / {
       proxy_pass http://www.tiankai.party
   }
}
```

当用户请求被反向代理到了`http://www.tiankai.party` 的时候,会对应的找到 名为 `www.tiankai.party` 的 `upstream` 的 四个 服务器,这样在访问`localhost:80`的时候,就会把请求代理到 这四个服务器上,实现负载均衡.

`ip_hash`的作用: 是为了在用户访问后留下记号,这样下次用户再进行访问的时候直接访问上次分发的服务器地址就行了.
