import { YWRouterNavParams, ywNavManager, YWLocalNavType, ywNavRouter, YWNavPath } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"
import { HSLocalConfig } from "@learn/app_config_har"
import { HomeUIState, HomeViewModel } from "./viewmodel/MineViewModel"
import { MineHeaderView } from "./view/MineHeaderView"
import { MineUserInfoView } from "./view/MineUserInfoView"
import { MineMenuView } from "./view/MineMenuView"
import { MineListView } from "./view/MineListView"

@Builder
export function mainMineBuilder(name:string, params:YWRouterNavParams) {
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

  viewModel:HomeViewModel = new HomeViewModel(this.getUIContext())
  @State mineUIState:HomeUIState = this.viewModel.iuState

  @Builder
  navPagesMap(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_MAIN_MINE)(name)?.builder(name,param)
  }

  aboutToAppear(): void {
    this.envName = HSLocalConfig.getEnv()

  }

  @Builder
  topBlackBgView() {
    Column(){

    }
    .width('100%')
    .height('200vp')
  }
  @Builder
  bottomBgColorView() {
    Column(){

    }
    .width('100%')
    .height('200vp')
  }

  build() {
    Stack() {
      Navigation(this.minePageNav) {
        Stack(){

          Scroll(){
            Column(){
              MineHeaderView()
              MineUserInfoView()
              MineMenuView()
              MineListView()

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
