import { YWNavParams, ywNavManager, YWLocalNavType, ywNavRouter, YWNavPath } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"

@Builder
export function mainCategoryBuilder(name:string, params:YWNavParams) {
  NavDestination(){
    MainCategoryPage()
  }
  .hideTitleBar(true)
}

const TAG = "MainCategoryPage"

@Component
export struct MainCategoryPage {
  @State message: string = 'Hello category';

  @State navigationMode: number = NavigationMode.Stack;

  categoryPageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_MAIN_CATEGORY)

  aboutToAppear(): void {

  }

  @Builder
  navPagesMap(name: string, param: YWNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_MAIN_CATEGORY)(name)?.builder(name,param)
  }

  build() {
    Stack() {

      // Button("测试")
      //   .backgroundColor(Color.Blue)
      //   .onClick(()=>{
      //     ywNavRouter.openRoute(this.getUniqueId())
      //       .onTargetUrl(YWNavPath.root_setting)
      //       .onNavWayNav(YWLocalNavType.NAV_ROOT)
      //       .onRouteMode()
      //       .go()
      //   })

      // Navigation(this.categoryPageNav) {
      //
      // }
      // .width('100%')
      // .height('100%')
      // .hideTitleBar(true)
      // .navBarWidth('50%')
      // .navDestination(this.navPagesMap)
      // // .hideNavBar(this.isFullScreen)
      // .mode(this.navigationMode)
      // .onAppear(()=>{
      //   hsLog.i(TAG,'--onAppear')
      // })
      // .onDisAppear(()=>{
      //   hsLog.i(TAG,'--onDisAppear')
      //
      // })
      // .onAreaChange((oldValue,newValue)=>{
      //   hsLog.i(TAG,`--onAreaChange:${oldValue}  ${newValue}`)
      //
      // })
    }
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.BottomEnd)
    .backgroundColor(YWResColor.bgBase())
    .backgroundColor(Color.Pink)

    // .padding(getAvoidPadding(this.avoidAreas))

  }
}
