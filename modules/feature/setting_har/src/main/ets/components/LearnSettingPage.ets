import { YWRouterNavParams, ywNavManager, YWLocalNavType, ywNavRouter, YWNavPath } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"
import { getAvoidPadding, getDefaultAvoidAreas, YWAvoidAreas } from "@learn/common_har"
import { YWConstants } from "@learn/constants_har"
import { YWBaseNavBar } from "@learn/baseui_har"

@Builder export function learnSettingBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    LearnSettingPage()
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


const TAG = "LearnSettingPage"

@Component
export struct LearnSettingPage {
  @State message: string = 'Hello setting';

  @State navigationMode: number = NavigationMode.Stack;
  @StorageProp(YWConstants.kStorageAreas) avoidAreas: YWAvoidAreas = getDefaultAvoidAreas()

  @StorageProp(YWConstants.kSafeBottomHeight) safeBottomHeight: number = 0
  @StorageProp(YWConstants.kStatusBarHeight) statusBarHeight: number = 0


  settingPageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_ROOT_LEARN_SETTING)
  @Builder
  navPagesMap(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_ROOT_LEARN_SETTING)(name)?.builder(name,param)
  }

  aboutToAppear(): void {
    let kk = ""
  }
  aboutToDisappear(): void {
    let yy = ""
  }

  build() {
    Stack() {
      Navigation(this.settingPageNav) {

        Column(){
          YWBaseNavBar({title:"设置", defaultGoBack:()=>{
            ywNavManager.getNavStack(YWLocalNavType.NAV_ROOT)?.pop(true)

          }})
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
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .height('100%')
      // .hideTitleBar(true)
      // .navBarWidth('50%')
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
    .alignContent(Alignment.TopStart)
    // .backgroundColor(YWResColor.bgBase())
    .backgroundColor(Color.Orange)

  }
}
