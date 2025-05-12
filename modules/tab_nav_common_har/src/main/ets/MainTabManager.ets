import { CarTabImp } from "@learn/car_har"
import { CategoryTabImp } from "@learn/category_har"
import { HomeTabImp } from "@learn/home_har"
import { MineTabImp } from "@learn/mine_har"
import { YWNavPath } from "@learn/nav_router_har/src/main/ets/components/YWNavPath"
import { YWLocalNavType } from "@learn/nav_router_har/src/main/ets/components/YWNavType"
import { YWResImage } from "@learn/res_har"
import { ITabAction, ITabBottomBarConfig, ITabNavConfig, ITabPageConfig, TabItemInfo } from "@learn/tab_nav_api_har"

const MainTabList:Map<YWLocalNavType,YWNavPath> = new Map([
  [YWLocalNavType.NAV_MAIN_HOME,YWNavPath.main_tab_home],
  [YWLocalNavType.NAV_MAIN_CATEGORY,YWNavPath.main_tab_category],
  [YWLocalNavType.NAV_MAIN_CAR,YWNavPath.main_tab_car],
  [YWLocalNavType.NAV_MAIN_MINE,YWNavPath.main_tab_mine],

])

export class MainTabManager {

  maintTabList:ITabPageConfig[] = []
  otherTabList:ITabPageConfig[] = []

  constructor() {

    // for (const itemInfo of MainTabList) {
    //   let item = new TabItemInfo()
    //   item.cid = itemInfo[0]
    //   item.navPath = itemInfo[1]
    //   item.title = "aaa"
    //   this.maintTabList.push(item)
    // }

    MainTabList.forEach((path, type)=> {

      let pageConfig: ITabPageConfig

      // let item = new TabItemInfo()
      // item.cid = type
      // item.navPath = path
      // item.navType = type

      if (type === YWLocalNavType.NAV_MAIN_HOME) {
        pageConfig = new HomeTabImp()
        //
        // item.title = "首页"
        // item.image = YWResImage.tab_home()
        // item.selectImage = YWResImage.tab_home_h()
        // item.isSelected = true
        // item.index = 0
        this.maintTabList.push(pageConfig)

      } else if (type === YWLocalNavType.NAV_MAIN_CATEGORY) {
        pageConfig = new CategoryTabImp()

        // item.title = "分类"
        // item.image = YWResImage.tab_category()
        // item.selectImage = YWResImage.tab_category_h()
        // item.index = 1
        this.maintTabList.push(pageConfig)

      } else if (type === YWLocalNavType.NAV_MAIN_CAR) {
        pageConfig = new CarTabImp()
        // item.title = "购物车"
        // item.image = YWResImage.tab_car()
        // item.selectImage = YWResImage.tab_car_h()
        // item.index = 2
        this.maintTabList.push(pageConfig)

      } else if (type === YWLocalNavType.NAV_MAIN_MINE) {
        pageConfig = new MineTabImp
        // item.title = "我的"
        // item.image = YWResImage.tab_mine()
        // item.selectImage = YWResImage.tab_mine_h()
        // item.index = 3
        this.maintTabList.push(pageConfig)

      }
      // else if (i == 4) {
      //   item.title = "首页"
      //   item.normalImage = YWResImage.tab_home()
      //   item.selectImage = YWResImage.tab_home_h()
      // }
    })

  }

  bindTabAction(navType: YWLocalNavType, tabAction: ITabAction) {
    for (let item of this.maintTabList) {
      let bottomNav = item.getTabBottomBarConfig()
      if (bottomNav.navType === navType && !bottomNav.tabActionProxy) {
        bottomNav.tabActionProxy = tabAction
      }
    }
  }

  getTabNavConfig(navType: YWLocalNavType): ITabNavConfig | undefined {
    let bottomNav = this.maintTabList.find((item)=>{
      let bottomNav = item.getTabBottomBarConfig()
      return bottomNav.navType === navType
    })
    return bottomNav?.getTabNavConfig()
  }


  getTabAction(navType: YWLocalNavType): ITabBottomBarConfig | undefined {
    let bottomNav = this.maintTabList.find((item)=>{
      let bottomNav = item.getTabBottomBarConfig()
      return bottomNav.navType === navType
    })
    return bottomNav?.getTabBottomBarConfig()
  }
}

export const ywMainTabManger = new MainTabManager()