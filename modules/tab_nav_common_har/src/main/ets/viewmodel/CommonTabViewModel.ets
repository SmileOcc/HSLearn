import { YWLocalNavType, ywNavRouter } from "@learn/nav_router_har";
import { TabItemInfo } from "../core/bar/TabItemInfo";
import { TabViewIUState } from "../core/bar/TabViewIUState";

export class TabMainViewModel {
  private viewModelState:TabViewIUState
  private componentId:number
  private navName:YWLocalNavType
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

    let fistItem = this.viewModelState.tabInfo.getFirstTab()

    ywNavRouter.openRoute(this.componentId)
      .onTargetUrl(fistItem!.navPath)
      // .onNavWayCurrent()
      .onNavWayNav(this.navName!)
      .onRouteMoveToTop()
      .onOpenAnimation(false)
      .go()
  }

  selectIndexTab(tabInfo:TabItemInfo) {

    ywNavRouter.openRoute(this.componentId)
      .onTargetUrl(tabInfo.navPath)
      .onRouteMoveToTop()
      .onOpenAnimation(false)
      .go()
  }

}