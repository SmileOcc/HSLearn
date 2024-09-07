import { EmitterData, MYEmitterType, MyEmitterUtil } from '../../../../../../modules/common_har/src/main/ets/utils/MyEmitterUtil';
import RouterUtils from '../../../../../../modules/common_har/src/main/ets/utils/RouterUtils';

@Entry
@Component
struct EmitterBasePage {
  @State message: string = 'Hello World';

  myEmitterUtil = new MyEmitterUtil(MYEmitterType.one)
  aboutToAppear() {
    this.myEmitterUtil.onEmitter((eventData: EmitterData) => {
      console.info('父组件监听结果: ', JSON.stringify(eventData));
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

        Button('child')
          .onClick(()=>{
            RouterUtils.jumpRouter('pages/base/EmitterOneChildPage')
          })
        Button('向子组件发送事件')
          .onClick(()=>{
            MyEmitterUtil.emitEvent(MYEmitterType.two,MyEmitterUtil.UPDATE_DETAIL, "携带的测试数据");
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}