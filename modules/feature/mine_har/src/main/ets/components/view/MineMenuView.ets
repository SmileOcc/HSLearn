import { YWConstants } from "@learn/constants_har";
import { MineMenuModel } from "../model/MineMenuModel";

@ComponentV2
export struct MineMenuView {

  @Param @Require orderMenus: MineMenuModel[] = []

  @Builder
  itemView(item:MineMenuModel) {
    Column(){
      Image(item.itemImage)
        .width('32vp')
        .height('32vp')
        .backgroundColor(YWConstants.RandomColor())
      Blank().height('8vp')
      Text(item.itemTitle)
        .fontSize(12)
        .maxLines(1)
        .backgroundColor(YWConstants.RandomColor())
    }
    .width('22%')
    .padding({top:'8vp',bottom:'8vp'})
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(YWConstants.RandomColor())

  }

  build() {
    Column(){
      Row(){
        ForEach(this.orderMenus,(value:MineMenuModel,index)=>{
          this.itemView(value)
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(Color.Red)
      .padding({left:'8vp',right:'8vp'})
    }
    .width('100%')
    // .height('90vp')
    .borderRadius('16vp')
    .clip(true)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(YWConstants.RandomColor())
  }
}