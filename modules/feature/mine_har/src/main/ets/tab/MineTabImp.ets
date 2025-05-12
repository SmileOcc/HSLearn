import { YWLocalNavType, YWNavPath } from "@learn/nav_router_har";
import { YWResColor, YWResImage, YWResString } from "@learn/res_har";
import { ITabAction,
  ITabBadgeDelegate,
  ITabBottomBarConfig,
  ITabComponentDelegate,
  ITabNavConfig, ITabPageConfig } from "@learn/tab_nav_api_har";
import { MineTabAction } from "./MineTabAction";

export class MineTabImp implements ITabPageConfig {

  badgeProxy?: ITabBadgeDelegate
  tabProxy?: ITabComponentDelegate

  private tabAction: MineTabAction = new MineTabAction()
  private bottomConfig?: MineBottomImp

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
      let config:MineBottomImp = new MineBottomImp(
        "mine_tab",
        YWResString.mainMine(),
        YWLocalNavType.NAV_MAIN_MINE,
        YWNavPath.main_tab_mine)
      config.normalColor = YWResColor.themeUnselect()
      config.selectColor = YWResColor.themeColor()
      config.selectImage = YWResImage.tab_mine_h()
      config.image = YWResImage.tab_mine()
      this.bottomConfig = config
    }

    return this.bottomConfig
  }

  getTabAction(): ITabAction {
    return this.tabAction
  }

}

export class MineBottomImp implements ITabBottomBarConfig {
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