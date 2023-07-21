## I.语义标签

指标签的含义，在合适的地方给出合理的标签使得页面结构更清晰

#### 常用标签
1. < h1 > 标题标签,数字代表标题层次
2. < p > 段落标签,给文本分段
3. < br / > 换行标签 **(单标签)**

## II.文本标签

突出文本重要性

#### 常用标签
1. < strong > or < b > 加粗文字
2. < em > or < i > 文字倾斜
3. < del > or < s > 删除线标签
4. < ins > or < u > 下划线标签
---
## III.布局标签

用于布局

#### 常用标签
1. < div > 独占一行
2. < span > 仅占内容大小

---
## IV.图像标签

用于添加图片

#### < img >
< img src="URL"/>
**属性**
格式key="value"
1. src 图片路径
2. alt 图像不能显示时表示的文字
3. title 鼠标放到图像上显示的文字
4. width 图像宽度
5. height 图像高度
6. border 边框粗细

#### 相对路径
相对于图片文件的位置
1. 同级路径，直接写图像名即可，例如：<br />src="im.jpg"
2. 下一级路径,需接文件夹名/，例如：<br />src="img/im.jpg"
3. 上一级路径,需接../回到上一级文件夹中，例如：<br />src="../im2.jpg"

#### 绝对路径
1. 本地文件 src="C:\web\img\im.jpg"
2. 网络地址 src直接接图片连接
---
## V.超链接

用< a >标签定义超链接，作用为从一个页面链接到另一个页面

#### 语法格式
< a href="跳转目标" target="目标窗口弹出方式" > 文本/图像 < /a >
target 值:默认_self 当前窗口打开页面 _blank 创新一个新窗口打开页面
1. 外部链接：href值为网页连接
2. 内部链接：href值为网页文件
3. 空链接：用#表示
4. 下载链接：href值为文件
5. 锚点链接：点击跳转至页面某个位置
   - href值为#名字
   - 目标位置标签添加属性id="名字"
   - 例:< a href="#t" > xxx < /a >
    < h3 id ="t"> xxx介绍< /h3 >
---
<!-- zwr防伪 -->
## VI.特殊字符

![](/img/html/spchar.png)

---
## VII.表格标签
主要用于展示数据

#### 基本语法
```html
<table>
    <tr>
        <td>单元格文字</td>
    </tr>
</table>
```
1. < table > 定义表格的标签
2. < tr > 定义表格的行
3. < td > 定义行中的单元格
4. < th > 表头标签(文本会加粗并且居中)

#### 表格结构标签
< thead >表示表头区域，< tbody >表示表格主体区域
```html
<table>
    <thead>
        <tr>
            <th>xxx</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>xx</td>
        </tr>
    </tbody>
</table>
```

#### 合并单元格
作为属性写到< td >中例如: < td rowspan="1" >< /td >
合并后多余的单元格需手动删除(也可以一开始就不写)
1. rowspan="合并单元格个数" 跨行，从当前向下
2. colspan="合并单元格个数" 跨列，从当前向右
---
## VIII.列表标签
用于布局

#### 无序列表
< ul >表示无序列表,列表项使用< li >定义

**语法格式**
```html
<ul>
    <li>列表项1</li>
    ...
</ul>
```
#### 有序列表
< ol >表示
语法同无序列表
<!-- zwr防伪 -->
#### 自定义列表
常用于对术语或名词进行解释描述，定义列表的列表项前没有任何项目符号
< dl >定义列表,< dt >表示名词 < dd >对名次进行解释

```html
<dl>
    <dt>关注我们</dt>
    <dd>QQ</dd>
    <dd>微信</dd>
</dl>
```
---
## IX.表单标签
用于收集用户信息
完整的表单通常由表单域、表单控件、提示信息3个部分构成

#### 表单域
包含表单控件的区域,用< form >标签定义
```html
<form action="url地址" method=" 提交方式" name="表单域名称">
    各种控件
</form>
```
<del>表格知识应用</del>
<table border="1" width="500" >
    <thead>
        <tr>
            <th>属性</th>
            <th>属性值</th>
            <th>作用</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>action</td>
            <td>url地址</td>
            <td>用于指定接收并处理表单数据的服务器程序的url地址</td>
        </tr>
        <tr>
            <td>method</td>
            <td>get/post</td>
            <td>用于设置表单的提交方式</td>
        </tr>
        <tr>
            <td>name</td>
            <td>名字</td>
            <td>用于指定表单名称</td>
        </tr>
    </tbody>
</table>

#### 表单控件

**< input >**
输入控件(**单标签**)，< input type="value" >
input的value:
![](/img/html/input_value.png)

type的value:
![](/img/html/input_type_value.png)

<!-- zwr防伪 -->
**< lable >**
为input元素定义标注，档点击lable文本时，会自动将光标转到对应表单控件上
```html
<lable for="txt">用户名:</lable><input type="text" id="txt">
```

**< select >**
下拉列表，节约空间
![](/img/html/select.png)
```html
<select>
    <option>xxx</option>
    <option>xxx2</option>
    ...
</select>
```
1. 在option中添加属性selected="selected"表示默认选中

**< textarea >**
文本域，可以进行多行文本输入
```html
<textarea>
    xxx(默认初始文本)
</textarea>
```

---

