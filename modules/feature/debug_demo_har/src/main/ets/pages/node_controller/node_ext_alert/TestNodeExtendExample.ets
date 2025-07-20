import { YWConstants } from "@learn/constants_har";
import { ItemView } from "../../observed/TestBaseObserved";
import { ExtendNodeManager, ExtendNodeUIManager } from "./ExtendNodeManager";
import { ExtendNodeController } from "./ExtenNodeController";
import { ExtenUIBaseViewModel } from "./ExtenUIViewModel";

@Builder
export function testNodeExtendBuilder() {
  NavDestination() {
    TestNodeExtendExample()
  }
  .hideTitleBar(true)
}
@ComponentV2
export struct TestNodeExtendExample {
  private extendList:ExtenUIBaseViewModel[] = []
  private extendNodeManager: ExtendNodeUIManager = new ExtendNodeUIManager()

  aboutToAppear(): void {
    this.extendList = ExtendNodeManager.getExtendPlugins()
  }
  build() {
    Stack(){
      Column(){
        Text(`点击弹窗扩展弹窗: ${this.extendList.length}`).onTouch(()=>{
          this.extendNodeManager.invokeApiPlug("extend.show_example_sheet")
        })

        Text(`点击弹窗扩展弹窗AA: ${this.extendList.length}`).onTouch(()=>{
          this.extendNodeManager.invokeApiPlug("extend.show_aa_example_sheet",(params)=>{
            setTimeout(()=>{
              //测试 再次弹窗默认
              this.extendNodeManager.invokeApiPlug("extend.show_example_sheet")
            },3000)


          })
        })
      }

      ForEach(this.extendList,(item: ExtenUIBaseViewModel)=>{
        NodeContainer(item.onCreateNode()).zIndex(item.getUILevel())
      }, (item: ExtenUIBaseViewModel) => item.getFlagScene())
    }
    .onAttach(()=>{
      this.extendNodeManager.onInit(this.extendList)
    })
      .backgroundColor(YWConstants.RandomColor())
      .width('100%')
      .height('100%')
  }
}