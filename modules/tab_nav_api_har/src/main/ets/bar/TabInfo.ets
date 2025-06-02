import { IUState } from "@learn/common_har"
import { ITabBottomBarConfig, ITabPageConfig } from "../../../../Index"
import { TabItemInfo } from "./TabItemInfo"

//TODO
// type MainTabNav:Map<string,string> = new Map<string,string>()

@Observed
export class TabInfo {
  mainNavList:ITabPageConfig[] = []
  navList:ITabPageConfig[] = []

  getNavList():ITabPageConfig[] {
    if (this.mainNavList.length>0) {
      return this.mainNavList
    }
    return this.navList
  }

  getFirstTab():ITabPageConfig | undefined {
    let pageConfig: ITabPageConfig | undefined = undefined
    if (this.mainNavList.length > 0) {
      pageConfig = this.mainNavList[0]
    } else if (this.navList.length>0) {
      pageConfig = this.navList[0]
    }
    if (pageConfig) {
      pageConfig.getTabBottomBarConfig().isSelected = true
    }
    return pageConfig
  }

  getTabWithConfigID(configId: string): ITabPageConfig | undefined {
    for (const item of this.mainNavList) {
      let navBottom = item.getTabBottomBarConfig()
      if (navBottom.cid == configId) {
        return item
      }
    }

    for (const item of this.navList) {
      let navBottom = item.getTabBottomBarConfig()
      if (navBottom.cid == configId) {
        return item
      }
    }

    return undefined
  }

  getCurrentTab():ITabPageConfig | undefined {
    for (const item of this.mainNavList) {
      let navBottom = item.getTabBottomBarConfig()
      if (navBottom.isSelected) {
        return item
      }
    }

    for (const item of this.navList) {
      let navBottom = item.getTabBottomBarConfig()
      if (navBottom.isSelected) {
        return item
      }
    }
    return undefined
  }

  updateSelectTab(tabInfo:ITabBottomBarConfig) {
    for (const item of this.mainNavList) {
      let navBottom = item.getTabBottomBarConfig()
      navBottom.isSelected = false
      if (navBottom.cid == tabInfo.cid) {
        navBottom.isSelected = true
      }
    }

    for (const item of this.navList) {
      let navBottom = item.getTabBottomBarConfig()
      navBottom.isSelected = false
      if (navBottom.cid == tabInfo.cid) {
        navBottom.isSelected = true
      }
    }
  }
}