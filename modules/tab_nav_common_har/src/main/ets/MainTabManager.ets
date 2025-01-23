import { YWNavPath } from "@learn/nav_router_har/src/main/ets/components/YWNavPath"
import { YWLocalNavType } from "@learn/nav_router_har/src/main/ets/components/YWNavType"
import { YWResImage } from "@learn/res_har"
import { TabItemInfo } from "@learn/tab_nav_api_har"

const MainTabList:Map<YWLocalNavType,YWNavPath> = new Map([
  [YWLocalNavType.NAV_MAIN_HOME,YWNavPath.main_tab_home],
  [YWLocalNavType.NAV_MAIN_CATEGORY,YWNavPath.main_tab_category],
  [YWLocalNavType.NAV_MAIN_CAR,YWNavPath.main_tab_car],
  [YWLocalNavType.NAV_MAIN_MINE,YWNavPath.main_tab_mine],

])

export class MainTabManager {

  maintTabList:TabItemInfo[] = []
  otherTabList:TabItemInfo[] = []

  constructor() {

    // for (const itemInfo of MainTabList) {
    //   let item = new TabItemInfo()
    //   item.cid = itemInfo[0]
    //   item.navPath = itemInfo[1]
    //   item.title = "aaa"
    //   this.maintTabList.push(item)
    // }

    MainTabList.forEach((path, type)=> {

      let item = new TabItemInfo()
      item.cid = type
      item.navPath = path
      item.navType = type

      if (type === YWLocalNavType.NAV_MAIN_HOME) {
        item.title = "首页"
        item.normalImage = YWResImage.tab_home()
        item.selectImage = YWResImage.tab_home_h()
        item.isSelected = true
        item.index = 0
      } else if (type === YWLocalNavType.NAV_MAIN_CATEGORY) {
        item.title = "分类"
        item.normalImage = YWResImage.tab_category()
        item.selectImage = YWResImage.tab_category_h()
        item.index = 1
      } else if (type === YWLocalNavType.NAV_MAIN_CAR) {
        item.title = "购物车"
        item.normalImage = YWResImage.tab_car()
        item.selectImage = YWResImage.tab_car_h()
        item.index = 2
      } else if (type === YWLocalNavType.NAV_MAIN_MINE) {
        item.title = "我的"
        item.normalImage = YWResImage.tab_mine()
        item.selectImage = YWResImage.tab_mine_h()
        item.index = 3
      }
      // else if (i == 4) {
      //   item.title = "首页"
      //   item.normalImage = YWResImage.tab_home()
      //   item.selectImage = YWResImage.tab_home_h()
      // }

      this.maintTabList.push(item)
    })

  }
}

export const ywMainTabManger = new MainTabManager()