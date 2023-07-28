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

```html
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
```html
    let obj={
        name:' ',
        ...
        //方法
        fname:function(){
            ...
        }
    }

```