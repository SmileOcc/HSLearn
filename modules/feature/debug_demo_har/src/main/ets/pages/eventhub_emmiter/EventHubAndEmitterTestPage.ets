import { emitter } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';

@Builder
export function TestEventHubEmitterBuilder() {

  NavDestination() {
    EventHubAndEmitterTestPage()
  }
}

@Entry
@Component
struct EventHubAndEmitterTestPage {

  // --------------- EventHub
  private context = getContext(this) as common.UIAbilityContext;
  private eventHub: common.EventHub | null = null;
  private EVENT_TAG: string = "TEST";

  private emitByEventHub(){
    this.eventHub = this.context.eventHub;
    this.eventHub.emit(this.EVENT_TAG, "测试数据EventHub");
  }

  /**
   * EventHub事件回调
   */
  callbackByEventHub = (content: string)=>{
    promptAction.showToast({
      message: JSON.stringify(content)
    });
  }

  private registerByEventHub = ()=>{
    this.eventHub?.on(this.EVENT_TAG, this.callbackByEventHub);
  }

  private unRegisterByEventHub = ()=>{
    this.eventHub?.off(this.EVENT_TAG, this.callbackByEventHub);
  }

  // --------------- Emitter
  private eventId: number = 1;
  private event: emitter.InnerEvent = {
    eventId: this.eventId,
    priority: emitter.EventPriority.LOW   // 定义一个eventId为1的事件，事件优先级为Low
  };

  private emitByEmitter(){
    let eventData: emitter.EventData = {
      data: {
        content: '测试数据',
        id: 1,
        isEmpty: false
      }
    };

    // 发送eventId为1的事件，事件内容为eventData
    emitter.emit(this.event, eventData);
  }

  private callback = (eventData: emitter.EventData): void => {
    promptAction.showToast({
      message: JSON.stringify(eventData)
    });
  };

  private registerByEmitter(){
    emitter.on(this.event, this.callback);
    // 监听触发后，自动消除监听。不需要手动off
    emitter.once(this.event, this.callback)
  }

  private unRegisterByEmitter(){
    emitter.off(this.event.eventId, this.callback);
  }

  // ---------------点击事件处理

  onEmitEvent = ()=>{
    this.emitByEmitter();
    this.emitByEventHub();
  }

  onRegisterEvent = ()=>{
    this.registerByEmitter();
    this.registerByEventHub();
  }

  onUnRegisterEvent = ()=>{
    this.unRegisterByEmitter();
    this.unRegisterByEventHub();

  }

  /**
   * 统一样式封装
   */
  @Styles ButtonStyle(){
    .width(px2vp(350))
    .height(px2vp(200))
    .margin({ top: px2vp(66) })
  }

  build() {
    Column(){
      Button("发送事件")
        .ButtonStyle()
        .onClick(this.onEmitEvent)

      Button("监听事件")
        .ButtonStyle()
        .onClick(this.onRegisterEvent)

      Button("取消事件")
        .ButtonStyle()
        .onClick(this.onUnRegisterEvent)

    }.size({
      width: "100%",
      height: "100%"
    })
  }
}
