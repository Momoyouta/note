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

</details>