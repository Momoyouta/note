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

</details>

---

<details>
<summary> </summary>

</details>


---

<details>
<summary> </summary>

</details>


---

<details>
<summary> </summary>

</details>


