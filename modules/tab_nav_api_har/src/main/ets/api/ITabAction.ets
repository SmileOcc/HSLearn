import { TabItemInfo } from "../bar/TabItemInfo";
import { ITabBadgeDelegate } from "../delegate/ITabBadgeDelegate";
import { ITabComponentDelegate } from "../delegate/ITabComponentDelegate";

export interface ITabAction {

  onFirstLoad:(itemInfo:TabItemInfo)=>void

  onBind:(itemInfo:TabItemInfo,titleController:ITabComponentDelegate)=>void
  onBindBadge:(itemInfo:TabItemInfo,badgeController:ITabBadgeDelegate)=>void


  //TODO
}