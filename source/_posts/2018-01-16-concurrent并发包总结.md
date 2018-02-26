---
title: concurrent并发包总结
categories: java
tags:
  - concurrent并发包
comments: false
copyright: true
top: 10
abbrlink: 9880a961
date: 2018-01-16 13:46:39
---

## <center>java.util.concurrent 包 java并发编程包（一）</center>

### 1.简介

通常所说的concurrent包基本有3个package组成 
java.util.concurrent：提供大部分关于并发的接口和类，如BlockingQueue,Callable,ConcurrentHashMap,ExecutorService, Semaphore等 
java.util.concurrent.atomic：提供所有原子操作的类， 如AtomicInteger, AtomicLong等； 
java.util.concurrent.locks:提供锁相关的类, 如Lock, ReentrantLock, ReadWriteLock, Condition等； 

concurrent包的优点：

> 1. 首先，功能非常丰富，诸如线程池(ThreadPoolExecutor)，CountDownLatch等并发编程中需要的类已经有现成的实现，不需要自己去实现一套； 毕竟jdk1.4对多线程编程的主要支持几乎就只有Thread, Runnable,synchronized等
> 2. concurrent包里面的一些操作是基于硬件级别的CAS(compare and swap),就是在cpu级别提供了原子操作，简单的说就可以提供无阻塞、无锁定的算法； 而现代cpu大部分都是支持这样的算法的；

### 闭锁CountDownLatch

java.util.concurrent.CountDownLatch 是一个并发构造，它允许一个或多个线程等待一系列指定操作的完成。

通常的使用场景是，某个主线程接到一个任务，起了n个子线程去完成，但是主线程需要等待这n个子线程都完成任务了以后才开始执行某个操作； 

演示代码

<!--more-->

```java
@Test
public void demoCountDown()
{
    int count = 10;
    final CountDownLatch l = new CountDownLatch(count);
    for(int i = 0; i < count; ++i)
    {
        final int index = i;
        new Thread(new Runnable() {

            @Override
            public void run() {
                try {
                    Thread.currentThread().sleep(20 * 1000);
                } catch (InterruptedException e) {

                    e.printStackTrace();
                }

                System.out.println("thread " + index + " has finished...");

                l.countDown();

            }
        }).start();
    }

    try {
        l.await();
    } catch (InterruptedException e) {
        e.printStackTrace();
    }

    System.out.println("now all threads have finished");

}
```

只有当前面10个线程执行完成，最后一句话才会执行打印。（ps：10个线程执行顺序不定）
<!--more-->

### Atomic类

Atomic相关的类，比如AtomicLong, AtomicInteger等这些；
简单的说，这些类都是线程安全的，支持无阻塞无锁定的

```java
set()
get()
getAndSet()
getAndIncrement()
getAndDecrement()
getAndAdd()
```

等操作

演示代码

```java
package com.hetaoblog.concurrent.test;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicLong;
import org.junit.Test;

/**
 * by http://www.hetaoblog.com
 *
 * @author hetaoblog
 */
public class AtomicTest {

    @Test
    public void testAtomic() {
        final int loopcount = 10000;
        int threadcount = 10;

        final NonSafeSeq seq1 = new NonSafeSeq();
        final SafeSeq seq2 = new SafeSeq();

        final CountDownLatch l = new CountDownLatch(threadcount);

        for (int i = 0; i < threadcount; ++i) {
            final int index = i;
            new Thread(new Runnable() {

                @Override
                public void run() {
                    for (int j = 0; j < loopcount; ++j) {

                        seq1.inc();
                        seq2.inc();
                    }

                    System.out.println("finished : " + index);
                    l.countDown();

                }
            }).start();
        }

        try {
            l.await();
        } catch (InterruptedException e) {

            e.printStackTrace();
        }

        System.out.println("both have finished....");

        System.out.println("NonSafeSeq:" + seq1.get());
        System.out.println("SafeSeq with atomic: " + seq2.get());

    }
}

class NonSafeSeq {
    private long count = 0;

    public void inc() {
        count++;
    }

    public long get() {
        return count;
    }
}

class SafeSeq {
    private AtomicLong count = new AtomicLong(0);

    public void inc() {
        count.incrementAndGet();
    }

    public long get() {
        return count.longValue();
    }
}
```
其中NonSafeSeq是作为对比的类，直接放一个private long count不是线程安全的，而SafeSeq里面放了一个AtomicLong,是线程安全的；可以直接调用incrementAndGet来增加

运行代码，可以得到类似这样的结果 
finished : 1
finished : 0
finished : 3
finished : 2
finished : 5
finished : 4
finished : 6
finished : 8
finished : 9
finished : 7
both have finished....
NonSafeSeq:91723
SafeSeq with atomic: 100000

可以看到，10个线程，每个线程运行了10,000次，理论上应该有100,000次增加，使用了普通的long是非线程安全的，而使用了AtomicLong是线程安全的；

注意，这个例子也说明，虽然long本身的单个设置是原子的，要么成功要么不成功，但是诸如count++这样的操作就不是线程安全的；因为这包括了读取和写入两步操作；

### 可以代替synchronized关键字的ReentrantLock

在jdk 1.4时代，线程间的同步主要依赖于synchronized关键字，本质上该关键字是一个对象锁，可以加在不同的instance上或者class上，从使用的角度则分别可以加在非静态方法，静态方法，以及直接synchronized(MyObject)这样的用法；
concurrent包提供了一个可以替代synchronized关键字的ReentrantLock，
简单的说你可以new一个ReentrantLock， 然后通过lock.lock和lock.unlock来获取锁和释放锁；注意必须将unlock放在finally块里面，
reentrantlock的好处

1. 是更好的性能，
2. 提供同一个lock对象上不同condition的信号通知
3. 还提供lockInterruptibly这样支持响应中断的加锁过程，意思是说你试图去加锁，但是当前锁被其他线程hold住，然后你这个线程可以被中断；

演示代码

```java
package com.hetaoblog.concurrent.test;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.locks.ReentrantLock;
import org.junit.Test;

public class ReentrantLockDemo {

    @Test
    public void demoLock() {
        final int loopcount = 10000;
        int threadcount = 10;

        final SafeSeqWithLock seq = new SafeSeqWithLock();

        final CountDownLatch l = new CountDownLatch(threadcount);

        for (int i = 0; i < threadcount; ++i) {
            final int index = i;
            new Thread(new Runnable() {

                @Override
                public void run() {
                    for (int j = 0; j < loopcount; ++j) {

                        seq.inc();

                    }

                    System.out.println("finished : " + index);
                    l.countDown();

                }
            }).start();
        }

        try {
            l.await();
        } catch (InterruptedException e) {

            e.printStackTrace();
        }

        System.out.println("both have finished....");

        System.out.println("SafeSeqWithLock:" + seq.get());

    }
}

class SafeSeqWithLock {
    private long count = 0;

    private ReentrantLock lock = new ReentrantLock();

    public void inc() {
        lock.lock();

        try {
            count++;
        } finally {
            lock.unlock();
        }
    }

    public long get() {
        return count;
    }
}
```

同样以前面的类似Sequence的类举例，通过对inc操作加锁，保证了线程安全； 
当然，这里get()我没有加锁，对于这样直接读取返回原子类型的函数，我认为不加锁是没问题的，相当于返回最近成功操作的值； 

运行结果类似这样，
finished : 7
finished : 2
finished : 6
finished : 1
finished : 5
finished : 3
finished : 0
finished : 9
finished : 8
finished : 4
both have finished....
SafeSeqWithLock:100000

### 读写锁ReadWriteLock

concurrent包里面还提供了一个非常有用的锁，读写锁ReadWriteLock 
下面是ReadWriteLock接口的说明： 
A ReadWriteLock maintains a pair of associated locks, one for read-only operations and one for writing. The read lock may be held simultaneously by multiple reader threads, so long as there are no writers. The write lock is exclusive. 

意思是说读锁可以有很多个锁同时上锁，只要当前没有写锁； 
写锁是排他的，上了写锁，其他线程既不能上读锁，也不能上写锁；同样，需要上写锁的前提是既没有读锁，也没有写锁； 
两个写锁不能同时获得无需说明，下面一段程序说明下上了读锁以后，其他线程需要上写锁也无法获得

演示代码

```java
import org.junit.Test;
import java.util.Date;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * @author  LN
 * @create 2018-02-10 15:02
 **/

public class concurrentTest {

    @Test
    public void testRWLock_getw_onr(){
        ReentrantReadWriteLock lock = new ReentrantReadWriteLock();

        final Lock rlock = lock.readLock();
        final Lock wlock = lock.writeLock();

        final CountDownLatch l = new CountDownLatch(2);

        //start r thread
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println(new Date() + "now to get rlock");
                rlock.lock();

                try {
                    Thread.currentThread().sleep(20*1000);
                } catch (InterruptedException ev) {
                    ev.printStackTrace();
                }

                System.out.println(new Date() + "now to unlock rlock");
                rlock.unlock();

                l.countDown();
            }
        }).start();

        //start w lock
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println(new Date() + "now to get wlock");
                wlock.lock();

                System.out.println(new Date() + "now to unlock wlock");
                wlock.unlock();

                l.countDown();
            }
        }).start();

        try {
            l.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println(new Date() + "now to finished");
    }
}
```

在试图获取写锁时，写锁线程必须等读锁线程将读锁释放了之后才可以获得写锁。

结果：
Sat Feb 10 15:26:09 CST 2018now to get rlock
Sat Feb 10 15:26:09 CST 2018now to get wlock
Sat Feb 10 15:26:29 CST 2018now to unlock rlock
Sat Feb 10 15:26:29 CST 2018now to unlock wlock
Sat Feb 10 15:26:29 CST 2018now to finished

ReadWriteLock的实现是ReentrantReadWriteLock，
有趣的是，在一个线程中，读锁不能直接升级为写锁，但是写锁可以降级为读锁；
这意思是，如果你已经有了读锁，再去试图获得写锁，将会无法获得， 一直堵住了； 
但是如果你有了写锁，再去试图获得读锁，没问题；

下面是一段降级的代码，

```java
@Test
public void testRWLock_downgrade()
{
    ReentrantReadWriteLock lock = new ReentrantReadWriteLock();

    Lock rlock = lock.readLock();
    Lock wlock = lock.writeLock();

    System.out.println("now to get wloc
    k");
    wlock.lock();
    System.out.println("now to get rlock");
    rlock.lock();

    System.out.println("now to unlock wlock");

    wlock.unlock();

    System.out.println("now to unlock rlock");
    rlock.unlock();

    System.out.println("finished");
}
```

### 参考资料

- [说一说java的concurrent包-系列文章](http://www.iteye.com/topic/1121021)

- [Java 并发工具包 java.util.concurrent 用户指南](http://blog.csdn.net/defonds/article/details/44021605/)