import { YWRouterNavParams } from "@learn/nav_router_har";
import { ITabAction, ITabBadgeDelegate, ITabComponentDelegate, TabItemInfo } from "@learn/tab_nav_api_har";
import { mainHomeBuilder } from "../components/MainHomePage";


export const MainHomeBuilder = wrapBuilder(mainHomeBuilder)



export class HomeTabAction implements ITabAction {

  private badgerControllerProxy?: ITabBadgeDelegate
  private tabItemInfo?: TabItemInfo

  onFirstLoad = (itemInfo: TabItemInfo) => {

  }
  onBind = (itemInfo: TabItemInfo, titleController: ITabComponentDelegate) => {


  }
  onBindBadge = (itemInfo: TabItemInfo, badgeController: ITabBadgeDelegate) => {
    this.tabItemInfo = itemInfo
    this.badgerControllerProxy = badgeController
  };

  getTabBuilder(): WrappedBuilder<[name: string, params: YWRouterNavParams]> {
    return MainHomeBuilder
  }

}