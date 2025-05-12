import { YWRouterNavParams } from "@learn/nav_router_har";
import { ITabAction, ITabBadgeDelegate, ITabComponentDelegate, TabItemInfo } from "@learn/tab_nav_api_har";
import { mainCategoryBuilder } from "../components/MainCategoryPage";


export const MainCategoryBuilder = wrapBuilder(mainCategoryBuilder)



export class CategoryTabAction implements ITabAction {

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
    return MainCategoryBuilder
  }

}