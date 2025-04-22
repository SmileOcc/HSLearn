import { YWConstants } from "@learn/constants_har";
import { YWResColor, YWResImage } from "@learn/res_har";
import { ITabBottomBarConfig, TabItemInfo } from "@learn/tab_nav_api_har";

@Component
export struct TabMainItemView {

  @Require
  tabInfo:ITabBottomBarConfig = new TabItemInfo()

  @State isVertical: boolean = true

  build() {
    if (this.isVertical) {
      Column(){
        Image( this.tabInfo.itemImage())
          .width("24")
          .height("24")
        Text(this.tabInfo.title)
          .fontSize(13)
          .fontColor(this.tabInfo.titleColor())
          .textAlign(TextAlign.Center)
          .maxLines(1)
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    } else {
      Row(){
        Image( this.tabInfo.itemImage())
          .width("24")
          .height("24")
        Text(this.tabInfo.title)
          .fontSize(13)
          .fontColor(this.tabInfo.titleColor())
          .textAlign(TextAlign.Center)
          .maxLines(2)
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height('100%')
    }

  }
}