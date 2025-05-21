import { YWConstants } from "@learn/constants_har";
import { YWResColor } from "@learn/res_har";

@ComponentV2
export struct MineHeaderView {

  @Builder
  leftView() {
    Row(){
      this.itemView($r('app.media.tab_home_select'),0)
    }
  }

  @Builder
  rightView() {
    Row(){
      this.itemView($r('app.media.account_message'),1)
      Blank().width('8vp')
      this.itemView($r('app.media.account_setting'),0)
    }
  }

  @Builder
  itemView(imageUrl: ResourceStr, badgeCount:number) {
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
  }

  build() {
    Row()
    {
      this.leftView()
      this.rightView()
    }
    .width('100%')
    .height(YWConstants.kMainNavSM)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .padding({left:'16vp',right:'16vp'})
  }
}