# HSLearn 001

// 允许@ObjectLink装饰的数据属性赋值
this.objLink.a= ...
// 不允许@ObjectLink装饰的数据自身赋值
this.objLink= ...

@Observed装饰数据model
数据支持刷新 需要用new xxx创建

使用了@Observed和@ObjectLink，修改嵌套对象的属性，UI还是不刷新，常见的问题有以下三种形式：
1.多级嵌套，嵌套对象的类并没有添加@Observed进行监听
2.多级嵌套，嵌套对象的View组件没有抽离出来，添加@ObjectLink进行该级对象的监听绑定
3.嵌套对象，并没有new出来创建，直接赋值没有创建对象的过程，无法激活Observed监听


一、EventHub是什么？
移动应用开发的同学应该比较了解EventHub，类似于EventBus。标准的事件广播通知，订阅，取消订阅的处理。EventHub模块提供了事件中心，提供订阅、取消订阅、触发事件的能力。

类似的框架工具有很多，例如MQTT。使用起来也超级简单，从介绍上就能大体了解使用方式，见名知意的一种快捷工具。通过一个事件ID即TAG作为唯一的key，进行事件广播通知和订阅。

在ArkUI框架中，EventHub通过单例对象的形式提供，因为放在上下文里。所以每个UIAbility对应一个EventHub。不同的UIAbility的EventHub是不同步的。


在page界面或者组件中，通过UIcontext强转为UIAbilityContext获取：
let context = getContext(this) as common.UIAbilityContext;
let eventhub = context.eventHub;

获得到EventHub单例对象后，就可以调用emit发送事件，on监听事件，off取消监听事件。进行事件广播的使用.

// TAG作为事件的id为字符串类型
private EVENT_TAG: string = "TEST";

/**
* EventHub事件回调
  */
  callbackByEventHub = (content: string)=>{
  promptAction.showToast({
  message: JSON.stringify(content)
  });
  }

this.eventHub?.on(this.EVENT_TAG, this.callbackByEventHub); this.eventHub?.off(this.EVENT_TAG, this.callbackByEventHub);
this.eventHub?.off(this.EVENT_TAG);// 第二个参数不传，则代表EVENT_TAG下的所有注册回调都清空


二、Emitter是什么？
类似于EventHub的使用，只是内部封装了事件队列和分发的机制。多了事件id和优先级的概念。并且Emitter也可以在不同线程内调用。

Emitter区别于上文中的EventHub的事件ID，定义了一层对象进行约束。除了事件id，还需要设置事件级别。

private event: emitter.InnerEvent = {
eventId: this.eventId,
priority: emitter.EventPriority.LOW   // 定义一个eventId为1的事件，事件优先级为Low
};

和EventHub不同的是，事件广播的内容，也进行了约束。 发送事件时传递的数据，支持数据类型包括Array、ArrayBuffer、Boolean、DataView、Date、Error、Map、Number、Object、Primitive（除了symbol）、RegExp、Set、String、TypedArray，数据大小最大为16M。

data是key val形式的对象，可以自己定义里面的key和val。

    let eventData: emitter.EventData = {
      data: {
        content: '测试数据',
        id: 1,
        isEmpty: false
      }
    };

事件的广播发送，订阅和取消订阅与EventHub区别不大。只是多了once一次性监听而已。

private callback = (eventData: emitter.EventData): void => {

};

    emitter.emit(this.event, eventData);
    emitter.once(this.event, this.callback)
    emitter.off(this.event.eventId, this.callback);


三、EventHub和Emitter的使用场景与区别
EventHub是线程内使用的时间广播工具，Emitter是线程间通信使用的工具
EventHub的使用更简单，属于轻量级的广播工具，主要用于UIAbility和page之间，page和组件之间，组件和组件之间，UI和VM之间的通信，传递的数据内容形式多变且方便（…args: Object[]）。Emitter属于重量级的广播工具，封装了优先级和队列的逻辑。传递的数据内容，必须有包裹成进行约束（emitter.EventData）
Emitter监听设置，在on基础上，额外提供了once一次性监听的API。触发之后不需要再手动off取消监听。EventHub则没有。

混淆自定义选项名称
功能简述
混淆选项
-disable-obfuscation 关闭混淆
-enable-property-obfuscation 属性混淆
-enable-toplevel-obfuscation 顶层作用域名称混淆
-enable-filename-obfuscation 文件名混淆
-enable-export-obfuscation export导出名称与属性混淆
-compact 代码压缩
-remove-log 删除console*方法
-print-namecache filepath 指定路径输出namecachejson文件及内容
-apply-namecache filepath 复用指定的名称缓存文件
-remove-comments 删除注释
保留选项
-keep-property-name 保留属性白名单
-keep-global-name 保留顶层作用域名称白名单
-keep-file-name 保留文件名白名单
-keep-comments 保留某个类的JsDoc注释
-keep-dts filepath 读取指定dts文件中的名称作白名单


///// =============== NodeController 刷新，子组件每次都会触发 aboutToAppear （解决在aboutToAppear处理数据请求 一些异常) =========//

//NodeController更新数据，不一定需要@state, 关联数据，需要更新的时候触发rebuild()、或makeNode即可


自定义弹框OpenCustomDialog、CustomDialog与DialogHub的区别详解
CustomDialog 因为CustomDialogController强耦合于UI，
需要在UI界面或者自定义View中使用CustomDialogController控制弹框显示隐藏。
无法在纯逻辑类中处理弹框时机的显示。
（这种情况下只能想办法发送通知给UI，UI再处理回调显示，处理起来麻烦。）
=====致命的问题是，弹框内的UI无法动态刷新。需要重新创建渲染======


对标CustomDialog 的CustomDialogController。官方通过将弹框对象实例，放到上下文中，实现在纯逻辑类中也可以调用弹框的显示和隐藏。

将@CustomDialog弹框布局内容，放到ComponentContent节点对象中，实现弹框UI的解耦。

###
使用Function.bind()所引发的问题
问题：组件内成员方法 bind() 作为回调函数保存了引用，出现了调用失效、内存泄漏等问题；
1、性能问题：每次渲染都创建新函数；
2、内存泄漏风险：
Button('Risk')
.onClick(this.handler.handleEvent.bind(this.handler)) // ❌ 可能内存泄漏
3、调试困难：
.onChange((value: string) => {
// ❌ 调试时难以追踪
this.processInput.bind(this)(value);
})
4、类型安全问题：
class MyService implements ApiService {
private baseUrl: string = 'https://api.example.com';

async fetchData(id: number) {
// bind 可能掩盖类型错误
const response = await fetch(`${this.baseUrl}/data/${id}`);
return response.json();
}
}

Button('Fetch')
// ❌ bind 可能隐藏类型不匹配
.onClick(this.service.fetchData.bind(this.service, 'string')) // 应该报错但可能不会

解决思路：
解决方案：

避免使用 func().bind(this) 的情况：
在渲染方法中频繁调用的地方
需要严格类型检查的场景
需要良好调试体验的情况
关注内存使用的性能敏感应用
推荐使用：
箭头函数 () => func()
类属性箭头函数 func = () => {}
提前绑定（在构造函数或初始化时）
记忆化处理对于重复使用的回调

1、使用箭头函数：
.onClick(() => this.increment()) // ✅ 推荐
2、使用类属性箭头函数：
// 类属性箭头函数
handleClick = (): void => {
this.count++;
}
.onClick(this.handleClick) // ✅ 直接引用
3、在构造函数中提前绑定：
increment:()=>void
constructor() {
// 提前绑定，避免重复创建
this.increment = this.incrementAction.bind(this);
}

incrementAction() {
this.count++;
}
--
private handler = new MyHandler();
build() {
Column() {
Button('Pre-bound')
.onClick(this.handler.increment) // ✅ 已提前绑定
}
}

4、使用 useMemo 模式（如果适用）：
// 模拟 useMemo 行为
private memoizedHandlers = new Map<string, () => void>();

getHandler(key: string): () => void {
if (!this.memoizedHandlers.has(key)) {
this.memoizedHandlers.set(key, () => {
this.count++;
});
}
return this.memoizedHandlers.get(key)!;
}

build() {
Column() {
Button('Memoized')
.onClick(this.getHandler('increment')) // ✅ 记忆化处理
}
}