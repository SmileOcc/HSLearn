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

  borderRadiusValue(item:MineServiceModel):BorderRadiuses {
    if (item.borderRadius == 1) {
      return {topLeft:'12vp', topRight:'12vp'}
    } else if (item.borderRadius == 2) {
      return {bottomLeft:'12vp', bottomRight:'12vp'}
    }
    return {}
  }
  build() {
    ListItemGroup(){
      ForEach(this.groupInfo.items, (item:MineServiceModel, index) => {
        ListItem(){
          Row(){
            Row(){
              Image(item.itemImage)
                .width('24vp')
                .height('24vp')

              Text(item.itemTitle)
                .fontSize(13)
                .maxLines(2)
                .margin({left:'5vp'})

              Blank().layoutWeight(1)
              Image($r("app.media.arrow_right"))
                .width('15vp')
                .height('15vp')
            }
            .width(`100%`)
            .height('45vp')
            .padding({left:'8vp',right:'8vp'})
          }
          .width('100%')
          .borderRadius(this.borderRadiusValue(item))
          .backgroundColor($r('app.color.col_ffffff'))

        }
        .onClick(()=>{
          item.itemClick?.(item)
        })
      })
    }
    .padding({left:'16vp',right:'16vp'})


  }
}