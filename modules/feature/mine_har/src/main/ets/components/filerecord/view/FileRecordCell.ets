import { YWConstants } from "@learn/constants_har"
import { FileTreeItem } from "../model/FileTreeModel"

@ComponentV2
export struct FileRecordCell {
  @Param @Require itemInfo: FileTreeItem
  @Param foldBlock?:((item: FileTreeItem)=>void) | undefined = undefined
  @Param clickBlock?:((item: FileTreeItem)=>void) | undefined = undefined

  build() {
    Row() {
      Blank().width(`${this.itemInfo.level * 16}vp`)
      Image( this.itemInfo.isFold ? $r('app.media.ic_right_arrow') : $r('app.media.ic_down_arrow')).width('24vp').height('24vp')
        .backgroundColor(YWConstants.RandomColor())
        .onClick(()=>{
          this.foldBlock?.(this.itemInfo)
        })
      Column(){
        Text(this.itemInfo.text)
      }
      .padding({left:'4vp',right:'4vp'})
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .layoutWeight(1)
      Image($r('app.media.address_check_mark'))
        .width('30vp')
        .height('30vp')
        .backgroundColor(YWConstants.RandomColor())
    }
    .backgroundColor(YWConstants.RandomColor())
    .onClick(()=>{
      this.clickBlock?.(this.itemInfo)
    })
  }
}