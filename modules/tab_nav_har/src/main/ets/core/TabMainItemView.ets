import { YWConstants } from "@learn/constants_har";
import { YWResColor, YWResImage } from "@learn/res_har";
import { TabItemInfo } from "@learn/tab_nav_common_har";

@Component
export struct TabMainItemView {

  @Require
  tabInfo:TabItemInfo = new TabItemInfo()

  build() {
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
  }
}