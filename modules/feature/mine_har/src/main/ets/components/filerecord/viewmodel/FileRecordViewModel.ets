import { IUState, YWBaseModel } from "@learn/common_har"
import { FileMockTreeModel, FileTreeData, FileTreeItem, FileTreeModel } from "../model/FileTreeModel"
import { FileRecordMovePlug } from "./FileRecordMovePlug"

export class FileRecordViewModel extends YWBaseModel<FileRecordUIState>{
  iuState: FileRecordUIState = new FileRecordUIState()
  treeData: FileTreeData = FileMockTreeModel()
  displayItems:FileTreeItem[] = []
  searchItems:FileTreeItem[] = []
  foldIdSet: Set<string> = new Set()
  searchFoldIdSet: Set<string> = new Set()
  currentSearchKey: string | undefined = undefined
  currentSelectId: string | undefined = undefined

  recordMovePlug?: FileRecordMovePlug

  constructor() {
    super()
    //打平显示
    this.displayItems = this.handTree(this.treeData.tree)
    this.iuState.showItems = this.displayItems

    this.recordMovePlug = new FileRecordMovePlug(this.treeData)
  }

  handTree(fileTree:FileTreeModel | undefined): FileTreeItem[] {
    let list: FileTreeItem[] = []
    if (fileTree?.current && fileTree.current.cid != "root") {
      list.push(fileTree.current)
    }
    for (const element of fileTree?.childs ?? []) {
      list = list.concat(this.handTree(element))
    }

    return list
  }


  getShowList():FileTreeItem[] {
    if (this.currentSearchKey && this.currentSearchKey.length > 0) {
      for (const element of this.searchItems) {
        element.isFold = this.searchFoldIdSet.has(element.cid)
        element.isSelect = element.cid == this.currentSelectId
      }
      return this.searchItems
    } else {
      for (const element of this.displayItems) {
        element.isFold = this.foldIdSet.has(element.cid)
        element.isSelect = element.cid == this.currentSelectId
      }
      return this.displayItems
    }

  }

  tapSelect(item: FileTreeItem) {
    this.currentSelectId = item.cid
  }


}

@ObservedV2
export class FileRecordUIState implements IUState {
  @Trace
  isLoading:boolean = true
  @Trace
  showItems:FileTreeItem[] = []
  @Trace
  isShowSheet: boolean = false

}