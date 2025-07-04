import { YWBaseNavBar } from "@learn/baseui_har"
import { YWConstants } from "@learn/constants_har"
import { hsLog } from "@learn/logger_har"
import { ywDebugGlobal } from "../../core/DebugGlobal"
import { HSDataSource, HSLazyDataSource } from "@learn/base_model_har";

const TAG = "ListScrollerMore"

@Builder
export function listerScrollMoreBuilder() {
  NavDestination() {
    ListScrollerMore()
  }
  .hideTitleBar(true)
}

@ObservedV2
class FileItem {
  name?: string
  id: string = ""
  childs: SubItem[] = []
  subScroll: Scroller = new Scroller()
}

@ObservedV2
class SubItem {
  name?: string
  id: string = ""
}

@ComponentV2
export struct ListScrollerMore {
  private fileDatas: FileItem[] = []
  @Local fileWidth: number = 150
  private fileScroll: Scroller = new Scroller()

  private outScroller: Scroller = new Scroller()
  private moveDistance: number = 0.0
  private appearCell: Set<Scroller> = new Set()

  // 懒加载数据
  @Local fileSource: HSDataSource<FileItem> = new HSDataSource([]);

  handMove(moveY: number): boolean {
    if (this.fileWidth - moveY > 100 || this.fileWidth - moveY < 250) {
      this.fileWidth = this.fileWidth - moveY
      hsLog.d(TAG, `===FileWidth: ${this.fileWidth}`)
      return true

    }
    return false
  }

  aboutToAppear(): void {
    for (let i = 0; i < 20; i++) {
      const tempFile: FileItem = new FileItem()
      tempFile.name = "file_name_" + i
      tempFile.id = "cid_" + i

      let subs: SubItem[] = []
      for (let j = 0; j < 7; j++) {
        const tempSubItem: SubItem = new SubItem()
        tempSubItem.name = `sub_name_${i}_${j}`
        tempSubItem.id = `cid_${i}_${j}`
        subs.push(tempSubItem)
      }
      tempFile.childs = subs
      this.fileDatas.push(tempFile)
    }

    this.fileSource.pushData(this.fileDatas)
  }

  @Builder
  topView() {
    Row() {

    }
    .height('50vp')
    .width('100%')
    .backgroundColor(YWConstants.RandomColor())
  }

  allScroller(offsetX: number) {
    for (let item of this.fileDatas) {
      item.subScroll.scrollTo({
        xOffset: offsetX,
        yOffset: 0
      })
    }
  }

  @Builder
  scrollItemView(item: FileItem) {
    // Scroll(this.outScroller) {
    Scroll() {
      Row() {
        Text("======aa======")
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width(this.fileWidth)
        List({ scroller: item.subScroll }) {
          ForEach(item.childs, (subItem: SubItem, index: number) => {
            if (index == 0) {
              ListItem() {
                Text(subItem.name)
                  .borderWidth('1vp')
                  .borderColor(YWConstants.RandomColor())
                  .padding({
                    left: '16vp',
                    right: '16vp',
                    top: '8vp',
                    bottom: '8vp'
                  })
              }
              // .position({left:0})
              .zIndex(100)
            } else {
              ListItem() {
                Text(subItem.name)
                  .borderWidth('1vp')
                  .borderColor(YWConstants.RandomColor())
                  .padding({
                    left: '16vp',
                    right: '16vp',
                    top: '8vp',
                    bottom: '8vp'
                  })
              }
              .zIndex(99)
            }


          }, (subItem: string) => subItem)
        }
        .id("inner")
        .flingSpeedLimit(100)
        .listDirection(Axis.Horizontal)
        .edgeEffect(EdgeEffect.None)
        .layoutWeight(1)
        // .padding({left:this.fileWidth})
        // .width('100%')
        .height('90vp')
        .backgroundColor(Color.Pink)
        .enableScrollInteraction(false) // TODO：知识点：禁用List组件的手势
      }

      // .width(`calc(100% + ${this.fileWidth - 100}vp)`)
      // .width('100%')
    }
    .id('outer')
    .scrollable(ScrollDirection.Horizontal)
    .width('100%')
    .onAppear(()=>{
      this.appearCell.add(item.subScroll)
      this.scrollAllVisAppear()
    })
    .onDisAppear(()=>{
      this.appearCell.delete(item.subScroll)
    })
    // TODO：知识点：通过调用Scroll.onScrollFrameBegin()，在每帧开始滚动时触发时将Scroll返回的实际滚动量的offset，通过scrollBy(0, offset)方法，将Scroll的偏移量派发给Web、List。
    .onScrollFrameBegin((offset: number, state: ScrollState) => {

      if (offset >= 0) { //左滑
        if (this.fileWidth > 100) {
          this.fileWidth -= offset
          hsLog.d(TAG, `==左滑 减少宽度 ${offset} ：fileWidth:${this.fileWidth}}`)
          return { offsetRemain: 0 }
        }
      } else if (offset < 0) { //右滑
        if (item.subScroll.currentOffset().xOffset <= 0) {
          if (this.fileWidth <= 150) {
            this.fileWidth -= offset
            hsLog.d(TAG, `==右滑 增加宽度 ${offset}：fileWidth:${this.fileWidth}}`)
            return { offsetRemain: 0 }
          }
        }
      }
      if (offset > 0) { // 手指左滑
        this.scrollAllBy(offset)
        hsLog.d(TAG, `==左滑 liseter offset:${offset}==:${this.fileWidth}}`)
        return { offsetRemain: 0 }
        // }
      } else if (offset < 0) { // 手指右滑
        this.scrollAllBy(offset)
        hsLog.d(TAG, `==右滑 liseter offset:${offset}==:${this.fileWidth}}`)
        return { offsetRemain: 0 }
      }

      hsLog.d(TAG, `==最外滚动 offset:${offset}==:${this.fileWidth}}`)
      return { offsetRemain: offset } // 否则，scroll自身滚动
    })

  }

  scrollAllBy(offsetX: number) {
    if (this.moveDistance + offsetX <= 0) {
      this.moveDistance = 0
    } else {
      this.moveDistance += offsetX
    }
    hsLog.d(TAG, `==内部滚动 距离:${this.moveDistance}==:${this.fileWidth}}`)

    // for (let item of this.fileDatas) {
    //   item.subScroll.scrollBy(offsetX, 0)
    // }
    for (let itemScroll of this.appearCell) {
      itemScroll.scrollBy(offsetX, 0)
    }
  }

  scrollAllVisAppear() {
    // for (let item of this.fileDatas) {
    //   item.subScroll.scrollTo({
    //     xOffset: this.moveDistance,
    //     yOffset: 0,
    //     animation: false
    //   })
    // }

    for (let itemScroll of this.appearCell) {
      itemScroll.scrollTo({
        xOffset: this.moveDistance,
        yOffset: 0,
        animation: false
      })
    }
  }

  isScrollTop(): boolean {
    let first = this.fileDatas[0]
    if (first.subScroll) {
      let isTop = first.subScroll.isAtEnd()
      let offsetX = first.subScroll.currentOffset().xOffset
      return offsetX <= 0 ? true : false
    }
    return false
  }

  isScrollEnd(): boolean {
    let first = this.fileDatas[0]
    if (first.subScroll) {
      let isEnd = first.subScroll.isAtEnd()
      return isEnd
    }
    return false
  }

  @Builder
  bottomView() {
    Column() {
      //数据列表
      List({ space: 20, scroller: this.fileScroll }) {
        LazyForEach(this.fileSource, (item: FileItem, index: number) => {
          ListItem() {
            this.scrollItemView(item)
          }
        }, (item: string) => item)
      }
      .flingSpeedLimit(100)
      .cachedCount(3)

    }
    .width('100%')
    .height('50%')
    .backgroundColor(YWConstants.RandomColor())
  }

  build() {
    Column() {
      YWBaseNavBar({
        title: "横向滚动", defaultGoBack: () => {
          ywDebugGlobal.getMainNav().pop()
        }
      })

      Column() {

      }
      .layoutWeight(1)

      Column() {
        this.topView()
        this.bottomView()
      }
      .borderRadius({ topLeft: "12vp", topRight: "12vp" })
    }
    .width('100%')
    .height('100%')
  }
}