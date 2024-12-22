import { hsLog } from '@learn/logger_har';
import { EmitterData, MYEmitterType, MyEmitterUtil } from '../../../../../../modules/common_har/src/main/ets/utils/MyEmitterUtil';

@Entry
@Component
struct EmitterOneChildPage {
  @State message: string = 'emitter child';

  myEmitterUtil = new MyEmitterUtil(MYEmitterType.two)

  aboutToAppear() {

    this.myEmitterUtil.onEmitter((eventData: EmitterData) => {
      hsLog.i('子组件监听结果: ', JSON.stringify(eventData));
      // 判断事件类型并执行相应操作...
      this.message = eventData.flag + eventData.data
    });
  }

  aboutToDisappear() {
    this.myEmitterUtil.offEmitter();
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('向父组件发送事件')
          .onClick(()=>{
            // 向父组件发送事件
            MyEmitterUtil.emitEvent(MYEmitterType.one,MyEmitterUtil.UPDATE_LIST, "测试");
          })

        Button('向父组件发送事件')
          .onClick(()=>{
            // 向父组件发送事件
            MyEmitterUtil.emitEvent(MYEmitterType.one,MyEmitterUtil.UPDATE_LIST_2, "测试2");
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}