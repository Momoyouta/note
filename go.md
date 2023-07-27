# go语言基础语法

## 前言
语法与c，java都十分相似，有该基础学go会轻松许多，基础方法差别较大的
地方为字符串的一些使用.相较于其他语言go也是提供了非常多的方法库，更方便了我们的开发

## I.go特点
1. 高性能高并发            
2. 语法简单、学习曲线平缓
3. 丰富的标准库  
4. 完善的工具链  
5. 静态链接
   - 编译结果都是静态链接，只需要拷贝编译之后的唯一个可执行文件即可部署运行
6. 快速编译
7. 跨平台
   - 交叉编译
8. 垃圾回收
   - 无需考虑内存分配释放

## II.变量声明
[]表示可以省略
1. var name [类型] = value  
2. name:=类型(value)
3. const name=value 表常量，会根据上下文自动判断类型

## 语句

### if
与c类似，但if后不需要加括号
```go
if x==1{
 ....
}
```

### for
与c类似，同意不需要括号
for表示while

### switch
相交于c,go中可以取代任意if-else语句，即switch后什么也不加
```go
switch {
    case x==1:
    ...
}
```

## III.切片
可变长度的数组类似c++中的vector
### 创建
```
 name:=make(类型,初始长度)
```

### 常用函数
1. append 添加元素
   - s=append(s,value);
2. copy 复制切片

## IV.map
类似c++中map,键值对

### 创建
```go
m:=make(map[key类型]value类型)

m[key]表示value
```

## V.range
遍历数组是可以用range遍历
```go
nums :=[]int{2,3,4}
for i,num := range nums{
//可以一次返回多个值,第一个为索引，第二为对应值
}//map同理，第一个返回值为key，第二个为value
```

## VI.函数
类型后置，且能return多个值
```func name(形参1 类型,形参2 类型) 函数类型{}```

## VII.指针
用法与c类似，如在函数中更改外部值，但作用有限

## VIII.结构体
与c类似
### 创建
```go
type name struct{
    ...
}
```

### 结构体方法
```go
func (name struct_name) 方法名(参数列表){}
```

### IX.错误处理
在函数类型后加上err error
``` (int,err error)```

返回时可以用error.New(value)创建错误返回值

## X.数字解析
利用strconv库，字符串相互转化数值


