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

**实现**<br/>
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
        ex.printStackTrace();
        return Result.error("操作失败");
    }
}
```


</details>

---

## IV.JS数据处理精度丢失

<details>
<summary> </summary>
例如对于Long型的19位id提交时与数据库中的不一致，原因是js对long型数据处理时丢失精度

#### 解决方法
在服务端给页面响应json数据时进行处理，将long型数据统一转为String字符串
1. 提供对象转换器JacksonObjectMapper，基于Jackson进行java对象到json数据的转换
2. 在WebMvcConfig配置类中扩展Spring mvc消息转换器，在此消息转换器中使用提供的对象转换器进行java对象到json数据的转换
```java
@Configuration
public class WebMvcConfig extends WebMvcConfigurationSupport {
    @Override
    protected void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        //创建消息转换器对象
        MappingJackson2HttpMessageConverter messageConverter=new MappingJackson2HttpMessageConverter();
        //设置对象转换器，底层使用Jackson将java对象转为json
        messageConverter.setObjectMapper(new JacksonObjectMapper());
        //将上面的消息转换器对象追加到mvc框架的转换器集合中
        converters.add(0,messageConverter);
    }
}

```

</details>


---

## V.公共字段自动填充
<details>
<summary> </summary>

例，在新增员工时都需要设置创建时间，这字段就属于公共字段，对于这些公共字段可以利用MybatisPlus提供的公共字段自动填充功能进行统一处理，简化开发<br />

> [TableFill](https://baomidou.com/pages/223848/#fieldfill)

#### 实现
1. 在实体类属性上加入@TableField注解，指定自动填充策略
2. 按照框架要求编写元数据对象处理器，在此类中统一为公共字段赋值，此类需要实现MetaObjectHandler接口

#### 对于当前请求session获取
利用ThreadLocal来维护线程中的变量，即Threadlocal为线程的局部变量
Threadlocal存储在堆区
| 方法                     | 作用                               |
| ------------------------ | ---------------------------------- |
| public void set(T value) | 设置当前线程的线程局部变量的值     |
| public T get()           | 返回当前线程对应的线程局部变量的值 |

### SpringBoot实现
- 自定义AutoFill注解，用于表示需要进行公共字段填充的方法
  ```java
  @Target(ElementType.METHOD)
  @Retention(RetentionPolicy.RUNTIME)
  public @interface AutoFill {
  //OperationType为枚举体
  OperationType value();
  }
  ```
-  自定义切面类AutoFillAspect，统一拦截加入AutoFill的方法
  ```java
    @Aspect
    @Component
    public class AutoFillAspect {
        @Pointcut("execution(xxx) && @annotation(xxx.AutoFill)")
        public void autoFillPointCut(){}

        @Before(value = "autoFillPointCut()")
        public void autoFill(JoinPoint joinPoint){
            //获取当前被拦截方法的操作类型
            MethodSignature methodSignature=(MethodSignature) joinPoint.getSignature();//方法签名对象
            AutoFill autoFill=methodSignature.getMethod().getAnnotation(AutoFill.class);//获得方法上的注解对象
            OperationType operationType=autoFill.value();
            //获取当前被拦截方法的参数
            Object[] args = joinPoint.getArgs();
            if(args == null ||args.length==0){
                return;
            }
            Object entity=args[0];
            //准备赋值数据
            ...
            //根据不同操作类型，为对应属性通过反射赋值
            if(operationType==OperationType.xxx){
                
            }
        }
    }

  ```

</details>

---

## VI.MP处理分页多表查询方法

<details>
<summary> </summary>

### 1.使用工具类连接，转为多次单表查询
**情景再现**
现有Student表与Teacher表，Student表中存有TeacherId但没有TeacherName,要求输出学生所有信息以及所属老师名

**解决方法**
- 对于前端请求数据，建立一个DTO类继承Student，在此基础上添加TeacherName成员变量，这样即可接受前端传来包含Student以及TeacherName的数据
- 后端数据处理，构造Student与DTO的分页构造器对象stuPage、dtoPage，将stuPage中除records外的数据利用BeanUtils拷贝到dtoPage中(忽略records节省资源)，再根据stuPage中的records读取出teacherId进行对Teacher的单表查询，并将数据填入dtoPage中，最终返回dtoPage完成多表查询
```java
public R<Page> page(int page,int pageSize,String name){
    Page<Student> pageInfo = new Page<>(page,pageSize);
    Page<StuDto> stuDtoPgae=new Page<>();
    LambdaQueryWrapper<Student> queryWrapper=new LambdaQueryWrapper<>();
    queryWrapper.like(name!=null,Student::getName,name);
    stuService.page(pageInfo,queryWrapper);
    //对象拷贝,忽略records
    BeanUtils.copyProperties(pageInfo,stuDtoPgae,"records");
    List<Student> records = pageInfo.getRecords();
    List<StuDto> list= records.stream().map((item)->{
        StuDto stuDto=new StuDto();
        BeanUtils.copyProperties(item,stuDto);
        Long teacherId=item.getTeacherId();
        Teacher teacher=TeacherService.getById(teacherId);//二次查询
        String teacherName=teacher.getName();
        stuDto.setTeacherName(teacherName);
        return stuDto;
    }).collect(Collectors.toList());
    stuDtoPgae.setRecords(list);
    return R.success(stuDtoPgae);
}
```

</details>

---

## VII.Swagger

<details>
<summary> </summary>
用于生成接口文档以及在线接口调试页面

**Knife4j**
为JavaMVC框架集成Swagger生成API文档的增强解决方案
```xml
<dependency>
    <groupId>com.github.xiaoymin</groupId>
        <artifactId>knife4j-openapi3-jakarta-spring-boot-starter</artifactId>
    <version>4.1.0</version>
</dependency>
```

**yml配置**
```yml
#springdoc相关配置
springdoc:
    swagger-ui:
    path: /swagger-ui.html
    tags-sorter: alpha
    operations-sorter: alpha
    api-docs:
    path: /v3/api-docs
    group-configs:
    - group: 'hyc'
        paths-to-match: '/**'
        packages-to-scan: com.sky

#knife4j相关配置 可以不用改
knife4j:
    enable: true
    setting:
    language: zh_cn
```

**注解**
| 注解                                                              | 注解位置                      | 作用                 |
| ----------------------------------------------------------------- | ----------------------------- | -------------------- |
| @Tag(name = "")                                                   | Controller类上                | 对类的说明           |
| @Operation(summary = "")                                          | Controller方法上              | 说明方法的用途、作用 |
| @Parameters                                                       | Controller方法上              | 指定多个参数描述     |
| @Parameter(description = "")                                      | Controller方法上@Parameters里 | 描述参数信息         |
| @Parameter(hidden = true) 或 @Operation(hidden = true) 或 @Hidden | -                             | 隐藏属性             |
| @Schema                                                           | DTO类上 或 DTO 属性上         | 描述属性信息         |

</details>

---

## VIII.数据格式处理

<details>
<summary> </summary>

**例子**  
对日期进行统一格式
- 方法一：使用@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")来格式化数据
- 方法二：使用Spring MVC的消息转换器,与处理JS精度丢失方法相同

### Spring MVC消息转换器
实现WebMvcConfigurer的extendMessageConverters方法  
若集成Knife4j开发，注意注册ByteArrayHttpMessageConverter消息转换器，详情见
>[引用文章](https://blog.loverorien.com/archives/knife4j-document-request-error)



</details>

---

## IX.HttpClient

<details>
<summary> </summary>

- HttpClient是Apache Jakarta Common下的子项目，可以用来提供高效的、最新的、功能丰富的支持HTTP协议的客户端编程工具包，©它支持HTPP协议最新的版本

**依赖**
```xml
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
    <version>4.5.13</version>
</dependency>
```

**发送请求步骤**
- 创建HttpClient对象
- 创建Http请求对象
- 调用HttpClient的execute方法发送请求
```java
@Test
public void testGet() throws IOException {
    //创建httpclient对象
    CloseableHttpClient httpClient = HttpClients.createDefault();
    //创建请求对象
    HttpGet httpGet = new HttpGet("http://localhost:8080/user/shop/status");
    //发送请求，接受响应结果
    CloseableHttpResponse response = httpClient.execute(httpGet);
    //获取服务端返回的状态码
    System.out.println(response.getStatusLine().getStatusCode());

    HttpEntity entity=response.getEntity();
    String body= EntityUtils.toString(entity);
    System.out.println(body);

    //关闭资源
    response.close();
    httpClient.close();
}

@Test
public void testPOST() throws IOException {
    CloseableHttpClient httpClient=HttpClients.createDefault();
    HttpPost httpPost=new HttpPost("http://localhost:8080/admin/employee/login");
    //设置请求参数
    JSONObject jsonObject=new JSONObject();
    jsonObject.put("username","admin");
    jsonObject.put("password","123456");
    StringEntity stringEntity=new StringEntity(jsonObject.toString());
    //指定请求编码方式
    stringEntity.setContentEncoding("utf-8");
    stringEntity.setContentType("application/json");
    httpPost.setEntity(stringEntity);
    //发送请求
    CloseableHttpResponse response = httpClient.execute(httpPost);
    System.out.println(EntityUtils.toString(response.getEntity()));
    //关闭资源
    response.close();
    httpClient.close();
}
```
 
</details>

---

## X.缓存

<details>
<summary> </summary>

- 当数据都是通过查询数据库获得，当用户端访问量比较大时，数据库访问压力随之增大

**数据一致性**
- 缓存需及时清理以保持与数据库数据一致

### Redis解决
- 可通过Redis来缓存数据，减少数据库查询操作


### Spring Cache
- SpringCache实现了基于注解的缓存功能，只需要简单地加一个注解，就能实现缓存功能
- SpringCache提供了一层抽象，底层可以切换不同的缓存实现，例如：
  - EHCache
  - Caffeine
  - Redis

**Maven坐标**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
```

**常用注解**
![](/img/SpringCache_@.png)


</details>

---

##

<details>
<summary> </summary>

</details>