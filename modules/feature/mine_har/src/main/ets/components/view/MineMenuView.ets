import { YWConstants } from "@learn/constants_har";
import { MineMenuModel } from "../model/MineMenuModel";

@ComponentV2
export struct MineMenuView {

  @Param @Require orderMenus: MineMenuModel[] = []

  @Builder
  itemView(item:MineMenuModel) {
    Column(){
      Image(item.itemImage)
        .width('24vp')
        .height('24vp')
      Blank().height('8vp')
      Text(item.itemTitle)
        .fontSize(12)
        .maxLines(1)
    }
    .width('22%')
    .padding({top:'8vp',bottom:'8vp'})
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.col_FFFFFF'))

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
      .padding({left:'8vp',right:'8vp'})
    }
    .width('100%')
    // .height('90vp')
    .borderRadius('16vp')
    .clip(true)
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.col_FFFFFF'))
  }
}