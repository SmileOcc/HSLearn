import { TabItemInfo } from "../bar/TabItemInfo";
import { ITabBadgeHandle } from "./ITabBadgeHandle";

export interface ITabBadgeCreate {
  create(tabItem:TabItemInfo, userSession:Object | undefined):ITabBadgeHandle
}