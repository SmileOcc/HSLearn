import { YWLocalNavType, YWNavPath } from "@learn/nav_router_har";
import { YWResColor, YWResImage, YWResString } from "@learn/res_har";
import { ITabAction,
  ITabBadgeDelegate,
  ITabBottomBarConfig,
  ITabComponentDelegate,
  ITabNavConfig, ITabPageConfig } from "@learn/tab_nav_api_har";
import { CarTabAction } from "./CarTabAction";

export class CarTabImp implements ITabPageConfig {

  badgeProxy?: ITabBadgeDelegate
  tabProxy?: ITabComponentDelegate

  private tabAction: CarTabAction = new CarTabAction()
  private bottomConfig?: CarBottomImp

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
      let config:CarBottomImp = new CarBottomImp(
        "car_tab",
        YWResString.mainCar(),
        YWLocalNavType.NAV_MAIN_CAR,
        YWNavPath.main_tab_car)
      config.normalColor = YWResColor.themeUnselect()
      config.selectColor = YWResColor.themeColor()
      config.selectImage = YWResImage.tab_car_h()
      config.image = YWResImage.tab_car()
      this.bottomConfig = config
    }

    return this.bottomConfig
  }

  getTabAction(): ITabAction {
    return this.tabAction
  }

}

export class CarBottomImp implements ITabBottomBarConfig {
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