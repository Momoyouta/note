## I.初始

<details>
<summary> </summary>

### 简介
- MongoDB是一个高性能、无模式的文档型数据库，当初的设计就是用于简化开发和方便扩展，是NoSQL数据库产品的一种


### 应用场景
- 对象数据库高并发读写需求
- 对海量数据的高效率储存和访问需求
- 对数据库的高可扩展性和高可用性需求

### 启动与连接

**启动**
bin目录下执行
- `mongod --dbpath=数据存储路径`
- `mongod --config=conf配置文件路径`，配置文件必须配置数据存储路径

**Shell连接**
bin目录下执行
- `mongosh [--host <ip>] [--port <port>]` 

</details>

---

## II.基础常用命令

<details>
<summary> </summary>

### 数据库操作

| 命令              | 作用                                      |
| ----------------- | ----------------------------------------- |
| use 数据库名称    | 选择/创建数据库，当数据库不存在会自动创建 |
| show dbs          | 查看所有有权访问的数据库                  |
| db.dropDatabase() | 删除当前所选择的库                        |

数据库名需满足以下条件
- 不能是空字符串
- 不得含有空格 '.' '$' '/' '\' '\0'
- 全部小写
- 最多64字节

特殊数据库
- `admin` 从权限角度来看，这是root数据库。若将一个用户添加到这个数据库，这个用户自动继承所有数据库的权限。一些特定的服务器端命令也只能从这个数据库运行
- `local` 这个数据永远不会被复制，可以用来存储限于本地单台服务器的任意集合
- `config` 当Mongo用于分片设置时，config数据库在内部使用，用于保存分片的相关信息


### 集合操作

| 命令                          | 作用     |
| ----------------------------- | -------- |
| db.createCollection("集合名") | 创建集合 |
| db.集合名.drop()              | 删除集合 |

### 文档基本CRUD

**文档插入**

```
db.collection.insertOne(
    <document or array of documents>.
    {
        writeConcern: <document>,
        ordered: <boolean>
    }
) //单条插入
db.collection.insertMany(
    [<document 1>,<document 2>,...],
    {
        writeConcern: <document>,
        ordered: <boolean>
    }
) //多条插入
```
| 参数         | 类型              | 描述                                       |
| ------------ | ----------------- | ------------------------------------------ |
| document     | document or array | 要插入到集合种的文档或者文档数组(json格式) |
| ordered      | boolean           | 是否排序                                   |
| writeConcern | document          | 插入时性能、可靠性的级别                   |

例如：
```
db.my.insertOne(
    {
        "id":"100",
        "content":"你好"
    }
)
```

**查询**

`db.collection.find(<query>,[projection])`
| 参数       | 类型     | 描述                                                                                           |
| ---------- | -------- | ---------------------------------------------------------------------------------------------- |
| query      | document | 可选。使用查询运算符指定选择筛选器。若要返回集合中的所有文档，请省略此参数或传递空文档         |
| projection | document | 可选。指定要在与查询筛选器匹配的文档中返回的字段。若要返回匹配文档中的所有字段，请省略此参数。 |

示例：   
查找上文插入的文档  
`db.my.find()` 查看所有文档  
`db.my.find({id:'100'},{id:1})` 查找指定文档并只显示指定字段id

**更新**
```
db.collection.update(query,update,options)
```
- 覆盖更新，修改id为1的记录的一个字段，最终该文档只会剩下该字段  
  `db.collection.update({id:"1"},{a:NumberInt(100)})`  
- 局部修改，顾名思义,使用修改器\$set   
  ``db.collection.update({id:"1"},{$set{a:NumberInt(100)}})``
- 批量修改，修改所有满足条件的文档字段  
  `db.collection.update({id:"1"},{$set{a:NumberInt(100)}},{multi:true})`
- 列值增长，在原有值上进行变动，可使用\$inc来实现  
  `db.collection.update({id:"1"},{$inc{a:NumberInt(100)}})`

**删除**
`db.collection.remove(条件)`  
例如  
`db.my.remove({name:"张山"})`


### 分页查询

**统计查询**  
`db.collection.count(query,[option])`

**列表查询**  
`db.collection.find().skip().limit()`  
limit限制查询条数，skip跳过指定数据数

**排序查询**  
`db.collection.find().sort({key:1/-1})`  
1代表升序，-1代表降序

### 其他查询

**正则的复杂条件查询**  
MongoDB的模糊查询是通过正则表达式实现  
`db.collection.find({字段:/正则表达式/})`  
> 正则表达式相关可见于MySQL笔记中**XI.正则表达式**

**比较查询**  
`db.collection.find({字段:{$gt:value}})`  
| 操作符 | 描述 |
| ------ | ---- |
| $gt    | >    |
| $lt    | <    |
| $gte   | >=   |
| $lte   | <=   |
| &ne    | !=   |

**包含查询**  
`db.collection.find({字段:{$in:[value1,value2,...]}})`  
不包含使用\$nin

**条件查询**  
`db.collection.find({$and:[{numb:{$gt:NumberInt(700)}},{},{},..]})`  
\$and表并，\$or表或




</details>

---

## III.索引

<details>
<summary> </summary>

### 概述
- 索引支持在MongoDB中高效地执行查询。如果没有索引,MongoDB必须执行全集合扫描，即扫描集合中的每个文档，以选择与查询语句匹配的文档。这种扫描全集合的查询效率是非常低的，特别在处理大量的数据时，查询可以要花费几十秒甚至几分钟，这对网站的性能是非常致命的。  
- 如果查询存在适当的索引，MongoDB可以使用该索引限制必须检查的文档数
- 索引是特殊的数据结构，它以易于遍历的形式存储集合数据集的一小部分。索引存储特定字段或─组字段的值，按字段值排序。索引项的排序支持有效的相等匹配和基于范围的查询操作。此外，MongoDB丕可以使用索引中的排序返回结果

### 索引类型
- 单字段索引：在文档的单个字段创建升序、降序索引
- 复合索引：多个字段定义索引，例如`{userid:1,score:-1}`，则先按userid升序排序，然后对于每个userid按score降序排序
- 其他索引：地理空间索引(Geospatial Index)、文本索引（Text Indexes)、哈希索引(Hashed Indexes)
  - 地理空间索引：为了支持对地理空间坐标数据的有效查询，MongoDB提供了两种特殊的索引:返回结果时使用平面几何的二维索引和返回结果时使用球面几何的二维球面索引
  - 文本索引：MongoDB提供了一种文本索引类型，支持在集合中搜索字符串内容。这些文本索引不存储特定于语言的停止词(例如"the"、"a"、"or")，而将集合中的词作为词干，只存储根词
  - 哈希索引：为了支持基于散列的分片，MongoDB提供了散列索引类型，它对字段值的散列进行索引。这些索引在其范围内的值分布更加随机，但只支持相等匹配。不支持基于范围的查询

### 索引操作

**查看索引**  
`db.collection.getIndexes()`  
结果
```
[
  {
    "key": {
      "_id": 1 //索引排序字段
    },
    "name": "_id_", //索引名
    "ns": "articledb.my", //数据库名以及集合名
    "v": 2 //版本
  }
]
```

**创建索引**  
`db.collection.createIndex(keys,[options])`  

部分常用可选项
| 参数   | 类型    | 描述                                                                   |
| ------ | ------- | ---------------------------------------------------------------------- |
| unique | boolean | 建立的索引是否唯一                                                     |
| name   | string  | 索引名。若未指定，则自动通过连接索引的字段名和排序顺序生成一个索引名称 |

**删除索引**  
`db.collection.dropIndex(index)`  

**性能分析**  
`db.collection.find(query,options).explain(options)`  
用于查看查询的情况如查询耗费的时间、是否基于索引查询等  

**涵盖查询**  
当查询条件和查询的投影仅包含索引字段时，直接从索引返回结果，而不扫描任何文档或将文档带入内存(类似无需回表查询) 

![](/img/MongoDB/cover_query.png)


</details>

---

## IV.整合springboot 

<details>
<summary> </summary>

**依赖**
```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-mongodb</artifactId>
</dependency>
```

**实体类注解**
| 注解                         | 作用                                           |
| ---------------------------- | ---------------------------------------------- |
| @Document(collection="name") | 设置映射名，若省略，则默认使用类名小写映射集合 |
| @Id                          | 主键标识                                       |
| @Field("name")               | 对应到mongodb的字段名，若一致则可省略          |
| @Indexed                     | 索引标识                                       |
| @CompoundIndex(def="{}")     | 复合索引                                       |

### DAO接口
继承MongoRepository< T ,ID Type >  
MongoRepository提供了基础的CRUD
- save(T t) 
- deleteOneById(T id)
- findOneById(T id)


**分页查询**  
`Pgae<Comment> findByPatamerName(T t,Pageable pageable)`  
方法名必须按findBy-参数名格式  
实现：
```java
public Page<Comment> findCommentListByParentId(String parentid, int page, int pagesize) {
    return commentRepository.findByParentid(parentid, PageRequest.of(page-1,pagesize));
}
```

**MongoTemplate**   
提供Mongodb模板方法，例
```java
Query query=Query.query(Criteria.where("字段").is(条件参数)); //查询条件
Update update =new Update();
update.inc("更新字段"); //同mongodb操作，有set、inc等方法
mongoTemplate.updateFirst(Query query,Update update,Class<?> entityClass)
```
- query可以通过.addCriteria()添加条件

[更多方法](https://docs.spring.io/spring-data/mongodb/docs/current/api/org/springframework/data/mongodb/core/MongoTemplate.html)

</details>

---

## V.副本集-Replica Sets

<details>
<summary> </summary>

> 副本集是一组维护相同数据集的mongod服务，副本集可以提供冗余和高可用性，是所有生产部署的基础。
>  也可以说，副本集类似于有自动故障恢复功能的主从集群。通俗的讲就是用多台机器进行同一数据的异步同步，从而使多台机器拥有同一数据的多个副本，并且当主库当掉时在不需要用户干预的情况下自动切换其他备份服务器做主库。而且还可以利用副本服务器做只读服务器，实现读写分离，提高负载
> 主从复制和副本集的区别在于副本集没有固定的“主节点”。整个集群会选出一个“主节点”，当其挂掉后，又在剩下的从节点中选出其他节点作为“主节点”，副本集总有一个活跃点和一个或多个备份节点

**副本集的类型与角色**  
两种类型：
- 主节点(Primary)：数据操作的主要连接点，可读写
- 次要节点(Secondaries：数据冗余备份节点，可以读或选举  
三种角色：
- 主要成员(Primary)：主要接受所有写操作，就是主节点
- 副本成员(Replicate)：从主节点通过复制操作以维护相同的数据集，即备份数据，不可写操作，但可以读操作，是默认的一种从节点类型
- 仲裁者(Arbiter)：不保留任何数据的副本，只是有投票选举作用。当然也可以将仲裁服务器维护为副本集的一部分，即副本成员同时也可以是仲裁者。也是一种从节点类型

**副本集架构**
![](/img/MongoDB/Replica_sets_structure.png)

**副本集构建**  
节点创建类似于mongodb数据库的搭建，即建立存放数据和日志的目录

> 第一步：创建主节点
```
#建目录
mkdir -p ./mongodb/replica_sets/myrs_27017/log \ &
mkdir -p ./mongodb/replica_sets/myrs_27017/data/db
#配置文件
vim /mongodb/replica_sets/myrs_27017/mongod.conf
```
配置文件
```conf
systemLog:
  destination: file
  path: "/usr/local/mongodb/replica_sets/myrs_27017/log/mongod.log"
  logAppend: true
storage:
  dbPath: "/usr/local/mongodb/replica_sets/myrs_27017/data/db"
  journal:
    enabled: true
processManagement:
  fork: true
net:
  bindIp: localhost,192.168.52.129
  #端口
  port: 27017
replication:
  #副本集名称
  replSetName: myrs
```
启动
```
/usr/local/mongodb/bin/mongod -f /mongodb/replica_sets/myrs_27017/mongod.conf
```

> 第二步：创建副节点、仲裁节点
同主节点，修改端口、目录即可


> 第三步：初始化配置副本集和主节点

客户端连接主节点，初始化新的副本集  
`rs.initiate([configuration])`
- `rs.config()` 查看节点配置
- `rs.isMaster()` 查看是否为主节点
- `rs.status()` 查看节点状态 

> 第四步：添加从节点  
> 
- ` rs.add(host,arbiterOnly)`
- `rs.add("ip")`
- `rs.addArb("ip")`或第一条均可添加仲裁节点  
  
| 参数       | 类型               | 描述                                                                                                                                                                                                        |
| ---------- | ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| host       | string or document | 要添加到副本集的新成员。指定为字符串或配置文档:1)如果是一个字符串，则需要指定新成员的主机名和可选的端口号;2)如果是一个文档，请指定在members数组中找到的副本集成员配置文档。必须在成员配置文档中指定主机字段 |
| rbiterOnly | boolean            | 可选。仅在<host>为字符串时使用。为true则添加的为仲裁者                                                                                                                                                      |

主机成员配置文档：
```
{
  _id: <int>,
  host: <string>,
  arbiterOnly: <boolean>,
  buildIndexes: <boolean>,
  hidden: <boolean>,
  priority: <number>,
  tags: <document>,
  slaveDelay: <int>,
  votes: <number>
}

```

### 主节点的选举原则
MongoDB在副本集中，会自动进行主节点的选举，主节点选举的触发条件：
- 主节点故障
- 主节点网络不可达
- 人工干预(rs.stepDown(600))

**选举规则**
- 票数最高，且获得了“大多数”成员的投票支持的节点获胜。
> “大多数”定义为：假设复制集内投票成员数量为N，则大多数为N/2+1。当复制集内存活成员数量不足大多数时，整个复制集将无法选举出Primary，复制集将无法提供写服务，处于只读状态
- 若票数相同，且获得了大多数成员的投票支持，数据新的节点获胜
- 在获得票数时，优先级参数影响重大，通过设置优先级可以获得额外票数

### SpringDataMongoDB连接副本集
修改配置文件，数据源配置采用uri
```
mongodb://host1,host2,host3,.../arti?connect=replicaSet&slaveOK=true&replicaSet=副本集名字
```



</details>


---

## VI.分片集群-Sharded Cluster

<details>
<summary> </summary>

**概述**
- 分片是一种跨多台机器分布数据的方法，MongoDB使用分片来支持具有非常大的数据集和高吞吐量操作
- 分片是指将数据拆分，将其分散存在不同的机器上的过程。有时也用分区来表示这个概念。将数据分散到不同机器上，不需要功能强大的大型计算机就可以存储更多的数据，处理更多的负载
- 具有大型数据集或高吞吐量应用程序的数据库系统可以会挑战单个服务器的容量。例如，高查询率会耗尽服务器的CPU容量。工作集大小大于系统的RAM会强调磁盘驱动器的I/O容量
> 有两种解决系统增长的方法：垂直扩展和水平扩展
> 垂直扩展意味着增加单个服务器的容量，如使用更强大的CPU，添加更多RAM或增加存储空间量。可用技术的局限性可能会限制单个机器对于给定工作负载。结果，垂直缩放有实际的最大值。
> 水平扩展意味着划分系统数据集并加载多个服务器，添加其他服务器可以根据需要增加容量。虽然单个机器的总体速度或容量可能不高，但每台机器处理整个工作负载的子集，可能提供比单个高速大容量服务器更高的效率。扩展部署容量只需要根据添加额外的服务器，这可能比单个机器的高端硬件的总体成本更低。权衡使基础架构和部署维护的复杂性增加

**分片集群包含的组件**
- 分片：每个分片包含分片数据的子集。每个分片都可以部署为副本集
- 路由(mongos)：mongos充当查询路由器，在客户端应用程序和分片集群之间提供接口
- config servers调度配置：配置服务器存储群集的元数据和配置设置。
![](/img/MongoDB/Sharded_Cluster.png)

### 分片集群架构
![](/img/MongoDB/Sharded_Cluste2.png)

### 分片集群搭建
第一套副本集
```
mkdir -p ./mongodb/sharded_cluster/myshardrs01_27018/log \ &
mkdir -p ./mongodb/sharded_cluster/myshardrs01_27018/data/db \ &

mkdir -p ./mongodb/sharded_cluster/myshardrs01_27118/log \ &
mkdir -p ./mongodb/sharded_cluster/myshardrs01_27118/data/db \ &

mkdir -p ./mongodb/sharded_cluster/myshardrs01_27218/log \ &
mkdir -p ./mongodb/sharded_cluster/myshardrs01_27218/data/db 
```
配置文件  
`vim ./mongodb/sharded_cluster/myshardrs01_27018/mongod.conf`  

```conf
systemLog:
  destination: file
  path: "/usr/local/mongodb/sharded_cluster/myshardrs01_27018/log/mongod.log"
  logAppend: true
storage:
  dbPath: "/usr/local/mongodb/sharded_cluster/myshardrs01_27018/data/db"
  journal:
    enabled: true
processManagement:
  fork: true
net:
  bindIp: localhost,192.168.52.129
  #端口
  port: 27018
replication:
  #副本集名称
  replSetName: myshardrs01
sharding:
  #分片角色
  clusterRole: shardsvr
```
- 类似的依照结构图创建该分片的从节点，端口分别为27118，27218
- 启动并设置第一套副本集：一主一副本一仲裁
- 同理设置第二套副本集、配置节点副本集

路由节点  
路由节点不需要存储具体数据，使用mongos服务，其他创建相同
```
mkdir -p ./mongodb/sharded_cluster/mymongos_27017/log 
vim ./mongodb/sharded_cluster/mymongos_27017/mongos.conf
```
config文件中需指定配置节点副本集,路由器无副本集名字
```
sharding:
  #指定配置节点副本集
  configDB: myconfigrs/192.168.52.129:27019,192.168.52.129:27119,192.168.52.129:27129
```

- 创建好路由节点后需将分片添加进路由中  

添加分片  
`rs.addShard("分片名称/ip:port,ip2:pory...")`  

开启分片  
```
sh.enableSharding("库名")
```

集合分片  
`sh.shardCollection(namespace,key,unique)`  
`sh.shardCollection("库名.集合名",{"key":1})`
|参数|类型|描述|
|-|-|-|
|namespace|string|分片共享的目标集合的命名空间|
|key|document|用作分片建的索引规范文档，由包含字段和该字段的索引遍历方向的文档组成|
|unique|boolean|当为true时，片键字段上回限制为确保是唯一索引。哈希策略片键不支持唯一索引|

**片键(Shard Key)**
- 片键是每条记录都必须包含的，且建立了索引的单个字段或复合字段
- MongoDB按照片键将数据划分到不同的数据块中，并将数据块均衡的分布到所有分片中
- 分片方式：
  - 基于哈希的随机平均分配
  - 基于范围的数值大小分配
    - 数据库(chunk)未被填满时不会分片

### SpringDataMongoDB连接分片集群
连接路由，通过路由控制即可
```yml
spring:
  data:
    mongodb:
    uri: mongodb://192.168.52.129:27017,192.168.52.129:27117/articledb
```



</details>


---

## VII.安全认证

<details>
<summary> </summary>

**简介**
- 默认情况下，MongoDB实例启动运行时是没有启用用户访问权限控制的，也就是说，在实例本机服务
器上都可以随意连接到实例进行各种操作，MongoDB不会对连接客户端进行用户验证，这是非常危险
的
- 为了保障安全可以：
  - 默认情况下，MongoDB实例启动运行时是没有启用用户访问权限控制的，也就是说，在实例本机服务
    器上都可以随意连接到实例进行各种操作，MongoDB不会对连接客户端进行用户验证，这是非常危险
    的
  - 开启安全认证。认证要同时设置服务器之间的内部认证方式，同时要设置客户端连接到集群的账号
    密码认证方式
- 为了强制开启用户访问控制(用户验证)，则需要在MongoDB实例启动时使用选项 --auth 或在指定启动
配置文件中添加选项 auth=true   

1. 启用访问控制：
     - MongoDB使用的是基于角色的访问控制(Role-Based Access Control,RBAC)来管理用户对实例的访问。
通过对用户授予一个或多个角色来控制用户访问数据库资源的权限和数据库操作的权限，在对用户分配
角色之前，用户无法访问实例
2. 角色：
      - 在MongoDB中通过角色对用户授予相应数据库资源的操作权限，每个角色当中的权限可以显式指定，
也可以通过继承其他角色的权限，或者两都都存在的权限
3. 权限：
      - 权限由指定的数据库资源(resource)以及允许在指定资源上进行的操作(action)组成
        - 资源包括：数据库、集合、部分集合和集群
        - 操作包括：对资源的CRUD操作
      -  在角色定义时可以包含一个或多个已存在的角色，新创建的角色会继承包含的角色所有的权限。在同一
      个数据库中，新创建角色可以继承其他角色的权限，在 admin 数据库中创建的角色可以继承在其它任意
      数据库中角色的权限。
- 角色权限查看：
```
// 查询所有角色权限(仅用户自定义角色)
> db.runCommand({ rolesInfo: 1 })
// 查询所有角色权限(包含内置角色)
> db.runCommand({ rolesInfo: 1, showBuiltinRoles: true })
// 查询当前数据库中的某角色的权限
> db.runCommand({ rolesInfo: "<rolename>" })
// 查询其它数据库中指定的角色权限
> db.runCommand({ rolesInfo: { role: "<rolename>", db: "<database>" } }
// 查询多个角色权限
> db.runCommand(
  {
    rolesInfo: [
    "<rolename>",
    { role: "<rolename>", db: "<database>" },
    ...
    ]
  }
)
```
![](/img/MongoDB/chmod.png)

### 单例环境
**创建用户以及常用命令**
- 切到admin库
- 创建命令:`db.createUser({user:"name",pwd:"pwd",roles:[{"role":"root..","db":"dbname"}]})`
  |参数|描述|
  |-|-|
  |role|角色(权限)|
  |db|管理的库,默认所有库|
- `db.system.users.find()`：查看已创建用户情况
- `db.dropUser("name)`：删除用户
- `db.changeUserPassword("myroot","123456")` 修改密码


**开启认证**
1. 启动时添加`--auth`
   ```
   /usr/local/mongodb/bin/mongod -f /mongodb/single/mongod.conf --auth
   ```
2. 配置文件中添加参数
   ```
   security:
    authorization: enabled
   ```
- `db.auth("name","pwd")`：登录认证

**springData连接**
修改配置文件
```yml
mongodb:
  username: name
  password: 123456
  #或uri: mongodb://name:pwd@ip:port/db
```

### 副本集环境
- 对副本集执行访问控制需要配置以下方面：
  - 副本集和共享集群的各个节点成员之间使用内部身份验证，可以使用密钥文件或x.509证书。密钥文
件比较简单，本文使用密钥文件，官方推荐如果是测试环境可以使用密钥文件，但是正式环境，官方推
荐x.509证书。原理就是，集群中每一个实例彼此连接的时候都检验彼此使用的证书的内容是否相同。
只有证书相同的实例彼此才可以访问
  - 使用客户端连接到mongodb集群时，开启访问授权。对于集群外部的访问。如通过可视化客户端，
或者通过代码连接的时候，需要开启授权
  - 在keyfile身份验证中，副本集中的每个mongod实例都使用keyfile的内容作为共享密码，只有具有正确
密钥文件的mongod或者mongos实例可以连接到副本集。密钥文件的内容必须在6到1024个字符之
间，==并且在unix/linux系统中文件所有者必须有对文件至少有读的权限==  

除了创建key环境,其他步骤基本与单实例相同,在这里简单介绍key相关

**1.创建副本集认证key文件**  
生成密钥方法很多，例如，以下操作用openssl生成密码文件，然后使用chmod来更改文件程序，仅为文件所有者提供读取权限
```
openssl rand -base64 90 -out ./mongo.keyfile
chmod 400 ./mongo.keyfile
```
- 提示：
  - 所有副本集节点都必须要用同一份keyfile，一般是在一台机器上生成，然后拷贝到其他机器上，且必须
有读的权限
  - 一定要保证密钥文件一致，文件位置随便。但是为了方便查找，建议每台机器都放到一个固定的位置，
都放到和配置文件一起的目录中

**2.修改配置文件指定keyfile**  
编辑conf文件
```
security:
  keyFile: /mongodb/...../mongo.keyfile
  authorization: enabled
```

springData连接副本集与单例类似,添加username和pwd即可

分片集群认证和副本集一直


</details>

---

## 

<details>
<summary> </summary>


</details>

