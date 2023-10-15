## 1 MQ基本概念

<details>
<summary> </summary>

### 1.1 MQ概述
MQ全程Message Queue(消息队列)，是在消息的传输过程中保存消息的容器。多用于分布式系统之间进行通信

### 1.2 MQ优势
- 优势
  - 应用解耦：提高系统容错性和可维护性
  - 异步提速：提升用户体验和系统吞吐量
  - 削峰填谷：提高系统稳定性



### 1.3 MQ劣势
- 劣势
  - 系统可用性降低
    - 系统引入外部依赖越多，系统稳定性越差，一旦MQ宕机，就会对业务造成影响
  - 系统复杂性提供
    - 如何保证消息没有被重复消费、如何处理消息丢失、保证消息传递顺序性
  - 一致性问题

### 1.4 RabbitMQ简介
- AMQP，高级消息队列协议，是一个网络协议。基于此协议的客户端与消息中间件可以传递消息，并不受客户端、中间件不同产品，不同开发语言等条件限制  
基础框架
![](/img/RabbitMQ/base_structrue.png)

### 1.5 JMS
- JMS即JavaMessage Service，消息服务应用程序接口，是java中面向消息中间件的API



</details>

---

## 2 RabbitMQ安装以及快速入门

<details>
<summary> </summary>

在linux上搭建
### 2.1 准备
- [RabbitMQ3.6.5安装包](https://github.com/rabbitmq/rabbitmq-server/releases?expanded=true&page=4&q=3.6.5)
- [erlang安装包](https://github.com/rabbitmq/erlang-rpm/releases?page=22)
- 注意RabbitMQ版本需使用对应erlang版本，rabbitMQ官网可查看  
 [版本查询](https://www.rabbitmq.com/which-erlang.html)


```
#安装依赖环境
yum install build-essential openssl openssl-devel uni0DBC unix0DBC-devel make gcc gcc-c++ kernel-devel m4 ncurses-devel tk tc xz 
#安装erlang
rpm -ivh erlang-19.3.6.5-1.el7.centos.x86_64.rpm
#socat安装(rabbitmq依赖)
yum install -y socat
#安装RabbitMQ
rpm -ivh rabbitmq-server-3.6.5-1.noarch.rpm

```

**启动**
```
systemctl start rabbitmq-server #启动
systemctl restart rabbitmq-server #重启
systemctl stop rabbitmq-server #停止
systemctl status rabbitmq-server #状态
```
**开启管理界面以及配置**
```
rabbitmq-plugins enable rabbitmq_management
#修改默认配置信息
vim /usr/lib/rabbitmq/lib/rabbitmq_server-3.6.5/ebin/rabbit.app
#将loopback_users中的guest释放，即删除<<"">>符号,配置结束记得restart服务
```
**登录测试**
- 访问http://虚拟机ip:15672/
  - 端口默认15672
  - 注意虚拟机防火墙拦截，简单解决方法关闭虚拟机防火墙




</details>

---

## 3 

<details>
<summary> </summary>




</details>

---

## 4 

<details>
<summary> </summary>




</details>