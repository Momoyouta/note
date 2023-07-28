### 内存基础

<details>
<summary> </summary>

**知识点**
1. 内存分为4个区域，堆区，栈区，方法区，元空间（常量池所在地
2. 栈区存放局部变量以及方法调用等
3. 堆区放对象
4. 方法区加载类方法字节码
5. 引用类型的定义是在栈区开辟一个空间，在堆区开辟对应类对象的数据空间，再将堆的地址传给栈区空间中的变量
6. 对于基础数据类型==比较的是值，引用类型比较的是地址
   - 所以对于引用类型一般使用equals直接比较值，如string
   - 对于赋值，会将常量池中对应值地址传给栈区，也就是说对于
     ```java
     String a="a",b="a";
     System.out.println(a==b);
     ```
     结果为true，而对于通过其他变量拼接而成的String会在常量池生成新的字符串，再将该字符串的地址传给栈区变量，这样一来==结果会为false
7. 


</details>


### StringBuilder

<details>
<summary> </summary>

**概述**
创建一个内容可变的字符串对象
StringBuilder x = new StringBuilder()
**常用API**
1. toString -转为String
2. reverse -反转
3. lenght -长度
4. append(x) -添加数据并返回对象本身
5. 
**特殊**
print输出为属性值而不是地址

</details>

### StringJoiner
<details>
<summary> </summary>


**概述**
与stringbuilder一样，内容可更改的容器,进一步提高字符串操作效率
StringJoiner("间隔符号","开始符号","结束符号")

**常用API**
1. add(x) -添加数据并返回对象本身
2. toString --
3. lenght --

</details>

### ArrayList

<details>
<summary> </summary>

**概述**
类似链表,一个自动调节长度的数组
ArrayList<> x = new ArrayList<>(); 
**常用API**
1. add -增加数据
2. remove(int index) -删除指定索引元素,返回被删除元素,也可以直接删除指定元素
3. set(int index,E e) -修改指定索引下的元素，返回原来的元素
4. get(int index) -获取指定索引元素
5. size --


**特殊**
1. 打印对象不是地址，而是集合中存储的数据内容
2. 对arraylist的sort自定义规则，可以用Comparator.comparing方法创建比较器
   ```java
   Coparator <Student> nameComparator = Comparator.comparing(Student::name);
   student.sort(nameComparator);
   ```

</details>


### 双列集合

<details>
<summary> </summary>

**概述**
类似c中map，一个key对应一个value

#### Map

**概述**
双列集合的顶层端口,它的功能全部双列集合都可以继承使用
Map是一个接口，需要有对应的实现类
Map<key,value> x = new 实现类()
**常见API**
1. V put(V key,V value) -添加元素
   - 添加时若key不存在返回null，key存在执行覆盖，返回被覆盖的value
2. V remove(Obj key) -删除对应key元素
   - 返回被删除的value
3. void clear -清空
4. boolean containsKey(Obj Key) -判断集合是否包含该key
5. boolean containsValue(Obj value) -判断集合是否包含该value
6. boolean isEpmty() -判断集合是否为空
7. int size() --

**遍历方法**
1. 利用Map的entrySet获取所有key-value对,用迭代器进行遍历
key-value对类型:Map.Entry<xxx,xxx> (xxx为数据类型)
   ```java
   Map<String,String> map = new HashMap<>()
   map.put("a","b");
   Iterator<Map.Entry<String, String>> it = map.entrySet().iterator();
   while(it.hasNext())
   {
      String str = it.next().getKey();
   }
   ```
2. 通过Map.keySet()获得key的集合来找对应value
   ```java
   Map<String,String> map = new HashMap<>()
   map.put("a","b");
   Set<String> keys = new Set();
   for(String key : keys)//用迭代器也可
   {
      String str = map.get(key);
   }
   ```

#### HashMap

**概述**
与HashSet一样都是哈希表结构

**底层原理**
对Entry对象利用key计算哈希值，与value无关，再根据哈希值计算数组地址，若该地址value为null则存入
若不为null，则用equals比较key，若一样则覆盖Entry对象，若不一样则新添加的Entry对象，接到原位置的对象之下形成链表，若长度>=64则转为红黑树

</details>



### static

<details>
<summary> </summary>

**概述**
静态方法只能访问静态
非静态可以访问所有
不依赖对象存在

**内存分析**
1. 静态随类加载而加载
2. 静态存储位置在堆内容中的静态区

</details>

### 继承与多态

<details>
<summary> </summary>

**知识点**
1. 虚方法表，将可继承的方法添加到表中，对于重写的方法进行覆盖，后将表传递给子类，优化族中方法的寻找
2. 构造方法中用super(/....)调用父类构造方法
3. 上转型对象,不能调用子类成员变量，方法，但可以调用重写的方法,多用于泛型参数
4. 强制转化上转型对象可以用 e instanceof E来判断e是否属于E类，辅助转化
   - jdk14后的新特性强转写法 if(e instanceof E b)，即e是E则转为E，并命名为b

</details>

### 接口

<details>
<summary> </summary>

**知识点**
1. jdk8前只能写抽象方法
2. jdk8后可以定义有方法体的方法(默认，静态)
3. 默认即default修饰词，解决接口升级问题，实现类重写该方法，其他类不需重写
4. 静态方法不需要重写
5. jdk9后增添私有方法，私有方法为默认方法服务(静态的私有为静态服务)，不被外部访问，提高代码复用性
6. 当一个方法参数是接口时，可以传递接口所有实现类的对象

**适配器设计模式**
1. 解决接口和接口实现类之间的矛盾,即写一个中间类XXXAdapter对对应接口进行空实现，再让真正的实现类继承中间类
2. 为了避免生成适配器对象，可用abstract修饰

</details>

### 泛型

<details>
<summary> </summary>


提高代码复用性

**知识点**
1. 泛型方法定义:修饰词 <T,E..> 返回类型 名字(参数)
2. 泛型类:class 类名<T,E....>
3. 泛型接口:inteface 接口名<T,E...>

</details>

### GUI入门

<details>
<summary> </summary>

**知识点**
1. JFrame类为窗体,JMenuBar为菜单栏,Jmenu菜单,JMenuItem菜单项
2. 窗口界面的设计实际上是容器，个体的叠加嵌套
3. 事件-监听器key,mouse,action-Listener,action为前两个监听器的精简，只能监听空格或者鼠标按下
4. 图片先加载的在上方

**JOptionPane**
API:
1. showMessageDialog(null,"");消息提示
2. showConfirmDialog(null,"",OPTION)提供选择按钮，返回值为int，0为true，1为false


#### 并发

**概述**
启动线程-事件分发线程-后台处理线程
将事件处理单独分出一个线程处理

**SwingWorker**
避免GUI使用多线程的风险
```java
SSwingWorker worker = new SwingWorker<Void,Void>() {
   protected Void doInBackground() throws Exception{
         tf.setText("");
         return null;
      }
   };
worker.execute();
```



</details>


### IO

<details>
<summary> </summary>

**知识点**
1. inputstream字节流，读数据单位为byte;reader为字符,单位为Unicode码元(2byte) 

#### File

**构造方法**
1. File(String filename)
2. File(String directoryPath,String filename)
3. File(File f,String filename),f是指定成一个目录的文件

**常见API**
1. String getName() -获取名字
2. String getAbsolutePath() -获取文件的绝对路径
3. boolean canRead/Write() -判断文件是否可读/写
4. boolean exists() -判断文件是否存在

#### 输入输出流
用完记得flush以及close
可将输入输出写成类并进行单态处理
**FileInputStream**
```java
InputStream f= new FileInputStream("hello.txt");
int index=f.read(byte b[]);//后可接两个参数:int off,int len,分别为输入起始位置，长度
String s2=new String(b,0,index);//转码转化为字符串
```
**FileOutputStream**
```java
OutputStream f = new FileOutputStream("hello.txt");
f.write(byte b[]);//后可接两个参数:int off,int len,分别为输出起始位置，长度
```

**FileReader,FileWriter**
字符流，用法类似字节流，只不过读取写入的是字符char

#### 数据流

**构造方法**
DataOutputStream(OutputStream os)
DataInputStream(InputStream is)

**常用API**
1. writeInt/...(Int x)
2. readInt/...(Int x)

#### 对象流

**构造方法**
ObjectInputStream(InputStream in)
ObjectOutputStream(OutputStream out)

**常见API**
1. writeObject()
2. readObject()

**注意**
被读写类需使用Serializable接口
```java
OutputStream os = new FileOutputStream("hello.txt");
ObjectOutputStream oos=new ObjectOutputStream(os);
people zhang2=new people();
zhang2.age=12;
zhang2.name="asd";
oos.writeObject(zhang2);
``` 

</details>


### 网络基础

<details>
<summary> </summary>

#### URL类

**概述**


**知识点**

#### InetAddress类

**知识点**
1. getAllByName("URL")获取ip地址
2. getLoaclHost()获得一个InetAddress对象，该对象含有本地地址
<!-- zwr防伪 -->
#### 套接字Socket

**Socket类**
为不同进程搭建通信桥梁
即端口号与IP地址组合得出一个网络套接字

**ServerSocket类**
将客户端与服务的套接字对象连接
监听是否有客户端连接

**知识点**
1. ServerSocket类 accept()方法进行阻塞，当有服务器连接时返回一个socket对象,阻塞结束
2. 通过Socket类getInputStream()方法获取输入流对象(输出同理)，实现客户端与服务端通信(读写成对出现)
</details>

### RMI

<details>
<summary> </summary>

**概述**
RMI可以让一个JVM上的应用程序请求调用位于网络上的另一处的JVM的对象方法

**Remote接口**
实现该接口才会被认为是一个远程对象
若接口方法中参数采用了类，则被采用的类需序列化即实现Serializable接口

**创建服务端**
Registry类 调用LocateRegistry.createRegistry方法注册远程对象
Naming.rebind(String name,Remote obj)远程服务调用服务器类方法

**调用服务端**
对远程对象接口使用Naming.lookup(地址);调用远程对象



</details>


### 常用API

<details>
<summary> </summary>

#### I.Math
进行一些数学操作如max、向上取整等等,类似c中的math库

#### II.System
与系统相关的方法
1. exit(0) 终止虚拟机，0表示正常停止
2. long currentTimeMillis() 返回当前系统的时间毫秒值形式
3. arraycopy  拷贝数组

#### III.Object
顶级父类,可以对其中方法进行重写
1. String toString() 返回对象的字符串表现形式
2. equals(Object obj) 比较两个对象是否相等
3. clone 把A对象的属性值完全拷贝给B对象
   - 在Object中clone是protect修饰，故子类对象想使用克隆得重写clone方法，通过super关键字调用父类clone方法实现子类对象克隆
   - 子类实现Cloneable接口(标记性接口，接口中无方法)
   - Object中clone为浅克隆，要实现深克隆需重写时写
   - 一般实现深克隆使用第三方工具如gson

#### IV.Ojects
1. boolean equals 比较两个对象
   - 底层会先判断两个对象是否为null，null则直接返回false
2. boolean isNull 对象是否为空

</details>

### 

<details>
<summary> </summary>

</details>
