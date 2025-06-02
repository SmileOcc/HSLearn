import { YWConstants } from "@learn/constants_har"
import { hsLog } from "@learn/logger_har"
import { ywNavManager, YWRouterNavParams } from "@learn/nav_router_har"
import { YWResColor } from "@learn/res_har/src/main/ets/res/YWResColor"
import { ITabEventState, ITabNavTitleConfig, ITabPageConfig, TabNavTitleConfig } from "@learn/tab_nav_api_har"
import { TabInfo } from "@learn/tab_nav_api_har"
import { TabItemInfo } from "@learn/tab_nav_api_har"
import { TabViewIUState } from "@learn/tab_nav_api_har"
import { TabMainItemView } from "./TabMainItemView"
import { router } from "@kit.ArkUI"
import { YWMainNavBar } from "@learn/tab_nav_common_har"
import { YWResImage } from "@learn/res_har"
import { NavAvatarInfo, NavTitleInfo } from "@learn/tab_nav_api_har/src/main/ets/config/TabNavTitleConfig"
import { BreakpointTypeEnumValue } from "@learn/common_har"
import { YWMainNavTabBar } from "./tabbar/YWMainNavTabBar"

const TAG = "TabContentView"
@Component
export struct TabContentView {

  navName?:string

  // @State navigationMode: NavigationMode = NavigationMode.Split
  @State navigationMode: number = NavigationMode.Stack;
  navigationMode_valueList =  ["Stack", "Split", "Auto"]

  @State navInfo?:ITabNavTitleConfig = new TabNavTitleConfig()

  @Consume("tabIUState") tabIUState:TabViewIUState

  @Watch('windowPointChange')
  @StorageProp(YWConstants.kCurrentBreakpointValue)
  currentBreakValue:BreakpointTypeEnumValue = 320


  @Consume('mainNavWidth')
  mainNavWidth: number

  @State
  mainNavContentWidth: number = 320
  @State
  mainContentWidth: number = 320


  @State isVisible: boolean = true


  private currentTabInfo?:ITabPageConfig


  @Consume("ITabEventState")
  tabEventState:ITabEventState

  windowPointChange() {

    if (this.currentBreakValue >= BreakpointTypeEnumValue.LG) {
      this.navigationMode = NavigationMode.Split
      this.mainNavContentWidth = 320
    } else {
      this.navigationMode = NavigationMode.Stack
      this.mainNavContentWidth = this.currentBreakValue
    }
    hsLog.i(TAG,"tabContent navMode: " + this.navigationMode)
  }

  aboutToAppear(): void {
    hsLog.i(TAG,"aboutToAppear")

    this.currentTabInfo = this.tabIUState.tabInfo.getCurrentTab()
    this.navInfo = this.currentTabInfo?.getNavTitleConfig()
    this.navName = this.currentTabInfo?.getTabBottomBarConfig().navType ?? ""

    let localNavInfo = new TabNavTitleConfig()
    localNavInfo.title = "MM"
    localNavInfo.userAvatarInfo = new NavAvatarInfo(true,YWResImage.userAvatar(),()=>{
      let kk = ""
    })

    //   {
    //   isShow:true,
    //   icon:YWResImage.userAvatar(),
    //   onClick:()=>{
    //     let kk = ""
    //   }
    // }
    localNavInfo.titleInfo = new NavTitleInfo(this.navName ?? "",()=>{
      let kk = ""
    })

    //   {
    //   title:this.navName,
    //   onClick:()=>{
    //     let kk = ""
    //   }
    // }

    // localNavInfo.rightMenuInfos = {
    //   wrapItemBuilder:[]
    // }

    // setTimeout(()=>{
    //   this.navInfo.titleInfo!.title = "ggg"
    // },2000)
    //
    // this.navInfo = localNavInfo

    this.windowPointChange()
  }

  @Builder
  navDestPages(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(this.navName!)(name)?.builder(name,param)
  }

  @Builder
  contentBuilder() {

  }

  @Builder
  menuBuilder() {

  }

  build() {
    Navigation(ywNavManager.getNavStack(this.navName!)){

      Column(){
        //导航
        if (!this.navInfo?.hideNavBar)  {
          if (this.navInfo?.customNavBuilder) {
            this.navInfo.customNavBuilder.builder({})
          } else {
            YWMainNavBar({navInfo:this.navInfo})
              .backgroundColor(Color.Yellow)
          }

        }

        //内容显示
        Column(){
          if (this.currentTabInfo) {
            this.currentTabInfo.getTabNavConfig().navBuilder.builder(this.navName!, this.currentTabInfo.getTabNavParams())

          }
          // if (this.currentTabInfo?.index == 0) {
          //   mainHomeBuilder(this.navName!,new YWRouterNavParams())
          // } else if (this.currentTabInfo?.index == 1) {
          //   mainCategoryBuilder(this.navName!,new YWRouterNavParams())
          // } else if (this.currentTabInfo?.index == 2) {
          //   mainCarBuilder(this.navName!,new YWRouterNavParams())
          // } else if (this.currentTabInfo?.index == 3) {
          //   mainMineBuilder(this.navName!,new YWRouterNavParams())
          // }

        }
        .layoutWeight(1)
        .backgroundColor(Color.Gray)

        if (this.currentBreakValue < BreakpointTypeEnumValue.LG) {
          YWMainNavTabBar()
            //.backgroundColor(YWConstants.RandomColor())
            .width('100%')
          // //底部tab
          // Row(){
          //
          //   ForEach(this.tabIUState.tabInfo.mainNavList, (item: TabItemInfo) => {
          //     TabMainItemView({tabInfo:item})
          //       .onClick(()=>{
          //         if (this.tabEventState) {
          //           this.tabEventState.onClickIndex(this.tabIUState.tabInfo.getCurrentTab()!,item)
          //         }
          //       })
          //       .layoutWeight(1)
          //       .height(49)
          //     // .backgroundColor(YWConstants.RandomColor())
          //
          //   })
          // }
          // .height(YWConstants.kMainTabHeight)
          // .width('100%')
        }

      }
      .width('100%')
      .height('100%')

    }

    .onAppear(()=>{
      hsLog.i(TAG,'--onAppear')
    })
    .onDisAppear(()=>{
      hsLog.i(TAG,'--onDisAppear')

    })
    .hideTitleBar(true)
    // .hideNavBar(true)
    .navDestination(this.navDestPages)
    .mode(this.navigationMode)
    .navBarWidth(this.mainNavContentWidth)
    .navBarWidthRange([320,600])// 导航组件的最小宽度 320，最大宽度 600
    .minContentWidth(320)
    .width('100%')
    .height('100%')
    .onNavBarStateChange((isVisible: boolean) => {
      hsLog.i(TAG,"onNavBarStateChange: " + isVisible)
    })
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      this.mainContentWidth = Number(newValue.width ?? 320)
      hsLog.i(TAG,`Ace: on size change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
    })
  }
}

/*
       * Navigation - 导航组件
       *   mode() - 导航组件的显示模式（NavigationMode 枚举）
       *     Stack - 导航组件（Navigation）与导航目标页（NavDestination）之间独立显示，相当于两个页面
       *     Split - 导航组件（Navigation）与导航目标页（NavDestination）之间在一个面里，左右分栏显示
       *     Auto - 根据窗口宽度自动确定用 Stack 模式还是 Split 模式
       *   onNavigationModeChange() - 导航组件的显示模式发生变化时的回调
       *   navBarPosition() - 分栏显示时，导航组件的位置（NavBarPosition 枚举）
       *     Start - 导航组件在左侧显示
       *     End - 导航组件在右侧显示
       *   navBarWidthRange() - 分栏显示时，导航组件的最小宽度和最大宽度
       *   navBarWidth() - 分栏显示时，导航组件的默认宽度
       *   minContentWidth() - 分栏显示时，导航目标页（NavDestination）的最小宽度
       *   hideNavBar() - 是否隐藏导航组件
       *   onNavBarStateChange() - 导航组件的显示和隐藏状态发生变化时的回调
       *
       */

@Builder
export function maintTabContentViewBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    TabContentView({navName:params.params.get("navName") as string ?? ""})
  }
  .onBackPressed(()=>{
    router.back()
    return true
  })
  .hideTitleBar(true)
}