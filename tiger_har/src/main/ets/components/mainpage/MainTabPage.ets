import { BreakpointSystem, BreakPointType } from "@learn/common_har";
import { CategoryPage } from "../pages/CategoryPage";
import { HomePage } from "../pages/HomePage";
import { MinePage } from "../pages/MinePage";
import { hsLog } from '@learn/logger_har';
import { TigerRouteParams } from "../../route/TigerRouteParams";
import { MainPage, tigerMainPageBuilder } from "./MainPage";
import { MainTabUIState, MainTabViewModel } from "./MainTabViewModel";
import { TigerGlobalThis } from "../../core/TigerGlobalThis";


@Builder
export function tigerMainTabBuilder(name:string, params:TigerRouteParams) {
  NavDestination(){
    MainTabPage({params:params})
  }
  .hideTitleBar(true)
}

@Component
export struct MainTabPage {
  @State selectIndex: number = 0;

  @Require
  params?:TigerRouteParams

  @State uiState:MainTabUIState = new MainTabUIState()
  viewModel:MainTabViewModel = new MainTabViewModel(TigerGlobalThis.getInstance().getAppContext())

  aboutToAppear(): void {
    hsLog.i("======= aboutToAppear")


    this.viewModel.iuState = this.uiState

    this.viewModel.loadConfig()
  }

  aboutToDisappear(): void {
    // this.appContext.
    hsLog.i("======= aboutToDisappear")

  }

  onPageShow(): void {
    hsLog.i("======= onPageShow")

  }
  onPageHide(): void {
    hsLog.i("======= onPageHide")

  }

  onBackPress(): boolean | void {
    hsLog.i("======= onPageHide")

  }

  // 路由容器
  @Builder
  navDestination(name: string, params: TigerRouteParams) {
    tigerMainPageBuilder(name,123,params)
  }

  @Builder
  tabBuilder() { //自定义 tab
    Navigation(){

    }
    .height('100%')
    .width('100%')
    // .toolbarConfiguration(this.tabBarBuilder) // 设置tabBar
    .navDestination(this.navDestination) // 设置路由容器
    .mode(NavigationMode.Stack)
    // .title(this.titleBuilder, {
    //   backgroundColor: Color.Blue,
    // }) // 设置标题
    .titleMode(NavigationTitleMode.Full) // 标题模式
    // .menus(this.NavigationMenus) // 顶部图标
    // .hideTitleBar(!this.iuState.isShowTitleBar) // 是否隐藏标题栏
    // .hideNavBar(!this.iuState.isShowTab) // 是否隐藏导航栏, 隐藏Navigation的导航栏，包括标题栏、内容区和工具栏。
    .backgroundColor(Color.Pink)
    .onAppear(()=>{
      hsLog.i("======= aboutToAppear")
      // this.iuState.isShowTab = true

    })
    // .animation()
    .onDisAppear(()=>{
      hsLog.i("======= aboutToAppear")
      // this.iuState.isShowTab = false
    })
  }

  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()

  @Builder
  bottomBarItemBuilder(name: ResourceStr, icon: Resource, selectIcon:Resource, index: number) {
    Flex({
      direction: new BreakPointType({
        sm: FlexDirection.Column,
        md: FlexDirection.Row,
        lg: FlexDirection.Column
      }).getValue(this.currentBreakpoint),
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Image(this.selectIndex == index ? selectIcon: icon)
        .height(24)
        .width(24)
        .fillColor(this.getTabBarColor(index))
      Text(name)
        .margin(new BreakPointType<Padding>({
          sm: { top: 4 },
          md: { left: 8 },
          lg: { top: 4 }
        }).getValue(this.currentBreakpoint) as Padding)
        .fontSize(11)
        .fontColor(this.getTabBarColor(index))
    }
  }

  private getTabBarColor(index: number) {
    return this.selectIndex == index ? $r('app.color.tab_normal_color') : $r('app.color.tab_bar_normal_color')
  }

  build() {
    Stack() {
      Tabs({ index: this.selectIndex, barPosition: BarPosition.End }) {
        ForEach(['首页', '分类', '我的'], (item: string, index: number) => {
          TabContent() {
            if (index === 0) {
              HomePage()
            } else if (index === 1) {
              CategoryPage()
            } else if (index === 2) {
              MinePage()
            }
          }.tabBar(this.bottomBarItemBuilder(item, $r("app.media.home_normal"),$r('app.media.home_select'), index))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])


          // .tabBar(this.buildTabs(item, index))
        }, (item: string, index?: number) => index + JSON.stringify(item))
      }
      .barHeight(50)
      .onTabBarClick((index: number) => {
        this.selectIndex = index
      })
    }
    .width('100%')
    .layoutWeight(1)

  }
}
