import { YWBaseNavBar } from "@learn/baseui_har";
import { YWLazy } from "@learn/global_service_har";
import { ywNavRouter, YWRouterNavParams } from "@learn/nav_router_har";
import { AddressDetailGroupItem, AddressDetailItemModel, AddressItemType } from "./model/AddressDetailItemModel";
import { AddressInfo, HSAddressModel } from "./model/HSAddressModel";
import { AddressCityPicker } from "./view/AddressCityPicker";
import { AddressInputView } from "./view/AddressInputView";
import { AddressDetailViewModel, AddressUIState } from "./viewmodel/AddressDetailViewModel";

@Builder
export function addressDetailBuilder(name?: string, params?: YWRouterNavParams) {
  NavDestination(){
    AddressDetail({navParams: params})
  }
  .hideTitleBar(true)
}

@ComponentV2
export struct AddressDetail {
  @Param navParams?: YWRouterNavParams = undefined
  @Local title: string = "地址详情"
  private scroller: Scroller = new Scroller();

  @Local uiState:AddressUIState = new AddressUIState()

  viewModel:YWLazy<AddressDetailViewModel> = new YWLazy(()=>{
    return new AddressDetailViewModel(this.getUniqueId(), this.uiState)
  })
  aboutToAppear(): void {
    this.viewModel.value.handleAddress(this.navParams?.itemInfo as HSAddressModel)
  }


  @Builder
  topHeader() {

  }

  @Builder
  listView() {
    List({space:'12vp', scroller:this.scroller}){
      ForEach(this.uiState.groupList,(value:AddressDetailGroupItem,index)=>{
        ListItemGroup({header: this.topHeader()}){
          ForEach(value.childs, (item:AddressDetailItemModel, index) => {
            ListItem(){
              if (item.type == AddressItemType.PROVINCE) {
                Column(){
                  AddressCityPicker({ outAddress: item.addressInfo, selectAddressBlock:(addressInfo:AddressInfo)=>{
                    let k = addressInfo
                  }})
                }
                .width('100%')
                // .height('45vp')
                .constraintSize({minHeight:'45vp'})
                .padding({left:'8vp',right:'8vp'})
              } else if (item.type == AddressItemType.DEFAULT) {
                Column(){
                  Row(){
                    Text(item.title)

                  }
                }
              }
              else {
                Column() {
                  AddressInputView({
                    componentId: item.cid,
                    text: item.title,
                    contentType: ContentType.PERSON_FULL_NAME,
                    label: item.placeholder,
                    index: 0
                  })
                  Divider()
                    .height('2vp')
                    .color('#ccc');
                }
                .width('100%')
                // .height('45vp')
                .constraintSize({minHeight:'45vp'})
                .padding({left:'8vp',right:'8vp'})
              }

            }
            .onClick(()=>{
              this.viewModel.value.onClickItem(item)
            })
          })
        }
        .borderRadius('12vp')
        .backgroundColor($r('app.color.col_ffffff'))
      })

    }
    .layoutWeight(1)
    .padding({left:'16vp',right:'16vp'})
  }

  @Builder
  bottomView() {
    Row() {
      Text(this.title)
        .width(`calc(100% - 32vp)`)
        .height('40vp')
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontColor($r('app.color.col_FFFFFF'))
        .borderRadius(8)
        .backgroundColor($r('app.color.col_0D0D0D'))
        .onClick(()=>{

        })
    }
    .justifyContent(FlexAlign.Center)
    .height('58vp')
    .padding({top:'8vp'})
    .width('100%')
    .backgroundColor($r('app.color.bg_base'))
  }

  build() {
    Column(){
      YWBaseNavBar({title:"地址详情", defaultGoBack:()=>{
        ywNavRouter.openRoute(this.getUniqueId()).back()
      }})
      Blank().height('12vp')
      this.listView()
      this.bottomView()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_gray_base'))
  }
}