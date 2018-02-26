---
title: 记推送失败——git命令之ssh-add学习
categories: 随笔
tags:
  - hexo
comments: false
copyright: true
top: 10
abbrlink: e8996bd7
date: 2017-11-09 10:51:05
---

## <center>推送失败——git命令学习</center>

### 起因

昨天更新文档推送设计模式的笔记，在git bash 命令框下输入以前的

```bash
hexo g -d
```

却给我报了个错误,**Could not open a connection to your authentication agent**，一翻百度发现解决方法如下：
<!--more-->
> 1.exec ssh-agent bash
2.eval ssh-agent -s
3.ssh-add "C:\Users\LN\.ssh\id_rsa"

将相应的秘钥地址改为你自己的地址，然后就可以愉快的输入测试命令了

```bash
ssh -T git@github.com
ssh -T git@git.coding.net
```

测试通过，ok，然后就可以输入部署命令了。

### 参考文档
- [win下给 Git Bash 添加私钥时ssh-add报错的解决办法](http://www.jianshu.com/p/1adbd697b249)