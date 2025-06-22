import { YWConstants } from "@learn/constants_har";
import { YWResColor } from "@learn/res_har";

@ComponentV2
export struct MineHeaderView {

  @Event homeClick?:()=>void
  @Event messageClick?:()=>void
  @Event settingClick?:()=>void
  @Param isBlack: boolean = false

  @Builder
  leftView(click?:()=>void) {
    Row(){
      this.itemView(this.isBlack ? $r('app.media.status_bar_animation_scan_black') : $r('app.media.status_bar_animation_scan_white'),0,click)
    }
  }

  @Builder
  rightView(messageClick?:()=>void, click?:()=>void) {
    Row(){
      this.itemView(this.isBlack ? $r('app.media.status_bar_animation_share_black') : $r('app.media.status_bar_animation_share_white'),1,messageClick)
      Blank().width('8vp')
      this.itemView(this.isBlack ? $r('app.media.status_bar_animation_setting_black') : $r('app.media.account_setting'),0,click)
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
    .padding({left:12,right:12})
    .width('100%')
    .height(YWConstants.kMainNavSM)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }
}