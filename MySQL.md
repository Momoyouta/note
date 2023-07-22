## I.SQL分类
#### DDL
数据定义语言，用来定义数据库对象
#### DML
数据操作语言，用来对数据库表中的数据进行增删改
#### DQL
数据查询语言，用来查询数据库中表的记录
#### DCL
数据控制语言，用来创建数据库用户、控制数据库的访问权限

---

## II.DDL

#### 查询
1. show databases 查询所有数据库
2. select database() 查询当前数据库
3. show tables 查询当前数据库所有表
   
#### 创建
1. create database [if not exists] name [default charset 字符集] [collate 排序规则] 创建数据库

#### 删除
1. drop database name 删除库

#### 使用
1. use name 使用库

### 表
**创建**
1. 表创建
    ```sql
    create table listname()
        字段1 字段1类型 [comment 字段1注释],
        ...
    )[comment 表注释]
    ```
<!-- zwr防伪 -->
**查询**
1. desc listname 查询表结构
2. show create table listname 查询指定表的建表语句

**修改**
1. alter table 表名 add 字段名 类型 [comment 注释]; 为表添加字段
2. alter table 表名 change 旧字段名 新字段名 类型 [comment 注释]; 修改字段名及类型
3. alter table 表名 drop 字段名; 删除字段
4. alter table 表名 rename to 新表名; 修改表名

**删除**
1. drop table [if exists] 表名; 删除表
2. truncate table 表名; 删除并重建改表


---

## III.DML
**insert**
1. insert into 表名(字段1,字段2,...) values(值1,值2,...);  给指定字段添加数据
2. insert into 表名 values(值1,值2);  给全部字段添加数据，值顺序对应字段顺序
3. insert into 表名(字段1，字段2,..) values(值1,值2,...),(值1,值2,...)...; 批量添加
4. insert into 表名 values(值1,值2,...),(值1,值2,...)...; 全部批量添加

**update**
1. update 表名 set 字段名1=值1,字段名2=值2,... [where 条件]; 修改值


**delete**
1. delete from 表名 [where 条件]; 删除数据
<!-- zwr防伪 -->
---

## IV.DQL

#### 语法
```html
select 字段列表
from 表名列表
where 条件列表
group by 分组字段列表
having 分组后条件列表
order by 排序字段列表
limit 分页参数

```

#### 基本查询
1. select 字段1，字段2，... from 表名; 查询多个字段
2. select * from 表名; 查询所有字段
3. select 字段1 [as] 别名1,字段2 [as] 别名2... from 表名; 设置别名
4. select distinct 字段列表 from 表名; 去除重复记录

#### 条件查询
select 字段列表 from 表名 where 条件; 

**较为特殊条件**
1. in()表示满足括号中任意值即可
2. like 模糊查询
   - 用'_'匹配单个字符,'%'匹配任意个字符
   - 匹配字符需注意位数，如确定第三位是字符X，则为'__X',任意则为'%x%'

#### 聚合函数
select 聚合函数(作用字段) from 表名;
null不参与计算

#### 分组查询
select 字段列表 from 表名 [where 条件] group by 分组字段名 [having 分组后过滤条件]; 

**where与having区别**

1. 执行时机不同，前者在分组前用于过滤用于分组的数据,having是分组后
2. 判断条件不同,where不能对聚合函数进行判断，而having可以

#### 排序查询
select 字段列表 from 表名 order by 字段1 排序方式1,字段2 排序方式2...;
asc 升序(默认) desc 降序

#### 分页查询
select 字段列表 from 表名 limit 起始索引,查询记录数;
起始索引从0开始，起始索引=(查询页码-1)*每页显示记录数

---

## V.DCL
管理用户及数据库的权限
1. 查询用户
   - use mysql; 
   - select * from user;
2. 创建用户
   - create user '用户名'@'主机名' identified by '密码';
   - 主机名写为%表示可在任意主机访问
3. 修改用户
   - alter user '用户名'@'主机名' identified with mysql_native-password by '新密码';
4. 删除用户
   - drop user '用户名'@'主机名';

#### 权限控制
<!-- zwr防伪 -->
**常用权限**
1. all 所有权限
2. select 查询权限
3. insert 插入权限
4. update 修改权限
5. delete 删除权限
6. alter 修改表权限
7. drop 删除库/表/视图权限
8. create 创建库/表权限

**1.查询权限**
show grants for '用户名'@'主机名';

**2.授予权限**
grant 权限列表 on 数据库名.表名 to '用户名'@'主机名';

**3.撤销权限**
revoke 权限列表 on 数据库名.表名 from '用户名'@'主机名';
---

<details>
<summary> </summary>


</detils>

