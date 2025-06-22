// import { LitheRefresh, RefreshController } from "@abner/lithe_refresh_v2";
import { ListView, RefreshController } from "@abner/refresh_v2";
import { YWBaseNavBar } from "@learn/baseui_har";
import { YWNavPath, ywNavRouter, YWRouterNavParams } from "@learn/nav_router_har";
import { HSAddressModel } from "./model/HSAddressModel";
import { AddressDetailSheet } from "./view/AddressDetailSheet";
import { HSAddressViewModel } from "./viewmodel/HSAddressViewModel";

@Builder
export function addressListBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    AddressListPage()
  }
  .hideTitleBar(true)
}

@ComponentV2
export struct AddressListPage {

  addressViewModel: HSAddressViewModel = new HSAddressViewModel()
  @Local addConfirmTitle: string = "新增地址"
  @Local addressData:HSAddressModel[] = []
  @Local showSheetAddress: boolean = false
  selectItem?: HSAddressModel

  @Param addClick?:()=>void = undefined

  scroller: Scroller = new Scroller()
  controller: RefreshController = new RefreshController()

  aboutToAppear(): void {
    this.addressViewModel.getAddressList()
      .then(value => {

        console.log('========== room return')
        this.addressData = this.addressData.concat(value)


        // this.isLoading = false
        // this.isMore = false
        //
        // this.testLoadCount++
        // if (value && value.length >= YWConstants.kPageSize10) {
        //   this.isMore = true
        //   if (this.testLoadCount > 3) {
        //     this.isMore = false
        //   }
        // }
      })
  }

  @Builder
  addressPanel() {
    AddressDetailSheet({
      addressDetail: this.selectItem,
      dismissBlock:()=>{
        this.showSheetAddress = false
      }
    })
  }

  @Builder
  itemCell(item: HSAddressModel) {
    Row(){
      Column({space:'4vp'}){
        Text((item.country ?? "") + " " + item.state + " " + item.city)
          .fontSize(12)
          .fontColor($r('app.color.col_999999'))
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .maxLines(1)
          .textAlign(TextAlign.Start)
        Text(item.streetMore)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .maxLines(2)
          .fontColor($r('app.color.col_0D0D0D'))
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .textAlign(TextAlign.Start)
        Row(){
          Text((item.firstName ?? "") + (item.lastName ?? "") + "  " + item.phone)
            .fontSize(14)
            .fontColor($r('app.color.col_666666'))
            .maxLines(1)
            .textOverflow({overflow:TextOverflow.Ellipsis})

          if (item.isDefault) {
            Row(){
              Text("默认")
                .fontSize(14)
                .maxLines(1)
                .borderRadius(4)
                .textAlign(TextAlign.Center)
                .padding({left:'6vp',right:'6vp',top:'2vp',bottom:'2vp'})
                .fontColor($r('app.color.col_B62B21'))
            }
            .margin({left:'8vp'})
            .backgroundColor($r('app.color.col_B62B21_02'))
            .borderWidth(0.5)
            .borderColor($r('app.color.col_B62B21'))

          }


        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Image($r('app.media.edit'))
        .width('30vp')
        .height('30vp')
        .onClick(()=>{
          this.selectItem = item
          if (item.isDefault) {
            this.showSheetAddress = true
          }
        })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .padding({left:'8vp',right:'16vp',top:'8vp',bottom:'8vp'})
    .borderWidth(1)
    .borderRadius('8vp')
    .borderColor(item.isDefault ? $r('app.color.col_0D0D0D') : $r('app.color.col_EEEEEE'))
    .backgroundColor($r('app.color.bg_base'))
    .shadow({radius:4, color:$r('app.color.shadow'), offsetX: 9, offsetY: 4})
    .width('100%')
    .onClick(()=>{
      ywNavRouter.openRoute(this.getUniqueId())
        .onTargetUrl(YWNavPath.root_address_detail_nav)
        .onParams("address", item)
        .onItemInfo(item)
        .go()
    })
  }

  @Builder
  itemLayout(item: HSAddressModel,index:number) {
    ListItem() {
      this.itemCell(item)
    }
    // List({ scroller: _this.scroller, space: 12 }) {
    //   ForEach(_this.addressData, (item: HSAddressModel) => {
    //     ListItem() {
    //       this.itemCell(item)
    //     }
    //   }, (item: string, index: number) => JSON.stringify(item) + "_" + index)
    // }
    // .scrollBar(BarState.Off)
    // .edgeEffect(EdgeEffect.None)
    // .width("100%")
    // .height('100%')
    // .padding({ left: 20, right: 20 })
    // .nestedScroll({
    //   scrollForward: NestedScrollMode.PARENT_FIRST,
    //   scrollBackward: NestedScrollMode.PARENT_FIRST
    // })
  }

  @Builder
  listView() {
    Column(){
      ListView({
        items: this.addressData,
        itemLayout: (item, index) => {
          this.itemLayout(item as HSAddressModel,index)
        },
        controller: this.controller,
        isLazyData: false,
        onRefresh: () => {
          //下拉刷新
          setTimeout(() => {
            this.controller.finishRefresh()
          }, 2000)
        },
        onLoadMore: () => {
          //上拉加载
          setTimeout(() => {

            this.controller.finishLoadMore()
          }, 2000)
        }
      })
    }
    .width('100%')
    .padding({top:'12vp'})
    .layoutWeight(1)
  }

  @Builder
  addButtonView() {
    Row() {
      Text(this.addConfirmTitle)
      .width(`calc(100% - 32vp)`)
      .height('40vp')
      .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontColor($r('app.color.col_FFFFFF'))
        .borderRadius(8)
      .backgroundColor($r('app.color.col_0D0D0D'))
        .onClick(()=>{
          this.addClick?.()
        })
    }
    .justifyContent(FlexAlign.Center)
    .height('58vp')
    .padding({top:'8vp'})
    .width('100%')
    .backgroundColor($r('app.color.bg_base'))
  }
  build() {
    Column() {
      YWBaseNavBar({title:"地址列表", defaultGoBack:()=>{
        ywNavRouter.openRoute(this.getUniqueId()).back()
      }})
      this.listView()
      this.addButtonView()
      Column(){

      }
      .bindSheet(this.showSheetAddress, this.addressPanel(), {showClose: true, onDisappear:()=>{
        this.showSheetAddress = false
      }})
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_gray_base'))
  }
}
