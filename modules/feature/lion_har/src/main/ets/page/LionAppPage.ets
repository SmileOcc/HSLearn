import { hsLog } from "@learn/logger_har";
import { YWLocalNavType, ywNavManager, YWNavParams, YWNavPath, ywNavRouter } from "@learn/nav_router_har";
import { YWResColor } from "@learn/res_har";
import { TabInfo, TabItemInfo, TabViewIUState } from "@learn/tab_nav_api_har";
import { commonTabBuilder } from "@learn/tab_nav_common_har"
import { lionMainBuilder } from "../../../../Index";

export const LionRootBuilder = wrapBuilder(lionAppBuilder)

@Builder export function lionAppBuilder(name:string, params:Map<string,Object>) {
  NavDestination(){
    LionAppPage()
  }
  .hideTitleBar(true)
}

const TAG = "LionAppPage"
@Entry
@Component
struct LionAppPage {
  @State message: string = 'Hello Lion';

  @State navigationMode: number = NavigationMode.Stack;

  private params:YWNavParams = new Map()

  private tabState?:TabViewIUState

  aboutToAppear(): void {



    let tabInfo = new TabInfo()
    tabInfo.navList = []
    for (let i=0; i< 3; i++) {
      let tabItem = new TabItemInfo()

      if (i == 0) {
        tabItem.cid = "id_" + `${i}`
        tabItem.title = "首页"
        tabItem.isSelected = true
        tabItem.navPath = YWNavPath.lion_tab_home
      } else if (i ==1) {
        tabItem.cid = "id_" + `${i}`
        tabItem.title = "消息"
        tabItem.navPath = YWNavPath.lion_tab_news
      } else if (i ==2) {
        tabItem.cid = "id_" + `${i}`
        tabItem.title = "我的"
        tabItem.navPath = YWNavPath.lion_tab_me
      }

      tabInfo.navList.push(tabItem)
    }

    this.tabState = new TabViewIUState()

    this.tabState.currentIndex = 0
    this.tabState.tabInfo = tabInfo

    this.params.set("custom_nav",YWLocalNavType.NAV_LION_MAIN_TAB_NAV)
    this.params.set("tabInfo",this.tabState!)

    // ywNavRouter.openRoute(this.getUniqueId())
    //   .onTargetUrl(YWNavPath.root_lion_tab_nav)
    //   // .onParams("custom_nav","lion_tab")
    //   // .onParams("tabInfo",this.tabState!)
    //   // .onRouteMoveToTop()
    //
    //   .onOpenAnimation(false)
    //   .onRouteMode()
    //   .go()

  }

  onBackPress() {
    ywNavRouter.openRoute(this.getUniqueId()).back()
  }
  @Builder
  navDestPages(name: string, param: YWNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_LION_MAIN_NAV)(name)?.builder(name,param)
  }

  build() {
    Stack() {

      Navigation(ywNavManager.getNavStack(YWLocalNavType.NAV_LION_MAIN_NAV)) {

        lionMainBuilder("",this.params)

      }
      .layoutWeight(1)
      .height('100%')
      .hideTitleBar(true)
      .navBarWidth('50%')
      .navDestination(this.navDestPages)
      .mode(this.navigationMode)
      .onAppear(()=>{
        hsLog.i(TAG,'--onAppear')
      })
      .onDisAppear(()=>{
        hsLog.i(TAG,'--onDisAppear')

      })
      .onAreaChange((oldValue,newValue)=>{
        hsLog.i(TAG,`--onAreaChange:${oldValue}  ${newValue}`)

      })



      // commonTabBuilder(this.tabState!)

      // if(this.isShowLeft) {
      //   Column(){
      //
      //   }
      //   .width('100%')
      //   .height('100%')
      //   .backgroundColor(Color.Gray)
      //   .onClick(()=>{
      //     this.isShowLeft = false
      //   })
      //
      //   Column(){
      //
      //
      //   }
      //   .width('70%')
      //   .height('100%')
      //   .backgroundColor(Color.White)
      //
      // }


    }
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    // .alignContent(Alignment.BottomEnd)
    .backgroundColor(YWResColor.bgBase())
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Pink)
  }
}