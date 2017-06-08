---
title: spring ioc 控制反转
categories: java学习之路
tags:
  - java
  - IOC（Inversion of Control）控制反转
comments: true
abbrlink: 50de3585
date: 2017-03-04 21:15:00
---

## <center>Spring -- IOC<center>

### spring ioc 控制反转

    IOC（Inversion of Control）控制反转：本来是由应用程序管理的对象之间的依赖关系，现在交给了容器管理，这就叫控制反转，即交给了IOC容器，Spring的IOC容器主要使用DI方式实现的。不需要主动查找，对象的查找、定位和创建全部由容器管理。

    通俗点说就是不创建对象。以前我们要调用一个对象的方法，首先要new一个对象。但使用IOC容器，在代码中不直接与对象连接，而是在配置文件中描述要使用哪一个对象。容器负责将这些联系在一起。

### 实现方法

      IOC容器的对象实例化是通过配置文件来实现的。术语上这叫做注入。注入有两种形式，采用构造方法注入和采用setter注入。具体的注入形式如下
<!--more--> 
采用set方法注入，给属性添加一个set方法，并对其进行赋值
```java
publicclass UserManagerImplimplements UserManager {

    private UserDaouserDao;

    publicvoid setUserDao(UserDao userDao) {

        this.userDao = userDao;

    }

}
```
#### 配置文件：
```java
<beanid="userManager"class="com.bjpowernode.spring.manager.UserManagerImpl">

     <propertyname="userDao"ref="usrDao4Oracle"/>

  </bean>
```
set注入特点：

        与传统的JavaBean的写法更相似，程序员更容易理解、接受，通过setter方式设定依赖关系显得更加直观、明显；

        对于复杂的依赖关系，如果采用构造注入，会导致构造器过于臃肿，难以阅读。Spring在创建Bean实例时，需要同时实例化其依赖的全部实例，因而导致死你功能下降。而使用设置注入，则避免这下问题；

       尤其在某些属性可选的情况下，多参数的构造器更加笨拙。

采用构造方法注入，在构造方法中对属性进行赋值
```java
publicclass UserManagerImplimplements UserManager {

    private UserDaouserDao;

    public UserManagerImpl(UserDao userDao) {
        this.userDao = userDao;
    }
}
```
配置文件：
```java
<beanid="userManager"class="com.bjpowernode.spring.manager.UserManagerImpl">

    <constructor-argref="userDao4Mysql"/>

</bean>
```
构造方法注入特点：

       构造注入可以在构造器中决定依赖关系的注入顺序，优先依赖的优先注入。

       对于依赖关系无须变化的Bean，构造注入更有用处；因为没有setter方法，所有的依赖关系全部在构造器内设定，因此，不用担心后续代码对依赖关系的破坏。
      依赖关系只能在构造器中设定，则只有组件的创建者才能改变组件的依赖关系。对组件的调用者而言，组件内部的依赖关系完全透明，更符合高内聚的原则；
