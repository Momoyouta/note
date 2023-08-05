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

## VI.函数

#### 字符串函数

**常用函数**
1. concat(s1,s2,...) 字符串拼接
2. lower(str) 转为小写
3. upper(str) 转为大写
4. lpad(str,n,pad) 左填充，用字符串pad对str的左边进行填充，达到n个字符串长度
5. rpad 右填充
6. trim(str)  去字符串头部和尾部的空格
7. substring(str,start,len) 返回从字符串str从start位置起的len个长度的字符串
8. left/right(str,length) 从左/右截取字符串
9. group_concat([distinct] 要连接的str [order by 排序字段] [separator '分隔符']) 连接字段

#### 数值函数
类似java中math库
**常用函数**
1. ceil(x) 向上取整
2. floor(x) 向下取整
3. mod 求模
4. rand() 返回0-1内的随机数,通过乘上一个数来达到取更多数的效果
5. round(x,y) 求x四舍五入的值，保留y位小数

#### 日期函数

**常用函数**
1. curdate() 返回当前日期
2. curtime() 返回当前时间
3. now() 返回当前日期和时间
4. year(Date) 获取指定date年份
5. month(date) 获取指定date月份
6. dat(date)  获取指定date日期
7. date_add(date interval expr type) 返回一个日期/时间值加上一个时间间隔expr后的时间值
8. datediff(date1,date2) 返回起始时间date1和结束时间date2之间的天数

#### 流程函数
在SQL语句中实现条件筛选，提高语句的效率

**常用函数**
1. if(value,t,f) 如果value为true，则返回t，否则f
2. ifnull(value1,value2) 如果value1不为空,返回value1,否则返回value2
3. case when [val1] then [res1]... else [default] end 如果val1为true,返回res1,..否则返回default默认值
4. case [expr] when [val1] then [res1] ... else[default] end 如果expr值等于val1，返回res1,...否则返回default默认值


---

## VII.约束
作用于表中字段上的规则，用于限制存储在表中的数据   
利用外键建立表之间的联系

**表内约束**
约束可以在建表时字段后直接添加
```
create table user2(
    id int primary key auto_increment comment '主键',
    ...
)
```
也可以之后添加
```
alter table add 约束(被添加的字段)
```
同理可以用drop删除约束

**外键添加**
```
alter table 表名 add constraint 外键名称 foreign key (被添加字段) references 主表(主表名);
```
**外键约束**
1. cascade 当在父表删除/更新对应记录时,首先检查该记录是否有对应外键,有则也删除/更新外键在子表中的记录
2. set null 当在父表删除对应记录时，首先检查该记录是否有对应外键，有则设置子表中该外键值为null
3. restrict/no action 有对应外键，不允许更新删除
```
alter table 表名 add constraint 外键名称 foreign key (被添加字段) references 主表(主表名) on update/delete 约束;
```

---

## VIII.多表查询

### 链接查询

#### 内连接
查询交集部分数据


#### 外连接
选取左/右表，只查询左/右表以及交集部分数据
==用于处理部分数据外键值为null导致多表查询时不显示问题==
```sql
select 字段列表 from 表1 left/right [outer] join 表2 on 条件..;
```
**其他链接**
1. 外链接:left join +right join
   使用union all将两个JOIN合并

#### 自连接
例子:学生进行了分组操作，需查询各学生的组长是谁(名字),而组长信息也在学生信息中,某学生的组长用id记录,此时就用到自链接
```select 字段列表 from 表 别名a join 表 别名b on 条件...```
外连接同样适用

### 联合查询-union,union all
把多次查询的结果合并起来，形成一个新的查询结果集
多张表字段数以及类型必须保持一致
```sql
select 字段列表 from 表A...
union [all]  -->加all会直接拼接结果,即可能出现重复数据
select 字段列表 from 表B...

```

### 子查询(嵌套查询)
查询已查询获得的信息(嵌套)
#### 标量子查询
```select * from user2 where user2.workplace_id=(select id from user where id=1);```

#### 列子查询
子查询的返回结果为一列

**常用操作符**
将where后条件'=' 替换为操作符  
```select * from user2 where user2.maht > all (select math from user where id=1);```
1. in 在指定集合范围内，多选一
2. not in 不在指定的范围之内
3. any/some 子查询返回列表中，有任意一个满足
4. all 必须所有都满足

#### 行子查询
返回结果为一行
常用操作符:in,<>,=,
#### 表子查询
返回结果为多行多列
常用操作符:in


---

## IX.事务

### 事务操作 
**查看事务提交方式**
select @@autocommit
**设置事物提交方式**
set @@autocommit=0;
1自动，0手动
**提交事务**
commit;
**回滚事务**
rollback;
**开启事务**
start transaction 或begin;

### 事务隔离级别
![](/img/MySQL/gl.png)
**查看隔离级别**
select @@transaction_isolation

**设置隔离级别**
set [session|global] tansaction isolation level {级别}

---

## X.窗口函数

**语法**
```sql
<窗口函数> oevr ([partition by <列清单>]
                        [范围限定] order by <排序用列清单>)
```

**常见函数**
1. 部分聚合函数(sum,avg,count,max,min)
2. **rank()**  计算记录排序,如果存在相同的位次的记录,则会跳过之后的位次(两个第一名则第三个人为第三名)
3. **dense_rank()**  计算记录排序,即使存在相同位次的记录,也不会跳过之后的位次(两个第一名,第三个人为第二名)
4. **row_number()**  赋予唯一的连续位次(两个同分,分别为第一第二名)
5. **lag(参数名,偏移位数,超出边界默认值)** 查询当前行向上偏移n行对应的结果 
6. **lead(同lag)** 查询向下偏移n行结果

**范围限定**
1. rows 限定行
利用rows(行)，preceding(之前),following(之后)关键字来限定范围
```sql
   rows between 1 preceding and 1 following
   //表示当前行和前行和后一行
```
2. range 限定数值范围
需通过order by确定关键字
如限定日期
```sql
range interval 6 day preceding
//限定近7天的值
```

---

## XI.正则表达式
用于匹配字符,like是模糊匹配,而正则表达式则是准确匹配
使用regexp关键字进行匹配
**正则表达式函数**
1. **regexp_like(str1,str2)** 匹配，返回1或0
2. **regexp_instr** 包含
3. **regexp_replace(str,匹配字符串,替换字符串)** 替换
4. **regexp_substr(str,匹配字符串,位置)** 用于模式匹配,提取子串

**匹配模式**
<table data-draft-node="block" data-draft-type="table" data-size="normal"><tbody><tr><th>模式</th><th>匹配模式的什么</th><th>例子</th><th>含义</th></tr><tr><td>^</td><td>匹配字符串开头</td><td>select name from 表名 where name regexp &#39;^王&#39;</td><td>匹配姓为王的名字</td></tr><tr><td>$</td><td>匹配字符串结尾</td><td>select name from 表名 where name regexp &#39;明$&#39;</td><td>匹配名字最后一个字为明的名字</td></tr><tr><td>.</td><td>匹配任意字符</td><td>select name from 表名 where name regexp &#39;.明.&#39;</td><td>匹配带有明的名字</td></tr><tr><td>[…]</td><td>匹配方括号间列出的任意字符</td><td>select name from 表名 where name regexp &#39;^[wzs]&#39;;</td><td>匹配括号里任意字符的名字</td></tr><tr><td>[^…]</td><td>匹配方括号间未列出的任意字符</td><td>select name from 表名 where name regexp &#39;^[^wzs]&#39;;</td><td>匹配未在括号里任意字符的名字</td></tr><tr><td>p1|p2|p2</td><td>交替：匹配任意p1或p2或p3</td><td>select performance from 表名 where performance regexp &#39;A-|A|A+&#39;;</td><td>匹配p1,p2,p3</td></tr><tr><td>*</td><td>匹配前面的字符零次或者多次</td><td>str*&#39;</td><td>可以匹配st/str/strr/strrr……</td></tr><tr><td>?</td><td>匹配前面的字符零次或者1次</td><td>str?&#39;</td><td>可以匹配st/str</td></tr><tr><td>+</td><td>匹配前面的字符一次或者多次</td><td>str+&#39;</td><td>可以匹配str/strr/strrr/strrrr……</td></tr><tr><td>{n}</td><td>匹配前面的字符n次</td><td></td><td></td></tr><tr><td>{m,n}</td><td>匹配前面的字符m至n次</td><td></td><td></td></tr></tbody></table>

---

## XII.索引
帮助数据库高效获取数据的==数据结构==

#### 结构
一般情况下为B+Tree(多路平衡搜索树)

#### 语法
- 创建索引
  ```
  create [unique] index 索引名 on 表名(字段名)
  ```
   会自动为主键和有unique约束的字段创建索引
- 查看索引
  ```
  show index from 表名
  ```
- 删除索引
  ```
  drop index 索引名 on 表名
  ```


---

<details>
<summary> </summary>


</detils>

