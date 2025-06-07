import { YWBaseNavBar } from "@learn/baseui_har"
import { YWConstants } from "@learn/constants_har"
import { ywNavRouter, YWRouterNavParams } from "@learn/nav_router_har"
import OrderListView from "./view/OrderListView"

const TAG = "MyOrderPage"
@Builder
export function myOrderBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    MyOrderPage()
  }
  .hideTitleBar(true)
  .onWillDisappear(() => {
    params.getPageLifecycle().pageOnDisappear?.()
  })
  .onShown(() => {
    params.getPageLifecycle().pageOnShow?.()
  })
  .onHidden(() => {
    params.getPageLifecycle().pageOnHide?.()
  })
}

@Entry
@ComponentV2
struct MyOrderPage {
  @Local currentTabIndex: number = 0

  @Builder finishOrderView() {
    OrderListView({status: "20"})

  }
  @Builder waitUseOrderView() {
    OrderListView({status: "13"})
  }

  @Builder waitPayOrderView() {
    OrderListView({status: "0"})
  }

  @Builder OrderView() {
    OrderListView({status: undefined})

  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column(){
        YWBaseNavBar({title:"我的订单", defaultGoBack:()=>{
          ywNavRouter.openRoute(this.getUniqueId()).back()
        }})
        Tabs({
          barPosition: BarPosition.Start
        }) {
          TabContent() {
            // this.homeMainView()
            this.OrderView()

          }.tabBar(this.bottomBarItemBuilder($r("app.string.order_all"), 0))

          TabContent() {
            this.waitPayOrderView()

          }.tabBar(this.bottomBarItemBuilder($r("app.string.Unpaid"), 1))

          TabContent() {
            this.waitUseOrderView()

          }.tabBar(this.bottomBarItemBuilder($r("app.string.order_waitUse"), 2))

          TabContent() {
            this.finishOrderView()

          }.tabBar(this.bottomBarItemBuilder($r("app.string.Reviewed"), 3))
        }
        .vertical(false)
        .barWidth('100%')
        .barHeight('56vp')
        .animationDuration(0)
        .backgroundColor(YWConstants.RandomColor())
        .onChange((index) => {
          this.currentTabIndex = index
        })
      }
      .height('100%')
    }
  }

  @Builder
  bottomBarItemBuilder(name: Resource, index: number) {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Text(name)
        .margin({top:4})
        .fontSize(11)
        .fontColor(this.getTabBarColor(index))
    }
  }

  private getTabBarColor(index: number) {
    return this.currentTabIndex == index ? $r('app.color.theme_light') : $r('app.color.theme_unselect')
  }
}

