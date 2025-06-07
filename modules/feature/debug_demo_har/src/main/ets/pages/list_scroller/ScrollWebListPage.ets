import { YWConstants } from "@learn/constants_har"
import { hsLog } from "@learn/logger_har"
import { webview } from "@kit.ArkWeb"
import { YWBaseNavBar } from "@learn/baseui_har"
import { ywDebugGlobal } from "../../core/DebugGlobal"

@Builder
export function scrollWebListBuilder() {
  NavDestination(){
    ScrollWebListPage()
  }
  .hideTitleBar(true)

}


const TAG = "ScrollWebListPage"
@Entry
@ComponentV2
export struct ScrollWebListPage {
  scroller: Scroller = new Scroller()
  scroller2: Scroller = new Scroller()
  controller: webview.WebviewController = new webview.WebviewController()

  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,11,12,13,14,15,16]
  private childRecognizer: GestureRecognizer = new GestureRecognizer()
  private currentRecognizer: GestureRecognizer = new GestureRecognizer()
  private lastOffset: number = 0
  private listScroller: Scroller = new Scroller()

  private startOffSetY = 0
  private currentOffSetY = 0

  @Local topHeight: number = 150
  @Local webHeight: number = 0
  @Local isWebAtEnd: boolean = false
  private webScrollTop: number = 0

  getWebScrollTop() { // 检测web组件是否滚动到边界，isWebAtEnd的值为ture到Web底部，false还未到底部。
    try {
      // 获取Web组件的滚动偏移量
      this.controller.runJavaScriptExt('document.documentElement.scrollTop || document.body.scrollTop',
        (error, result) => {
          if (error || !result) {
            return;
          }
          let type = result.getType();
          if (type === webview.JsMessageType.NUMBER) {
            this.webScrollTop = result.getNumber();
            let pageHeight = this.controller.getPageHeight(); // 获取web组件内容高度
            this.isWebAtEnd = false; // 未到Web底部
            if (this.webScrollTop + this.webHeight >= pageHeight) { // 当web组件滚动偏移量 + web组件高度 ≥ web组件内容高度（web组件高度固定，内容可以很长）
              this.isWebAtEnd = true; // 到Web底部了
            }
            hsLog.d(TAG,`=== webTop:${this.webScrollTop}  isWebEnd:${this.isWebAtEnd}`)
          }
        });
    } catch (error) {
      hsLog.e(TAG,"error" +error);
    }
  }

  getWebHeight() { // 获取web组件高度
    try {
      this.controller?.runJavaScriptExt('window.innerHeight', (error, result) => {
        if (error || !result) {
          return;
        }
        if (result.getType() === webview.JsMessageType.NUMBER) {
          this.webHeight = result.getNumber(); // 获取web组件高度
        }
      })
    } catch (error) {
      hsLog.e('error' + error);
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column(){
        YWBaseNavBar({title:"横向滚动", defaultGoBack:()=>{
          ywDebugGlobal.getMainNav().pop()
        }})

        Scroll(this.scroller) { // 外部滚动容器
          Column() {
            Text("Scroll Area")
              .width('90%')
              .height(this.topHeight)
              .backgroundColor(0xFFFFFF)
              .borderRadius(15)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .margin({ top: 10 })
            Web({ src: 'https://zhuanlan.zhihu.com/p/30880291584', controller: this.controller })
              .id("inner")
              .width('100%')
              .height(800)
              .backgroundColor(YWConstants.RandomColor())
                // Web网页加载完成时，禁用Web手势生成的滚动。
              .onPageEnd(e => {
                // TODO：知识点：设置禁用Web手势生成的滚动
                this.controller.setScrollable(false, webview.ScrollType.EVENT);
                this.getWebHeight();
              })
                // 禁用Web的pan手势，即鼠标滚轮和触摸板的双指滑动。
              .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
                others: Array<GestureRecognizer>) => {
                if (current.isBuiltIn() && current.getType() == GestureControl.GestureType.PAN_GESTURE) {
                  // TODO：知识点：使用onGestureRecognizerJudgeBegin方法，禁用web自带的pan手势触发即鼠标滚轮和触摸板的双指滑动。
                  return GestureJudgeResult.REJECT; // 禁用Web组件上的鼠标滚轮和触摸板的双指滑动
                }
                return GestureJudgeResult.CONTINUE;
              })
            //数据列表
            List({ space: 20, scroller: this.listScroller}) {
              ForEach(this.arr, (item: number, index: number) => {
                ListItem() {
                  Row(){
                    Text(`aaa===${item}`)
                  }
                  .width('100%')
                  .height('60')
                  .borderWidth(1)
                  .borderColor(YWConstants.RandomColor())

                }
              }, (item: string) => item)
            }
            .enableScrollInteraction(false) // TODO：知识点：禁用List组件的手势
          }.width('100%')
        }
        .backgroundColor(YWConstants.RandomColor())
        .id("outer")
        .height(1000)
        .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
        .scrollBar(BarState.On) // 滚动条常驻显示
        .scrollBarColor(Color.Gray) // 滚动条颜色
        .scrollBarWidth(10) // 滚动条宽度
        .edgeEffect(EdgeEffect.None)
        // TODO：知识点：通过调用Scroll.onScrollFrameBegin()，在每帧开始滚动时触发时将Scroll返回的实际滚动量的offset，通过scrollBy(0, offset)方法，将Scroll的偏移量派发给Web、List。
        .onScrollFrameBegin((offset: number, state: ScrollState) => {

          this.getWebScrollTop(); // 检测web组件是否滚动到边界
          if (offset > 0) {//上滑
            if (this.topHeight > 50) {
              this.topHeight -= 2
              hsLog.d(TAG,`==上滑 减少高度：topHeight:${this.topHeight}}`)
              return { offsetRemain: 0 }
            }
          } else if (offset < 0) {//下滑
            if (this.webScrollTop <= 0) {
              if (this.topHeight <= 150) {
                this.topHeight +=2
                hsLog.d(TAG,`==上滑 增加高度：topHeight:${this.topHeight}}`)
                return { offsetRemain: 0 }

              }
            }
          }
          if (offset > 0) { // 手指上滑
            if (!this.isWebAtEnd) { // 还没触到web底部
              this.controller.scrollBy(0, offset) // 通过调用Web的WebController.scrollBy接口，滚动偏移派发给web（水平方向滚动距离为0，竖直方向滚动距离为offset）
              hsLog.d(TAG,`==上滑 web offset:${offset}==:${this.topHeight}}`)

              return { offsetRemain: 0 } // 将Scroll剩余滚动偏移量返回0，scroll就不会滚动，也不会停止惯性滚动动画
            } else if (this.scroller.isAtEnd()) { // 检测scroll组件滚动到了下边界
              this.listScroller.scrollBy(0, offset) // 通过调用List滚动控制器的scrollBy接口，滚动偏移派发给List
              hsLog.d(TAG,`==上滑 liseter offset:${offset}==:${this.topHeight}}`)

              return { offsetRemain: 0 }
            }
          } else if (offset < 0) { // 手指下滑
            if (this.listScroller.currentOffset().yOffset > 0) { // 检测List还没到上边界
              this.listScroller.scrollBy(0, offset) // 通过调用List滚动控制器的scrollBy接口，滚动偏移派发给List
              hsLog.d(TAG,`==下滑 liseter offset:${offset}==:${this.topHeight}}`)

              return { offsetRemain: 0 } // 将Scroll剩余滚动偏移量返回0，scroll就不会滚动，也不会停止惯性滚动动画
            } else if (this.scroller.currentOffset().yOffset <= 0) { // 检测scroll组件滚动到了上边界
              this.controller.scrollBy(0, offset) // 通过调用Web的WebController.scrollBy接口，滚动偏移派发给web
              hsLog.d(TAG,`==下滑 web offset:${offset}==:${this.topHeight}}`)
              return { offsetRemain: 0 }
            }
          }

          hsLog.d(TAG,`==最外滚动 offset:${offset}==:${this.topHeight}}`)
          return { offsetRemain: offset } // 否则，scroll自身滚动
        })
      }
      .width('100%')
      .height('100%')

    }.width('100%').height('100%').backgroundColor(0xDCDCDC)
  }
}
