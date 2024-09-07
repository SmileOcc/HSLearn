// import Curves from '@ohos.curves'
import { router } from '@kit.ArkUI';


@Entry
@Component
struct ScrollListPage {

  @State TooTmp: ToolbarItem = {'value': "func", 'icon': "./image/ic_public_highlights.svg", 'action': ()=> {}}

  private arr: String[] = ["scrollFirst", "scrollSecond", "NestedScroll","StickyNestedScroll","商品列表","组件可见区域变化时触发该回调"];

  build() {
    // Column(){
    //   Navigation() {
    //     Scroll(this.scroller) {
    //       Column() {
    //         Button('ScorllFist')
    //           .height('5%')
    //           .onClick(() => { // 点击后下滑指定距离150.0vp
    //             router.pushUrl({url:'pages/accountInfo/ScrollFirstPage'})
    //           })
    //           .margin({ top: 10, left: 20 })
    //         Button('scroll 150')
    //           .height('5%')
    //           .onClick(() => { // 点击后下滑指定距离150.0vp
    //             this.scroller.scrollBy(0, 150)
    //           })
    //           .margin({ top: 10, left: 20 })
    //         Button('scroll 100')
    //           .height('5%')
    //           .onClick(() => { // 点击后滑动到指定位置，即下滑100.0vp的距离
    //             const yOffset: number = this.scroller.currentOffset().yOffset;
    //             this.scroller.scrollTo({ xOffset: 0, yOffset: yOffset + 100 })
    //           })
    //           .margin({ top: 10, left: 20 })
    //         Button('scroll 100')
    //           .height('5%')
    //           .onClick(() => { // 点击后滑动到指定位置，即下滑100.0vp的距离，滑动过程配置有动画
    //             let curve = Curves.interpolatingSpring(10, 1, 228, 30) //创建一个阶梯曲线
    //             const yOffset: number = this.scroller.currentOffset().yOffset;
    //             this.scroller.scrollTo({ xOffset: 0, yOffset: yOffset + 100, animation: { duration: 1000, curve: curve } })
    //           })
    //           .margin({ top: 10, left: 20 })
    //         Button('back top')
    //           .height('5%')
    //           .onClick(() => { // 点击后回到顶部
    //             this.scroller.scrollEdge(Edge.Top)
    //           })
    //           .margin({ top: 10, left: 20 })
    //         Button('next page')
    //           .height('5%')
    //           .onClick(() => { // 点击后滑到下一页
    //             this.scroller.scrollPage({ next: true })
    //           })
    //       }.
    //       width('100%')
    //       .margin({ top: 10, left: 20 })
    //     }
    //     .height('100%')
    //     .width('100%')
    //     .backgroundColor(Color.Green)
    //   }
    //   .mode(NavigationMode.Stack)
    //   .backgroundColor(Color.White)
    //   .title("scrollView")
    //   .height('100%')
    //   .width('100%')
    //
    //
    // }


    Column() {
      Navigation() {
        TextInput({ placeholder: 'search...' })
          .width("90%")
          .height(40)
          .backgroundColor('#FFFFFF')

        List({ space: 12 }) {
          ForEach(this.arr, (item:string,index) => {
            ListItem() {
              NavRouter() {
                Text(item)
                  .width("100%")
                  .height(72)
                  .backgroundColor('#FFFFFF')
                  .borderRadius(24)
                  .fontSize(16)
                  .fontWeight(500)
                  .textAlign(TextAlign.Center)
                // NavDestination() {
                //   Text("NavDestinationContent" + item)
                // }
                // .title("NavDestinationTitle" + item)
              }.onClick(()=>{
                if (index == 0) {
                  router.pushUrl({url:'pages/accountInfo/ScrollFirstPage'})
                } else if (index == 1) {
                  router.pushUrl({url:'pages/accountInfo/ScrollSecondPage'})

                } else if (index == 2) {
                  router.pushUrl({url:'pages/accountInfo/NestedScrollPage'})

                } else if (index == 3) {
                  router.pushUrl({url:'pages/accountInfo/StickyNestedScrollPage'})

                } else  if (index == 4) {
                  router.pushUrl({url:'pages/list/goodsList/GoodsListPage'})
                } else  if (index == 5) {
                  router.pushUrl({url:'pages/accountInfo/ScrollVisibleAreaPage'})
                }
              })
            }
          }, (item:string):string => item)
        }
        .width("90%")
        .margin({ top: 12 })
      }
      .title("ScrollViewList")
      .mode(NavigationMode.Auto)
      .titleMode(NavigationTitleMode.Mini)
      .menus([
        {value: "", icon: "./image/ic_public_search.svg", action: ()=> {}},
        {value: "", icon: "./image/ic_public_add.svg", action: ()=> {}},
        {value: "", icon: "./image/ic_public_add.svg", action: ()=> {}},
        {value: "", icon: "./image/ic_public_add.svg", action: ()=> {}},
        {value: "", icon: "./image/ic_public_add.svg", action: ()=> {}}
      ])
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')


  }
}