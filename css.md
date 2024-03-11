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

#### 1.后代选择器
将父元素中的子元素选择出来

```css
父 子{
    .....
}
```

#### 2.子选择器
只选最近一代
```css
元素1 > 元素2{
    .....
}
```

#### 3.并集选择器
可以选择多组标签定义同意样式
```元素1,元素2,...{....}```

#### 4.链接伪类选择器

1. a:link  选择所有未访问的链接
2. a:visited 选择所有已被访问的链接
3. a:hover  选择鼠标指针位于其上的链接，常用于制作鼠标悬停效果
4. a:active 选择活动链接(鼠标按下但未弹起
5. focus 把活得光标的input表单元素选择出来
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

## IV.文本属性
![](/img/css/textvalue.png)


## V.元素显示模式
某些元素需转化为块元素才能设置高宽
display:value
1. block 块元素//div
   - 独占一行
   - 宽度默认为父级的100%
   - 宽高可以自行设置
2. inline 行内元素//span
   - 一行共存多个
   - 尺寸由内容改变
   - 宽高样式不生效
3. inline-block行内块元素//img
   - 一行共存多个
   - 默认尺寸由内容决定
   - 宽高样式生效

## VI.css三大特性

### 层叠性

相同的属性会覆盖，不同的会叠加，解决相同选择器给设置相同的样式的样式冲突

#### 原则
1. 就近原则，哪个样式离结构近，就执行哪个样式
2. 样式不冲突，不会层叠

### 继承性
子标签会继承父标签的某些样式,若子标签自带样式则生效自己的

### 优先级
当同一个元素指定多个选择器
1. 选择器相同，执行层叠性
2. 选择器不同，根据权重优先

**权重**
- 继承的权重是0
- 复合选择器权重会叠加，从左向右比，不存在进位
![](/img/css/css_importantvalue.png)


## VII.背景属性

![](/img/css/background-img.png)

- 复合属性：背景色 背景图 平铺方式 位置/缩放 固定

## VIII.盒子模型

#### 组成
边框，外边距，内边距，实际内容

### border-边框
**三要素**
1. border-width 单位px
2. border-style 样式,常用:solid 实线边框,dashed 虚线边框,dotted 点线边框
3. border-color
**复合简写**
```border:1px solid red```

border-top，border-bottom...用于指定上下边框

**合并边框**
border-collapse:collapse 重合的边框会被合并成一个  

**圆角**
border-radius: px/百分比 
多值写法可以达到不同效果，如10px 20px为左上右下为10，其余为20

### padding-内边距
padding-left,right... 设置上下左右边距

### margin-外边距
控制盒子之间距离 margin-方向
value设为auto可以使用盒子自动水平居中  
当垂直排列的盒子外边距重合时会合并，取最大值  

行内元素垂直内外边距不受margin与padding影响，但可通过line-height改变  

**阴影**
box-shadow: X偏移 Y便宜 模糊半径 扩散半径 颜色 内外阴影


---


## IX.浮动
让块元素水平排列  
**float**
- left-左对齐
- right-右对齐  

特点：顶对齐，具备行内块显示模式特点 

---

## X.Flex布局
弹性布局，比float更优秀,会将子元素自动挤压、拉伸
**display: flex**

### 组成
- 弹性容器
- 弹性盒子
- 主轴：默认在水平方向，弹性盒子延主轴排序
- 侧轴/交叉轴：默认在垂直方向

![](/img/html/flex-1.png)


### 主轴对齐方式
- justify-content

![](/img/html/flex-justfycontent.png)

### 侧轴对齐方式
- align-items：当前弹性容器内所有弹性盒子的侧轴对齐方式（给弹性容器设置
- align-self：单独控制某个弹性盒子的侧轴对齐方式（给弹性盒子设置

![](/img/html/flex-align.png)

### 修改主轴方向
- flex-direction:column
- 修改为垂直方向

### 弹性伸缩比
- flex:整数
- 调整占父级容器剩余空间的份数

### 弹性盒子换行
- flex-wrap：warp/nowarp

### 行对齐方式
- align-content
- 值更justify一致


---

## XI.定位
- 灵活改变盒子在网页中的位置
  
### 实现
- 定位模式 position
  - relative
    - 不脱标
    - 保持原有显示模式
    - 参照物为自己原来的位置
  - absolute
    - 脱标不占位
    - 参照物先找最近的已经定位的祖先元素，若无则参照浏览器窗口
    - 显示模式特点改变，宽高生效
  - fixed
    - 脱标不占位
    - 不随着内容滚动而滚动 (垃圾广告的定位
    - 参照物浏览器
    - 显示模式特点为
- 边偏移：设置盒子的位置
  - left、right、top、bottom

### 堆叠层级 z-index
- 设置定位元素的层级顺序，改变定位元素的显示顺序
- z-index: 权重 (权重越高层级越高


---

## XII.CSS Sprites
- 一种网页图片应用处理方式，把网页中一些背景图片整合到一张图片文件中，再background-position精确的定位出背景图片的位置
- 优点：减少服务器被请求次数，减轻服务器的压力，提高页面加载速度

**实现**  
- 创建盒子，盒子尺寸与小图尺寸相同
- 设置盒子背景图为精灵图
- 添加background-position属性，改变背景图位置
  - 取小图左上角负坐标，通过移动背景大图来达到只显示小图的效果

---

## XIII.字体图标
- 展示的是图标，本质是字体
- 作用：在网页中添加简单的、颜色单一的小图标

**优点**  
- 灵活性：灵活的修改样式
- 轻量：体积小、渲染快、降低服务器请求次数
- 兼容性
- 使用方便

**实现**  
- 引入字体样式表（iconfont.css
- 标签使用字体图标类名
  - iconfont：字体图标基本样式
  - icon-xxx：图标对应的类名
```html
<span class="iconfont icon-xxx"></span>
```

## XIV.修饰属性

**透明的opacity**  
- 设置元素的透明度，包括背景和内容
- 值：0-1 

**光标类型cursor**  
- 鼠标悬停在元素上时指针的样式

![](./img/html/cursor.png)

**Favicon图标**
- link:favicon

```html
  <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
```


---

## XV.移动web

### 平面转换
- transform
- 为元素添加动态效果，一般与过渡配合使用
- 改变盒子在平面内的形态（位移、旋转、缩放、倾斜
- 多重转换以第一种转换形态的坐标轴为准

**平移**  
```css
transform: translate(X,Y)
```
- value: px/%

**旋转**  

```css
transform: route(旋转角度)
```

**改变转换原点**  

```css
transform-origin: 水平原点位置 垂直远点位置
```

- 取值:
  - 方位 (left\top...
  - px
  - %

**缩放**  
```css
transform: scale(缩放倍数 or X/Y)
```

**倾斜** 
```css
transform: skew(度数)
```

### 渐变
- 渐变是多个颜色逐渐变化的效果，一般用于设置盒子背景

**线性渐变**  

```css
background-image: linear-gradient(
  渐变方向,
  颜色1 终点位置,
  颜色2 终点位置,
  ....
);

```

- 取值：
  - 渐变方向：
    - to 方位
    - 角度
  - 终点位置
    - %

**径向渐变**  

```css
background-image: radial-gradient(
  半径 at 圆心位置,
  颜色1 终点位置,
  颜色2 终点位置,
  ....
);

```

- 半径可以为两条，即椭圆

### 空间转换
```css
transform: translate3d(X,Y,Z)
```

**视距perspective**  
- 指定观察者与z=0平面的距离，为元素添加透视效果（近大远小
- 添加给父级，范围800-1200

```csss
perspective: value
```

### 动画 

**定义**  
- 大括号中写css属性
```css
@keyframes 动画名称 {
  from {}
  to {}
}/* 只能两种状态 */
```

```css
@keyframes 动画名称 {
  0% {}
  10% {}
  ...
  100% {}
}/* 多种状态 %表示动画时长的百分比*/
```

**使用**  
```css
animation: 动画名称 花费时间 速度曲线 延迟时间 重复次数 动画方向 执行完毕状态
```
- 动画名称和花费时间必须存在
- 取值不分先后
- 如果有两个时间值，第一个时间表示动画时长，第二个时间表示延迟时间


---
## XVI.响应式




---