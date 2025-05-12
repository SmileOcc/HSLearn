import { YWConstants } from "@learn/constants_har"
import { hsLog } from "@learn/logger_har"

@Builder
export function TestScrollTwoGestureBuilder() {
  NavDestination(){
    ScrollTwoGesturePage()
  }

}


const TAG = "ScrollTwoGesturePage"
@Entry
@Component
export struct ScrollTwoGesturePage {
  scroller: Scroller = new Scroller()
  scroller2: Scroller = new Scroller()
  scroller3: Scroller = new Scroller()
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  private childRecognizer: GestureRecognizer = new GestureRecognizer()
  private currentRecognizer: GestureRecognizer = new GestureRecognizer()
  private lastOffset: number = 0

  private startOffSetY = 0
  private currentOffSetY = 0
  @State isHideHeader: boolean = false

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column(){
        if (!this.isHideHeader) {
          Row(){

          }
          .width('100%')
          .height(60)
          .backgroundColor(YWConstants.RandomColor())
        }


        Scroll(this.scroller) { // 外部滚动容器
          Column() {
            Stack(){
              Scroll(this.scroller3) {
                Row(){
                  Text("A")
                    .width(90)
                    .height(60)
                    .backgroundColor(YWConstants.RandomColor())
                  Text("b")
                    .width(90)
                    .height(60)
                    .backgroundColor(YWConstants.RandomColor())
                  Text("C")
                    .width(90)
                    .height(60)
                    .backgroundColor(YWConstants.RandomColor())
                  Text("D")
                    .width(90)
                    .height(60)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(YWConstants.RandomColor())
                  Text("E")
                    .width(90)
                    .height(60)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(YWConstants.RandomColor())
                  Text("F")
                    .width(90)
                    .height(60)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(YWConstants.RandomColor())
                }
              }
              .width('100%')
              .height(60)
              .padding({right:120})
              .scrollable(ScrollDirection.Horizontal) // 滚动方向纵向
              Row(){
                Image($r('app.media.right_head'))// .margin(2)
                  .height(30)
                  .width(30)
              }
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .height(60)
              .width(120)
              .position({right:0})
              .linearGradient({
                direction: GradientDirection.Right, // 渐变方向
                repeating: false, // 渐变颜色是否重复
                // colors:[[0x000000,0.5]]
                // colors: [[0x000000, 0.0], ['rgba(0,0,0,0)', 0.1], ['rgba(0,0,0,0)', 0.9], [0x000000, 1.0]]

                colors: [[0x50000000, 0.0], [0x000000, 0.2], [0x000000, 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
              })
            }
            .height(60)
            .width('100%')



            Text("Scroll Area")
              .width('90%')
              .height(150)
              .backgroundColor(0xFFFFFF)
              .borderRadius(15)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .margin({ top: 10 })

            Scroll(this.scroller2) { // 内部滚动容器
              Column() {
                Text("Scroll Area2")
                  .width('90%')
                  .height(150)
                  .backgroundColor(0xFFFFFF)
                  .borderRadius(15)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .margin({ top: 10 })
                Column() {
                  ForEach(this.arr, (item: number) => {
                    Text(item.toString())
                      .width('90%')
                      .height(150)
                      .backgroundColor(0xFFFFFF)
                      .borderRadius(15)
                      .fontSize(16)
                      .textAlign(TextAlign.Center)
                      .margin({ top: 10 })
                  }, (item: string) => item)
                }.width('100%')
              }
            }
            .id("inner")
            .width('100%')
            .height(800)
            .backgroundColor(YWConstants.RandomColor())
          }.width('100%')
        }
        .backgroundColor(YWConstants.RandomColor())
        .id("outer")
        .height('100%')
        .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
        .scrollBar(BarState.On) // 滚动条常驻显示
        .scrollBarColor(Color.Gray) // 滚动条颜色
        .scrollBarWidth(10) // 滚动条宽度
        .edgeEffect(EdgeEffect.None)
        .onWillScroll((xOffset, yOffset,scrollState,scrollSource)=>{
          // this.startOffSetY = yOffset
          // //要取currentOffset
          // const currentOffsetY = this.scroller.currentOffset().yOffset
          // this.startOffSetY = currentOffsetY
          // hsLog.d(TAG,"---滚动总是触发，无语了,这个不靠谱 onWillScroll yOffset: " + currentOffsetY  + " == " + yOffset)

        })
        .onScrollStart(()=>{
          const currentOffsetY = this.scroller.currentOffset().yOffset
          this.startOffSetY = currentOffsetY
          hsLog.d(TAG,"---onScrollStart yOffset: " + currentOffsetY)
        })
        .onScrollStop(()=>{
          const currentOffsetY = this.scroller.currentOffset().yOffset
          hsLog.d(TAG,"---onScrollStop yOffset: " + currentOffsetY)
        })
        .onDidScroll((xOffset, yOffset,scrollState)=>{
          if (scrollState == ScrollState.Scroll) {
            const currentOffsetY = this.scroller.currentOffset().yOffset
            let isUp = false
            if (currentOffsetY > this.currentOffSetY) {
              isUp = true
            }

            hsLog.d(TAG,`===== move: ${currentOffsetY} - ${this.startOffSetY} = ${currentOffsetY - this.startOffSetY}`)
            if (currentOffsetY - this.startOffSetY > 50) {

              animateTo({
                duration: 500,
                curve: Curve.Friction,
                onFinish: () => {
                }
              }, () => {
                this.isHideHeader = true
              })

              // this.isHideHeader = true
              hsLog.d(TAG,`===== isHide:  ${currentOffsetY} - ${this.startOffSetY} = ${currentOffsetY - this.startOffSetY}`)
            } else if (currentOffsetY == 0) {
              // this.isHideHeader = false
              animateTo({
                duration: 500,
                curve: Curve.Friction,
                onFinish: () => {
                }
              }, () => {
                this.isHideHeader = false
              })
              hsLog.d(TAG,"===== isHide false")
            }
            this.currentOffSetY = currentOffsetY

            hsLog.d(TAG, `isUp:${isUp}  ishide:${this.isHideHeader}` + "--- yOffset: " + currentOffsetY  + " == " + yOffset)


          }
        })
        .shouldBuiltInRecognizerParallelWith((current: GestureRecognizer, others: Array<GestureRecognizer>) => {
          for (let i = 0; i < others.length; i++) {
            let target = others[i].getEventTargetInfo();
            if (target) {
              if (target.getId() == "inner" && others[i].isBuiltIn() && others[i].getType() == GestureControl.GestureType.PAN_GESTURE) { // 找到将要组成并行手势的识别器
                this.currentRecognizer = current; // 保存当前组件的识别器
                this.childRecognizer = others[i]; // 保存将要组成并行手势的识别器
                return others[i]; // 返回将要组成并行手势的识别器
              }
            }
          }
          return undefined;
        })
        .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer, others: Array<GestureRecognizer>) => { // 在识别器即将要成功时，根据当前组件状态，设置识别器使能状态
          if (current) {
            let target = current.getEventTargetInfo();
            if (target) {
              if (target.getId() == "outer" && current.isBuiltIn() && current.getType() == GestureControl.GestureType.PAN_GESTURE) {
                if (others) {
                  for (let i = 0; i < others.length; i++) {
                    let target = others[i].getEventTargetInfo() as ScrollableTargetInfo;
                    if (target instanceof ScrollableTargetInfo && target.getId() == "inner") { // 找到响应链上对应并行的识别器
                      let panEvent = event as PanGestureEvent;
                      if (target.isEnd()) { // 根据当前组件状态以及移动方向动态控制识别器使能状态
                        if (panEvent && panEvent.offsetY < 0) {
                          this.childRecognizer.setEnabled(false)
                          this.currentRecognizer.setEnabled(true)
                        } else {
                          this.childRecognizer.setEnabled(true)
                          this.currentRecognizer.setEnabled(false)
                        }
                      } else if (target.isBegin()) {
                        if (panEvent.offsetY > 0) {
                          this.childRecognizer.setEnabled(false)
                          this.currentRecognizer.setEnabled(true)
                        } else {
                          this.childRecognizer.setEnabled(true)
                          this.currentRecognizer.setEnabled(false)
                        }
                      } else {
                        this.childRecognizer.setEnabled(true)
                        this.currentRecognizer.setEnabled(false)
                      }
                    }
                  }
                }
              }
            }
          }
          return GestureJudgeResult.CONTINUE;
        })
        .parallelGesture( // 绑定一个Pan手势作为动态控制器
          PanGesture()
            .onActionUpdate((event: GestureEvent)=>{
              if (this.childRecognizer.getState() != GestureRecognizerState.SUCCESSFUL || this.currentRecognizer.getState() != GestureRecognizerState.SUCCESSFUL) { // 如果识别器状态不是SUCCESSFUL，则不做控制
                return;
              }
              let target = this.childRecognizer.getEventTargetInfo() as ScrollableTargetInfo;
              let currentTarget = this.currentRecognizer.getEventTargetInfo() as ScrollableTargetInfo;
              if (target instanceof ScrollableTargetInfo && currentTarget instanceof ScrollableTargetInfo) {
                if (target.isEnd()) { // 在移动过程中实时根据当前组件状态，控制识别器的开闭状态
                  if ((event.offsetY - this.lastOffset) < 0) {
                    this.childRecognizer.setEnabled(false)
                    if (currentTarget.isEnd()) {
                      this.currentRecognizer.setEnabled(false)
                    } else {
                      this.currentRecognizer.setEnabled(true)
                    }
                  } else {
                    this.childRecognizer.setEnabled(true)
                    this.currentRecognizer.setEnabled(false)
                  }
                } else if (target.isBegin()) {
                  if ((event.offsetY - this.lastOffset) > 0) {
                    this.childRecognizer.setEnabled(false)
                    if (currentTarget.isBegin()) {
                      this.currentRecognizer.setEnabled(false)
                    } else {
                      this.currentRecognizer.setEnabled(true)
                    }
                  } else {
                    this.childRecognizer.setEnabled(true)
                    this.currentRecognizer.setEnabled(false)
                  }
                } else {
                  this.childRecognizer.setEnabled(true)
                  this.currentRecognizer.setEnabled(false)
                }
              }
              this.lastOffset = event.offsetY
            })
        )
      }
      .width('100%')
      .height('100%')

    }.width('100%').height('100%').backgroundColor(0xDCDCDC)
  }
}
