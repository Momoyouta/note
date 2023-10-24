##  1.安装

<details>
<summary> </summary>

- 官网获取安装包解压后进入文件，找到configure文件`./configure`执行
- configure需要很多依赖，下面是部分可能所需:
  - `yum install -y pcre pcre-devel`
  - `yum install -y zlib zlib-devel`
  - `yum install -y gcc`
  - `yum install -y GeoIP-devel.x86_64  gd gd-devel.x86_64`
- 检查完依赖后执行`make install`
- 创建用户，不创建可能报错`nginx: [emerg] getpwnam("nginx") failed`  
  `useradd nginx`
- 进入安装好的目录`/usr/local/nginx/sbin`,可发现目录下有nginx文件
  ```
  ./nginx 启动
  ./nginx -s stop 快速停止
  ./nginx -s quit 优雅关闭，在退出钱完成已经接收的连接请求
  ./nginx -s reload 重新加载配置
  ```
</details>

---

## 2.配置

<details>
<summary> </summary>
`/nginx/conf/nginx.conf`

### 配置虚拟主机
```
server {
    #端口
    listen       80;
    #域名、主机名
    server_name  localhost;

    location / {
        #根目录
        root   html;
        index  index.html index.htm;
    }
    #错误时显示的网页
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}
```


</details>

---

##  3.配置虚拟主机

<details>
<summary> </summary>

`/nginx/conf/nginx.conf`下

### 简单案例

```
server {
    #端口
    listen       80;
    #域名、主机名
    server_name  localhost;

    location / {
        #根目录
        root   html;
        index  index.html index.htm;
    }
    #错误时显示的网页
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}
```

### ServerName匹配规则
- 同一servername匹配多个域名
  - 完整匹配
    - 可以在server_name后直接写多个域名  
      `server_name  localhost www.lsls.com;`
  - 通配符匹配
    - 利用通配符`*`,conf中谁先定义优先匹配谁
  - 正则匹配
    - 支持正则表示式



</details>

---

## 4.反向代理

<details>
<summary> </summary>

### 概念
![](/img/Nginx/reverse-proxy.png)
[知乎大佬介绍代理模式](https://zhuanlan.zhihu.com/p/464965616)

**概括**  
- 在访问一个网站过程中，浏览器需要通过代理服务器根据域名查到对应ip才能访问网站，而浏览器不知道哪里有浏览器
- 对于正向代理，相当于要配置代理服务器
- 对于反向代理，相当于不需要配置代理服务器

**作用**
- 作为内容服务器的替身，真实的web服务器被包含，在外网只能看到反向代理服务器，但反向代理服务器上没有真实数据，可以保护web服务器的资源安全
- 作为内容服务器的负载均衡器，可以在一个组织内使用多个代理服务器来平衡各Web服务器间的网络负载，提高网络访问效率

</details>

---

## 5.负载均衡

<details>
<summary> </summary>




</details>

---

##  

<details>
<summary> </summary>




</details>