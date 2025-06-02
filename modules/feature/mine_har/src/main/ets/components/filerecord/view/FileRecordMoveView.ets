import { FileTreeItem } from "../model/FileTreeModel"
import { FileRecordMovePlug } from "../viewmodel/FileRecordMovePlug"
import { FileRecordCell } from "./FileRecordCell"
import { KeyboardAvoidMode } from '@kit.ArkUI';

@ComponentV2
export struct FileRecordMoveView {

  @Param @Require recodePlug:FileRecordMovePlug

  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
  }

  aboutToDisappear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
  }

  build() {
    Column(){
      Row({space:'4vp'}){
        TextInput({placeholder:'请输入', text: this.recodePlug.currentSearchKey})
          .onChange((value: string) => {
            this.recodePlug.searchKey(value)
          })
          .placeholderColor(Color.Gray)
          .height('44vp')
          .layoutWeight(1)

        if (this.recodePlug.currentSearchKey && this.recodePlug.currentSearchKey.length >0) {
          Text("取消")
        }
      }
      .alignItems(VerticalAlign.Center)
      Blank().height('8vp')
      List() {
        ForEach(this.recodePlug.showItems, (item: FileTreeItem) => {
          ListItem() {
            FileRecordCell({itemInfo: item, foldBlock:(tItem) =>{
              this.recodePlug.tapFold(tItem)
            }, clickBlock:(tItem)=>{

            }})
          }
        }, (item: FileTreeItem, index?: number) => index + JSON.stringify(item))
      }


    }
    .padding({left:'16vp',right:'16vp'})
    .width('100%')
    .constraintSize({minWidth:'100vp'})
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}