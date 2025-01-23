import { ywNavRouter } from "@learn/nav_router_har";
import { YWNavParamsKey } from "@learn/nav_router_har/src/main/ets/components/YWNavType";
import { ITabComponentDelegate, TabItemInfo } from "@learn/tab_nav_api_har";
import { TabViewIUState } from "@learn/tab_nav_api_har";
import { ywMainTabManger } from "@learn/tab_nav_common_har";

export class TabMainViewModel {
  private viewModelState:TabViewIUState
  private componentId:number

  tabDelegate?:ITabComponentDelegate

  constructor(componentId:number, viewState:TabViewIUState) {
    this.componentId = componentId
    this.viewModelState = viewState
  }

  init(componentId:number) {
    this.componentId = componentId

    this.load()
  }

  load(){

    this.showFirstTab()
  }

  showFirstTab() {

    let fistItem = this.viewModelState.tabInfo.mainNavList[0]

    ywNavRouter.openRoute(this.componentId)
      .onTargetUrl(fistItem.navPath)
      // .onUrlKey(fistItem.navPath)
      .onRouteMoveToTop()
      .onOpenAnimation(false)
      .go()
  }

  selectIndexTab(tabInfo:TabItemInfo) {

    ywNavRouter.openRoute(this.componentId)
      .onTargetUrl(tabInfo.navPath)
      .onUrlKey(tabInfo.navPath)
      .onRouteMoveToTop()
      .onOpenAnimation(false)
      .go()
  }

}