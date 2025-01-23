import { TabItemInfo } from "./TabItemInfo";

export interface ITabEventState{
  onClickIndex:((oldTabInfo:TabItemInfo,selectTabInfo:TabItemInfo)=>void)
  onDoubleClickIndex:((oldTabInfo:TabItemInfo,selectTabInfo:TabItemInfo)=>void)
}