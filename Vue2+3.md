## I.最好的文档
[https://cn.vuejs.org/guide/introduction.html](https://cn.vuejs.org/guide/introduction.html)


## II.基础语法


**Vue实例**  
```html
<div id="root">
  <h1>hello {{name}}</h1>
  <a v-bind:href="url">123</a>
  <input type="text" v-module:value="val">
</div>
<!-- 针对标签中的变量采用v-bind进行绑定
v-module用于对表单元素进行双向绑定 -->
<script>
  Vue.config.productionTip = false;
  const v =new Vue({
    el:'#root',
    data:{
      name:'118',
      url:'https://www.momoyouta.icu',
      val:'1'
    }
    //data第二种写法
    /*
    data:function(){
      return name:''
    }
    */

  })
  /* v.$mount('#root') *///容器绑定第二种方法
</script>
```


## III.数据代理
- 通过一个对象代理对另一个对象中属性的操作
- 通过`Object.defineProperty()`实现代理
```js
  let obj={x:100}//被代理对象
  let obj2={y:200}//代理对象

  Object.defineProperty(obj2,'x',{
    get(){//读取obj2.x时返obj.x
      return obj.x
    },
    set(value){//修改obj2.x时修改obj.x
      obj.x=value
    }
  })
```

### Vue中数据代理
- 通过defineProperty方法将Vue对象中的`_data`属性映射到Vue对象中相对应的属性
- 如下例子访问修改`vm._data.a`就可以通过访问修改`vm.a`实现
- 只有`data`中才会进行数据劫持、数据代理
```js
let vm = Vue({
  el:'xxx',
  data:{
    a:1,
    b:2
  }
})
```

- 因为data自身使用`defineproperty`的`set\get`方法会进入无限递归，所有Vue中会有一个代理对象用于监视data属性的变化，即用于代理data
- 最终将该对象其赋予给_data，实现vue对数据的检测、响应
- 因为数据代理的存在，当想在之后再添加属性，不能直接`vm.data.c=xxx`，需要调用vue的api添加并进行数据代理
  ```js
  Vue.set(target,key,val)
  //or
  vm.$set(target,key,val)
  //需注意set只能给data中的对象添加属性，_data、vm不能作为target  
  ```

  - 在vue中data的数组可以用set来修改或者用Array能修改自身的方法修改数据，Vue对这下方法进行了数据代理相关的处理，若直接`arr[0]=xx`修改将不会响应

## IV.事件处理
- `v-on:`当事件触发时调用vue函数
- 简写为`@`
```html
<div id="root">
  <h1>hello {{name}}</h1>
  <!-- <button v-on:click="showInfo">  -->
  <!-- 不传参 -->
  <button @click="showInfo"> 点我提示信</button>
  <!-- 传参，且用$event保留事件对象 -->
  <button @click="showInfo2($event,66)"> 点我提示信2</button>
</div>
<script>
  Vue.config.productionTip = false;
  const v =new Vue({
    el:'#root',
    data:{
      name:'118',
    },
    methods:{
      showInfo(event){
        console.log("helloo");
      }
      showInfo2(event,number){
        console.log(number);
      }
    }

  })
</script>
```

### 事件修饰符

- `<button @click.prevent="showInfo"> 点我提示信</button>`  
  `.prevent`可以阻止默认事件

|修饰符|作用|
|-|-|
|prevent|阻止默认事件|
|stop|阻止事件冒泡|
|once|事件只触发一次|
|capture|使用事件的捕获模式|
|self|只有eevent.target是当前操作的元素时才触发事件|
|passive|事件的默认行为立即执行，无需等待事件回调执行完毕|

### 键盘事件

- `@keyup.enter` 按下弹起后才触发
  - 对于`ctrl、shift、alt、meta`需要同时按住当前键再按下其他键后释放,如`@keyup.ctrl.s`需要按ctrl+s才能触发
- `@keydown` 按下即触发事件
**Vue中常用别名**  
- enter
- delete
- esc
- space
- table
- up\dowm\left\right

**自定义**  
1. 调用事件对象`e.ketCode`指定按键
2. `Vue.config.keyCodes.自定义键名 = 键码`,自定义按键别名

## V.计算属性

- Vue对象中的computed属性

```html
<div id="root">
  姓<input type="text" v-model="firstName">
  名<input type="text" v-model="lastName"><br>
  <span>{{fullName}}</span> <br>
  <span>{{fullName}}</span> 
  <!-- 只会调用一次get，调用一次后会存入缓存 -->
  <!-- 当依赖的数据改变时才会再次调用get -->
</div>
<script>
  Vue.config.productionTip = false;
  const v =new Vue({
    el:'#root',
    data:{
      firstName:'z',
      lastName:'s'
    },
    computed:{
      fullName:{
        //同defineProperty
        get(){
          return this.firstName+'-'+this.lastName
        }
        set(value){//一般情况set不需要，因为结果一般情况下只读
          const arr=value.split('-')
          this.firstName=arr[0]
          this.lastName=arr[1]
        }
      }
      //简写，当结果为只读时使用
      /* fuuName(){
        return this.firstName+'-'+this.lastName
      } */
    }

  })
</script>
```

## VI.监视属性
- `watch`

```js
new Vue({
  el:..,
  data:{
    a:1,
    obj:{
      a:1,
      b:2,
    }
  }
  watch:{
    a:{
      immediate:true, //初始化时让handler调用一下
      handler(newValue,oldValue){//当a发生改变时调用
        console.log('a被修改了',newValue,oldValue)
      }

    }
    /**
     * 简写,但不能写配置项
     * a(){
     * ...
     * }
     */
    obj:{
      deep:true//////////////////////vue的watch默认只监测一层，若要检测多层，需开启深度监测
      handler(){
        ..
      }
    }
  }
})
/*另一种写法
vm.$watch('a',{
  immediate:true, //初始化时让handler调用一下
  handler(newValue,oldValue){//当a发生改变时调用
    console.log('a被修改了',newValue,oldValue)
  }
})
*/ 
```

## VII.绑定样式

- 变化的样式使用`v-bind`
```html
<div class="basic" :class="a"></div>
<div class="basic" :class="classArr"></div>
<div class="basic" :class="classObj"></div>
<script>
  new Vue({
    el:'root',
    data:{
      //字符串写法
      a:'css',
      //数组写法
      classArr:['a1','a2','a3'],
      //对象写法,对于内联style也建议使用对象写法
      calssObj:{
        a1:false,
        a2:false,
        a3:false
      }

    }
  })
</script>
```

## VIII.条件渲染

**v-show**  
- 控制元素的显示，实际是修改该元素的display属性
```html
<div id="root">
  姓<input type="text" v-model="firstName" v-show="false">
</div>
```

**v-if/v-else-if/v-else** 
- 使用方法同v-show，但会将dom元素直接删除而非修改display，
- 意味着性能开销更大


使用template标签可以在不破坏原有结构的情况下一个if控制多个元素
```html
<<template v-if="....">
  ...
</template>>
```

## IX.列表渲染
- `v-for`
- 类似js的for of语句
- 每个元素需要有个key提供给vue服务于diff算法，key的重要性如同数据库中的主键
```html
<div id="root">
  <ul>
    <!-- 遍历数组 -->
    <li v-for="(p,index) in persons" :key="p.id/index..."></li>
    <!-- 遍历对象 -->
    <li v-for="(value,key) of person" :key="..."></li>
  </ul>
</div>
```

## X.自定义指令

- 自定义`v-xxx`类指令


### 函数式

- 调用时机:
  - 指令与元素成功绑定时
  - 指令所用到的数据更新时
```html
<body>
  <div id="root">
    <h2>当前n大小：<span v-text="n"></span></h2>
    <h2>放大10倍后的n：<span v-big="n"></span></h2>
    <button @click="n++">点击n+1</button>
  </div>
  <script>
    Vue.config.productionTip = false;
    const vm =new Vue({
      el:'#root',
      data:{
        n:1,
      },
      directives:{
        big(domele,binding){
          domele.innerText=binding.value*10;
          
        }
      }
    })
  </script>
</body>
```

### 对象式

- 实际上函数式就是对象式的简写
- 函数式省略了inserted

```html
<body>
  <div id="root">
    <h2>当前n大小：<span v-text="n"></span></h2>
    <h2>放大10倍后的n：<span v-big="n"></span></h2>
    <button @click="n++">点击n+1</button>
    <input type="text" v-fbind="n">
  </div>
  <script>
    Vue.config.productionTip = false;
    const vm =new Vue({
      el:'#root',
      data:{
        n:1,
      },
      directives:{
        big(domele,binding){
          domele.innerText=binding.value*10;
          
        },
        fbind:{
          //元素绑定时执行
          bind(ele,binding){
            ele.value =binding.value
          },
          //指令所在元素被插入页面时执行
          inserted(ele,binding){
            ele.focus()
          },
          //指令所在模板被重新解析时执行
          update(ele,binding){
            ele.value =binding.value
          }
        }
      }
    })
  </script>
</body>
```

## XI.生命周期
- 又名：生命周期回调函数、生命周期函数、生命周期钩子
- Vue在关键时刻帮我们调用的一些特殊名称的函数
- 生命周期函数的名字不可更改，但函数的具体内容是程序员根据需求编写的
- 生命周期函数中的this指向是vm或组件实例对象

![](https://v2.cn.vuejs.org/images/lifecycle.png)

### beforeCreate
- 在数据代理、数据检测前，无法通过vm访问data中的数据和methods的方法

### created
- 可以通过vm访问data的数据和methods的方法

### beforeMount
- 此时显示的是未经Vue编译的DOM结构

### mounted
- 页面呈现的是经过Vue编译的DOM
- 对DOM的操作均有效
- 至此初始化过程结束，一般在这开启定时器、发送网络请求、订阅消息等初始化操作

### beforeDestroy
- 此时vm所有内容均可用，一般在此阶段关闭定时器、取消订阅消息等收尾操作


## XII.组件

### 基本使用

**创建组件**  
- 配置项与new Vue差不多
- 不需要配置el，因为最终所有的组件都要被一个vm管理，由vm决定服务于谁
- data需以函数式配置
```js
const school = Vue.extend({
  template:`
    html..
  `,
  data(){
    return {
      a:...,
      b:...
    }
    ...
  }
})
```

**注册组件**  
```js
new Vue({
  el:'#root'
  components:{
    组件名:a
  }
})

```

- 全局注册：`Vue.component('组件名',组件)`


**组件嵌套**  
```js
const student = Vue.extend({
  template:``,
  data(){
    ..
  }
})
const school = Vue.extend({
  template:`
    html..
  `,
  data(){
    return {
      a:...,
      b:...
    }
    ...
  }
  components:{
    student
  }
})
```

- Vue组件实质是VueComponent的一个实例对象
- 从原型链来看，VueComponent的原型对象的__proto__指向Vue的原型对象  
  这意味着组件实例对象可以使用vue的原型方法


### props属性
- 用于给组件内部传送参数，类似函数中的形参
- 传入的值无法更改，props的优先级比data高
```html
<student name="xxx" ...> </student>
```

```js
export default {
  name:'student',
  data(){
  return {
    ...
  },
  props;['name',...]
  /*接收同时对数据类型进行限制
   props:{
    name:String,
    ..
  } */

  //更多配置
  /* props:{
    name:{
      type:String,
      required:true //是否必要
      //default:默认值
    }
  } */
 } 
}
```

### mixin
- vue相同的配置可以单独以对象的形式写在js文件中，通过暴露给其他组件引入
- 在组件中配置mixin属性即可引入
- mixin使得配置可以复用

```js
export const mixin = {
  methods:{
    show(){
      ....
    }
  }
}
```

```js
import {mixin} from "url";
export default {
  name:'student',
  data(){
  return {
    ...
  },
  mixins:['mixin']
 } 
}
```
### ref属性
- Vue提供了获取DOM元素的方法
- 给元素添加ref属性后，在VC中可以通过`this.$refs.ref值`获取DOM元素
- 对于vc标签，ref获取的是vc实例对象

### 自定义事件
- 对于原生事件绑定到组件元素上需要添加`.native`修饰

**绑定与触发**  
- 绑定方法：
  - 1.`<组件 v-on:自定义事件名="function">`
  - 2.借用`refs`获取vc实例对象，通过`this.$refs.refname.$on()`来为vc对象绑定事件
- 触发：在vc的methods中添加一个函数通过`this.$emit(自定义事件名)`来触发事件
- 这也意味着自定义事件只能是父与子之间绑定

**解绑**  
- 在vc中调用`$off(['事件名',...])`

  ## XIII.CLI脚手架

[官方文档](https://cli.vuejs.org/zh/)

**scoped**
- 为组件样式标签添加`scoped`可以解决不同组件同名元素样式冲突问题
- 原理是为元素自动添加了自定义标签来区别不同组件中的标签


## XIV.全局事件总线
- 通过一个中间件X，将事件绑定到X上，回调函数存在需要进行数据请求的组件中，其他组件通过X调用`$emit`触发事件来实现组件间的数据传输
- 对于X可以添加至Vue的原型对象上，使得VC能通过原型链找到中间件X;
- 安装X可以在vue的beforeCreate()钩子

## XV.消息订阅与发布