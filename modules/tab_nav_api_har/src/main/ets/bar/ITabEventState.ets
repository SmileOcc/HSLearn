import { ITabBottomBarConfig } from "../config/ITabBottomBarConfig";
import { TabItemInfo } from "./TabItemInfo";

export interface ITabEventState{
  onClickIndex:((oldTabInfo:ITabBottomBarConfig,selectTabInfo:ITabBottomBarConfig)=>void)
  onDoubleClickIndex:((oldTabInfo:ITabBottomBarConfig,selectTabInfo:ITabBottomBarConfig)=>void)
}