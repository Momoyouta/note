## I.基础语句

<details>
<summary> </summary>

#### 通配符
  ‘*’ 用于模糊匹配

#### 管道符
’|‘，将左侧的输出结果转交给右侧


#### 部分基础语句
1. `ls [-l -a -h] path` ：查看文件夹内容 <br/>
| 选项 | 作用                     |
| ---- | ------------------------ |
| -l   | 列出文件详细信息         |
| -a   | 列出所有文件包括隐藏文件 |
| -h   | 展示文件大小             |
2. `cd path` ：将工作区转到对应路径
3. `pwd` ：展示当前工作目录
4. `mkdir [-p] path` ： 创建文件夹,-p表示自动创建不存在的父目录，用于创建连续多层级目录
5. `touch path `： 创建文件
6. `cat path` ： 查看文件内容
7. `more path`查看文件内容，可以翻页查看
   - 空格进行翻页，输入q退出
8. `cp [-r] 参数1 参数2` : 复制文件1到2中，-r表示复制文件夹
9. `mv 参数1 参数2` ： 将文件1移动到2中
10. `rm [-r -f] 参数1 参数2...` : 删除文件，可一次性删除多项 -r表示删除文件夹，-f表示强制删除
11. `which 命令` ： 查找命令程序文件位置
12. `find 起始路径 -name/-size "文件名"/大小` ： 按名字/大小查找文件，+表示大于，-表示小于，如-1000K表示小于1000k
13. `grep [-n] 关键字 path` ： 从文件中过滤关键字，-n表示显示匹配的行号
14. `wc [-l -w -m -c] path` ： 统计文件行数，单词数等<br/>
| 选项 | 作用        |
| ---- | ----------- |
| -l   | 统计行数    |
| -w   | 统计单词数  |
| -m   | 统计字符数  |
| -c   | 统计bytes数 |
15. `echo "输出内容"` : 输出内容
    - 利用反引号可以输出命令执行后结果，如`echo \`pwd``
    - 重定向符：'>'表示将左侧命令结果覆盖写入指定文件，'>>'则表示追加写入
16. `tail [-f -num] path` ： 查看文件尾部内容，默认查看10行,-f表示持续追踪，能实时输出新更新内容
17. `tar [-zcxvf] fileName [files]`：打包压缩解压命令
- .tar表示完成了打包但没有压缩
- .tar.gz表示打包的同时还进行了压缩
| 选项 | 作用                                                      |
| ---- | --------------------------------------------------------- |
| -z   | z代表gizp，通过gizp命令处理文件，gzip可以对文件压缩或解压 |
| -c   | c代表create，创建新的包文件                               |
| -x   | x代表extract，实现从包文件中还原文件                      |
| -v   | v代表verbose，显示命令的执行过程                          |
| -f   | f代表的是file，用于指定包文件的名称                       |
18. `history` 查询历史执行命令


</details>

---

## II.root用户

<details>
<summary> </summary>
- 拥有最大系统权限
- su [ - ] [用户名] 切换用户 用exit退出root用户

**sudo**
给予认可的普通用户临时root权限  

**配置认证**：
- root下执行visudo，在打开的文件最后添加 `用户名 ALL=(ALL) NOPASSWD: ALL`

### 用户管理
- 创建用户：`useradd [-g -d] 用户名`
  - -g指定用户组
  - -d指定用户HOME路径
- 删除用户：`userdel [-r] 用户名`
  - -r删除用户的home目录
- 查询用户所属组：`id [用户名]`
- 修改用户所属组：`usermod -aG 用户组 用户名`
- 查看系统中的用户：`getent passwd`
  - 所返回信息：`用户名:密码(x):用户ID:组ID:描述信息:HOME目录:执行终端`

### 用户组管理
- 创建用户组：`groupadd 用户组名`
- 删除用户组：`groupdel 用户组名`
- 查看系统中的组：`getent group`
  - 所返回信息：`组名称:组认证(x):组ID`


### 修改文件权限

#### chmod
修改文件权限
- `chmod [-R] 权限 文件/文件夹`  -R对文件夹内全部内容应用同样操作
  - 例：`chmod u=rwx,g=rx,o=x hello.txt`修改文件权限为rwxr-x--x
  - 权限可以用数字代替<br>
    | 数字 | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
    | ---- | --- | --- | --- | --- | --- | --- | --- | --- |
    | 权限 | --- | --x | -w- | -wx | r-- | r-x | rw- | rwx |
---

#### chown
修改文件、文件夹所属用户和用户组
- `chown [-R] [用户][:][用户组] 文件/文件夹` -R对文件夹内全部内容应用同样操作
- 
</details>

---

## III.yum安装

<details>
<summary> </summary>

yum：RPM包软件管理器，用于自动化安装配置Linux软件，并可以自动解决依赖问题  
`yum [-y] [install | remove | search] 软件名称`
- -y，自动确认，无需手动确认安装或卸载过程
- yum命令需要root权限、联网

</details>

---

## IV.软链接

<details>
<summary> </summary>

- 在系统中创建软链接可以将文件、文件夹链接到其它位置,类似windows中的快捷方式 
- 使用ln命令创建软链接  
  `ln -s 参数1 参数2`
  - -s,创建软链接
  - 参数1：被链接的文件或文件夹
  - 参数2：要链接去的目的地




</details>

---

## V.日期与时区

<details>
<summary> </summary>

### date命令
- 通过date命令查看系统时间  
  `date [-d] [+格式化字符串]`
  - -d按照指定的字符串显示日期，一般用于日期计算
  - 格式化字符串：通过特定的字符串标记，来控制显示的日期格式  
    |符号|作用|
    |-|-|
    |%Y|年|
    |%y|年份后两位数|
    |%M|月|
    |%d|日|
    |%H|小时|
    |%M|分钟|
    |%S|秒|
    |%s|自1970-01-01 0点到现在的秒数|
- `date -d "+1 day"` 显示当前日期+一天

### 修改Linux时区
将系统自动的localtime删除，并将/usr/share/zoneinfo/Asia/Shanghai文件链接为localtime文件即可
```
rm -f /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

</details>

---

## VI.IP与主机

<details>
<summary> </summary>

### IP

- 通过ifconfig查看ip
- 特殊ip：
  - `127.0.0.1` 代指本机
  - `0.0.0.0`
    - 可用于代指本机
    - 可以在端口绑定中用来确定绑定关系
    - 在一些IP地址限制中，代表所有IP的意思，如放行规则设置则代表允许任意IP访问

### 主机名
- `hostname` 查看主机名
- `hostnamectl set-hostname 主机名` 修改主机名

### 域名解析
日常访问很少直接输入ip进行访问，而是通过域名(与ip搭建关系)访问服务，
![](/img/Linux/hosts.png)
- 先查看本机记录(/etc/hosts)
- 再联网去DNS服务器

#### 域名映射配置
只需去修改hosts文件即可
```
127.0.0.1 bgon

```

###  配置Linux固定ip

- 当前我们虚拟机的linux操作系统，其ip地址是通过DHCP服务获取的
- DHCP：动态获取IP地址，即每次重启设备后都会获取一次，可能导致IP地址频繁变更

**步骤**  
- 在VM Workstation中配置IP地址网关和网段(IP地址的范围)
  - 虚拟网络编辑器中修改vmnet8子网IP和NAT中网关
  - 如子网`192.168.52.0`,网关`192.168.52.2`
- 在Linux系统中手动修改配置文件，固定IP
  - 修改/etc/sysconfig/network-scripts/ifcfg-ens33
    ![](/img/Linux/staticip.png)

- 执行`systemctl restart network`重启网卡即可

</details>

---

## VII.下载和网络请求

<details>
<summary> </summary>



</details>

---

## 

<details>
<summary> </summary>



</details>

---

##  

<details>
<summary> </summary>



</details>


---

## 

<details>
<summary> </summary>



</details>


---

## 

<details>
<summary> </summary>



</details>

