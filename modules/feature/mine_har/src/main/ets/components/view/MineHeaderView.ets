import { YWConstants } from "@learn/constants_har";
import { YWResColor } from "@learn/res_har";

@ComponentV2
export struct MineHeaderView {

  @Event homeClick?:()=>void
  @Event messageClick?:()=>void
  @Event settingClick?:()=>void

  @Builder
  leftView(click?:()=>void) {
    Row(){
      this.itemView($r('app.media.tab_bag_select'),0,click)
    }
  }

  @Builder
  rightView(messageClick?:()=>void, click?:()=>void) {
    Row(){
      this.itemView($r('app.media.account_message'),1,messageClick)
      Blank().width('8vp')
      this.itemView($r('app.media.account_setting'),0,click)
    }
  }

  @Builder
  itemView(imageUrl: ResourceStr, badgeCount:number, click?:()=>void) {
    Column(){
      Badge({
        count: badgeCount,
        position: BadgePosition.RightTop,
        style: { badgeSize: 16, badgeColor: '#FA2A2D' }
      }) {
        Image(imageUrl)
          .width(32)
          .height(32)
      }
      .margin('4vp')
    }
    // .onClick(()=>{
    //   click?.()
    // })
    .onClick(click)
  }

  build() {
    Row()
    {
      this.leftView(this.homeClick)
      this.rightView(this.messageClick, this.settingClick)
    }
    .width('100%')
    .height(YWConstants.kMainNavSM)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor(YWConstants.RandomColor())
  }
}