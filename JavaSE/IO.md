## 1.高级流

<details>
<summary> </summary>

### 1.1 字符缓冲流
`BufferedInputStream(InputStream is)`  
`BufferedReader(Reader rd)`
- 自带字符缓冲池，可以提高字符输入流读取字符数据性能
- 输入输出时先输入到内存的缓冲池中，全部数据输入/输出完后再将缓冲池数据输入/输出

### 1.2 转换流
- 如果代码编码和被读取的文本文件的编码是不一致的，使用字符流读取文本文件时就会出现乱码  

`InputStreamReader(InputStream is,String charset)`
- 把原始字节输入流按照指定字符集编码转成字符输入流
- `OutputStreamWriter`字符输出转换流

### 1.3 打印流
- 打印流可以实现更方便、更高效的打印数据出去，能实现打印什么出去就是什么出去

|构造器|说明|
|-|-|
|public PrintStream(OutputStream/File/String)|打印流直接通向字节输出流/文件/文件路径|
|public Printstream(string fileName,charset charset)|可以指定写出去的字符编码|
|public PrintStream(Outputstream out， boolean autoFlush)|可以指定实现自动刷新|
|public Printstream(outputstream out, boolean autoFlush,string encoding|可以指定实现自动刷新，并可指定字符的编码|


|方法|说明|
|-|-|
|public void print1n(Xxx xx)|打印任意类型的数据出去|
|public void write(int/byte[ ]/byte[]一部分)|可以支持写字节数据出去|

### 1.4 数据流
`DataInputStream DataOutputStream`
- 允许把数据和其类型一同写入/写出

### 1.5 序列化流
`ObjectOutputStream ObjectOutputStream`
- 读写JAVA对象
- 使用`transient`修饰能让该成员变量不参与序列化
```
ObjectOutputStream(OutputStream os) //构造
writeObject(Object o) //写出
```


</details>


## 

<details>
<summary> </summary>


</details>


## 

<details>
<summary> </summary>


</details>

## 

<details>
<summary> </summary>


</details>

## 

<details>
<summary> </summary>


</details>
