import { IUState } from "@learn/common_har";
import { TabInfo } from "./TabInfo";

@Observed
export class TabViewIUState implements IUState {
  count:number = 0
  currentIndex:number = 0
  tabInfo:TabInfo = new TabInfo()
}
