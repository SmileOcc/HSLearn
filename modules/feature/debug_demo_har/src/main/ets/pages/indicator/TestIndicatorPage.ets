import { YWConstants } from "@learn/constants_har"
import { hsLog } from "@learn/logger_har"
import { RectIndicator } from "./RectIndicator"

@Builder
export function TestIndicatorBuilder() {
  NavDestination(){
    TestIndicatorPage()
  }

}


const TAG = "ScrollTwoGesturePage"
@Entry
@Component
export struct TestIndicatorPage {
  scroller: Scroller = new Scroller()

  @State indicatorLeft: number = 0
  private SUB_MENUS = ["1","2","3","4","5","6","7","8"]
  private itemWidth = 80

  build() {
    Column(){
      Scroll(this.scroller) {
        Row() {
          ForEach(this.SUB_MENUS, (item: string, index) => {
            Column() {
              // Image(item.menuIcon).width(28).height(28)
              Text(item).fontSize(12).fontColor($r("app.color.icon_color")).margin({ top: 5 })
            }.width(this.itemWidth).height(this.itemWidth).id("item")
            .backgroundColor(YWConstants.RandomColor())
          })
        }
      }.scrollable(ScrollDirection.Horizontal)
      .backgroundColor(YWConstants.RandomColor())
      .margin({ top: 12 })
      .width(this.itemWidth * 4)
      .scrollBar(BarState.Off)
      //滑动监听
      .onDidScroll((_xOffset, _yOffset, scrollState) => {
        //当前状态为滑动状态
        if (scrollState == ScrollState.Scroll) {
          //获取滚动的偏移量，通过控制器获取比较准确
          const currentOffsetX = this.scroller.currentOffset().xOffset
          // hsLog.d("滑动偏移量", vp2px(currentOffsetX).toString())
          //子组件宽度*2=未显示出来的组件/指示器灰色部分
          let ratio = this.itemWidth * (this.SUB_MENUS.length - 4) / (50-20)
          //指示器进度的偏移量=scroll 的偏移量/比率

          this.indicatorLeft = currentOffsetX / ratio
          hsLog.d("滑动偏移量 ", currentOffsetX.toString()+  " slide move: " + this.indicatorLeft)

        }
      })
      RectIndicator({
        marginLeft: this.indicatorLeft, //左间距
        indicatorHeight: 10,  //指示器的高度
        indicatorWidth: 50,  //指示器的背景宽度
        indicatorProgressWidth: 20  //指示器进度的宽度
      }).margin({ top: 8, bottom: 8 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Gray)
  }
}