import { hsLog } from "@learn/logger_har";
import { YWLocalNavType, YWRouterNavParams, ywNavManager, YWNavPath, ywNavRouter } from "@learn/nav_router_har";
import { YWResColor } from "@learn/res_har";
import { asyncLocalStage, GlobalService, YWGlobalServiceManager, YWLazy } from "@learn/global_service_har"
import { TabInfo, TabItemInfo, TabViewIUState } from "@learn/tab_nav_api_har";
import { commonTabBuilder } from "@learn/tab_nav_common_har"
import { router } from "@kit.ArkUI";

const TAG = "LionMainPage"
@Component
struct LionMainPage {


  @State navigationMode: number = NavigationMode.Stack;

  private params:YWRouterNavParams = new YWRouterNavParams()

  private tabState?:TabViewIUState

  // @Consume('isFullScreen') isFullScreen: boolean;


  @State isShowLeft:boolean = false

  aboutToAppear(): void {

    hsLog.i(TAG,"aboutToAppear")


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

    this.params.params.set("main_nav",YWLocalNavType.NAV_LION_MAIN_NAV)
    this.params.params.set("main_tab_nav",YWLocalNavType.NAV_LION_MAIN_TAB_NAV)
    this.params.params.set("tabInfo",this.tabState!)


    ywNavRouter.openRoute(this.getUniqueId())
      .onTargetUrl("lion_tab")
      .onParams("custom_nav","lion_tab")
      .onParams("tabInfo",this.tabState!)
        // .onRouteMoveToTop()
      .onOpenAnimation(false)
      .onRouteMode()
      .go()
  }

  onBackPress() {

    let kk = "d"
  }

  build() {
    Stack() {

      commonTabBuilder(this.params)

      if(this.isShowLeft) {
        Column(){

        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Gray)
        .onClick(()=>{
          this.isShowLeft = false
        })

        Column(){


        }
        .width('70%')
        .height('100%')
        .backgroundColor(Color.White)

      }


    }
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.BottomEnd)
    .backgroundColor(YWResColor.bgBase())
  }
}

@Builder
export function lionMainBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    LionMainPage({},asyncLocalStage(()=>{
      return new LocalStorage()
    }))
  }
  .hideTitleBar(true)
  .onBackPressed(()=>{

    ywNavManager.getNavStack(YWLocalNavType.NAV_LION_MAIN_NAV)?.pop(true)
    return false
  })
}