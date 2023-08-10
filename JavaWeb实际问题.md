## I.文件上传与存储
<details>
<summary></summary>

### 上传文件大小设置
配置springboot文件

### 本地储存
- 使用springboot中的MultipartFile接受请求
- 使用MultipartFile方法getOriginalFilename获取原始文件名和transferTo储存到本地磁盘方法
- 避免文件重名:截取原始文件后缀配合UUID合成新文件名
```java
 @PostMapping("/upload")
    public Result upload(String username, Integer age, MultipartFile image) throws IOException {
        //获取文件名
        String originalFilename=image.getOriginalFilename();
        //构建新文件名
        String newFileName= UUID.randomUUID().toString()+originalFilename.substring(originalFilename.lastIndexOf("."));
        //保存文件
        image.transferTo(new File("C:\\Users\\fairy\\Desktop\\头像\\"+newFileName));
        return Result.success();
    }
}
```

### 云储存-对象存储服务OSS

#### 阿里云OSS
- [简单文件上传](https://help.aliyun.com/zh/oss/developer-reference/simple-upload-11?spm=a2c4g.11186623.0.0.40a57a035F0Tpi)
用前注意配置相关[依赖](https://help.aliyun.com/zh/oss/developer-reference/java-installation?spm=a2c4g.11186623.0.0.5dd64297ZvXi3n)以及[阿里云访问凭证](https://help.aliyun.com/zh/oss/developer-reference/oss-java-configure-access-credentials?spm=a2c4g.11186623.0.0.67204297m1MPUF#e0f7fac0fdcna)
- 集成到案例中使用阿里云提供的工具类

</details>

---

## II.登录校验

<details>
<summary> </summary>

### 会话
#### 1.cookie
将登录信息自动保存在本地，自动发送给服务器验证
- HTTP协议支持的技术
- 不安全，用户可以禁用
- 不能跨域
- 移动端无法使用

#### 2.session
基于cookie技术，将登录信息保存在服务器，生成cookie记录信息对象传回给客户端
- 存储在服务端，安全
- cookie缺点
- 服务器集群环境无法直接使用

#### 3.令牌
登录成功在服务端生成令牌，响应时将令牌发送给客户端保存，之后客户端请求都会携带令牌给服务端进行验证，会话共享数据可以存储在令牌中
- 支持PC、移动端
- 解决集群环境下的认证问题
- 减轻服务器端存储压力
- 需自己实现

##### JWT-JSON Web Token
一种简洁的、自包含的格式，用于在通信双方以json数据格式安全的传输信息。由于数字签名的存在，这些信息是可靠的

**依赖**
```
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.9.1</version>
</dependency>
```

**组成**
1. Header：记录令牌类型、签名算法等
2. Payload：携带自定义信息、默认信息等
3. Signature：防止Token被篡改、确保安全性。将header、payload，并加入指定密钥，通过指定签名算法计算而来

**实现**
调用Jwts工具类
```java
public void jwtB() {
    Map<String,Object> claims=new HashMap<>();
    claims.put("id",1);
    claims.put("name","tome");
    String jwt=Jwts.builder()
            .signWith(SignatureAlgorithm.HS256,"pptp") //签名算法
            .setClaims(claims) //自定义内容
            .setExpiration(new Date(System.currentTimeMillis()+3600*1000)) //设置有效期为1h
            .compact();
    System.out.println(jwt);
}

//解析
@Test
public void ParseJwt(){
    String key="eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoidG9tZSIsImlkIjoxLCJleHAiOjE2OTE2Nzc0MTF9.cHM_vB8Vm_akc7Pg4R93qpLURax32rx7SJ_WqewHINo";
    Claims claims=Jwts.parser()
            .setSigningKey("pptp") //设置签名
            .parseClaimsJws(key)//设置密钥
            .getBody();//获取自定义内容
    System.out.println(claims);
}
```


#### 4.Filter
- 过滤器可以把对资源的请求拦截
- 过滤器一般完成一些通用操作如登录校验、统一编码处理、敏感字符处理
    

**实现**
1. 实现Filter接口,重写拦截方法doFilter
2. 配置Filter,在类上加@WebFilter注解配置拦截资源的路径
3. 引导类上加@ServletComponentScan开启Servlet组件支持
```java
@WebFilter(urlPatterns = "/*") //配置拦截资源路径
public class DemoFilter implements Filter {
    //init方法、销毁方法不需要重写
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("拦截方法执行");
        //放行
        filterChain.doFilter(servletRequest,servletResponse);
    }
}
```
- 放行后访问对应资源完会回到Filter中，并重新执行放行后逻辑

[👉过滤器与拦截器的区别及关系👈](https://blog.csdn.net/qq_34871626/article/details/79185829)
#### 5.Interceptor
- 概念：是一种动态拦截方法调用的机制，类似于过滤器。Spring框架中提供的，用来动态拦截控制器方法的执行。
- 作用：拦截请求，在指定的方法调用前后，根据业务需要执行预先设定的代码。

**实现**
1. 定义拦截器，实现HandlerInterceptor接口，并且重写所有方法
2. 注册拦截器
```java
@Configuration//配置类
public class WebConfig implements WebMvcConfigurer {
    @Autowired
    private LoginCheckInterceptor loginCheckInterceptor;//实现HandlerInterceptor接口的类
    @Override//注册拦截器
    public void addInterceptors(InterceptorRegistry registry){
        registry.addInterceptor(loginCheckInterceptor)
        .addPathPatterns("/**")//拦截资源
        .excludePathPatterns("/login");//不需要拦截的资源
    }
}
```
**请求路径**
| 拦截路径 | 含义       | 举例                             |
| -------- | ---------- | -------------------------------- |
| /*       | 一级路径   | 能匹配/depts，但不能匹配/depts/1 |
| /**      | 任意级路径 | 能匹配/depts，能匹配/depts/1...  |

**执行流程**
![](/img/JavaWeb-realproblem/Filter_and_Interceptor.png)

</details>


---

## III.异常处理
<details>
<summary> </summary>

#### 全局异常处理器
捕获所有异常

**实现**
```java
@RestControllerAdvice//包含了ResponseBody 能将方法返回值转化为json
public class GlobalExceptionHandler {
    @ExceptionHandler(Exception.class)//设定捕获异常类型
    public Result ex(Exception ex){
        ex.printStackTrace();;
        return Result.error("操作失败");
    }
}
```


</details>

---


<details>
<summary> </summary>

</details>
