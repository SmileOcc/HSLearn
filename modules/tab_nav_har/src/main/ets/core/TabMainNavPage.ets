import { YWNavParams, ywNavManager, YWLocalNavType } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { TabInfo } from "@learn/tab_nav_common_har"
import { TabMainViewModel } from "./viewmodel/TabMainViewModel"
import { YWLazy } from "@learn/global_service_har/src/main/ets/core/YWLazy"
import { TabViewIUState } from "@learn/tab_nav_common_har"
import { ITabEventState } from "@learn/tab_nav_common_har"
import { TabItemInfo } from "@learn/tab_nav_common_har"
import { ywMainTabManger } from "@learn/tab_nav_common_har"
import { router } from "@kit.ArkUI"

const TAG = "TabMainNavPage"
@Component
export struct TabMainNavPage {


  @State tabInfo:TabInfo = new TabInfo()
  @State navigationMode: number = NavigationMode.Stack;

  @Watch("tabStateChange")
  @Provide("tabIUState") tabIUState:TabViewIUState = new TabViewIUState()

  @Provide("ITabEventState")
  tabEventState:ITabEventState = {
    onClickIndex:(oldTabInfo,selectTabInfo) => {

      this.tabIUState.tabInfo.updateSelectTab(selectTabInfo)
      this.tabInfo = this.tabIUState.tabInfo

      this.viewModel.value.selectIndexTab(selectTabInfo)
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

  aboutToAppear(): void {

    let list = ywMainTabManger.maintTabList
    this.tabInfo.mainNavList = list
    this.tabIUState.tabInfo = this.tabInfo

    this.viewModel.value.init(this.getUniqueId())


  }

  onBackPress(): boolean | void {
    let kk = ""
  }

  @Builder
  navDestPages(name: string, param: YWNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_ROOT_MAIN_TAB)(name)?.builder(name,param)
  }

  build() {
    Row(){
      if (false) {
        Column(){

        }
        .height('100%')
        .width('60')
      }
      Stack() {
        Navigation(ywNavManager.getNavStack(YWLocalNavType.NAV_ROOT_MAIN_TAB)){



        }
        .hideTitleBar(true)
        .navDestination(this.navDestPages)
        .hideNavBar(true)
        .mode(this.navigationMode)
        .onAppear(()=>{
          hsLog.i(TAG,'--onAppear')
        })
        .onDisAppear(()=>{
          hsLog.i(TAG,'--onDisAppear')

        })
        .width('100%')
        .height('100%')
      }
      .layoutWeight(1)
      .height('100%')


    }
    .width('100%')
    .height('100%')

  }
}

@Builder
export function tabMainBuilder() {
  TabMainNavPage()
}

@Builder
export function tabMainNavBuilder(name:string, params:YWNavParams) {
 NavDestination(){
   TabMainNavPage()
 }
 .onBackPressed(()=>{
   router.back()
   return true
 })
 .hideTitleBar(true)
}