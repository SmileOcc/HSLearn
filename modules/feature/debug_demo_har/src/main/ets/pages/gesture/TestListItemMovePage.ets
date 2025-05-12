// import curves from '@ohos.curves';
// import Curves from '@ohos.curves'
import { curves, KeyboardAvoidMode } from '@kit.ArkUI';

@Builder
export function TestListItemMoveBuilder() {
  NavDestination(){
    TestListItemMovePage()
  }

}

@Entry
@Component
struct TestListItemMovePage {
  @State private arr: number[] = [0, 1, 2]
  @State dragItem: number = -1
  @State scaleItem: number = -1
  @State neighborItem: number = -1
  @State neighborScale: number = -1
  private dragRefOffset: number = 0
  @State offsetX: number = 0
  @State offsetY: number = 0
  private ITEM_INTV: number = 120
  scaleSelect(item: number): number {
    if (this.scaleItem == item) {
      return 1.05
    } else if (this.neighborItem == item) {
      return this.neighborScale
    } else {
      return 1
    }
  }
  itemMove(index: number, newIndex: number): void {
    let tmp = this.arr.splice(index, 1)
    this.arr.splice(newIndex, 0, tmp[0])
  }
  build() {
    Stack() {
      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.arr, (item: number) => {
          ListItem() {
            Text('' + item)
              .width('100%')
              .height(100)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .borderRadius(10)
              .backgroundColor(0xFFFFFF)
              .shadow(this.scaleItem == item ? { radius: 70, color: '#15000000', offsetX: 0, offsetY: 0 } :
                { radius: 0, color: '#15000000', offsetX: 0, offsetY: 0 })
              .animation({ curve: Curve.Sharp, duration: 300 })
          }
          .margin({ left: 12, right: 12 })
          .scale({ x: this.scaleSelect(item), y: this.scaleSelect(item) })
          .zIndex(this.dragItem == item ? 1 : 0)
          .translate(this.dragItem == item ? { y: this.offsetY } : { y: 0 })
          .gesture(
            // 以下组合手势为顺序识别，当长按手势事件未正常触发时则不会触发拖动手势事件
            GestureGroup(GestureMode.Sequence,
              LongPressGesture({ repeat: true })
                .onAction((event?: GestureEvent) => {
                  animateTo({ curve: Curve.Friction, duration: 300 }, () => {
                    this.scaleItem = item
                  })
                })
                .onActionEnd(() => {
                  animateTo({ curve: Curve.Friction, duration: 300 }, () => {
                    this.scaleItem = -1
                  })
                }),
              PanGesture({ fingers: 1, direction: null, distance: 0 })
                .onActionStart(() => {
                  this.dragItem = item
                  this.dragRefOffset = 0
                })
                .onActionUpdate((event: GestureEvent) => {
                  this.offsetY = event.offsetY - this.dragRefOffset
                  // console.log('Y:' + this.offsetY.toString())
                  this.neighborItem = -1
                  let index = this.arr.indexOf(item)
                  let curveValue = curves.initCurve(Curve.Sharp)
                  let value: number = 0
                  //根据位移计算相邻项的缩放
                  if (this.offsetY < 0) {
                    value = curveValue.interpolate(-this.offsetY / this.ITEM_INTV)
                    this.neighborItem = this.arr[index-1]
                    this.neighborScale = 1 - value / 20;
                    console.log('neighborScale:' + this.neighborScale.toString())
                  } else if (this.offsetY > 0) {
                    value = curveValue.interpolate(this.offsetY / this.ITEM_INTV)
                    this.neighborItem = this.arr[index+1]
                    this.neighborScale = 1 - value / 20;
                  }
                  //根据位移交换排序
                  if (this.offsetY > this.ITEM_INTV / 2) {
                    animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
                      this.offsetY -= this.ITEM_INTV
                      this.dragRefOffset += this.ITEM_INTV
                      this.itemMove(index, index + 1)
                    })
                  } else if (this.offsetY < -this.ITEM_INTV / 2) {
                    animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
                      this.offsetY += this.ITEM_INTV
                      this.dragRefOffset -= this.ITEM_INTV
                      this.itemMove(index, index - 1)
                    })
                  }
                })
                .onActionEnd((event: GestureEvent) => {
                  animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
                    this.dragItem = -1
                    this.neighborItem = -1
                  })
                  animateTo({
                    curve: curves.interpolatingSpring(14, 1, 170, 17), delay: 150
                  }, () => {
                    this.scaleItem = -1
                  })
                })
            )
              .onCancel(() => {
                animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
                  this.dragItem = -1
                  this.neighborItem = -1
                })
                animateTo({
                  curve: curves.interpolatingSpring(14, 1, 170, 17), delay: 150
                }, () => {
                  this.scaleItem = -1
                })
              })
          )
        }, (item: number) => item.toString())
      }
      .backgroundColor(Color.Gray)
    }.width('100%').height('100%').backgroundColor(0xDCDCDC).padding({ top: 5 })
  }
}
