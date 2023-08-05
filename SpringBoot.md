## I.初识
SpringBoot是一种java框架,什么是java框架？java框架是由一系列可重用的预编写代码组成，起着模板作用,可以帮助开发减少代码冗余，提高运行速度，且便于维护，规范编程。

## II.请求响应
tomcat是servlet容器，并不能直接访问web服务器的controller方法，需要通过DispatcherServlet类来调控

---

#### 请求
HTTP请求数据由tomcat解析后封装在该类下生成==HttpServletRequest==对象中，即请求对象
程序便可从中获取请求数据<br />
对于spring不需要HttpServletRequest对象，可以直接设置函数形参来读取对应数据，如
```java
@RestController
public class RquestController {
        @RequestMapping("/simpleParam")
        public String simpleParam(@RequestParam(name="name") String name,Integer age){
            System.out.println(name+":"+age);
            return "OK";
        }
}
//@RequestParam：如果请求参数与形参不匹配则使用其完成映射，第二个参数为required,默认true,代表请求参数必须传递
```

**实体参数**
springboot还可以通过对象实体来读取请求
如：
```java
public class User {
    private String name;
    private Integer age;
    private Address address;
    //需set,get,tostring方法
}
----------------------------
public String simpleParam(User user){
            System.out.println(user);
            return "OK";
}
```
**其他参数**
1. **数组**:形参写数组即可
2. **集合**:需用@RequestParam绑定参数关系
3. **日期参数**:使用@DateTimeFormat(pattern="")来固定日期格式
4. **json参数**:json数据键名与形参对象属性名相同,需要使用@RequestBody标识
5. **路径参数**:通过请求URL直接传递参数，使用{...}来标识该路径参数，需使用@PathVariable获取路径参数
   ```java
   @RequestMapping("/path/{id}/{...}")
   public String pathParam(@PathVariable Integer id,...){...}
   ```


#### 响应
通过该类下的==HttpServletResponse==对象设置响应数据，再由tomcat响应，即响应对象
程序便可从中获取请求数据

**注解**
1. **@ResponseBody**:将方法的返回值直接响应，如果返回值类型是实体对象/集合，将会转化为json格式响应
(@RestController=@Controller+@ResponseBody)


#### BS架构
Browser/Server,浏览器/服务器架构模式。客户端只需要浏览器，应用程序的逻辑和数据都存在服务端

#### CS架构
Client/Server，客户端/服务器架构模式，需要单独安装客户端

---

## III.分层解耦
通过IOC和DI实现层与层解耦
### 三层架构
- controller：控制层，接收前端发送的请求，对请求进行处理，并响应数据
- service：业务逻辑层，处理具体业务逻辑
- dao：数据访问层(Data Access Object)(持久层)，负责数据访问操作，包括数据的增、删、改、查

### IOC
控制反转，Inversion Of Control，简称IOC。对象的创建控制权由程序自身转移到外部(容器)，这种思想称为控制反转
使用@Component注解将类交给IOC容器管理

### DI
依赖注入，Dependecy Injection，简称DI。容器为应用程序提供运行时，所依赖的资源，称之为依赖注入
使用@Autowired注解实现依赖注入
使用@Primary或@Resource(name)实现容器优先选择


---