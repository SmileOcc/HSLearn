import { YWRouterNavParams, ywNavManager, YWLocalNavType, ywNavRouter, YWNavPath,
  YWNavMode } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"
import { ComponentContent, OverlayManager } from "@kit.ArkUI"
import { YWConstants } from "@learn/constants_har"
import { HomeIUState, HomeViewModel } from "./HomeViewModel"
import { ITabPageConfig } from "@learn/tab_nav_api_har"
import { BreakpointSystem, YWAppUtils } from "@learn/common_har"
import { emitter } from "@kit.BasicServicesKit"
import { HomeTopSwiper } from "./view/HomeTopSwiper"
import { HomeWaterView } from "./view/HomeWaterView"

export const MainHomeBuilder = wrapBuilder(mainHomeBuilder)

@Builder
export function mainHomeBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    MainHomePage({navParams: params})
  }
  .hideTitleBar(true)
  .onWillDisappear(()=>{

    //TODO 可以添加一个通用类 集中处理
    // 设置了全屏的在退出时取消全屏
    if (ywNavManager.getNeedWindowFullScreenRouters().includes(name)) {
      YWAppUtils.setStatusBar(false, true)
    }

    params.getPageLifecycle().pageOnDisappear?.()
  })
  .onShown(()=>{
    // 设置是否需要全屏
    if (ywNavManager.getFullScreenRouters().includes(name)) {
      YWAppUtils.setStatusBar(true, true)
    }
    params.getPageLifecycle().pageOnShow?.()
  })
  .onHidden(()=>{
    params.getPageLifecycle().pageOnHide?.()
  })
  .onBackPressed(()=>{

    //可以根据 name 添加不同的广播事件
    let innerEvent: emitter.InnerEvent = { eventId: 2 };
    let eventData: emitter.EventData = {
      data: {
        'backPressed': true
      }
    }
    emitter.emit(innerEvent, eventData);

    return true
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

  @State @Watch('onModeChange') navMode: YWNavMode = YWNavMode.DefaultMode;
  @Provide('swiperDisplayCount') swiperDisplayCount: number = 1; // 首页swiper展示item数量
  @StorageLink('currentBreakpoint') @Watch('onWindowSizeChange') currentBreakpoint: string = '';
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()

  navParams?:YWRouterNavParams
  private uiContext = this.getUIContext()
  private overlayNode: OverlayManager = this.uiContext.getOverlayManager()
  private componentContentTest?: ComponentContent<ActivityParams>

  viewModel: HomeViewModel = new HomeViewModel(this.uiContext)
  homeUIState: HomeIUState = this.viewModel.homeState
  // tabInfo:ITabPageConfig = yw

  @Builder
  navPagesMap(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_MAIN_HOME)(name)?.builder(name, param)
  }

  aboutToAppear(): void {
    hsLog.i(TAG, "aboutToAppear")

    this.navParams?.getPageLifecycleImp().setPageOnShow(()=>{
      hsLog.i(TAG, "--pageOnShow")
      this.overlayNode.showComponentContent(this.componentContentTest)

    })
    this.navParams?.getPageLifecycleImp().setPageOnHide(()=>{
      hsLog.i(TAG, "--pageOnHide")
      this.overlayNode.hideComponentContent(this.componentContentTest)
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

  // 屏幕尺寸发生改变时触发navMode改变
  onWindowSizeChange() {
    // 屏幕变化 ，路由模式，应该在最外层路由时，获取状态改变
    // if (DynamicsRouter.appRouterStack.length > 1 &&
    //   !FULL_SCREEN_COMPONENT.includes(DynamicsRouter.appRouterStack[1].name)) {
    //   if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM) {
    //     this.navMode = NavMode.HomePageMode;
    //   } else {
    //     this.navMode = NavMode.FoldMode;
    //   }
    // }
  }

  onModeChange() {
    // 获取路由栈最后一个路由的名称
    // let lastRouteName = DynamicsRouter.appRouterStack.slice(-1)[0].name;
    // switch (this.navMode) {
    //   // 当设备折叠态发生改变或屏幕旋转时响应以下逻辑
    //   case YWNavMode.FoldMode:
    //     // 全屏案例在折叠态变化时不需要切换NavigationMode
    //     if (ywNavManager.getFullScreenRouters().includes(lastRouteName)) {
    //       this.navigationMode = NavigationMode.Stack;
    //       break;
    //     }
    //     if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM) {
    //       if (this.pageStack.size() > 0) {
    //         // 宽屏条件下且展示了子路由，NavigationMode为Split
    //         this.navigationMode = NavigationMode.Split;
    //         this.swiperDisplayCount = 1;
    //       } else {
    //         // 宽屏条件下且未展示子路由，NavigationMode为Stack
    //         this.navigationMode = NavigationMode.Stack;
    //         this.swiperDisplayCount = 2;
    //       }
    //     } else {
    //       this.navigationMode = NavigationMode.Stack;
    //       this.swiperDisplayCount = 1;
    //     }
    //     break;
    // // 当应用进入子路由时响应以下逻辑
    //   case NavMode.ChildPageMode:
    //     // 进入全屏案例需切换为Stack
    //     if (FULL_SCREEN_ROUTE.includes(this.enterRouteName)) {
    //       this.navigationMode = NavigationMode.Stack;
    //       break;
    //     }
    //     // 根据屏幕宽度决定NavigationMode
    //     if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM) {
    //       this.navigationMode = NavigationMode.Split;
    //     } else {
    //       this.navigationMode = NavigationMode.Stack;
    //     }
    //     this.swiperDisplayCount = 1;
    //     break;
    // // 当应用返回首页时响应以下逻辑
    //   case NavMode.HomePageMode:
    //     if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM) {
    //       this.navigationMode = NavigationMode.Stack;
    //       this.swiperDisplayCount = 2;
    //     } else {
    //       this.navigationMode = NavigationMode.Stack;
    //       this.swiperDisplayCount = 1;
    //       this.isFullScreen = false;
    //     }
    //     this.pageStack.disableAnimation(false);
    //     break;
    //   default:
    //     break;
    // }
    // // 重置NavMode
    // if (this.navMode !== NavMode.DefaultMode) {
    //   this.navMode = NavMode.DefaultMode;
    // }
  }


  build() {
    Stack() {
      // Navigation(this.homePageNav) {

        Column() {
          Scroll(){
            Column() {
              // 首页轮播图组件
              HomeTopSwiper()
              // 首页列表组件
              HomeWaterView()
            }
          }
          // Text("home")
          // Text("go-car")
          //   .onClick(()=>{
          //     ywNavRouter.openRoute(this.getUniqueId())
          //       .onTargetUrl(YWNavPath.vc_car)
          //       .onNavWayNav(YWLocalNavType.NAV_ROOT_MAIN_TAB)//跨路由跳转
          //       .onRouteMode()
          //       .go()
          //   })
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
