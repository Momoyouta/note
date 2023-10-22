## I.通用命令
<details>
<summary> </summary>

查看命令：`help @generic`  `help command`

### 常用命令
1. `KEYS pattern`：查看复合模板的所有key
2. `DEL key1,key2...`：删除key
3. `EXISTS key`：判断key是否存在
4. `EXPIRE key seconds`：给key设置有效期，到期会自动删除key
5. `TTL key`：查看key剩余有效期    

#### String类型
 <details>
<summary> </summary>

**常见命令**
1. `SET` 添加或修改已经存在的一个·String类型键值对
2. `GET` 根据key获取string类型的value
3. `MSET` 批量添加多个String类型键值对
4. `MEGT` 根据多个KEY获取value
5. `INCR` 让一个整型key自增1
6. `INCRBY` 让一个整型key自增并且指定步长
7. `INCRBYFLOAT` 让一个浮点类型数字自增并指定步长
8. `SETNX` 添加一个string类型键值对，前提是key不存在
9. `SETEX` 添加一个string类型键值对且指定有效期

</details>

#### Hash类型
<details>
<summary> </summary>

Hash的value是无序字典，可以将对象中的每个字段单独存储
**常见命令**
1. `HSET key field value` 添加或修改已经存在的一个hash类型键值对
2. `HGET` 根据key获取hash类型key的field的value
3. `HMSET` 批量添加多个hash类型key的field的value
4. `HMEGT` 根据多个KEY获取key的field的value
5. `HINCRBY` 让一个hash的key的字段自增并且指定步长
6. `HSETNX` 添加一个hash类型key的field的value，前提是key不存在

</details>

#### List类型
<details>
<summary> </summary>

可看作一个双向链表结构，支持正反向检索
**常用命令**
1. `LPUSH key elment` ... 向列表左(L改R即右侧)侧插入元素
2. `LPOP key` 移除并返回左(L改R即右侧)侧第一个元素
3. `LRANGE key star end` 返回一段索引内的所有元素
4. `BLPOP\BRPOP` 类似LPOP，但没有元素时等待指定时间
</details>

#### Set类型
<details>
<summary> </summary>

类似Java中的HashSet，可以看作是一个value为null的HashMap
**常用命令**
1. `SADD` 向set中添加元素
2. `SREM` 移除set中的指定元素
3. `SCARD` 返回set中元素数
4. `SISMEMBER` 判断一个元素是否在set中
5. `SMEMBERS` 获取set中所有元素
6. `SINTER` 求两集合交集
7. `SDIFF` 求两集合差集
8. `SUNION` 求两集合并集
</details>

#### SortedSet类型
<details>
<summary> </summary>

可排序的Set集合,每个元素又score值靠该值排序

**常用命令**
1. `ZADD` 添加元素
2. `ZREM` 删除元素
3. `ZSCORE` 获取指定元素score值
4. `ZRANK` 获取指定元素排名
5. `ZCARD` 获取元素个数
6. `ZCOUNT` 统计score值在指定范围内的所有元素个数
7. `ZRANGE` 获取排序后指定排名内的元素  
所有的排名默认升序，在命令Z后添加REV则为降序
</details>

</details>

---

## II.Jedis入门

<details>
<summary> </summary>

所需依赖
```
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>3.7.0</version>
</dependency>
```

建立连接池
```java
public class JedisConnectionFactory {
    private static final JedisPool jedisPool; //连接池
    static {
        //配置连接池
        JedisPoolConfig poolConfig=new JedisPoolConfig();
        //最大连接数
        poolConfig.setMaxTotal(8);
        //最大空闲连接
        poolConfig.setMaxIdle(8);
        //最小空闲连接
        poolConfig.setMinIdle(0);
        //等待时长，当连接池没有连接池可用时，等待的时常
        poolConfig.setMaxWaitMillis(1000);
        //创建连接池对象
        jedisPool=new JedisPool(poolConfig,"192.168.52.129",6379,1000,"123456");
    }
    public static Jedis getJedis(){
        return jedisPool.getResource();
    }
}
```
使用
```java
public class JedisTest {
    private Jedis jedis;

    @BeforeEach
    void setUp(){
        jedis = JedisConnectionFactory.getJedis();//建立连接
        jedis.auth("123456");
        jedis.select(0);//选择库
    }

    @Test
    void testString(){
        String result=jedis.set("name","asd");
        String name=jedis.get("name");
        System.out.println(name);
    }

    @AfterEach
    void tearDown(){
        if(jedis!=null){
            jedis.close();
        }
    }
}

```

</details>

---

## III.SpringDataRedis

<details>
<summary> </summary>

SpringData时Spring中数据操作模块，包含对各种数据库的集成，其中对Redis的集成模块为SpringDataRedis
- 提供了对不同Redis客户端(Lettuce和Jedis)的整合
- 提供了RedisTemplate统一API来操作Redis
- 支持基于JDK、JSON、字符串、spring对象的数据序列号以及反序列化

**操作步骤**
1. 导入依赖
2. 配置Redis数据源
3. 编写配置类，创建RedisTemplate对象
4. 通过RedisTeamlate对象操作Redis


**依赖**
<details>
<summary> </summary>

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-pool2</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>

<!-- 自定义序列化相关依赖 -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
</dependency>
```

</details>

**连接池配置**
<details>
<summary> </summary>

```yaml
spring:
  data: #springboot 3.0后层级为spring>data>redis>host
    redis:
      host: 192.168.52.129
      port: 6379
      password: 123456
      lettuce:
         pool:
           max-active: 8 #最大连接
           max-idle: 8 #最大空闲连接
           min-idel: 0 #最小空闲连接
           max-wait: 100ms #连接等待时间
```

</details>

### 初始化配置类
```java
@Configuration
public class RedisConfiguration {
    public RedisTemplate redisTemplate(RedisConnectionFactory redisConnectionFactory){
        RedisTemplate redisTemplate=new RedisTemplate<>();
        //设置redis的连接工厂对象
        redisTemplate.setConnectionFactory(redisConnectionFactory);
        //设置redis key序列化器
        redisTemplate.setKeySerializer(new StringRedisSerializer());
        return  redisTemplate;
    }
}

```


### RedisTemplate工具类
对数据库操作借用该工具类方法即可
![](/img/Redis/redisTemplate.png)


**StringRedisTemplate**
将key与value序列化成String类型
- 对于对象序列化以及反序列化需要手动进行
  - 该部分可以借用ObjectMapper序列化工具
    ```java
    private static final ObjectMapper mapper=new ObjectMapper();//json序列化处理工具
    @Test
    void testSaveUser() throws JsonProcessingException {
        String json =mapper.writeValueAsString(new User("虎哥",21));//手动序列化
        stringRedisTemplate.opsForValue().set("user:200",json);
        String jsonUser=stringRedisTemplate.opsForValue().get("user:200"); 
        User userl=mapper.readValue(jsonUser,User.class);//反序列化
        System.out.println(userl);
    }
    ```


</details>


---

## IV.事务和锁机制

<details>
<summary> </summary>

> - Redis事务是一个单独的隔离操作：事物中的所有命令都会序列化、按顺序地执行。事务在执行的过程中，不会被其他客户端发送来的命令请求打断
> - Redis事务的主要作用就是串联多个命令防止别的命令插队

### 4.1 Multi、Exec、discard
从输入`Multi`开始，输入的命令都会依次进入命令队列中，但不会执行，直到输入`Exec`，redis会将之前的命令队列中的命令依次执行。组队的过程中可以通过`discard`来放弃组队
![图片均来源于尚硅谷](/img/Redis/Multi.png)

### 4.2 事务错误处理
- 组队中某个命令出现了报告错误，执行时整个的所有队列都会被取消
- 如果执行阶段某个命令出现了错误，则只有报错的命令不会被执行，而其他命令都会执行，不会回滚

### 4.3 事务冲突问题
![](/img/Redis/task_question.png)

#### 4.3.1 悲观锁
- 每次去拿数据时都认为别人会修改，所以每次在拿到数据的时候都会上锁，这样别人想拿这个数据就会block，直到它拿到锁。
![](/img/Redis/Pessimistic_lock.png)

#### 4.3.2 乐观锁
- 每次拿数据时候都认为别人不会修改，所以不会上锁，但在更新的时候判断一下在此期间有没有去更新这个数据，可以使用版本号等机制
- 乐观锁适用于多读的应用类型，这样可以提高吞吐量
- Redis就是利用这种check-and-set机制实现事务的
![](/img/Redis/Optimis_lock.png)

**实现** 
- **WATCH key [key..]**  
在执行multi之前，先执行watch key1 [key2]，可以监视一个/多个key，如果在事务执行之前这个key被其他命令所改动，那么事务将被打断
- **unwatch**  
  取消监视

#### 4.3.3 库存遗留问题
- 单纯的乐观锁导致库存因版本号不同而无法修改，而请求消息已经被消费，实际减少库存量与请求量不相符
- 如2000个请求对500库存进行减-1操作，最终库存不为0

**解决方法**  
使用`LUA`脚本
- Lua是一个小巧的脚本语言，Lua脚本可以很容易被C/C++代码调用，也可以反过来调用C/C++的函数
- 一般作为嵌入式脚本语言
- 在Rides中可以将复杂的或者多步的redis操作写为一个脚本，一次提交给redis执行，减少反复连接redis的次数，提升性能

利用Redis单线程的特性，将多个命令集合成一个，不会被打断，从而解决乐观锁并发问题

#### 4.3.4 Redis事务三特性
- 单独的隔离操作
- 事务中的所有命令都会序列化、按顺序的执行。事务在执行的过程中，不会被其他客户端发送来的命令请求打断
- 没有隔离级别的概念
- 队列中的命令没有提交之前都不会实际被执行，因为事务提交前任何指令都不会被实际执行
- 不保证原子性
- 事务中如果有一条命令执行失败，其后的命令仍然会被执行，无回滚

</details>

---

## V.持久化

<details>
<summary> </summary>

### 5.1 Redis DataBase
> - RDB：在指定的时间间隔内将内存中的数据集快照写入磁盘，也就是行话讲的Snapshot快照，它恢复时是将快照文件直接读到内存里
> - Redis会单独fork一个子进程来进行持久化(写时复制技术)，会先将数据写入到一个临时文件中，待持久化过程都结束了，再调用这个临时文件替换上次持久化好的文件。整个过程中主进程不进行任何IO操作，这确保了极高的性能。
> - RDB的缺点是最后一次持久化后数据可能丢失

#### 5.1.1 dump.rdb文件
**修改存储路径**
- redis.conf下修改snapshot中的dir
- 默认存在redis启动目录下

**关闭写入磁盘**  
snapshow下
`stop-writes-on-bgsave-error yes/no`

**save**  
设置指定时间内触发持久化阈值如：
```
save 600 10
//表示十分钟内key改变不少于10，则进行持久化操作，更推荐使用redis自动持久化bgsave
```

### 5.2 Append Only File
> 以日志的形式来记录每个写操作(增量保存)，将Redis执行过的所有写指令记录下来(读操作不记录)，只许追加文件但不可以改写文件，redis启动之初会读取该文件重新构建数据，换言之，redis重启的话就根据日志文件的内容将写指令从前到后执行一次

- AOF默认不开启，可在redis.conf中配置文件名称，默认为appendonly.aof
- AOF文件的保存路径与RDB一致
- AOF与RDB同时开启，系统默认取AOF的数据(数据不存在丢失)
- 当文件损坏时可以通过bin目录下`redis-check-aof --fix file`修复

#### 5.2.1 AOF同步频率设置
- appendfsyns value
  - always：始终同步，每次Redis的写入都会立刻记入日志。性能较差但数据完整性比较好
  - everysec：每秒同步，每秒计入日志一次，如果宕机，本秒数据可能丢失
  - no：redis不主动进行同步，把同步时机交给操作系统

#### 5.2.2 Rewrite压缩
- AOF采用文件追加的方式，文件会越来越大，为避免出现此种情况，新增了重写机制，当AOF文件大小超过设定阈值时，Redis就会启动AOF文件的内容压缩，只保留可以恢复数据的最小指令集
- 重写原理：将rdb的快照以二进制的形式附在新的aof头部作为已有的历史数据
- 重写流程：类似RDB，利用写时复制技术
- `auto-aof-rewrite-percentage`：设置重写的基准值，文件达到原文件(1+value)%时开始重写
- `auto-aof-rewrite-min-size`：设置重写基准值,最小文件大小，单位MB,达到这个值开始重写


</details>

---

## VI.主从复制

<details>
<summary> </summary>

**概念**  
主机数据更新后根据配置和策略，自动同步到备机的master/slaver机制，Master以写为主，Slave以读为主
![](/img/Redis/Master_slaver.png)

**特点**  
- 读写分离
- 容灾快速恢复
- 一主多从
### 6.1 搭建
- 创建/myredis文件夹
- 复制redis.conf配置文件到文件夹中
- 配置一主两从，创建三个配置文件
  - redis6379.conf
  - redis6380.conf
  - redis6381.conf
- 在三个配置文件中写入内容
  ```
  include /myredis/redis.conf
  pidfile /var/run/redis_6379.pid
  port 6379
  dbfilename dump6379.rdb
  ```
- 启动
  ```
  redis-server redis6379.conf
  redis-server redis6380.conf
  redis-server redis6381.conf
  ```
- 进入redis查看信息
  ```
  info replication
  ```
- 配置从属
  ```
  slaveof <ip><pory>
  成为某个实例的从服务器
  ```
#### 使用docker搭建
- 获取redis镜像
  ```
  docker pull redis
  ```
- 创建节点挂载目录
  ```
  mkdir -p /myredis/redis6379/conf \ &
  mkdir -p /myredis/redis6379/data \ &
  mkdir -p /myredis/redis6380/conf \ &
  mkdir -p /myredis/redis6380/data \ &
  mkdir -p /myredis/redis6381/conf \ &
  mkdir -p /myredis/redis6381/data
  ```
- 获取主节点ip
  ```
  docker inspect redis6379
  ```
- 添加并配置redis.conf
  ```
  vim /myredis/redis6379/conf/redis.conf
  ...
  #####
  bind 0.0.0.0
  protected-mode no
  replicaof 172.17.0.2 6379 #主节点不需要
  ```
- 启动容器
  ```
  #主
  docker run -d \
  -p 6379:6379 \
  --name redis6379 \
  --privileged=true \
  -v /myredis/redis6379/conf/redis.conf:/etc/redis/redis.conf \
  -v /myredis/redis6379/data:/data \
  redis \
  redis-server /etc/redis/redis.conf

  #从1
  docker run -d \
  -p 6380:6380 \
  --name redis6380 \
  --privileged=true \
  -v /myredis/redis6380/conf/redis.conf:/etc/redis/redis.conf \
  -v /myredis/redis6380/data:/data \
  redis \
  redis-server /etc/redis/redis.conf

  #从2
  docker run -d \
  -p 6381:6381 \
  --name redis6381 \
  --privileged=true \
  -v /myredis/redis6381/conf/redis.conf:/etc/redis/redis.conf \
  -v /myredis/redis6381/data:/data \
  redis \
  redis-server /etc/redis/redis.conf
  ```

- 进入容器
  ```
  docker exec -it redis6379 redis-cli
  ```

- 查看信息
  ```
    127.0.0.1:6379> info
    可以看到绑定有两个slaver
  ```
可进入主节点创建数据再进去从节点查看key验证搭建是否成功

### 6.2 复制原理
- 从连接上主之后，从服务器向主服务发送进行数据同步消息
- 主服务器接到从服务器发送过来的同步消息，把主服务器数据进行持久化，把rdb文件发送从服务器，从服务器拿到rdb进行读取
- 每次主服务器进行写操作后，会和从服务器进行数据同步，这是主服务器主动做的

### 6.3 哨兵模式(sentinel)
- 能够后台监控主机是否故障，如果故障了根据投票票数自动将从库转换为主库

**搭建**  
- 在redis.conf相同目录下创建sentinel.conf
- 配置哨兵
  ```
  sentinel monitor mymaster 127.0.0.1 6379 1
  #1代表至少有多少个哨兵同意迁移的数量
  ```
- 启动哨兵
  ```
  docker run -d \
  --name sentinel \
   -v  /myredis/redis6379/conf/sentinel.conf:/usr/local/etc/redis/sentinel.conf \
   redis \
   redis-sentinel /usr/local/etc/redis/sentinel.conf
  ```
- 关闭6379来模拟主服务器宕机
- 可以通过`docker logs sentinel`来查看哨兵对三个服务器的操作
- 当原主服务器重启时，会成为新主服务器的从服务器
- 新主的选择条件为：
  1. 选择优先级靠前的
     - 优先级可以在redis.conf中配置`slave-priority 100`,值越小优先级越高
  2. 选择偏移量大的
     - 偏移量指获得原主机数据最全的
  3. 选择runid最小的

</details>

---

## VII.集群

<details>
<summary> </summary>

### 7.1 无中心化集群
- 任何一个服务器都能作为集群的入口
- 能减少资源消耗，简化维护

### 7.2 搭建
- 参照VI先搭建6台服务器，切勿建立主从关系
- 采用6379,6389,6399,6378,6388,6398
- 配置修改
  ```conf
  #打开集群模式
  cluster-enabled yes
  #设定节点配置文件命
  cluster-config-file nodes-6379.conf
  #设定节点失联时间，超过该时间，集群自动进行主从切换
  cluster-node-timeout 15000 
  ```
- 进入任意一个容器，组建redis集群
- 注意搭建是要保证所有节点数据一致，即rdb文件都要删除
  ```
  docker exec -it redis6379 /bin/bash
  #执行组建集群的命令，不使用docker搭建时一样
  redis-cli --cluster create 172.17.0.2:6379 172.17.0.3:6378 172.17.0.4:6389 172.17.0.5:6388 172.17.0.7:6399 172.17.0.6:6398 --cluster-replicas 1
  #最后一个参数代表主从比例，表示一个主节点对应一个从节点
  ```
- 采用集群策略连接
  ```
  docker exec -it redis6379 redis-cli -c -h ip -p port
  ```
- 通过`cluster nodes`来查看集群信息

**集群操作**  
- slot插槽，每个服务器会被分配连续的插槽0-199，200-300...,key会插到这些插槽中
- 一次插多个key时，需要以组的形式插入
  ```
  mset name{user} lucy age{user} 20
  其中user是组名
  ```
- `cluster getkeysinslot < solt >< count >` 返回count个slot槽中的键
</details>


---

## VIII.应用问题

<details>
<summary> </summary>

### 8.1 缓存穿透

#### 问题描述
key对应的数据在数据源并不存在，每次针对此key的请求从缓存获取不到，请求都会压到数据源，从而可能压垮数据源

#### 解决方案
> 一个一定不存在缓存及查询不到的数据，由于缓存时不命中时被动写的，并且出于容错考虑，如果从存储层找不到数据则不写入缓存，这将导致这个不存在的数据每次请求都要到存储层去查询，失去了缓存的意义

- 对空值缓存：如果一个查询返回的数据为空(不管数据是否存在)，我们仍然把这个null结果进行缓存，设置空结果的过期时间会很短，最长不超过5分钟
- 设置白名单：使用bitmaps类型定义一个可以访问的名单，名单id作为bitmaps的偏移量，每次访问和bitmap里面的id进行比较，如果访问id不在bitmaps里面，进行拦截，不允许访问
- 采用布隆过滤器：将所有可能存在的数据哈希到一个足够大的bitmaps中，一个一定不存在的数据会被 这个bitmaps拦截掉，从而避免了对底层存储系统的查询压力。
  - 布隆过滤器实际上是一个很长的二进制向量(位图)和一系列随机映射函数(哈希函数)。布隆过滤器可以用于检索一个元素是否在一个集合中。它的优点是空间效率和查询时间都远远超过一般的算法，缺点是有一定的误识别率和删除困难
- 进行实时监控：当发现Redis的命中率开始急速降低，需要排查访问对象和访问的数据，和运维人员配合，可以设置黑名单限制服务

### 8.2 缓存击穿

#### 问题描述
key对应的数据存在，但在redis中过期，此时若有大量并发请求，这些请求发现缓存过期一般都会从后端DB加载数据，并回设到缓存，这个时候大并发的请求可能会瞬间把后端DB压垮

#### 解决方案
- 预先设置热门数据：在redis高峰访问之前，把一些热门数据提前存到redis里面，加大这些热门key的时长
- 实时调整：现场监控哪些数据热门，实时调整key的过期时长
- 使用锁：
  - 在缓存失效时(判断拿出来的值为空)，不立即load db
  - 先使用缓存工具的某些带成功操作返回值的操作去set一个mutex key
  - 当操作返回成功时，再进行load db操作，并回设缓存，最后删除mutex key
  - 当操作返回失败时，证明有有线程在load db(利用了redis单线程特性)，当前线程睡眠一段时间再重试get缓存

### 8.3 缓存雪崩

#### 问题描述
- 某一时间段大量key过期，而此时有大量请求，导致后端DB压力急速上升
- 击穿针对某一个key，雪崩针对大量key
#### 解决方案
- 构建多级缓存架构：nginx缓存 + redis缓存 +其他缓存（ehcache等）
- 用锁或队列：
  用加锁或者队列的方式保证来保证不会有大量的线程对数据库一次性进行读写，从而避免失效时大量的并发请求落到底层存储系统上。不适用高并发情况
- 设置过期标志更新缓存：
  记录缓存数据是否过期（设置提前量），如果过期会触发通知另外的线程在后台去更新实际key的缓存。
- 将缓存失效时间分散开：
  比如我们可以在原有的失效时间基础上增加一个随机值，比如1-5分钟随机，这样每一个缓存的过期时间的重复率就会降低，就很难引发集体失效的事件


### 8.4 分布式锁

#### 问题描述
- 由于分布式系统多线程、多进程并且分布在不同机器上，这将使原单机部署情况下的并发控制锁策略失效
- 为了解决该问题，需要一种跨JVM的互斥机制来控制共享资源的访问

#### 基于redis实现分布式锁
- `setnx key value` 只当key不存在时才可以设置
- `expire key second` 为锁添加过期时间
- `set key value nx ex second` 上锁同时添加过期时间

#### UUID防误删
**问题描述**  
当3个业务抢一把锁，当业务1执行时发生卡顿导致锁过期释放，业务2获得了锁，但在业务2执行过程中业务1缓了过来，进行了del释放锁，导致释放了业务2的锁

**解决方法**  
- 为锁添上每个业务自己的uuid
- 释放锁的时候，先判断当前uuid与要释放的锁uuid是否一样

#### LUA保证原子性

</details>


---

## IX.Access Control List-访问控制列表

<details>
<summary> </summary>

### 9.1 介绍
- ACL功能允许根据可以执行的命令和可以访问的键来限制某些连接
- ACL对用户进行更细粒度的权限控制
  - 接入权限：用户名和密码
  - 可执行的命令
  - 可以操作的key

### 9.2 命令
- `acl list` 展现用户权限列表
![](/img/redis/ACL-1.png)
- `acl cat` 查看添加权限指令类别 
- `acl whoami` 查看当前用户
- `acl set user` 创建和编辑用户ACL
</details>

---

## X.IO多线程

<details>
<summary> </summary>

### 10.1 介绍
- IO多线程指客户端交互部分的网络IO交互处理模块多线程，而非执行命令多线程
- 只是用来处理网络数据的读写和协议解析

### 10.2 开启
配置文件中配置
```
io-threads-do-reads yes
io-threads 4
```

</details>

---

<details>
<summary> </summary>

</details>


