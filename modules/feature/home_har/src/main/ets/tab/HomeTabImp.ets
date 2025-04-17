import { YWNavPath } from "@learn/nav_router_har";
import { YWResColor, YWResImage, YWResString } from "@learn/res_har";
import { ITabAction,
  ITabBadgeDelegate,
  ITabBottomBarConfig,
  ITabComponentDelegate,
  ITabNavConfig, ITabPageConfig } from "@learn/tab_nav_api_har";
import { HomeTabAction, MainHomeBuilder } from "./HomeTabAction";

export class HomeTabImp implements ITabPageConfig {

  badgeProxy?: ITabBadgeDelegate
  tabProxy?: ITabComponentDelegate

  private tabAction: HomeTabAction = new HomeTabAction()

  getTabKey(): string {
    throw new Error("Method not implemented.");
  }

  getTabNavConfig(): ITabNavConfig {
    return {
      navPath:YWNavPath.main_tab_home,
      navBuilder:MainHomeBuilder
    }
  }

  getTabBottomBarConfig(): ITabBottomBarConfig {
    return {
      title: YWResString.mainHome(),
      selectColor: YWResColor.themeColor(),
      normalColor: YWResColor.themeUnselect(),
      image: YWResImage.tab_home(),
      selectImage: YWResImage.tab_home_h()
    }
  }

  getTabAction(): ITabAction {
    return this.tabAction
  }

}