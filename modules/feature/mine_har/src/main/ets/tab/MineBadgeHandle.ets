import { ITabBadgeCreate, ITabBadgeHandle, TabItemInfo } from "@learn/tab_nav_api_har";

export class MineBadgeHandle implements ITabBadgeCreate {
  create(tabItem: TabItemInfo, userSession: Object | undefined): ITabBadgeHandle {
    let tabHandle = new TabBadgeHandle()
    return tabHandle
  }

}

export class TabBadgeHandle implements ITabBadgeHandle {
  init(tabItem: TabItemInfo): void {

  }

  onDestroy(): void {

  }

}