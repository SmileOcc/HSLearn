import { YWRouterNavParams } from "@learn/nav_router_har";
import { FileTreeItem } from "./model/FileTreeModel";
import { FileRecordCell } from "./view/FileRecordCell";
import { FileRecordMoveView } from "./view/FileRecordMoveView";
import { FileRecordUIState, FileRecordViewModel } from "./viewmodel/FileRecordViewModel";
import { KeyboardAvoidMode } from '@kit.ArkUI';

@Builder
export function fileRecordBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    FileRecordPage()
  }
  .title("文件列表")
  // .hideTitleBar(true)
}


@ComponentV2
export struct FileRecordPage {

  viewModel: FileRecordViewModel = new FileRecordViewModel()

  @Local iuState: FileRecordUIState = this.viewModel.iuState

  @Builder
  SheetBuilder() {
    Column(){
      FileRecordMoveView({recodePlug: this.viewModel.recordMovePlug})
    }
    .width('100%')
    .height('100%')
  }

  build() {

    Column(){
      List() {
        ForEach(this.iuState.showItems, (item: FileTreeItem) => {
          ListItem() {
            FileRecordCell({itemInfo: item, foldBlock:(e)=>{
            }, clickBlock:(e)=>{
              if (this.viewModel.recordMovePlug) {
                this.viewModel.recordMovePlug.isShowSheet = true
              }
            }})
          }
        }, (item: FileTreeItem, index?: number) => index + JSON.stringify(item))
      }
    }
    .bindSheet(this.viewModel.recordMovePlug?.isShowSheet, this.SheetBuilder(), {
      detents: [SheetSize.MEDIUM, SheetSize.LARGE, 600],
      preferType: SheetType.BOTTOM,
      title: { title: '移动文件夹' },
      onWillAppear: () => {

      },
      onAppear: () => {
        this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);

      },
      onWillDisappear: () => {
      },
      onDisappear: () => {
        this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);

        if (this.viewModel.recordMovePlug) {
          this.viewModel.recordMovePlug.isShowSheet = false
        }      }
    })
    .width('100%')
    .height('100%')
    .padding({left:'16vp', right:'16vp'})
  }
}
