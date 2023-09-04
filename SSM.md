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


</details>





---



<details>
<summary> </summary>

</details>


---



<details>
<summary> </summary>

</details>

