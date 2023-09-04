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
2. 创建配置类，使用@Configuration标记，相当于properties中的空间配置，再添加上@ComponentSan(value)来指定扫描的包，最后调用ApplicationContext中的AnnotationConfigApplicationContext方法使用配置类来调用容器实现注入

</details>

---








<details>
<summary> </summary>

</details>

