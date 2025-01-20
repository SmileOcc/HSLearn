import { YWNavParams, ywNavManager, YWLocalNavType } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"

@Builder
export function catMainMeBuilder(name:string, params:YWNavParams) {
  NavDestination(){
    CatMainMePage()
  }
  .hideTitleBar(true)

}

const TAG = "CatMainMePage"

@Component
export struct CatMainMePage {
  @State message: string = 'Hello home';

  @State navigationMode: number = NavigationMode.Stack;

  homePageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_CAT_ME_NAV)
  @Builder
  navPagesMap(name: string, param: YWNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_CAT_ME_NAV)(name)?.builder(name,param)
  }

  aboutToAppear(): void {
    hsLog.i(TAG,"aboutToAppear")
  }

  build() {
    Stack() {
      Navigation(this.homePageNav) {

        Column(){
          Text("me")
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
    // .alignContent(Alignment.BottomEnd)
    .backgroundColor(YWResColor.bgBase())
    .backgroundColor(Color.Orange)
    .width('100%')
    .height('100%')
    // .padding(getAvoidPadding(this.avoidAreas))

  }
}
