import { YWLocalNavType, YWNavPath } from "@learn/nav_router_har";
import { YWResColor, YWResImage, YWResString } from "@learn/res_har";
import { ITabAction,
  ITabBadgeDelegate,
  ITabBottomBarConfig,
  ITabComponentDelegate,
  ITabNavConfig,
  ITabNavTitleConfig,
  ITabPageConfig,
  NavAvatarInfo,
  NavBackInfo,
  NavTitleInfo} from "@learn/tab_nav_api_har";
import { HomeNavBarBuilder } from "../components/view/HomeNavBar/HomeNavBar";
import { HomeNavTitleImp } from "./HomeNavTitleImp";
import { HomeTabAction } from "./HomeTabAction";

//如果有动态网络数据，可以获取后存全局，在这里单独取 （推荐）
//或者 在全局使用 这些数据是，与网络本地数据比较，替换
export class HomeTabImp implements ITabPageConfig {

  badgeProxy?: ITabBadgeDelegate
  tabProxy?: ITabComponentDelegate

  private tabAction: HomeTabAction = new HomeTabAction()
  private bottomConfig?: HomeBottomImp

  getTabKey(): string {
    throw new Error("Method not implemented.");
  }

  getTabNavConfig(): ITabNavConfig {
    return {
      navPath:YWNavPath.main_tab_home,
      navBuilder:this.tabAction.getTabBuilder()
    }
  }

  getTabBottomBarConfig(): ITabBottomBarConfig {
    if (!this.bottomConfig) {
      let config:HomeBottomImp = new HomeBottomImp(
        "home_tab",
        YWResString.mainHome(),
        YWLocalNavType.NAV_MAIN_HOME,
        YWNavPath.main_tab_home)
      config.normalColor = YWResColor.themeUnselect()
      config.selectColor = YWResColor.themeColor()
      config.selectImage = YWResImage.tab_home_h()
      config.image = YWResImage.tab_home()
      this.bottomConfig = config
    }

    return this.bottomConfig
  }

  getTabAction(): ITabAction {
    return this.tabAction
  }


  getNavTitleConfig(): ITabNavTitleConfig {
    let titleConfig: HomeNavTitleImp = new HomeNavTitleImp(
      false,"home",
      new NavBackInfo(),
      new NavAvatarInfo(false,undefined),
      new NavTitleInfo(""),
      undefined,
      undefined)
    titleConfig.customNavBuilder = HomeNavBarBuilder
    return titleConfig
  }
}

export class HomeBottomImp implements ITabBottomBarConfig {
  cid: string;
  image?: ResourceStr | undefined;
  selectImage?: ResourceStr | undefined;
  title: ResourceStr;
  selectColor?: ResourceColor | undefined;
  normalColor?: ResourceColor | undefined;
  badge?: number | undefined;
  navType: string;
  navPath: string;
  isSelected:boolean = false

  constructor(cid: string, title: ResourceStr, navType: string, navPath: string) {
    this.cid = cid
    this.title = title
    this.navType = navType
    this.navPath = navPath
  }

  titleColor():ResourceColor {
    return this.isSelected ? YWResColor.themeColor() : YWResColor.tabNormalColor()
  }

  itemImage():ResourceStr {
    return (this.isSelected ? this.selectImage : this.image) ?? YWResImage.appIcon()
  }

}