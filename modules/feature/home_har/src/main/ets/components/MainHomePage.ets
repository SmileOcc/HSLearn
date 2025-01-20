import { YWNavParams, ywNavManager, YWLocalNavType, ywNavRouter, YWNavPath } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"

// export const MainHomeBuilder = wrapBuilder(mainHomeBuilder)

@Builder
export function mainHomeBuilder(name: string, params: YWNavParams) {
  NavDestination() {
    MainHomePage()
  }
  .hideTitleBar(true)

  // MainHomePage()

}

const TAG = "MainHomePage"

@Component
export struct MainHomePage {
  @State message: string = 'Hello home';
  @State navigationMode: number = NavigationMode.Stack;
  homePageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_MAIN_HOME)

  @Builder
  navPagesMap(name: string, param: YWNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_MAIN_HOME)(name)?.builder(name, param)
  }

  aboutToAppear(): void {
    hsLog.i(TAG, "aboutToAppear")
  }

  build() {
    Stack() {
      Navigation(this.homePageNav) {

        Column() {
          Text("home")
          Text("go-car")
            .onClick(()=>{
              ywNavRouter.openRoute(this.getUniqueId())
                .onTargetUrl(YWNavPath.vc_car)
                .onNavWayNav(YWLocalNavType.NAV_ROOT_MAIN_TAB)//跨路由跳转
                .onRouteMode()
                .go()
            })
        }
        .backgroundColor(Color.Yellow)
        .width('100%')
        .height('100%')

      }
      .width('100%')
      .height('100%')
      .hideTitleBar(true)
      .navBarWidth('50%')
      .navDestination(this.navPagesMap)
      // .hideNavBar(this.isFullScreen)
      .mode(this.navigationMode)
      .onAppear(() => {
        hsLog.i(TAG, '--onAppear')
      })
      .onDisAppear(() => {
        hsLog.i(TAG, '--onDisAppear')

      })
      .onAreaChange((oldValue, newValue) => {
        hsLog.i(TAG, `--onAreaChange:${oldValue}  ${newValue}`)

      })
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    // .alignContent(Alignment.BottomEnd)
    .backgroundColor(YWResColor.bgBase())
    .backgroundColor(Color.Orange)
    .width('100%')
    .height('100%')

    // .padding(getAvoidPadding(this.avoidAreas))

  }
}
