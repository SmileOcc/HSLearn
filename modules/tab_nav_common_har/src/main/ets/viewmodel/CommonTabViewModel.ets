import { YWLocalNavType, ywNavRouter } from "@learn/nav_router_har";
import { TabItemInfo, TabViewIUState, ITabComponentDelegate, ITabBottomBarConfig } from "@learn/tab_nav_api_har";

export class TabMainViewModel {
  private viewModelState:TabViewIUState
  private componentId:number
  private navName:YWLocalNavType

  private tabDelegate?:ITabComponentDelegate
  constructor(componentId:number, navName:YWLocalNavType, viewState:TabViewIUState) {

    this.componentId = componentId
    this.navName = navName
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

    let fistItem = this.viewModelState.tabInfo.getFirstTab()?.getTabBottomBarConfig()
    if (fistItem) {
      this.bindTabAction(fistItem)
      ywNavRouter.openRoute(this.componentId)
        .onTargetUrl(fistItem!.navPath)
          // .onNavWayCurrent()
        .onNavWayNav(this.navName!)
        .onRouteMoveToTop()
        .onOpenAnimation(false)
        .go()
    } else {

    }

  }

  selectIndexTab(tabInfo:ITabBottomBarConfig) {

    ywNavRouter.openRoute(this.componentId)
      .onTargetUrl(tabInfo.navPath)
      .onRouteMoveToTop()
      .onOpenAnimation(false)
      .go()
  }


  bindTabAction(tabInfo: ITabBottomBarConfig) {
    tabInfo.itemImage()
  }
}