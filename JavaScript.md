## I.部分基础语句

#### 输出
1. document.write('') 文档输出内容
2. console.log('') 控制台输出内容
3. alert('') 对话框弹出
#### 输入
1. prompt ('')  输入框弹出

#### 模板字符串
用于在字符串中使用变量
使用反引号 `,${}框住变量

```js
let age=18;
document.wirte(`我今年${age}岁`);
//结果:我今年18岁
```

#### 检测数据类型
```typeof x```
返回数据类型

#### 函数声明
```function name(){}```

#### 立即执行函数
```(function(形参){})(实参)```


## II.对象

#### 声明
```js
    let obj={
        name:' ',
        ...
        //方法
        fname:function(){
            ...
        }
    }

```

### III.DOM
- 文档对象模型
- 用于呈现以及与任意HTML或XML文档交互的API


#### DOM树
- 将HTML文档以树状结构直观的表现出来，称之为文档树或DOM树
- DOM树直观的体现了标签与标签之间的关系

![](./img/JavaScript/DOMtree.png)


#### DOM对象
- 浏览器会根据HTML标签生成JS对象
- 修改这个对象的属性会自动映射到标签身上
- 核心思想：把网页内容当对象来处理 

![](./img/JavaScript/DOMobj.png)

**document对象**  
- 是DOM里提供的一个对象
- 它提供的属性与方法用于操作网页内容
  - 例如document.wirte()
- 网页所有内容都在document内