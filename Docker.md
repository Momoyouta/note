
## I.Docker初识
<details>
<summary> </summary>

简单来说就是用来快速搭建环境的  
>[大佬文章](https://zhuanlan.zhihu.com/p/187505981)

</details>

---

## II.常用命令

<details>
<summary> </summary>

![命令](/img/docker/command.png)
1. `ps` 查询运行中的容器
2. `exec` 进入容器

### 修改镜像源
- 使用国外镜像源会导致pull速度极其缓慢，故切换国内镜像源
- 在/etc/docker/daemon.json中添加参数(没有则创建)
```
{
  "registry-mirrors": ["https://9cpn8tt6.mirror.aliyuncs.com"]
}
```

</details>


---

## III.数据卷挂载

<details>
<summary> </summary>

数据卷是一个虚拟目录，是容器目录与宿主机目录之间的映射桥梁
![](/img/docker/data.jpg)

**常用命令**
| 命令                  | 说明                 |
| --------------------- | -------------------- |
| docker volume create  | 创建数据卷           |
| docker volume ls      | 查看所有数据卷       |
| docker volume rm      | 删除指定数据卷       |
| docker volume inspect | 查看某个数据卷的详情 |
| docker volume prune   | 清除数据卷           |

- 执行`docker run`时使用`-v 数据卷:容器内目录`可以完成数据卷挂载


</details>


---

## IV.本地目录挂载

<details>
<summary> </summary>

解决挂载目录过深问题

- 执行`docker run`时使用`-v 本地目录:容器内目录`可完成本地目录挂载
- 本地目录必须以`/`、`./`开头，否则会被认定为数据卷挂载
- `--network`可实现网络连接


</details>

---

## V.自定义镜像

<details>
<summary> </summary>

### 镜像结构
![](/img/docker/image_structur.png)

### dockerfile语法
- dockerfile本身是一个文本文件，其中包含指令，指令来说明要执行什么操作来构建镜像

| 指令       | 说明                                         | 示例                        |
| ---------- | -------------------------------------------- | --------------------------- |
| FROM       | 指定基础镜像                                 | FROM centos:6               |
| ENV        | 设置环境变量，可在后面指令使用               | ENV key value               |
| COPY       | 拷贝本地文件到镜像的指定目录                 | COPY ./mysql-5.7.rpm /tmp   |
| RUN        | 执行Linux的shell命令，一般是安装过程的命令   | RUN yum install gcc         |
| EXPOSE     | 指定容器运行时监听的端口，是给镜像使用者看的 | EXPOSE 8080                 |
| ENTRYPOINT | 镜像中应用的1启动命令，容器运行时调用        | ENTRYPOINT java -jar xx.jar |

**构建镜像**
`docker build -t myImage:1.0 .`
- `-t`给镜像起名，格式repository:tag，不指定tag时默认latest
- `.`指Dockerfile所在目录

### 网络
![](/img/docker/Network.png)

**自定义网络**
- 加入自定义网络的容器才可以通过容器名相互访问，Docker的网络操作命令如下
![](/img/docker/Network_command.png)


</details>

---


## VI.DockerCompose

<details>
<summary> </summary>

- DockerCompose通过一个单独的docker-compose-yml模板文件来定义一组相关联的应用容器，帮助我们实现多个相关联的Docker容器的快速部署
![](/img/docker/DockerCompose_structure.png)

**命令**
- `docker compose [OPTIONS] [COMMAND]`
![](/img/docker/docker_command.png)

</details>
