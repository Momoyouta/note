## I.语法规范
主要由两个部分构成：选择器以及一条或多条声明
写在< head >< /head >中，以< style >标签表样式修改
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        p {color:red; }
    </style>
</head>
<body>
    <p>红色</p>
</body>
</html>
```
## II.选择器
用于选择标签

### 基础选择器
由单个选择器组成

#### 1.标签选择器
以HTML标签名称作为选择器，如
p {color:red;}

#### 2.类选择器
能单独选一个或某几个标签

**语法**
```css
.classname{color:red;}
...
<p class="classname">xxx</p>
```
可以同时使用多个类名 class="class1 class2..."

#### 3.id选择器
为标有特定id的HTML元素指定特定样式
只能调用一次
**语法**
```css
#idname{color:red;}
...
<p id="idname">xxx</p>
```

#### 4.通配符选择器
用*定义，表示选取页面中所有标签
```html
* {color:red;}
```

### 复合选择器

---

## III.字体属性
Fonts属性用于定于字体系列、大小、粗细、和文字样式。
1. font-family 定义字体系列，如~:'微软雅黑',xx1,xx2;此处表示默认微软雅黑，若电脑上无该字体，则用下一个
2. font-size 定义字体大小 ~: 20px(px表像素)
3. font-wight 定义字体粗细
   - normal 正常字体(默认)
   - bold 粗体
   - bolder 特粗体
   - lighter 细体
   - number 直接设置粗细
4. font-style 定义字体样式

**复合写法**
顺序:font-style font-weight font-size/line-height font-family;
例如:font:italic 700 16px '微软雅黑'
size与family属性不可忽略

---