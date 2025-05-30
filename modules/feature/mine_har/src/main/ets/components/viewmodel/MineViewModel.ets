import { IUState, YWBaseModel } from "@learn/common_har"
import { HSAccountModel, HSUserInfoManager } from "@learn/userinfo_har"
import { MineMenuModel } from "../model/MineMenuModel"
import { MineServiceGroup, MineServiceModel } from "../model/MineServiceModel"

export class MineViewModel extends YWBaseModel<MineUIState> {
  iuState: MineUIState = new MineUIState()
  constructor(context:UIContext) {
    super()
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
          serviceItem.itemImage = $r("app.media.account_message")
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

        serviceItem.itemClick = ()=>{

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