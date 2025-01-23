import { IUState } from "@learn/common_har"
import { TabItemInfo } from "./TabItemInfo"

//TODO
// type MainTabNav:Map<string,string> = new Map<string,string>()

@Observed
export class TabInfo {
  mainNavList:TabItemInfo[] = []
  navList:TabItemInfo[] = []

  getNavList():TabItemInfo[] {
    if (this.mainNavList.length>0) {
      return this.mainNavList
    }
    return this.navList
  }

  getFirstTab():TabItemInfo | undefined {
    if (this.mainNavList.length > 0) {
      return this.mainNavList[0]
    } else if (this.navList.length>0) {
      return this.navList[0]
    }
    return undefined
  }

  getCurrentTab():TabItemInfo | undefined {
    for (const item of this.mainNavList) {
      if (item.isSelected) {
        return item
      }
    }

    for (const item of this.navList) {
      if (item.isSelected) {
        return item
      }
    }
    return undefined
  }

  updateSelectTab(tabInfo:TabItemInfo) {
    for (const item of this.mainNavList) {
      item.isSelected = false
      if (item.cid == tabInfo.cid) {
        item.isSelected = true
      }
    }

    for (const item of this.navList) {
      item.isSelected = false
      if (item.cid == tabInfo.cid) {
        item.isSelected = true
      }
    }
  }
}