import { hsLog } from "@learn/logger_har"
import { FileTreeData, FileTreeItem, FileTreeModel } from "../model/FileTreeModel"
import { JSON } from "@kit.ArkTS"

const TAG = "FileRecordMovePlug"
@ObservedV2
export class FileRecordMovePlug {

  sourceTree: FileTreeData
  sourceTreeData: FileTreeModel[] = []
  sourceAllItemMap: Map<string,FileTreeItem> = new Map()
  displayItems:FileTreeItem[] = []
  searchItems:FileTreeItem[] = []

  foldIdSet: Set<string> = new Set()
  searchFoldIdSet: Set<string> = new Set()

  searchFirstShowIDSet: Set<string> = new Set()
  searchSecondPathIds: number[][] = []
  searchThirdPathIdResults: Set<string> = new Set()

  heightMap: Map<string, number> = new Map()


  @Trace
  currentSearchKey: string | undefined = undefined
  currentSelectId: string | undefined = undefined

  constructor(source:FileTreeData) {
    this.sourceTree = source
    this.setDatas(source.tree, true)
  }
  @Trace
  showItems:FileTreeItem[] = []
  @Trace
  isShowSheet: boolean = false


  setDatas(tree:FileTreeModel | undefined, isFirst?: boolean) {
    this.displayItems = this.handTree(tree, isFirst)
    this.showItems = this.getShowList()

  }
  handTree(tree:FileTreeModel | undefined, isFirst?: boolean): FileTreeItem[]{
    let list: FileTreeItem[] = []
    if (tree?.current && tree.current.cid != "root") {
      list.push(tree.current)
      if (isFirst) {
        this.sourceAllItemMap.set(tree.current.cid, tree.current)
      }
    }
    if (tree?.current && this.foldIdSet.has(tree?.current?.cid) == false) {
      for (const element of tree?.childs ?? []) {
        list = list.concat(this.handTree(element, isFirst))
      }
    }
    hsLog.d(TAG,`handTree == fold: ${JSON.stringify(Array.from(this.foldIdSet))} ${JSON.stringify(list)}`)
    return list
  }


  getShowList():FileTreeItem[] {
    if (this.currentSearchKey && this.currentSearchKey.length > 0) {
      for (const element of this.searchItems) {
        element.isFold = this.searchFoldIdSet.has(element.cid)
        element.isSelect = element.cid == this.currentSelectId
      }
      hsLog.d(TAG,`getShowList searchItems== fold:${JSON.stringify(Array.from(this.searchFoldIdSet))} == ${JSON.stringify(this.searchItems)}`)
      return this.searchItems
    } else {
      for (const element of this.displayItems) {
        element.isFold = this.foldIdSet.has(element.cid)
        element.isSelect = element.cid == this.currentSelectId
      }
      hsLog.d(TAG,`getShowList displayItems== fold:${JSON.stringify(Array.from(this.foldIdSet))} ==  ${JSON.stringify(this.displayItems)}`)
      return this.displayItems
    }

  }

  getLevel(item: FileTreeItem): number {
    if (this.heightMap.has(item.cid)) {
      return this.heightMap.get(item.cid) ?? 0
    }
    if (this.sourceTree.tree) {
      let level = 0
      let path = [this.sourceTree.tree]

      while (path.length > 0) {
        const pathLength = path.length ?? 0
        //遍历每一层的，每加层 + 1
        for (let i = 0; i < pathLength; i++) {
          const currentTree = path.shift()
          let element = currentTree?.childs?.[i]
          if (element?.current?.cid == item.cid) {
            this.heightMap.set(item.cid, level)
            return level
          }
          path.concat(element?.childs ??[])
        }
        level = level + 1
      }
    }
    return 0
  }

  searchKey(searchKey: string) {
    this.currentSearchKey = searchKey
    if (this.currentSearchKey && this.currentSearchKey.length > 0 && this.sourceAllItemMap.size > 0 && this.sourceTree.tree) {
      this.searchItems = []
      this.searchFoldIdSet.clear()
      this.searchFirstShowIDSet.clear()
      this.searchSecondPathIds = []
      this.searchThirdPathIdResults.clear()
      //找到显示的
      for (const element of this.sourceAllItemMap.keys()) {
        let value = this.sourceAllItemMap.get(element)
        if (value?.text.includes(searchKey)) {
          this.searchFirstShowIDSet.add(element)
        }
      }
      hsLog.d(TAG,"--显示搜索Key searchFirstShowIDSet: " + JSON.stringify(Array.from(this.searchFirstShowIDSet)))

      let tree = this.sourceTree.tree
      let path:number[] = []
      this.dsfTree(tree, path)
      hsLog.d(TAG,"--显示搜索 dsf path searchSecondPathIds results: " + JSON.stringify(path) + " == " + JSON.stringify(this.searchSecondPathIds))


      for (const element of this.searchSecondPathIds) {
        let pathIds = element
        this.getTreeNode(tree, pathIds)
      }

      this.setTreeShowFlog(tree)
      hsLog.d(TAG,"--显示搜索 showFlog 需要显示的路径 ture: " + JSON.stringify(tree))

      this.searchItems = this.getSearchItems(tree.childs ?? [])
      hsLog.d(TAG,"--显示搜索 searchItems results: " + JSON.stringify(this.searchItems))

      this.showItems = this.searchItems

    } else {
      this.setDatas(this.sourceTree.tree)
      this.showItems = this.displayItems
    }

    // this.showItems = this.getShowList()
  }

  dsfTree(tree:FileTreeModel, path:number[]) {
    let length = tree.childs?.length ?? 0
    for (let i=0; i<length; i++) {
      path.push(i)
      let subItem = tree.childs![i]
      this.dsfTree(subItem, path)
      path.pop()

    }
    if (tree.current && this.searchFirstShowIDSet.has(tree.current.cid)) {
      path.push(0)
      this.searchSecondPathIds.push(path.concat([]))
      hsLog.d(TAG,"--显示搜索 dsf path 添加 searchSecondPathIds: " + JSON.stringify(path) + "current:" + JSON.stringify(this.searchSecondPathIds))
      path.pop()
    }
  }

  getTreeNode(tree: FileTreeModel, path: number[]) {
    while (path.length > 0) {
      let value = path.shift() ?? 0
      this.searchThirdPathIdResults.add(tree.current?.cid ?? "")

      hsLog.d(TAG,"--显示搜索 treeNode 添加 searchThirdPathIdResults: " + JSON.stringify(Array.from(this.searchThirdPathIdResults)))

      if (tree.childs && tree.childs?.length > value) {
        let itemTree = tree.childs[value]
        this.getTreeNode(itemTree, path)
      } else {
        return
      }
    }
  }

  getSearchItems(trees: FileTreeModel[]): FileTreeItem[] {
    let list: FileTreeItem[] = []
    for (const element of trees) {
      list = list.concat(this.getSearchItem(element))
    }

    return list
  }

  getSearchItem(tree: FileTreeModel): FileTreeItem[] {
    let list: FileTreeItem[] = []

    if (tree.isShow && tree.current) {
      list.push(tree.current)

      if (!this.searchFoldIdSet.has(tree.current?.cid)) {

        for (const element of tree.childs ?? []) {
          // if (element.current && !this.searchFoldIdSet.has(element.current?.cid)) {
          //   list =  list.concat(this.getSearchNodeUnder(element))
          // }
          list =  list.concat(this.getSearchNodeUnder(element))
        }
      }

    } else if(tree.current &&this.searchThirdPathIdResults.has(tree.current.cid)) {
      list.push(tree.current)
      if (!this.searchFoldIdSet.has(tree.current.cid) && tree.childs) {
        list = list.concat(this.getSearchItems(tree.childs))
      }
    }
    return list
  }

  getSearchNodeUnder(tree: FileTreeModel): FileTreeItem[] {
    let list: FileTreeItem[] = []
    if (tree.current) {

      if (this.searchFirstShowIDSet.has(tree.current.cid)) {
        list.push(tree.current)
      }

      if (this.searchFoldIdSet.has(tree.current.cid)) {
        return list
      }
    }

    for (const element of tree.childs ?? []) {
      list = list.concat(this.handTree(element))
    }

    return list
  }





  setTreeShowFlog(tree: FileTreeModel) {
    if (tree.current) {
      tree.isShow = false
      if (this.searchFirstShowIDSet.has(tree.current.cid)) {
        tree.isShow = true
      }
    }
    for (const element of tree.childs ?? []) {
      this.setTreeShowFlog(element)
    }
  }


  tapFold(item:FileTreeItem, position?:number) {
    if (this.currentSearchKey && this.currentSearchKey.length > 0) {
      if (this.searchFoldIdSet.has(item.cid)) {
        this.searchFoldIdSet.delete(item.cid)
        hsLog.i(TAG,`==tapFold 展开：${item.text}  searchFoldIdSet result: ${JSON.stringify(Array.from(this.searchFoldIdSet))}`)
      } else {
        this.searchFoldIdSet.add(item.cid)
        hsLog.i(TAG,`==tapFold 折叠：${item.text}  searchFoldIdSet result: ${JSON.stringify(Array.from(this.searchFoldIdSet))}`)
      }
      this.searchItems = this.getSearchItems(this.sourceTree.tree?.childs ?? [])
      hsLog.i(TAG,`==tapFold：${item.text}  searchItems: ${JSON.stringify(Array.from(this.searchItems))}`)

    } else {
      if (this.foldIdSet.has(item.cid)) {
        this.foldIdSet.delete(item.cid)
        hsLog.i(TAG,`==tapFold 展开：${item.text}  foldIdSet result: ${JSON.stringify(Array.from(this.foldIdSet))}`)
      } else {
        this.foldIdSet.add(item.cid)
        hsLog.i(TAG,`==tapFold 折叠：${item.text}  foldIdSet result: ${JSON.stringify(Array.from(this.foldIdSet))}`)
      }

      this.displayItems = this.handTree(this.sourceTree.tree)
      hsLog.i(TAG,`==tapFold：${item.text}  displayItems: ${JSON.stringify(Array.from(this.displayItems))}`)

    }

    this.showItems = this.getShowList()
  }

  tapSelect(item: FileTreeItem) {
    this.currentSelectId = item.cid
  }
}