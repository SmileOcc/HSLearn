import { MineItem, MineViewModel } from '../model/MineViewModel'
import { MineInfoView } from './MineInfoView'
import { MineNavBarView } from './MineNavBarView'
import { router } from '@kit.ArkUI'
import { Constants } from '../../../../../../../modules/common_har/src/main/ets/common/Constants'
import { UserInfoModel } from '../model/UserInfoModel'

@Component
export struct MineMainView {

  @Link userInfo:UserInfoModel

  mineViewModel = new MineViewModel()

  scorllView:Scroller = new Scroller()


  @Builder menuGroupItemView(items:MineItem[]) {

    ForEach(items,(subItem:MineItem,subIndex) => {
      ListItem() {
        Column(){
          Row(){
            Row(){
              Image($r('app.media.tab_new_select'))
                .objectFit(ImageFit.ScaleDown)
                .size({width:24,height:24})
              Text(subItem.title)
                .fontSize(14)
                .fontColor(Color.Black)
                .margin({left:12})
            }
            Image($r('app.media.arrow_right_new'))
              .objectFit(ImageFit.ScaleDown)
              .size({width:24,height:16})

          }
          .height(56)
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          if (subIndex != items.length - 1) {
            Line()
              .height(0.5)
              .backgroundColor(Constants.COLOR_EEEEEE)
              .width('100%')
          }
        }
      }
      .backgroundColor(Color.White)
      .padding({left:12,right:12})
      .onClick(()=> {
        router.pushUrl({url:'pages/mine/ctrl/MyOrderPage'})
      })
    })

  }

  // editUserEvent: (() => void) = ()=>{
  //
  // }
  editUserEvent(){
    router.pushUrl({url:'pages/accountInfo/ctrl/MineInfoPage'})
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {

      Scroll(this.scorllView){
        Column(){
          Column(){
            MineNavBarView({userInfo:this.userInfo,editBlock:this.editUserEvent})

            MineInfoView({userInfo:this.userInfo})
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          List({space:12}){
            ForEach(this.mineViewModel.groups, (items:Array<MineItem>,index) => {
              ListItemGroup(){
                this.menuGroupItemView(items)
              }
              .borderRadius(16)
              .clip(true)

            },(item:string):string => item)
          }
          .padding({left:13,right:13,top:12,bottom:12})
          // .divider({
          //   strokeWidth: 1,
          //   startMargin: 0,
          //   endMargin: 0,
          //   color: '#ffe9f0f0'
          // })
        }
      }
      .backgroundColor(Constants.COLOR_PAGE_BGC)
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}

enum MineItemRadiusType {
  top,
  bottom,
  no
}

//自定义样式
@Extend(ListItem) function oprateListItemStyle(radiusType:MineItemRadiusType){
  .borderRadius(radiusType == MineItemRadiusType.top ? {topLeft:16,topRight:16} : (radiusType == MineItemRadiusType.bottom ? {bottomLeft:16,bottomRight:16} : 0))
  .clip(true)

}

@Extend(Text) function  fristText() {
  .backgroundColor(Color.Red)
  .secondText()
}

@Extend(Text) function  secondText() {
  .backgroundColor(Color.Red)
}

