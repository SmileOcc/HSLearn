import { YWResColor, YWResImage } from "@learn/res_har";
import { TabItemInfo } from "../core/bar/TabItemInfo";

@Component
export struct CommonTabItemView {

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