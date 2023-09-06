## I.Spring -IOC与DI
<details>
<summary> </summary>

### properties文件配置方法(无注解)
利用< bean >标签配置bean，将对象创建交给IOC容器，利用ApplicationContext类中 ClassPathXmlApplicationContext方法读取properties文件，通过getBean来读取其中配置好的bean，实现注入

**Bean常用标签**
![](/img/SSM/bean_tag.png)

### 纯注解开发
1. 利用@Component将类交给IOC容器，相当于在properties中配置bean
   - @Controller、@Service、@Repository等效于@Component，便于开发辨识类作用
2. 利用@Autowired实现自动注入,搭配@Qualifier可以指定注入哪个bean
   - 不使用@Autowired方法，创建配置类，使用@Configuration标记，相当于properties中的空间配置，再添加上@ComponentSan(value)来指定扫描的包，最后调用ApplicationContext中的AnnotationConfigApplicationContext方法使用配置类来调用容器实现注入
- 其他注解
| 注解名          | 作用                                       |
| --------------- | ------------------------------------------ |
| @Scope          | 定义bean作用范围                           |
| @PostConstruct  | 定义初始化周期                             |
| @PreDestroy     | 定义容器摧毁周期                           |
| @PropertySource | 使用在配置类中，引入外部properties配置文件 |
| @Bean           | 添加bean，常用于管理第三方Bean             |

### XML配置比对注解配置
![](/img/SSM/xml_@.png)

</details>

---

## II.Spring整合Mybatis

<details>
<summary> </summary>

### 代码
```java
public class MybatisConfig {

    @Bean
    public SqlSessionFactoryBean sqlSessionFactory(DataSource dataSource){
        SqlSessionFactoryBean ssfb=new SqlSessionFactoryBean();
        ssfb.setTypeAliasesPackage("pojo"); //初始化配置类
        ssfb.setDataSource(dataSource); //初始化数据库连接池
        return ssfb;
    }

    @Bean //初始化映射配置
    public MapperScannerConfigurer mapperScannerConfigurer(){
        MapperScannerConfigurer msc=new MapperScannerConfigurer();
        msc.setBasePackage("dao");
        return msc;
    }
}
```

</details>


---

## III.AOP

<details>
<summary> </summary>

### 简介
- AOP面向切面编程，一种编程范式
- 作用：在不惊动原始设计的基础上为其进行功能加强
- Spring理念：无入侵式编程

> 核心概念
> ![](/img/SSM/AOP.png)
> 
**依赖**
- spring-context中包含有aop依赖
- aspectjweaver包

### 流程
- 创建一个通知类Myadvice，用于配置切入点以及通知，@Aspect标记
- 在通知类中用@Pointcut标记切入点，@Before等配置方法执行点
- 在Spring配置类中利用@EnableAspectJAutoProxy启动AOP中的@Aspect

**通知类示例**
```java
@Component
@Aspect  //告知spring读取内容
public class MyAdvice {

    @Pointcut("execution(void com.pptp.service.UserService.*())")
    private void pt(){}//切入点设置

    @Before("pt()")//设置切入位置
    public void before(){//执行方法
        System.out.println(System.currentTimeMillis());
    }
    
}//结果为在UserService所有方法执行前执行before方法
```

### AOP工作流程
本质就是Java的代理模式
1. Spring容器启动
2. 读取所有切面配置的切入点
3. 初始化bean，判定bean对应的类中的方法是否匹配到任意切入点
   - 匹配失败，创建对象
   - 匹配成功，创建原始对象的代理对象
4. 获取bean执行方法
   - 获取bean，调用方法并执行，完成操作
   - 获取的bean是代理对象时，根据代理对象的运行模式运行原始方法与增强内容

### 切入点表达式
`"execution(void com.pptp.service.UserService.*())"`<br/>
>格式 动作关键词(访问修饰符 返回值 包名.类/接口名.方法名(参数) 异常名)


</details>





---

## IV.事务管理

<details>
<summary> </summary>

### Spring事务管理
- 在业务层接口上添加Spring事务管理@Transactional
- 设置事务管理器
  ```java
    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource){
        DataSourceTransactionManager transactionManager=new DataSourceTransactionManager();
        transactionManager.setDataSource(dataSource);
        return transactionManager;
    }
  ```
- 在springconfig中使用@EnableTransactionManagement开启事务驱动



### 事务属性
![](/img/SSM/Transational_value.png)

**事务传播行为**
![](/img/SSM/transational_spread.png)

</details>


---

## V.SpringMVC

<details>
<summary> </summary>

一种基于Java实现MVC模型的轻量级Web框架

**依赖**
```
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>3.1.0</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>6.0.11</version>
</dependency>
```

**容器初始化**
```java
//定义一个servlet容器启动的配置类
public class ServletContainersinitConfig extends AbstractDispatcherServletInitializer {

    //加载springMVC容器配置
    @Override
    protected WebApplicationContext createServletApplicationContext() {
        AnnotationConfigWebApplicationContext ctx= new AnnotationConfigWebApplicationContext();
        ctx.register(SpringMvcConfig.class); //注册容器
        return ctx;
    }

    //设置归属springMVC处理的请求
    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }

    //加载spring容器配置
    @Override
    protected WebApplicationContext createRootApplicationContext() {
        return null;
    }
}

```

</details>



---

## VI.SSM整合

<details>
<summary> </summary>

**框架搭建**
- SpringConfig
  - JdbcConfig：配置数据库连接池
    - 利用properties文件设置
  - MybatisConfig
    - 创建SqlSessionFactoryBean，配置dataSource、类型(pojo)包
    - 创建MapperScannerConfigurer配置映射扫描(dao层)
  - 导入配置，配置扫描区域
- SpringMvcConfig
  - ServletConfig servlet容器启动的配置类
</details>



---



<details>
<summary> </summary>

</details>


---



<details>
<summary> </summary>

</details>

---



<details>
<summary> </summary>

</details>

