## 1 分布式系统中相关概念

<details>
<summary> </summary>

### 1.1 大型互联网项目架构目标
- 高性能--提供快速访问体验
- 高可用--网站服务一直可以正常访问
- 可伸缩--通过硬件增加、减少，提高、降低处理能力
- 高可扩展--系统间耦合低，方便的通过新增/移除方式，增加/减少新的功能/模块
- 安全性--提供网站安全访问和数据加密，安全存储等策略
- 敏捷性：随需应变，快速响应
**衡量网站的性能指标**：
- **响应时间**：指执行一个请求从开始到最后收到响应数据所花费的总体时间
- **并发数**：指系统同时能处理的请求数量
  - **并发连接数**：指的是客户端向服务器发起请求，并建立了TCP连接，每秒钟服务器连接的总TCP数量
  - **请求数**：QPS，每秒请求数
  - **并发用户数**：单位时间用户数
- **吞吐量**：指单位时间内系统能处理的请求数量
  - **QPS**：Query Per Second 每秒查询数
  - **TPS**：Transactions Per Second 每秒事务数
  - 一个事务是指一个客户机向服务器发送请然后服务器做出反应的过程。客户机在发送请求时开始计时，收到服务器响应后结束计时，以此来计算使用的时间和完成的事务个数
  - 一个页面的一次访问，只会形成一个TPS，但一次页面请求，可能产生多次对服务器的请求，就会有多个QPS

---

### 1.2 集群与分布式
- 集群：很多人，做同一件事
  - 一个业务模块，部署在多台服务器上
- 分布式：很多人，做不同一件事，但共同为一件大事服务
  - 一个大的业务系统，拆分为小的业务模块，分别部署在不同的机器上

**集群分布式特性**
- 高性能
- 高可用
- 高伸缩
- 高可扩展


</details>

---

## 2 Dubbo概念

<details>
<summary> </summary>

### 2.1 概念
- Dubbo是高性能、轻量级的JavaRPC框架
- 致力于提供高性能和透明化的RPC远程服务调用方案，以及SOA服务治理方案

### 2.2 架构
![](/img/Dubbo/Structrue.png)



</details>

---

## 3 dubbo入门

<details>
<summary> </summary>

### 3.1 注册中心安装-zookeeper

**安装**
```
#将zookeeper安装包放至/opt/zooKeeper
#解压
tar -zxvf apache-zookeeper-3.6.4-bin.tar.gz /opt/zookeeper/
```
**配置启动**
- 创建数据存放处
```
mkdir /opt/zooKeeper/zkdata
```
- 修改配置文件
```
#copy配置文件
cp ./conf/zoo_sample.conf ./conf/zoo.conf
#编辑，将DataDir值改为zkdata路径
vim ./conf/zoo.conf

```
- 启动服务
```
./bin/zkServer.sh start
```

### 3.2 spring与springmvc整合
![](/img/Dubbo/Structrue.png)
**步骤**
- 创建服务提供者Provider模块
- 创建服务消费者Consumer模块
- 在Provider模块编写UserServiceImpl提供服务
- 在Consumer中的UserController远程调用UserServiceImpl提供的服务
- 分别启动两个服务，测试
- 

</details>

---

## 4 

<details>
<summary> </summary>


</details>