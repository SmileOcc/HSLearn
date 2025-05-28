import { YWConstants } from "@learn/constants_har"
import { MineServiceGroup, MineServiceModel } from "../model/MineServiceModel"

@ComponentV2
export struct MineListGroupView {
  @Local list:string[] = ["1","2","3","4","5"]

  @Param @Require groupInfo:MineServiceGroup
  @Builder
  groupHeader() {
    Row(){

    }
  }
  build() {
    ListItemGroup(){
      ForEach(this.groupInfo.items, (item:MineServiceModel, index) => {
        ListItem(){
          Row(){
            Image(item.itemImage)
              .width('24vp')
              .height('24vp')
              .backgroundColor(YWConstants.RandomColor())

            Text(item.itemTitle)
              .fontSize(13)
              .maxLines(2)
              .margin({left:'5vp'})
              .backgroundColor(YWConstants.RandomColor())

            Blank().layoutWeight(1)
            Image($r("app.media.arrow_right"))
              .width('15vp')
              .height('15vp')
              .backgroundColor(YWConstants.RandomColor())
          }
          .width('100%')
          .height('45vp')
          .padding({left:'8vp',right:'8vp'})
        }
        .backgroundColor(YWConstants.RandomColor())
      })
    }


  }
}