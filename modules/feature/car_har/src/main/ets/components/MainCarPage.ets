import { YWNavParams, ywNavManager, YWLocalNavType } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"

@Builder
export function mainCarBuilder(name:string, params:YWNavParams) {
  NavDestination(){
    MainCarPage()
  }
  .hideTitleBar(true)
}

const TAG = "MainCarPage"

@Component
export struct MainCarPage {
  @State message: string = 'Hello car';

  @State navigationMode: number = NavigationMode.Stack;

  carPageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_MAIN_CAR)
  @Builder
  navPagesMap(name: string, param: YWNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_MAIN_CAR)(name)?.builder(name,param)
  }

  build() {
    Stack() {
      Navigation(this.carPageNav) {
        Column(){
          Text("==car==")
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
    .backgroundColor(Color.Orange)
    // .padding(getAvoidPadding(this.avoidAreas))

  }
}
