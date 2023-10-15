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

## 2 RabbitMQ安装

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

**解决config file not found**
将/usr/share/doc/rabbitmq-server-3.6.5/下rabbitmq.config.example复制到/etc/rabbitmq/
```
cp /usr/share/doc/rabbitmq-server-3.6.5/rabbitmq.config.example /etc/rabbitmq/rabbitmq.config
```
操作后重启服务即可


</details>

---

## 3 RabbitMQ快速入门

<details>
<summary> </summary>

- 创建Consumer、Provider模块
依赖
```
<dependency>
    <groupId>com.rabbitmq</groupId>
    <artifactId>amqp-client</artifactId>
    <version>5.14.2</version>
</dependency>
```
**Provider简单模式下**
```java
public class ProviderHelloWorld {
    public static void main(String[] args) throws IOException, TimeoutException {
        //1.创建连接工厂
        ConnectionFactory factory=new ConnectionFactory();
        //2.设置参数
        factory.setHost("192.168.52.129"); //ip
        factory.setPort(5672); //port 默认5672
        factory.setVirtualHost("/itcast");//虚拟机 默认/
        factory.setUsername("pptp"); //用户名
        factory.setPassword("pptp"); //密码
        factory.setHandshakeTimeout(300000000);//设置握手时间 解决超时报错问题
        //3.创建连接
        Connection connection = factory.newConnection();
        //4.创建channel
        Channel channel=connection.createChannel();
        //5.创建Queue
        /**
         *参数
         * 1. queue 队列名称
         * 2. durable 是否持久化，当mq重启后还在
         * 3. exclusive 是否独占，只能有一个consumer监听。当connection关闭时是否删除队列
         * 4. autoDelete 是否自动删除
         * 5. arguments 参数
         */
        channel.queueDeclare("helloWorld",true,false,false,null);
        //6.发送消息
        /**
         * 参数
         * 1. exchange 交换机名称，默认""
         * 2. routingKey 路由名称
         * 3. props 配置信息
         * 4. body 发送的消息数据
         */
        String body="hello rbmq";
        channel.basicPublish("","helloWorld",null,body.getBytes());
        
        //7.释放资源
        channel.close();
        connection.close();
    }
}
```
执行成功后页面管理queues结果  
![](/img/RabbitMQ/result1.png)

**Consumer**
```java
public class ConsumerHelloWorld {
    public static void main(String[] args) throws IOException, TimeoutException {
        ConnectionFactory factory=new ConnectionFactory();
        factory.setHost("192.168.52.129"); //ip
        factory.setPort(5672); //port 默认5672
        factory.setVirtualHost("/itcast");//虚拟机 默认/
        factory.setUsername("pptp"); //用户名
        factory.setPassword("pptp"); //密码
        factory.setHandshakeTimeout(300000000);//设置握手时间
        Connection connection = factory.newConnection();
        Channel channel=connection.createChannel();
        channel.queueDeclare("helloWorld",true,false,false,null);
        //接收消息
        /**
         * 参数
         * 1. queue 队列名称
         * 2. autoAck 是否自动确认
         * 3. callback 回调对象
         */
        Consumer consumer=new DefaultConsumer(channel){
            //回调方法，当收到消息后会自动执行该方法

            /**
             * 
             * @param consumerTag 标识
             * @param envelope 获取信息
             * @param properties 配置信息
             * @param body 数据
             * @throws IOException
             */
            @Override
            public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
                System.out.println(body.toString());
            }
        };
        channel.basicConsume("helloWorld",true, consumer);
    }
}
```

</details>

---

## 4 RabbitMQ工作模式

<details>
<summary> </summary>

### 4.1 Queues工作队列模式
![](/img/RabbitMQ/work_queues.png)
- 相比简单模式多了多个消费端，多个消费端共同消费同一个队列中的消息
- 应用于对于任务过重或任务较多情况，可以提高任务处理速度
- 代码上与简单模式无异

### 4.2 Pub/Sub订阅模式
![](/img/RabbitMQ/Pub_Sub.png)
- 引入了交换机(X)角色
  - 一方面接受生产者发送的消息，另一方面知道如何处理消息，如递交给某个特定队列。操作取决于Exchange类型:
    - Fanout：广播，将消息交给所有绑定到交换机的队列
    - Direct：定向，将消息交给符合指定routingkey的队列
    - Topic：通配符，把消息交给符合routing pattern的队列
    - Headers：参数匹配
- Exchange只负责转发消息，不具备存储消息的能力，因此如果没有任何队列与Exchange绑定，或者没有符合路由规则的队列，那么消息会丢失  


#### 4.2.1 Provider
> 主要增添了创建交换机和绑定步骤
```java
public class ProviderPubSub {
    public static void main(String[] args) throws IOException, TimeoutException {
        ConnectionFactory factory=new ConnectionFactory();
        factory.setHost("192.168.52.129"); 
        factory.setPort(5672); 
        factory.setVirtualHost("/itcast");
        factory.setUsername("pptp"); 
        factory.setPassword("pptp");
        factory.setHandshakeTimeout(300000000);
        Connection connection = factory.newConnection();
        Channel channel=connection.createChannel();
        //5.创建交换机
        /**
         * 参数
         * 1. exchange 交换机名称
         * 2. type 交换机类型
         *      DIRECT：定向
         *      FANOUT：广播
         *      TOPIC：通配符放松
         *      HEADERS：参数匹配
         * 3. durable：是否持久化
         * 4. autoDelete：自动删除
         * 5. internal：内部使用，一般false
         * 6. arguments：参数
         */
        String exchangeName="testFanout";
        channel.exchangeDeclare(exchangeName, BuiltinExchangeType.FANOUT,true,false,false,null);
        //6.创建队列
        String queue1Name="testFanoutQueue1";
        String queue2Name="testFanoutQueue2";
        channel.queueDeclare(queue1Name,true,false,false,null);
        channel.queueDeclare(queue2Name,true,false,false,null);
        //7.绑定队列和交换机
        /**
         * 参数
         * 1. queue：队列名称
         * 2. exchange：交换机名称
         * 3. routingKey：路由键，绑定规则，fanout默认为空字符串
         */
        channel.queueBind(queue1Name,exchangeName,"");
        channel.queueBind(queue2Name,exchangeName,"");
        //8. 发送消息
        String body="呵呵";
        channel.basicPublish(exchangeName,"",null,body.getBytes());
        //9/释放资源
        channel.close();
        connection.close();
    }
}
```
执行结果可发现两队列各有一条消息
![](/img/RabbitMQ/result2.png)

#### 4.2.1 Consumer
消费者代码无异，只需指定消费的队列，如样例种的queue1Name,queue2Name

### 4.3 Routing 路由模式




</details>

---

## 5 

<details>
<summary> </summary>




</details>

---

## 6 

<details>
<summary> </summary>




</details>

---

## 7 

<details>
<summary> </summary>




</details>