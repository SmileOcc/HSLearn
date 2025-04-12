import { YWNavParams, ywNavManager, YWLocalNavType, ywNavRouter, YWNavPath } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"
import { HSLocalConfig } from "@learn/app_config_har"

@Builder
export function mainMineBuilder(name:string, params:YWNavParams) {
  NavDestination(){
    MainMinePage()
  }
  .hideTitleBar(true)
}

const TAG = "MainCarPage"

@Component
export struct MainMinePage {
  @State message: string = 'Hello mine';

  @State navigationMode: number = NavigationMode.Stack;
  @State envName: string = ""

  minePageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_MAIN_MINE)
  @Builder
  navPagesMap(name: string, param: YWNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_MAIN_MINE)(name)?.builder(name,param)
  }

  aboutToAppear(): void {
    this.envName = HSLocalConfig.getEnv()

  }

  build() {
    Stack() {
      Navigation(this.minePageNav) {
        Column(){
          Text(`配置：${this.envName}`)
          Button("设置")
            .onClick(()=>{
              ywNavRouter.openRoute(this.getUniqueId())
                .onTargetUrl(YWNavPath.root_setting)
                .onRouteMode()
                .go()
            })

          Button("通用tab")
            .onClick(()=>{
              ywNavRouter.openRoute(this.getUniqueId())
                .onTargetUrl(YWNavPath.root_lion_nav)
                .onNavWayNav(YWLocalNavType.NAV_ROOT_MAIN_TAB)
                .onRouteMode()
                .go()
            })
        }
      }
      .width('100%')
      .height('100%')
      .hideTitleBar(true)
      .navBarWidth('50%')
      .navDestination(this.navPagesMap)
      // .hideNavBar(this.isFullScreen)
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
    }
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.BottomEnd)
    .backgroundColor(YWResColor.bgBase())
    .backgroundColor(Color.Green)
    // .padding(getAvoidPadding(this.avoidAreas))

  }
}
