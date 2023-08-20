## I.概述
MyBatis是一款持久层(Dao)框架，用于简化JDBC的开发
JDBC:使用Java语言操作关系型数据库的一套API

## II.数据库连接池
- 数据库连接池是个容器，负责分配、管理数据库连接(Connection)
- 它允许应用程序重复使用一个现有的数据库连接，而不是重建建立
- 释放空闲时间超过限制的连接，来避免因为没有释放连接而引起的数据库连接遗漏
---

## III.注解
1. **@Options(keyProperty="",useGeneratedKeys=true)**：主键返回
2. 

## IV.XML映射文件
- XML映射文件名称与Mapper接口名称一致(同包同名)
- XML映射文件的namespace属性为Mapper接口全限定名一致
- XML映射文件中sql语句的id与Mapper接口中的方法名一致，并保持返回类型一致

### 动态SQL

#### 标签
1. **< if >** ：用于判断条件是否成立。使用test属性进行条件判断，如果条件为true，则拼接SQL
2. **< where >**：where元素只会在子元素有内容的情况下才插入where子句。而且会自动去除子句的开头and或or
3. **< foreach collect="" item="" separator="" open="" close="">**：批量处理 
   属性分别对应遍历的集合、遍历出来的元素、分隔符、遍历开始前拼接的SQL片段、遍历结束后拼接的SQL片段
4. **sql&include**
   将SQL语句抽取命别名，提高代码复用性
   - **< sql id="name" >**：将SQL语句抽取
   - **< include refid="name"/>**：将代码引用

---

## Mybatis-Plus
1111
<details>
<summary> </summary>

内置Mapper、通用Service，封装了`单表`大部分CRUD操作

 **依赖**
需注意mp依赖中自带mybatis依赖，重复导入若版本不同会爆红
```java
<dependency>
   <groupId>com.baomidou</groupId>
   <artifactId>mybatis-plus</artifactId>
   <version>3.5.3.2</version>
</dependency>
<dependency>
   <groupId>com.baomidou</groupId>
   <artifactId>mybatis-plus-boot-starter</artifactId>
   <version>3.5.3.2</version>
</dependency>

```

**入门**
- 对于Mapper接口只需继承BaseMapper<User>,之后直接调用封装的CRUD操作
  - [CRUD接口](https://baomidou.com/pages/49cc81/)
- 对于条件查询，利用Wrapper条件构造器
  - [条件构造器](https://baomidou.com/pages/10c804/#alleq)
- 

**快速链接**
1. 
2. [注解](https://baomidou.com/pages/223848/#tablename)


</detils>

