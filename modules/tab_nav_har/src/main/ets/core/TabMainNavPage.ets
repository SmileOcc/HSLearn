import { YWRouterNavParams, ywNavManager, YWLocalNavType } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { ITabComponentDelegate, NavMenuInfo, NavTitleInfo, TabInfo, TabNavTitleConfig } from "@learn/tab_nav_api_har"
import { TabMainViewModel } from "./viewmodel/TabMainViewModel"
import { YWLazy } from "@learn/global_service_har/src/main/ets/core/YWLazy"
import { TabViewIUState } from "@learn/tab_nav_api_har"
import { ITabEventState } from "@learn/tab_nav_api_har"
import { TabItemInfo } from "@learn/tab_nav_api_har"
import { ywMainTabManger } from "@learn/tab_nav_common_har"
import { router } from "@kit.ArkUI"
import { NavAvatarInfo } from "@learn/tab_nav_api_har"
import { YWConstants } from "@learn/constants_har"
import { BreakpointTypeEnumValue, BreakpointTypeValue } from "@learn/common_har"
import { YWMainNavTabBar } from "./tabbar/YWMainNavTabBar"

const TAG = "TabMainNavPage"
@Component
export struct TabMainNavPage {

  tabDelegate?:ITabComponentDelegate


  @Watch('windowPointChange')
  @StorageProp(YWConstants.kCurrentBreakpoint)
  currentBreakpoint: string = 'sm'

  @StorageProp(YWConstants.kCurrentBreakpointValue)
  currentBreakValue:BreakpointTypeEnumValue = 320

  @Provide('mainNavWidth')
  mainNavWidth: number = 320

  @State navigationMode: number = NavigationMode.Stack;

  @State navInfo:TabNavTitleConfig = new TabNavTitleConfig()

  //共享状态，子组件通过Consume 读取数据
  @Provide tabInfo:TabInfo = new TabInfo()

  @Watch("tabStateChange")
  @Provide("tabIUState") tabIUState:TabViewIUState = new TabViewIUState()

  @Provide("titleInfo") titleInfo:NavTitleInfo = this.navInfo.titleInfo
  @Provide("userAvatarInfo") userAvatarInfo:NavAvatarInfo = this.navInfo.userAvatarInfo
  @Provide("rightMenuInfos") rightMenuInfos:NavMenuInfo = this.navInfo.rightMenuInfos

  @Provide("ITabEventState")
  tabEventState:ITabEventState = {
    onClickIndex:(oldTabInfo,selectTabInfo) => {

      this.tabIUState.tabInfo.updateSelectTab(selectTabInfo)
      this.tabInfo = this.tabIUState.tabInfo

      this.viewModel.value.selectIndexTab(oldTabInfo, selectTabInfo)
    },
    onDoubleClickIndex:(oldTabInfo,selectTabInfo) => {

    }
  }

  viewModel:YWLazy<TabMainViewModel> = new YWLazy(()=>{
    return new TabMainViewModel(this.getUniqueId(), this.tabIUState)
  })

  //UI数据变化
  tabStateChange(value:string) {

    if (this.tabIUState.tabInfo !== this.tabInfo) {

    }
  }

  windowPointChange() {
    // this.currentBreakValue = BreakpointTypeValue(this.currentBreakpoint)
    hsLog.i(TAG,`currentBreakpoint: ${this.currentBreakpoint}  -- ${this.currentBreakValue}`)
  }

  aboutToAppear(): void {
    this.viewModel.value.init(this.getUniqueId())
    this.tabInfo = this.tabIUState.tabInfo
  }

  onBackPress(): boolean | void {
    let kk = ""
  }

  @Builder
  navDestPages(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_ROOT_MAIN_TAB)(name)?.builder(name,param)
  }

  build() {
    Row(){
      if (this.currentBreakValue >= BreakpointTypeEnumValue.LG) {//大型设备

        YWMainNavTabBar({isVertical: true})
          .backgroundColor(YWConstants.RandomColor())
          .height('100%')
      }
      Navigation(ywNavManager.getNavStack(YWLocalNavType.NAV_ROOT_MAIN_TAB)){



      }
      .id(YWLocalNavType.NAV_ROOT_MAIN_TAB)
      .hideTitleBar(true)
      .hideNavBar(true)
      .navDestination(this.navDestPages)
      .mode(this.navigationMode)
      .onAppear(()=>{
        hsLog.i(TAG,'--onAppear')
      })
      .onDisAppear(()=>{
        hsLog.i(TAG,'--onDisAppear')

      })
      .layoutWeight(1)
      .height('100%')
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
        this.mainNavWidth = Number(newValue.width ?? 320)
        hsLog.i(TAG,`Ace: on size change, oldValue is ${JSON.stringify(oldValue)} value is ${JSON.stringify(newValue)}`)
      })

    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])


  }
}

@Builder
export function tabMainBuilder() {
  TabMainNavPage()
}

@Builder
export function tabMainNavBuilder(name:string, params:YWRouterNavParams) {
 NavDestination(){
   TabMainNavPage()
 }
 .onShown(()=>{
   hsLog.d(TAG,'main onShown')
 })
 .onHidden(()=>{
   hsLog.d(TAG,'main onHidden')

 })
 .onWillDisappear(()=>{
   hsLog.d(TAG,'main onWillDisappear')

 })
 .onDisAppear(()=>{
   hsLog.d(TAG,'main onDisAppear')

 })
 .onBackPressed(()=>{
   router.back()
   return true
 })
 .hideTitleBar(true)
}