
## I.Maven的作用
<details>
<summary> </summary>

#### 1.依赖管理
方便快捷的管理项目依赖的资源(jar包),避免版本冲突问题

#### 2.统一项目结构
提供标准、统一的项目结构

#### 3.项目构建
标准跨平台的自动化项目构建方式

</details>

---

## II.模型
<details>
<summary></summary>

![](/img/Maven/model.png)

</details>

---

## III.依赖管理

<details>
<summary> </summary>

**1.添加依赖**
使用< dependency >标签
**2.排除依赖**
使用< exclusions>标签
**3.依赖范围**
使用< scope>value< /scope>设置作用范围
![](/img/Maven/depend_scope.png)

</details>

---

## IV.生命周期

<details>
<summary> </summary>
每套生命周期包含一些阶段,阶段是有顺序的,后面的阶段依赖于前面的阶段

</details>

---

## v.继承与聚合

<details>
<summary> </summary>

### 聚合
- 将多个模块组织成一个整体，同时进行项目构建的过程称为聚合
- 使用聚合工程可以将多个工程编组，通过聚合工程进行构建，实现对所含模块进行同步构建
  - 挡工程中某个模块更新时，必须保障工程中与已更新模块关联的模块同步更新，此时可以使用聚合工程来解决批量模块同步构建问题

**实现**
创建一个只有pom文件的maven项目，用< modules>标签管理模块

### 继承
- 继承描述的是两个工程间的关系，与java中的继承类似，子工程可以继承父工程中的配置信息，常见于依赖关系的继承
- 可以简化配置，减少版本冲突

**实现**
- 利用< parent >标签设置父工程，< relativePath >设置父工程pom路径
- 利用< dependencyManager >可以实现子工程选择性加载依赖，同时又可以同步更新依赖，这也意味着子工程要使用该依赖必须写左边，但不需写版本号

### 属性
类似于变量，用于统一更改

**实现**
- < properties >标签下直接定义
  ```xml
  <properties>
   <spring.version>5.1.1</spring.version>
  </properties>
  ```
- 调用时采用`${name}`形式

**配置文件加载属性**
- pom中使用build.resources.resource标签层叠，< direcotory> 标记properties路径即可在配置文件中使用属性
```xml
<build>
 <resources>
  <resource>
   <directory>path</directory>
   <filtering>true</filtering>
  </resource>
 </resources>
</build>
```

### 多环境配置与应用

**实现**
- 利用< profiles >标签配置
  ```xml
  <profiles>
   <profile>
    <id>name</id>
    <properties>
     属性...
    </properties>
    <activation>
     <activeByDefault>true</activeByDefault> <!-- 是否为默认启动环境 -->
    </activation>
   </profile>
  </profiles>
  ```

#### 跳过测试
利用插件
```xml
<plugins>
    <plugin>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>2.12.4</version>
        <configuration> <!--配置需要跳过的测试-->
            <skipTests>false<skitTests>
            <!--排除不参与测试的内容-->
            <excludes>
                <exclude>path</exclude>
            </excludes>
        </configuration>
    </plugin>
</plugins>
```

</details>

---

## VI.私服

<details>
<summary> </summary>

![](/img/Maven/private_service_1.png)
![](/img/Maven/private_service_2.png)

**基础配置**
在本地仓库中配置，即maven的setting
1. `<servers>`下配置访问私服权限
2. `<mirrors>`下配置映射(私服访问路径)

**工程配置**
工程pom下配置工程保证在私服中的具体位置
1. `<distributionManagement>`
   ```xml
   <distributionManagement> /<snapshotRepository>
    <repository>
      <id></id>
      <url></url>
    </repository>
  </distributionManagement>
   ```
2. deploy上传




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