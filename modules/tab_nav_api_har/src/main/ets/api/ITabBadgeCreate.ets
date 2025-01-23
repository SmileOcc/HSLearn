import { TabItemInfo } from "../bar/TabItemInfo";
import { ITabBadgeHandle } from "./ITabBadgeHandle";

export interface ITabBadgeCreate {
  create(tabItem:TabItemInfo, userSeeison:Object | undefined):ITabBadgeHandle
}