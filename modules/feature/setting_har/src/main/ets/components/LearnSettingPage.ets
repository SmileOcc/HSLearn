import { YWNavParams, ywNavManager, YWLocalNavType, ywNavRouter, YWNavPath } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"

@Builder export function learnSettingBuilder(name:string, params:Map<string,Object>) {
  NavDestination(){
    LearnSettingPage()
  }
  .hideTitleBar(true)
}


const TAG = "LearnSettingPage"

@Component
export struct LearnSettingPage {
  @State message: string = 'Hello setting';

  @State navigationMode: number = NavigationMode.Stack;

  settingPageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_ROOT_LEARN_SETTING)
  @Builder
  navPagesMap(name: string, param: YWNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_ROOT_LEARN_SETTING)(name)?.builder(name,param)
  }

  build() {
    Stack() {
      Navigation(this.settingPageNav) {

        Column(){
          Text("原学习Demo")
            .onClick(()=>{

              ywNavRouter.openRoute(this.getUniqueId())
                .onTargetUrl(YWNavPath.root_demo_tab_nav)
                // .onNavWayNav(YWLocalNavType.NAV_ROOT_MAIN_TAB)
                .onRouteMode()
                .go()
            })


        }.width('100%')
        .height('100%')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)

      }
      .width('100%')
      .height('100%')
      // .hideTitleBar(true)
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
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.BottomEnd)
    .backgroundColor(YWResColor.bgBase())
    // .padding(getAvoidPadding(this.avoidAreas))

  }
}
