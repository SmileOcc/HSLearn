import { TabItemInfo } from "../bar/TabItemInfo";

export interface ITabBadgeHandle {

  init(tabItem:TabItemInfo):void

  onDestroy():void
}