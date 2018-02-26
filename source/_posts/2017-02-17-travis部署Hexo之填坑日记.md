---
title: travis部署Hexo之填坑日记
categories: Hexo
tags:
  - hexo
comments: true
abbrlink: a8653e18
date: 2017-02-17 16:34:46
copyright: true
---

这个小客栈总算是被我搭起来了，前前后后遇到了不少坑。果然每一次在网上学东西都是遇坑填坑的过程，不过这都是为了我们更好的成（zhuang）长(bi)嘛。

也就不重复的讲其他教程里有的内容了，只简明的记录下，我的填坑过程。

### 第一个坑 travis 找不指定文件
<!--more-->

``` bash

$ cd 博客项目文件夹根目录
$ touch .travis.yml
```

* 登录 travis

``` bash
travis login --auto
````

``` bash
# 这里的 REPO_TOKEN 是变量名,在后面的配置文件中会用到
# TOKEN 是上面github生成的Token
travis encrypt 'REPO_TOKEN=<TOKEN>' --add
```

这在很多讲解Travis部署Hexo的教程中都有的步骤，那么问题就出现了。。。。

* travis 找不到指定文件


这里是在travis encrypt 你的github创建的token的时候出现的。

解决办法： 在travis encrypt 'REPO_TOKEN=<TOKEN>' --add 的时候加上 -r 你的github用户民/你的repo名。比如我的就是

``` bash
travis encrypt 'REPO_TOKEN=<TOKEN>' --add -r Nanmen/nanmen.github.io
```

### 第二个坑 travis 构建你的工程时报2> dev/null错的问题

* 当我兴高采烈的去推送到我的dev分支的时候，travis 运行测试过程中报出个 '\<token> 2>dev/null' 的错误，一脸懵有没有，明明都是按照教程来的，怎么会是这样的呢。在我前后回想之后，一不小心测试出来了。。。。

解决办法： 在你执行travis encrypt 的时候，并不是跟大部分教程写的那样，应该执行这一句
``` bash
travis encrypt REPO_TOKEN=TOKEN --add -r Nanmen/nanmen.github.io
```

### 参考资料
1.[手把手教从零开始在GitHub上使用Hexo搭建博客教程(一)-附GitHub注册及配置 - 简书](http://www.jianshu.com/p/f4cc5866946b)
  2.[手把手教从零开始在GitHub上使用Hexo搭建博客教程(四)-使用Travis自动部署Hex... - 简书](http://www.jianshu.com/p/fff7b3384f46)
  3.[hexo教程系列——使用Travis自动部署hexo - 张学志の博客 - 博客频道 - CSDN.NET](http://blog.csdn.net/xuezhisdc/article/details/53130423)
