import { YWRouterNavParams, ywNavManager, YWLocalNavType } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { TabInfo, TabViewIUState, ITabEventState, TabItemInfo } from "@learn/tab_nav_api_har"
import { TabMainViewModel } from "../viewmodel/CommonTabViewModel"
import { YWLazy } from "@learn/global_service_har/src/main/ets/core/YWLazy"

import { ywMainTabManger } from "../MainTabManager"

const TAG = "CommonTabNavPage"
@Component
export struct CommonTabNavPage {

  params?:YWRouterNavParams
  navName?:YWLocalNavType
  @State navigationMode: number = NavigationMode.Stack;

  @Watch("tabStateChange")
  @Provide("CommonTabIUState") commonTabIUState:TabViewIUState = new TabViewIUState()

  @Provide("CommonITabEventState")
  commonTabEventState:ITabEventState = {
    onClickIndex:(oldTabInfo,selectTabInfo) => {

      this.commonTabIUState.tabInfo.updateSelectTab(selectTabInfo)

      this.viewModel.value.selectIndexTab(selectTabInfo)
    },
    onDoubleClickIndex:(oldTabInfo,selectTabInfo) => {

    }
  }

  viewModel:YWLazy<TabMainViewModel> = new YWLazy(()=>{
    return new TabMainViewModel(this.getUniqueId(), this.navName!, this.commonTabIUState)
  })

  //UI数据变化
  tabStateChange(value:string) {


  }

  aboutToAppear(): void {

    if (this.params) {
      this.commonTabIUState = this.params.params.get("tabInfo") as TabViewIUState
      this.navName = this.params.params.get("main_tab_nav") as YWLocalNavType
    }


    setTimeout(()=>{
      this.viewModel.value.init(this.getUniqueId())

    },3000)


  }

  onBackPress(){

    let kk = "d"
  }

  @Builder
  navDestPages(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(this.navName!)(name)?.builder(name,param)
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
        Navigation(ywNavManager.getNavStack(this.navName!)){

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
export function commonTabBuilder(params:YWRouterNavParams) {
  CommonTabNavPage({params:params})
}

@Builder
export function commonTabNavBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    CommonTabNavPage({params:params})
  }
  .hideTitleBar(true)
}