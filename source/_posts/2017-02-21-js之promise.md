---
title: js学习之promise
categories: js学习之路
tags:
  - js
  - nodejs
comments: true
abbrlink: fddbb00f
date: 2017-02-21 19:01:28
---

## <center>js学习之promise<center>

### Promise的初步认识

我们之前在完成异步执行都是利用的回调函数去实现的，例如ajax的调用：
```javascript
var request = new XMLHttpRequest(); // 新建XMLHttpRequest对象

request.onreadystatechange = function () { // 状态发生变化时，函数被回调
    if (request.readyState === 4) { // 成功完成
        // 判断响应结果:
        if (request.status === 200) {
            // 成功，通过responseText拿到响应的文本:
            return success(request.responseText);
        } else {
            // 失败，根据响应码判断失败原因:
            return fail(request.status);
        }
    } else {
        // HTTP请求还在继续...
    }
}

// 发送请求:
request.open('GET', '/api/categories');
request.send();

alert('请求已发送，请等待响应...');
```
<!--more--> 
当然我们可以封装起来，改成另外的写法：
```javascript
var ajax = ajaxGet('http://...');
ajax.ifSuccess(success)
    .ifFail(fail);
```

但是我们从ES6后我们有了新的写法

```javascript
new Promise(test).then(function (result) {
    console.log('成功：' + result);
}).catch(function (reason) {
    console.log('失败：' + reason);
});
```

当然这只是简单的promise的利用，进阶版本请看参考链接。

### 参考链接

>
1.[Promise - 廖雪峰的官方网站](http://www.liaoxuefeng.com/wiki/001434446689867b27157e896e74d51a89c25cc8b43bdb3000/0014345008539155e93fc16046d4bb7854943814c4f9dc2000)
2.[[翻译] We have a problem with promises - FEX](http://fex.baidu.com/blog/2015/07/we-have-a-problem-with-promises/)
3.[JavaScript Promise迷你书（中文版）](http://liubin.org/promises-book/)


---
### 前方的路很长，还需努力啊
