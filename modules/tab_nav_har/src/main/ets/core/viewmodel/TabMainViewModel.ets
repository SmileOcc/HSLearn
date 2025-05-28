import { ywNavRouter } from "@learn/nav_router_har";
import { YWNavParamsKey } from "@learn/nav_router_har/src/main/ets/components/YWNavType";
import { ITabAction, ITabBottomBarConfig, ITabComponentDelegate, TabItemInfo } from "@learn/tab_nav_api_har";
import { TabViewIUState } from "@learn/tab_nav_api_har";
import { ywMainTabManger } from "@learn/tab_nav_common_har";

export class TabMainViewModel {
  private viewModelState:TabViewIUState
  private componentId:number

  tabDelegate?:ITabComponentDelegate

  private bindTabActionMap:Map<string,ITabAction> = new Map()

  constructor(componentId:number, viewState:TabViewIUState) {
    this.componentId = componentId
    this.viewModelState = viewState
  }

  init(componentId:number) {
    this.componentId = componentId

    this.load()
  }

  load(){
    let list = ywMainTabManger.maintTabList
    this.viewModelState.tabInfo.mainNavList = list
    this.showFirstTab()
  }

  showFirstTab() {

    let fistItem = this.viewModelState.tabInfo.mainNavList[0]
    fistItem.getTabBottomBarConfig().isSelected = true

    ywNavRouter.openRoute(this.componentId)
      .onTargetUrl(fistItem.getTabBottomBarConfig().navPath)
      .onUrlKey(fistItem.getTabBottomBarConfig().navPath)
      .onRouteMoveToTop()
      .onOpenAnimation(false)
      .go()
  }

  selectIndexTab(tabInfo:ITabBottomBarConfig) {

    ywNavRouter.openRoute(this.componentId)
      .onTargetUrl(tabInfo.navPath)
      .onUrlKey(tabInfo.navPath)
      .onRouteMoveToTop()
      .onOpenAnimation(false)
      .go()
  }

  bindNavTitle(tabItem:TabItemInfo) {

  }

  bindNavBar(tabItem:TabItemInfo) {

  }

  bindTabAction(navType: string, tabItem:TabItemInfo) {
    if (!this.bindTabActionMap.has(navType)) {
      // let tabAction =
      this.bindTabActionMap.set(navType, tabItem.tabActionProxy!)
    }
  }

  // createTabAction(): ITabAction {
  //   let
  // }
}