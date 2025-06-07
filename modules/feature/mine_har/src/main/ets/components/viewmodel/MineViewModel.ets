import { IUState, YWBaseModel } from "@learn/common_har"
import { YWLocalNavType, YWNavPath, ywNavRouter } from "@learn/nav_router_har"
import { HSAccountModel, HSUserInfoManager } from "@learn/userinfo_har"
import { MineMenuModel } from "../model/MineMenuModel"
import { MineServiceGroup, MineServiceModel } from "../model/MineServiceModel"

export class MineViewModel extends YWBaseModel<MineUIState> {
  iuState: MineUIState = new MineUIState()
  getUiUniqueId: ()=> number
  constructor(context:UIContext, getUniqueId: ()=>number) {
    super()
    this.getUiUniqueId = () =>{
      return getUniqueId()
    }
    this.iuState.accountInfo = HSUserInfoManager.getInstance().account
    this.handleOrderMenus()
    this.handServiceGroup()
  }

  handleOrderMenus() {

    let orderMenus:MineMenuModel[] = []
    for (let index = 0; index < 4; index++) {
      let item = new MineMenuModel()
      item.itemCount = 0
      item.index = index
      if (index == 0) {

        item.itemImage = $r("app.media.order_unPay")
        item.itemTitle = $r("app.string.Unpaid")
      }
      if (index == 1) {
        item.itemImage = $r("app.media.order_processing")
        item.itemTitle = $r("app.string.Processing")
      }
      if (index == 2) {
        item.itemImage = $r("app.media.order_shipped")
        item.itemTitle = $r("app.string.Shipped")
      }

      if (index == 3) {
        item.itemImage = $r("app.media.order_reviewed")
        item.itemTitle = $r("app.string.Reviewed")
      }

      orderMenus.push(item)
    }
    this.iuState.orderMenus = orderMenus
  }

  handServiceGroup() {
    let groups:MineServiceGroup[] = []
    for (let index = 0; index < 3; index++) {
      let serviceGroup:MineServiceGroup = new MineServiceGroup()
      groups.push(serviceGroup)

      if (index == 0) {
        serviceGroup.hasMore = true
      }
      serviceGroup.moreClick = ()=>{

      }
      serviceGroup.items = []
      for (let j = 0; j < 3; j++) {
        let serviceItem = new MineServiceModel()

        if (j == 0) {
          serviceItem.itemImage = $r("app.media.category_select")
          serviceItem.itemTitle = "消息"
        }
        else if (j == 1) {
          serviceItem.itemImage = $r("app.media.address_map")
          serviceItem.itemTitle = "地址"
        }
        else if (j == 2) {
          serviceItem.itemImage = $r("app.media.ic_public_help")
          serviceItem.itemTitle = "帮助"
        }

        if ( index ==  0) {
          if (j == 0) {
            serviceItem.itemImage = $r("app.media.tab_home_select")
            serviceItem.itemTitle = "文件"
            serviceItem.navPath = YWNavPath.mine_file_record
          }
          else if (j == 1) {
            serviceItem.itemImage = $r("app.media.address_map")
            serviceItem.itemTitle = "酒店"
            serviceItem.navPath = YWNavPath.root_hotel_nav
          }
          else if (j == 2) {
            serviceItem.itemImage = $r("app.media.ic_public_help")
            serviceItem.itemTitle = "帮助"
          }
        }


        serviceItem.itemClick = (item)=>{
          let uniqueId = this.getUiUniqueId?.()
          if (item.navPath) {
            ywNavRouter.openRoute(uniqueId)
              .onNavWayNav(YWLocalNavType.NAV_ROOT_MAIN_TAB)
              .onTargetUrl(item.navPath)
              .onRouteMode()
              .onOpenAnimation(true)
              .go()
          }

        }
        serviceGroup.items.push(serviceItem)
      }
    }
    this.iuState.services = groups
  }

}

@ObservedV2
export class MineUIState implements IUState {
  @Trace
  isLoading:boolean = true
  @Trace
  isShowTab:boolean = true
  @Trace
  isShowTitleBar:boolean = false
  @Trace
  accountInfo?:HSAccountModel
  @Trace
  orderMenus?: MineMenuModel[]
  @Trace
  services?: MineServiceGroup[]

}