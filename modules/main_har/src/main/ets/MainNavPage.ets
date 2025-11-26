import { YWLocalNavType, ywNavManager, YWRouterNavParams, YWNavPath, ywNavRouter } from "@learn/nav_router_har";
import { router } from "@kit.ArkUI";
import { hsLog } from "@learn/logger_har";

const TAG = "MainNavPage"
@Component
export struct MainNavPage {

  mainNav = ywNavManager.getNavStack(YWLocalNavType.NAV_ROOT_MAIN_NAV)

  @State navigationMode: number = NavigationMode.Stack;

  aboutToAppear(): void {
    ywNavRouter.openRoute(this.getUniqueId())
      .onTargetUrl(YWNavPath.main_tab_nav)
      .onRouteMode()
      .onOpenAnimation(false)
      .go()
  }

  @Builder
  PagesMap(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_ROOT_MAIN_NAV)(name)?.builder(name,param)
  }

  build() {

    Row(){

      // if (true) {//TODO 大屏侧边菜单
      //   Column(){
      //     Text("菜单1")
      //     Text("菜单2")
      //   }
      //   .width(60)
      //   .height('100%')
      // }

      Navigation(this.mainNav) {



      }
      .layoutWeight(1)
      .height('100%')
      .hideTitleBar(true)
      .navBarWidth('50%')
      .navDestination(this.PagesMap)
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
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }

  }
}

@Builder
export function mainNavBuilder(name:string, params:YWRouterNavParams) {
  NavDestination() {
    MainNavPage()
  }
  .hideTitleBar(true)
  .onBackPressed(()=>{
    router.back()
    return true
  })
}

ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT,[
  {name:YWNavPath.root_main_nav,builder:wrapBuilder(mainNavBuilder)},

])