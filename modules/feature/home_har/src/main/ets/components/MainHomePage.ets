import { YWRouterNavParams, ywNavManager, YWLocalNavType, ywNavRouter, YWNavPath } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"
import { ComponentContent, OverlayManager } from "@kit.ArkUI"
import { YWConstants } from "@learn/constants_har"

// export const MainHomeBuilder = wrapBuilder(mainHomeBuilder)

@Builder
export function mainHomeBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    MainHomePage({navParams: params})
  }
  .hideTitleBar(true)
  .onWillDisappear(()=>{
    params.getPageLifecycle().pageOnDisappear?.()
  })
  .onShown(()=>{
    params.getPageLifecycle().pageOnShow?.()
  })
  .onHidden(()=>{
    params.getPageLifecycle().pageOnHide?.()
  })

  // MainHomePage()

}

const TAG = "MainHomePage"

@Component
export struct MainHomePage {
  @State message: string = 'Hello home';
  @State navigationMode: number = NavigationMode.Stack;
  // homePageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_MAIN_HOME)

  @StorageProp(YWConstants.kStorageWidth) screenWidth: number = 0; //屏幕宽度（单位：vp）
  @StorageProp(YWConstants.kStorageHeight) screenHeight: number = 0; //屏幕宽度（单位：vp）
  @StorageProp(YWConstants.kSafeBottomHeight) safeBottomHeight: number = 0; //屏幕宽度（单位：vp）

  navParams?:YWRouterNavParams
  private uiContext = this.getUIContext()
  private overlayNode: OverlayManager = this.uiContext.getOverlayManager()
  private componentContentTest?: ComponentContent<ActivityParams>

  @Builder
  navPagesMap(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_MAIN_HOME)(name)?.builder(name, param)
  }

  aboutToAppear(): void {
    hsLog.i(TAG, "aboutToAppear")

    this.navParams?.getPageLifecycleImp().setPageOnShow(()=>{
      hsLog.i(TAG, "--pageOnShow")

    })
    this.navParams?.getPageLifecycleImp().setPageOnHide(()=>{
      hsLog.i(TAG, "--pageOnHide")

    })


    let width = this.screenWidth
    let heig = this.screenHeight
    let componentContentTest = new ComponentContent(
      // this.uiContext, wrapBuilder<[ActivityParams]>(builderText),new ActivityParams("活动入口", {x: this.screenWidth - 100, y: this.screenHeight - 100}));
      this.uiContext, wrapBuilder<[ActivityParams]>(builderText),new ActivityParams("活动入口", {x: (this.screenWidth)/2.0 - 40- 20, y: (this.screenHeight)/2.0 - 40 - this.safeBottomHeight - YWConstants.kMainTabHeight - 20 - 20}));
    this.overlayNode.addComponentContent(componentContentTest, 1);
    // 1为新增节点在OverlayManager上的层级位置。
    this.componentContentTest = componentContentTest

    this.overlayNode.showComponentContent(this.componentContentTest)

    // this.overlayNode.removeComponentContent(componentContent.pop())
    // this.overlayNode.hideComponentContent(componentContent)


  }
  aboutToDisappear(): void {
    this.overlayNode.hideComponentContent(this.componentContentTest)
  }

  onPageShow(): void {
    let kk = ""
  }

  onPageHide(): void {
    let kk = ""
  }

  build() {
    Stack() {
      // Navigation(this.homePageNav) {

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

      // }
      // .width('100%')
      // .height('100%')
      // .hideTitleBar(true)
      // .navBarWidth('50%')
      // .navDestination(this.navPagesMap)
      // // .hideNavBar(this.isFullScreen)
      // .mode(this.navigationMode)
      // .onAppear(() => {
      //   hsLog.i(TAG, '--onAppear')
      // })
      // .onDisAppear(() => {
      //   hsLog.i(TAG, '--onDisAppear')
      //
      // })
      // .onAreaChange((oldValue, newValue) => {
      //   hsLog.i(TAG, `--onAreaChange:${oldValue}  ${newValue}`)
      //
      // })
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


class ActivityParams {
  text: string = "活动入口"
  offset: Position
  constructor(text: string, offset: Position) {
    this.text = text
    this.offset = offset
  }
}

@Builder
function builderText(params: ActivityParams) {
  Column() {
    Text(params.text)
      .fontSize(15)
      .fontWeight(FontWeight.Normal)
  }
  .width(80)
  .height(80)
  .borderRadius(40)
  .offset(params.offset)
  .backgroundColor(Color.Blue)
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Center)
}
