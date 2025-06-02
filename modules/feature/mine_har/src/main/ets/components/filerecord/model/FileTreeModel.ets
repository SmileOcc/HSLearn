export class FileTreeData {
  tree?: FileTreeModel
  //这个包含所以数据
  dataMap?: Map<string,FileTreeItem>
}

export class FileTreeModel {
  current?: FileTreeItem
  childs?: FileTreeModel[]
  isShow?: boolean = false
}

export class FileTreeItem {
  level: number = 0
  text: string = ""
  cid: string = ""
  isSelect: boolean = false
  isFold: boolean = false
}

export function FileMockTreeModel(): FileTreeData {
  let list:FileTreeModel[] = []

  for (let index = 0; index < 5; index++) {
    let fileTreeModel = new FileTreeModel()
    let currentId = "fold_id_" + index
    let currentText = "文件_" + index
    let level = 0
    let current: FileTreeItem = new FileTreeItem()
    current.cid = currentId
    current.text = currentText
    current.level = level
    fileTreeModel.current = current

    let childs:FileTreeModel[] = []
    let subCount = 0
    if (index <3) {
      subCount = 2
    } else if (index >4) {
      subCount = 1
    }

    for (let j = 0; j<subCount; j++) {
      let tempTreeFile: FileTreeModel = new FileTreeModel()

      let tempItem: FileTreeItem = new FileTreeItem()
      tempItem.cid = currentId + "_" + j
      tempItem.text = current.text + "." + j
      tempItem.level = level + 1
      if (current.text == "文件_2.1") {
        tempItem.isSelect = true
      }

      tempTreeFile.current = tempItem
      childs.push(tempTreeFile)
    }
    fileTreeModel.childs = childs
    list.push(fileTreeModel)
  }

  let rootTreeModel: FileTreeModel = new FileTreeModel()
  let current: FileTreeItem = new FileTreeItem()
  current.cid = "root"
  rootTreeModel.current = current
  rootTreeModel.childs = list


  let rootTreeData: FileTreeData = new FileTreeData()
  rootTreeData.tree = rootTreeModel

  return rootTreeData
}