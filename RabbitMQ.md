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
![](/img/RabbitMQ/Routing.png)
- 队列与交换机绑定，需要指定一个RoutingKey
- 消息的发送方在想交换机发送消息时，也必须指定消息的RoutingKey
- 交换机不再把消息交给每一个绑定的对象，而是根据RoutingKey判断，只有Key一致的队列才会受到消息

#### 4.3.1 Provider&Consumer
只需修改交换机的绑定参数即routingKey即可
例如：
```java
channel.queueBind(queue1Name,exchangeName,"error");
channel.queueBind(queue2Name,exchangeName,"info");
channel.queueBind(queue2Name,exchangeName,"error");
channel.queueBind(queue2Name,exchangeName,"warning");
```

### 4.4 Topics 通配符模式
![](/img/RabbitMQ/Topics.png)
- 能实现Pub/Sub和Routing模式的功能，至少Topic在配置routingKey时可以使用通配符，更加灵活  
通配符规则  

|符号|规则|示例|
|-|-|-|
|*|匹配一个单词|`pptp.*`将匹配`pptp.a`、`pptp.b`|
|#|匹配0个或多个单词|`pptp.#`将匹配`pptp.a.b`、`pptp.b.a`|
</details>

---

## 5 SpringBoot整合RabbitMQ

<details>
<summary> </summary>

### 5.1 SpringAMQP0
- 基于AMQP协议定义的一套API规范，提供了模板来发送和接受消息。包含两部分，其中spring-amqp是基础抽象，spring-rabbit是底层的默认实现

**依赖**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-amqp</artifactId>
</dependency>
```
**application配置**
```yml
spring:
  rabbitmq:
    host:  192.168.52.129 #主机名
    port:  5672 #端口
    virtual-host:  /itcast #虚拟主机
    username:  pptp #用户名
    password:  pptp #密码
    #设置连接超时时间,单位ms
    #解决.concurrent.TimeoutException报错
    connection-timeout:  0

```

#### 5.1.1 简单样例
- SpringAMQP提供了RabbitTemplate工具类，方便我们发送消息
> 该样例队列用图形页面添加  

**发送消息**
```java
@Autowired
private RabbitTemplate rabbitTemplate;

@Test
void testSimpleQueue() {
    //队列名
    String queueName = "pptp.queue";
    // 消息
    String message = "hello rabbitmq";
    // 发送
    rabbitTemplate.convertAndSend(queueName,message);
    //rabbitTemplate.convertAndSend(exchangeName,routingKey,message);
}
```
**接收消息**
```java
@Component
public class SpringRabbitListener {

    @RabbitListener(queues = "pptp.queue") //声明要监听的队列名称
    public void listenSimpleQueue(String msg){
        System.out.println(msg);
    }
}
```

#### 5.1.2 队列与交换机声明
SpringAMQP提供了几个类，用来声明队列、交换机及其绑定关系
- Queue：用于声明队列，可以用工厂类QueueBuilder构建
- Exchange：用于声明交换机，可以用工厂类ExchangeBuilder构建
- Binding：用于声明队列和交换机的绑定关系，可以用工厂类BindingBuilder构建

**5.1.2.1 基于Bean声明**
```java
@Configuration
public class FanoutConfiguration {
    //声明FanoutExchange交换机
    @Bean
    public FanoutExchange fanoutExchange(){
        return new FanoutExchange("pptp.fanout");
    }
    //声明队列1
    @Bean
    public Queue fanoutQueue1(){
        return new Queue("fanout.queue1");
    }
    //绑定队列1与交换机
    @Bean
    public Binding bindingQueue1(Queue fanoutQueue1,FanoutExchange fanoutExchange){
        return BindingBuilder.bind(fanoutQueue1).to(fanoutExchange);
    }
}

```
**5.1.2.2 基于注解声明**
```java
@RabbitListener(bindings = @QueueBinding(
        value = @Queue(name = "direct.queue1",durable = "true"),
        exchange = @Exchange(name = "pptp.direct",type = ExchangeTypes.DIRECT),
        key = "123"
)
)
public void listenSimpleQueue2(String msg) throws InterruptedException{
    System.out.println(msg);
}
```

### 5.2 消息转换器
- spring的对消息对象的处理是由org.springframework.amqp.support.converter.MessageConverter来处理的，而默认实现是SimpleMessageConverter，基于JDK的ObjectOutputStream完成序列化，存在下列问题：
  - JDK的序列化有安全风险
  - JDK序列化的消息太大
  - JDK序列化消息的可读性差
- 建议使用JSON序列化
```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
</dependency>
```
添加配置bean
```java
@Bean
public MessageConverter jacksonMessageConverter(){
    return new Jackson2JsonMessageConverter();
}
```

</details>

---

## 6 生产者可靠性

<details>
<summary> </summary>

### 6.1 生产者重连
> 有时候由于网络波动，可能会出现客户端连接MQ失败情况，通过配置我们可以开启连接失败后的重连机制
```yml
spring:
  rabbitmq:
    connection-timeout:  0 #设置连接超时时间 0代表等待至连接成功
    template:
      retry:
        enabled: true #开启超时重试机制
        initial-interval: 1000ms #失败后的初始等待时间
        multiplier: 1 #失败后下次等待时长的倍数，下次等待时长 = initial-interval * multiplier
        max-attempts: 3 #最大重试次数
```

### 6.2 生产者确认
> RabbitMQ提供了Publisher Confirm和ublisher Return两种确认机制。开启后MQ成功收到消息后会返回确认消息给生产者，结果有以下几种：
> - 消息投递到了MQ，但路由失败。此时会通过PublisherReturn返回路由异常原因，然后返回ACK，告知投递成功
> - 临时消息投递到了MQ，并且入队成功，返回ACK
> - 持久消息投递到了MQ，并且入队完成持久化，返回ACK
> - 其他情况返回NACK

### 6.3 实现
publisher中添加配置
```yml
spring:
  rabbitmq:
    publisher-confirm-type: correlated #开启publisher confirm机制 
    # tpye：
    #1. none：关闭confirm机制
    #2. simple：同步阻塞等待MQ的回执消息
    #3. correlated：MQ异步回调方式返回回执消息
    publisher-returns: true #开启publisher return机制
```

#### 6.3.1 ReturnCallback
```java
@Slf4j
@Configuration
public class MqConfirmConfig implements ApplicationContextAware {
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        RabbitTemplate rabbitTemplate=applicationContext.getBean(RabbitTemplate.class);
        //配置回调
        rabbitTemplate.setReturnsCallback(new RabbitTemplate.ReturnsCallback() {
            @Override
            public void returnedMessage(ReturnedMessage returnedMessage) {
                log.debug("收到消息的return callback,exchange:{},key:{},msg:{},code:{},text:{}",
                        returnedMessage.getExchange(),returnedMessage.getRoutingKey(),returnedMessage.getMessage(),
                        returnedMessage.getReplyCode(),returnedMessage.getReplyText()
                );
            }
        });
    }
}
```

#### 6.3.2 ConfirmCallback
```java
@Test
void testConfirmCallback() {
    //1.创建cd
    CorrelationData cd = new CorrelationData(UUID.randomUUID().toString());
    //2.添加ConfirmCallback
    cd.getFuture().addCallback(new ListenableFutureCallback<CorrelationData.Confirm>() {
        @Override
        public void onFailure(Throwable ex) {
            log.error("消息回调失败(spring问题",ex);
        }

        @Override
        public void onSuccess(CorrelationData.Confirm result) {
            log.debug("收到confirm callback回执");
            if(result.isAck()){
                log.debug("消息发送成功，收到ACK");
            }
            else{
                log.error("消息发送失败，收到NACK，原因：{}",result.getReason());
            }
        }
    });
    Map<String,Object> msg=new HashMap<>();
    msg.put("name","jack");
    rabbitTemplate.convertAndSend("pptp.direct","123",msg,cd);
    try {
        Thread.sleep(100000); //等待回调
    } catch (InterruptedException e) {
        throw new RuntimeException(e);
    }
}
```

</details>

---

## 7 MQ可靠性

<details>
<summary> </summary>

> 在默认情况下，RabbitMQ会将接收到的信息保存在内存中以降低消息收发的延迟。这会导致两个问题：
> - 一旦MQ宕机，内存中的消息会丢失
> - 内存空间有限，当消费者故障或处理过慢时，会导致消息积压，引发MQ阻塞  
>   - 内存上限时MQ会执行Paged Out机制，将消息持久化
> 
> 解决方法：
> - 数据持久化
> - Lazy Queue

### 7.1 数据持久化
RabbitMQ实现数据持久化包括三个方面：
- 交换机持久化 (spring默认持久)
- 队列持久化 (spring默认持久)
- 消息持久化 --修改DeliveryMode

### 7.2 Lazy Queue
在3.12后所有的队列都是LazyQueue模式，无法更改
**特征**
- 接收到消息后直接存入磁盘而非内存
- 消费者要消费消息时才会从磁盘中读取并加载到内存
- 支持数百万条的消息存储

**实现**
- 基于@Bean
```java
@Bean
public Queue LazyQueue(){
    return QueueBuilder
            .durable("lazy.queue")
            .lazy()
            .build();
}
```
- 基于注解
```java
@RabbitListener(queuesToDeclare = @Queue(
        name = "lazy.queue",
        durable = "true",
        arguments = @Argument(name = "x-queue-mode",value = "lazy")
))
public void listenLazyQueue(String msg){
    log.info("接收到：{}",msg);
}
```

</details>

---

## 8 消费者可靠性

<details>
<summary> </summary>

### 8.1 消费者确认机制
为了确认消费者是否成功处理消息，RabbitMQ提供了消费者确认机制。当消费者处理消息结束后，应该向RabbitMQ发送一个回执，告知RabbitMQ自己消息处理状态。回执有三种可选值：
- ACK：成功处理消息，RabbitMQ从队列中删除该消息
- NACK：消息处理失败，RabbitMQ需要再次投递消息
- Reject：消息处理失败并拒绝该消息，RabbitMQ从队列中删除该消息  
- 
SpringAMQP已经实现了消息确认功能，并允许我们通过配置文件选择ACK处理方式，有三种方式：
- none：不处理。即消息投递给消费者后立刻ack，消息会立刻从MQ删除。非常不安全
- manual：手动模式。需要自己在业务代码中调用api，发送ack或reject，存在业务入侵，但更灵活
- auto：自动模式。SpringAMQP利用AOP对我们的消息处理逻辑做了环绕增强，当业务正常执行时则自动返回ack，业务出现异常，根据异常判断返回不同结果；
  - 业务异常，返回nack
  - 消息处理异常或校验异常，返回reject

**实现**  
修改配置
```yml
spring:
  rabbitmq:
    listener:
      simple:
        prefetch: 1
        acknowledge-mode: none #none 关闭；manual，手动ack；auto，自动ack
```

### 8.2 失败重试机制
当消费者出现异常后，消息会不断requeue(重新入队)到队列，再重新发送给消费者，然后再次异常，再次requeue，无限循环，导致mq的消息处理飙升，带来不必要的压力。我们可利用Spring的retry机制，在消费者出现异常时利用本地重试，而不是无限制的requeue到mq队列  


**配置**
```yml
spring:
  rabbitmq:
    listener:
      simple:
        prefetch: 1
        retry:
          enabled: true #开启消费者失败重试
          initial-interval: 1000ms #初始的失败等待时长为1s
          multiplier: 1
          max-attempts: 3
          stateless: true #true 无状态；false有状态。如果业务中包含事务，这里改为false
```

### 8.3 失败消息处理策略
在开启重试模式后，重试次数耗尽，如果消息依然失败，则需要有MessageRecoverer接口处理，它包含三种不同实现：
- RejectAndDontRequeueRecoverer：重试耗尽后，直接reject，丢弃消息。默认方式
- ImmediateRequeueMessageRecoverer：重试耗尽后，返回nack，消息重新入队
- RepublisherMessageRecoverer：重试耗尽后，将失败消息投递到指定的交换机

**RepublisherMessageRecoverer**  
将失败策略改为RepublisherMessageRecoverer：
1. 定义接收失败消息的交换机、队列及其绑定关系
2. 定义RepublisherMessageRecoverer:  
   ```java
    @Configuration
    @ConditionalOnProperty(prefix = "spring.rabbitmq.listener.simple.retry",name = "enabled",havingValue = "true") //配置开启才启用
    public class ErrorConfiguration {
        @Bean
        public MessageRecoverer messageRecoverer(RabbitTemplate rabbitTemplate){
            return new RepublishMessageRecoverer(rabbitTemplate,"error.exchange","error");
        }
    }
   ```

### 8.4 业务幂等性
> 指同一个业务，执行一次或多次对业务状态的影响是一致的

#### 8.4.1 解决重复消息

**方案一  唯一消息id**  
给每个消息设置一个唯一id，利用id区分是否是重复消息：
- 每一条消息都生成一个唯一的id，与消息一起投递给消费者
- 消费者接收到消息后处理自己的业务，业务处理成功后将消息ID保存到数据库
- 如果下次又收到相同消息，去数据库查询判断是否存在，存在则为重复消息放弃处理  

```java
//consumer中利用消息转换器添加
@Bean
public MessageConverter jacksonMessageConverter(){
    //1. 定义消息转换器
    Jackson2JsonMessageConverter jjmc = new Jackson2JsonMessageConverter();
    //2. 配置自动创建消息id，用于识别不同消息，也可以在业务中基于ID判断是否为重复消息
    jjmc.setCreateMessageIds(true);
    return jjmc;
}
```

**方案二  业务判断**  
结合业务逻辑，基于业务本身做判断。例如：我们要在支付后修改订单状态为已支付，应该在修改订单状态前先查询订单状态，判断状态是否是未支付。只有未支付订单才需要修改，其他不做处理



</details>

---

## 9 

<details>
<summary> </summary>




</details>

---

##  

<details>
<summary> </summary>




</details>