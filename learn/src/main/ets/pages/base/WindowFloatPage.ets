import common from '@ohos.app.ability.common';
import window from '@ohos.window';

@Entry
@Component
struct WindowFloatPage {
  @State lasttime: number = 0

  @State message: string = '悬浮窗'
  @State foldStatus: boolean = false
  @State idleName: string = '收起'
  @State floatWindowWidth: number = 0
  @State offsetX: number = 0
  @State offsetY: number = 0
  @State positionX: number = 0
  @State positionY: number = 0
  @State windowPosition: Position = { x: 0, y: 0 };

  private context = getContext(this) as common.UIAbilityContext;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.All });

  floatWindow: window.Window|undefined

  aboutToAppear(){
    this.eventHubFunc()
    this.floatWindow = window.findWindow("floatWindow")
    this.floatWindowWidth = 1080
    this.panOption.setDistance(1)
  }

  onBackPress(){
    console.log('返回')
  }

  build() {
    Row() {

      Text('X').width(px2vp(140))
        .textAlign(TextAlign.Center)
        .fontColor(Color.Red).onClick(()=>{
        //关闭所依赖的UIAbility
        this.context.terminateSelf()
        //销毁悬浮窗。当不再需要悬浮窗时，可根据具体实现逻辑，使用destroy对其进行销毁。
        this.floatWindow?.destroyWindow((err) => {
          if (err.code) {
            console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
            return;
          }
          console.info('Succeeded in destroying the window.');
        });
      })

      Text(this.idleName)
        .width(px2vp(140))
        .height('100%')
        .fontSize(18)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .backgroundColor(Color.Gray)
        .onClick(()=>{
          this.foldStatus = !this.foldStatus

          if(this.foldStatus){
            this.idleName = "展开"
            this.floatWindowWidth = 280
          } else {
            this.idleName = "收起"
            this.floatWindowWidth = 1080
          }
        })

      Divider().vertical(true).color(Color.Red)

      if(!this.foldStatus) {
        Text(this.message)
          .width(px2vp(800))
          .fontSize(18)
          .fontColor(Color.White)
          .padding('12vp')
      }

    }
    .width(px2vp(this.floatWindowWidth))
    .height(px2vp(150))
    .borderRadius('12vp')
    .backgroundColor(Color.Green)
    .gesture(
      // 绑定PanGesture事件，监听拖拽动作
      PanGesture(this.panOption)
        .onActionStart((event: GestureEvent) => {
          console.info('Pan start');
        })
          // 发生拖拽时，获取到触摸点的位置，并将位置信息传递给windowPosition
        .onActionUpdate((event: GestureEvent) => {

          console.log(event.offsetX +' ' + event.offsetY)

          this.offsetX = this.positionX + event.offsetX
          this.offsetY = this.positionY + event.offsetY

          this.floatWindow?.moveWindowTo(vp2px(this.offsetX), vp2px(this.offsetY));

        })
        .onActionEnd(() => {
          this.positionX = this.offsetX
          this.positionY = this.offsetY
          console.info('Pan end');
        })
    )

  }

  eventHubFunc() {
    this.context.eventHub.on('info', (data:string) => {
      this.message = data
    });
  }

}
