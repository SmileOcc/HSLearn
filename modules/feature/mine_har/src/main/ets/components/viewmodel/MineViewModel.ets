import { IUState, YWBaseModel } from "@learn/common_har"
import { YWLocalNavType, YWNavPath, ywNavRouter } from "@learn/nav_router_har"
import { HSRegisterNetworkListener } from "@learn/network_har"
import { HSAccountModel, HSUserInfoManager } from "@learn/userinfo_har"
import { MineMenuModel } from "../model/MineMenuModel"
import { MineServiceGroup, MineServiceModel } from "../model/MineServiceModel"
import { MineColorImagePlugin } from "../plugin/MineColorImagePlugin"


// https://qcloud.dpfile.com/pc/q_Qx58ILWQ41BJKbmcHbfs0Z_-IwdlIFQB0p6JafKZzvSIezIF9PLMHM34718MRQ.jpg
// https://iphoto.mac89.com/photo/2020/01/06/JPG-200106_19/EW0maxFaI9_small.jpg
//https://img0.baidu.com/it/u=1391428208,2876911355&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500
//https://preview.qiantucdn.com/58pic/20240516/00C58PICR66UPNbQu15b4_PIC2018_PIC2018.jpg%21qt_h320
//https://img0.baidu.com/it/u=3059587418,1062339922&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1552
// https://inews.gtimg.com/om_bt/O6SG7dHjdG0kWNyWz6WPo2_3v6A6eAC9ThTazwlKPO1qMAA/641
//https://img1.baidu.com/it/u=2172818577,3783888802&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1422
export class MineViewModel extends YWBaseModel<MineUIState> {
  iuState: MineUIState = new MineUIState()
  getUiUniqueId?: ()=> number

  private bgImages:ResourceStr[] = [
    $r('app.media.bg_small_0'),
    $r('app.media.bg_big_0'),
    $r('app.media.bg_small_1'),
    $r('app.media.bg_small_2')]

  private bgNetImages:ResourceStr[] = [
    'https://iphoto.mac89.com/photo/2020/01/06/JPG-200106_19/EW0maxFaI9_small.jpg',
    'https://qcloud.dpfile.com/pc/q_Qx58ILWQ41BJKbmcHbfs0Z_-IwdlIFQB0p6JafKZzvSIezIF9PLMHM34718MRQ.jpg',
    'https://img0.baidu.com/it/u=1391428208,2876911355&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500',
    'https://preview.qiantucdn.com/58pic/20240516/00C58PICR66UPNbQu15b4_PIC2018_PIC2018.jpg%21qt_h320']

  private imagePlugin?: MineColorImagePlugin

  incrementAction() {
  }

  increment:()=>void

  constructor() {
    super()
    // 提前绑定，避免重复创建
    this.increment = this.incrementAction.bind(this);
  }

  init(uiContext:UIContext, context: Context,getUniqueId: ()=>number) {
    this.imagePlugin =  new MineColorImagePlugin(context)
    this.getUiUniqueId = () =>{
      return getUniqueId()
    }
    this.iuState.accountInfo = HSUserInfoManager.getInstance().account
    this.handleOrderMenus()
    this.handServiceGroup()

    // this.imagePlugin.loadImage($r('app.media.bg_big_0'),(sourceUrl,localUrl,bgColor,bgAlpha)=>{
    //   if (this.iuState.imageTheme == undefined) {
    //     this.iuState.imageTheme = new MineTheme()
    //   }
    //   this.iuState.imageTheme.localImageUrl = localUrl
    //   this.iuState.imageTheme.bgColor = bgColor
    // })
  }

  getRandom(){
    return Math.floor(Math.random() * 4)
  }

  loadMineInfo(){
    let imageIndex = this.getRandom()
    let imgs = HSRegisterNetworkListener.isCheckNetworkAvailable() ? this.bgNetImages : this.bgImages
    if (imgs.length > imageIndex) {
      const imgUrl = imgs[imageIndex]
      this.handBgImage(imgUrl)
    }
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
            serviceItem.itemImage = $r("app.media.address_map")
            serviceItem.itemTitle = "地址"
            serviceItem.navPath = YWNavPath.root_address_nav
          }
        }

        if (j == 0) {
          serviceItem.borderRadius = 1
        } else if (j == 2) {
          serviceItem.borderRadius = 2
        }


        serviceItem.itemClick = (item)=>{
          let uniqueId = this.getUiUniqueId?.() ?? 0
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

  handBgImage(url: ResourceStr) {
    if (this.imagePlugin && this.imagePlugin.sourceUrl != url) {

      this.imagePlugin.loadImage(url,(sourceUrl,localUrl,bgColor,bgAlpha)=>{
        if (this.iuState.imageTheme == undefined) {
          this.iuState.imageTheme = new MineTheme()
        }
        this.iuState.imageTheme.localImageUrl = localUrl
        this.iuState.imageTheme.bgColor = bgColor
      })
    }
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
  @Trace
  navBarAlpha: number = 0
  @Trace
  imageTheme?: MineTheme

}

@ObservedV2
export class MineTheme {
  @Trace
  imageUrl: ResourceStr = ""
  @Trace
  localImageUrl: ResourceStr = ""
  @Trace
  bgColor?: string
}