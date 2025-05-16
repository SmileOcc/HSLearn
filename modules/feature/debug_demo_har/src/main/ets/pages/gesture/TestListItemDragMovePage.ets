// import curves from '@ohos.curves';
// import Curves from '@ohos.curves'
import { curves, KeyboardAvoidMode } from '@kit.ArkUI';
import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';
import { hsLog } from '@learn/logger_har';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = "TestListItemDragMovePage"
// @Builder
// export function TestListItemDragMoveBuilder() {
//   NavDestination(){
//     TestListItemDragMovePage()
//   }
//
// }

// @Entry
// @Component
// struct TestListItemDragMovePage {
//   @State private arr: number[] = [0, 1, 2]
//   @State dragItem: number = -1
//   @State scaleItem: number = -1
//   @State neighborItem: number = -1
//   @State neighborScale: number = -1
//   private dragRefOffset: number = 0
//   @State offsetX: number = 0
//   @State offsetY: number = 0
//   private ITEM_INTV: number = 120
//   scaleSelect(item: number): number {
//     if (this.scaleItem == item) {
//       return 1.05
//     } else if (this.neighborItem == item) {
//       return this.neighborScale
//     } else {
//       return 1
//     }
//   }
//   itemMove(index: number, newIndex: number): void {
//     let tmp = this.arr.splice(index, 1)
//     this.arr.splice(newIndex, 0, tmp[0])
//   }
//   build() {
//     Stack() {
//       List({ space: 20, initialIndex: 0 }) {
//         ForEach(this.arr, (item: number) => {
//           ListItem() {
//             Text('' + item)
//               .width('100%')
//               .height(100)
//               .fontSize(16)
//               .textAlign(TextAlign.Center)
//               .borderRadius(10)
//               .backgroundColor(0xFFFFFF)
//               .shadow(this.scaleItem == item ? { radius: 70, color: '#15000000', offsetX: 0, offsetY: 0 } :
//                 { radius: 0, color: '#15000000', offsetX: 0, offsetY: 0 })
//               .animation({ curve: Curve.Sharp, duration: 300 })
//           }
//           .margin({ left: 12, right: 12 })
//           .scale({ x: this.scaleSelect(item), y: this.scaleSelect(item) })
//           .zIndex(this.dragItem == item ? 1 : 0)
//           .translate(this.dragItem == item ? { y: this.offsetY } : { y: 0 })
//           .gesture(
//             // 以下组合手势为顺序识别，当长按手势事件未正常触发时则不会触发拖动手势事件
//             GestureGroup(GestureMode.Sequence,
//               LongPressGesture({ repeat: true })
//                 .onAction((event?: GestureEvent) => {
//                   animateTo({ curve: Curve.Friction, duration: 300 }, () => {
//                     this.scaleItem = item
//                   })
//                 })
//                 .onActionEnd(() => {
//                   animateTo({ curve: Curve.Friction, duration: 300 }, () => {
//                     this.scaleItem = -1
//                   })
//                 }),
//             )
//               .onCancel(() => {
//                 animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
//                   this.dragItem = -1
//                   this.neighborItem = -1
//                 })
//                 animateTo({
//                   curve: curves.interpolatingSpring(14, 1, 170, 17), delay: 150
//                 }, () => {
//                   this.scaleItem = -1
//                 })
//               })
//           )
//         }, (item: number) => item.toString())
//       }
//       .backgroundColor(Color.Gray)
//     }.width('100%').height('100%').backgroundColor(0xDCDCDC).padding({ top: 5 })
//   }
// }
//
//
@Builder
export function TestListItemDragMoveBuilder() {
  NavDestination(){
    DragExample()
  }

}

// xxx.ets
@Extend(Text)
function textStyle() {
  .width('25%')
  .height(35)
  .fontSize(16)
  .textAlign(TextAlign.Center)
  .backgroundColor(0xAFEEEE)
}

class extraParams {
  selectedIndex: number = 0
  insertIndex: number = 0
}

class Drag {
  static getDataFromUdmfRetry(event: DragEvent, callback: (data: DragEvent) => void) {
    try {
      let data: UnifiedData = event.getData();
      if (!data) {
        return false;
      }
      let records: Array<unifiedDataChannel.UnifiedRecord> = data.getRecords();
      if (!records || records.length <= 0) {
        return false;
      }
      callback(event);
      return true;
    } catch (e) {
      console.log("getData failed, code = " + (e as BusinessError).code + ", message = " +
      (e as BusinessError).message);
      return false;
    }
  }

  // 跨组件拖拽
  static getDataFromUdmf(event: DragEvent, callback: (data: DragEvent) => void) {
    if (Drag.getDataFromUdmfRetry(event, callback)) {
      return;
    }
    setTimeout(() => {
      Drag.getDataFromUdmfRetry(event, callback);
    }, 1500);
  }
}

@Entry
@Component
struct DragExample {
  @State numbers: string[] = ['one', 'two', 'three', 'four', 'five', 'six']
  @State text: string = ''
  @State bool: boolean = true
  @State eventType: string = ''
  // @State fruitVisible: Visibility[] = [Visibility.Visible, Visibility.Visible, Visibility.Visible]
  @State idx: number = 0
  private dragList: string[] = ['apple', 'orange', 'banana']

  // 自定义拖拽过程中显示的内容
  @Builder
  pixelMapBuilder() {
    Column() {
      Text(this.text)
        .width('100%')
        .height(160)
        .fontSize(30)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
        .backgroundColor(0xAFEEEE)
    }
  }

  @Builder
  pixelCellBuilder(item: string) {
    Column() {
      Text(item)
        .width('100%')
        .height(80)
        .fontSize(16)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
        .backgroundColor(0xAFEEEE)
    }
  }

  @Builder
  textMoveView() {
    Text('There are three Text elements here')
      .fontSize(12)
      .fontColor(0xCCCCCC)
      .width('90%')
      .textAlign(TextAlign.Start)
      .margin(5)
    Row({ space: 15 }) {
      ForEach(this.dragList, (item: string, index) => {
        Text(item)
          // .textStyle()
          // .visibility(this.fruitVisible[index])
          .onDragStart(() => {
            this.bool = true
            this.text = item
            // this.fruitVisible[index] = Visibility.None
            return this.pixelMapBuilder
          })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.eventType = 'Down'
              this.idx = index
            }
            if (event.type === TouchType.Up) {
              this.eventType = 'Up'
              if (this.bool) {
                // this.fruitVisible[index] = Visibility.Visible
              }
            }
          })
      })
    }.padding({ top: 10, bottom: 10 }).margin(10)
  }

  build() {
    Column() {

      this.textMoveView()

      Text('This is a List element')
        .fontSize(12)
        .fontColor(0xCCCCCC)
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin(15)

      List({ space: 20 }) {
        ForEach(this.numbers, (item: string, index: number) => {
          ListItem() {
            Text(item)
              .width('100%')
              .height(80)
              .fontSize(16)
              .borderRadius(10)
              .textAlign(TextAlign.Center)
              .backgroundColor(0xAFEEEE)
              // .visibility(this.fruitVisible[index])
              // .onDragStart((event) => {
              //   this.bool = true
              //   this.text = item
              //   // this.fruitVisible[index] = Visibility.None
              //   // 跨组件需要的-start，，同组件拖拽可以不需要
              //   let data: unifiedDataChannel.PlainText = new unifiedDataChannel.PlainText();
              //   data.abstract = JSON.stringify(index);
              //   data.textContent = JSON.stringify(this.numbers);
              //   (event as DragEvent).setData(new unifiedDataChannel.UnifiedData(data));
              //   // 跨组件需要的-end
              //
              //   return this.pixelMapBuilder
              // })
              // .onTouch((event: TouchEvent) => {
              //   if (event.type === TouchType.Down) {
              //     this.eventType = 'Down'
              //     this.idx = index
              //   }
              //   if (event.type === TouchType.Up) {
              //     this.eventType = 'Up'
              //     if (this.bool) {
              //       // this.fruitVisible[index] = Visibility.Visible
              //     }
              //   }
              // })
          }
          .onDragStart((event,extraParams?: string) => {
            hsLog.d(TAG,`===onDragStart: ${JSON.stringify(event)} === params: ${extraParams}`)

            this.bool = true
            this.text = item
            // this.fruitVisible[index] = Visibility.None
            // 跨组件需要的-start，，同组件拖拽可以不需要
            let data: unifiedDataChannel.PlainText = new unifiedDataChannel.PlainText();
            data.abstract = JSON.stringify(index);
            data.textContent = JSON.stringify(this.numbers);
            (event as DragEvent).setData(new unifiedDataChannel.UnifiedData(data));
            // 跨组件需要的-end

            return this.pixelCellBuilder(item)
          })
          .onDragMove((event, extraParams) =>{
            hsLog.d(TAG,`===onDragMove: ${JSON.stringify(event)} === params: ${extraParams}`)
          })
          .onDragEnd((event, extraParams) => {
            hsLog.d(TAG,`===onDragEnd: ${JSON.stringify(event)} === params: ${extraParams}`)

          })
          .onTouch((event: TouchEvent) => {

            if (event.type === TouchType.Down) {
              this.eventType = 'Down'
              this.idx = index
            }
            if (event.type === TouchType.Up) {
              this.eventType = 'Up'
              if (this.bool) {
                // this.fruitVisible[index] = Visibility.Visible
              }
            }
            hsLog.d(TAG,`===onTouch: ${ this.eventType} === index: ${this.idx}`)

          })
        }, (item: string) => item)
      }
      .editMode(true)
      .height('50%')
      .width('90%')
      .border({ width: 1 })
      .padding(15)
      .divider({
        strokeWidth: 2,
        color: 0xFFFFFF,
        startMargin: 20,
        endMargin: 20
      })
      // .onDragEnter((event: DragEvent, extraParams: string) => {
      //   hsLog.d(TAG,'List onDragEnter, ' + extraParams + 'X:' + event.getX() + 'Y:' + event.getY())
      // })
      // .onDragMove((event: DragEvent, extraParams: string) => {
      //   hsLog.d(TAG,'List onDragMove, ' + extraParams + 'X:' + event.getX() + 'Y:' + event.getY())
      // })
      // .onDragLeave((event: DragEvent, extraParams: string) => {
      //   hsLog.d(TAG,'List onDragLeave, ' + extraParams + 'X:' + event.getX() + 'Y:' + event.getY())
      // })
      // 这一种是同组件内接受
      .onDrop((event: DragEvent, extraParams?: string) => {
        let jsonString = JSON.parse(extraParams ?? "") as extraParams
        // AlertDialog.show({ message: jsonString.insertIndex + "" })
        hsLog.d(TAG, `aa == onDrop ` + extraParams)
        // if (this.bool) {
        //   // 通过splice方法插入元素
        //   this.numbers.splice(jsonString.insertIndex, 0, this.text)
        //   this.bool = false
        // }
        // this.fruitVisible[this.idx] = Visibility.None
      })
      // 跨组件接受
      .allowDrop([uniformTypeDescriptor.UniformDataType.PLAIN_TEXT])
      .onDrop((dragEvent?: DragEvent, extraParams?: string) => {
        hsLog.d(TAG, `bb == onDrop ` + extraParams)

        // Drag.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
        //   let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
        //   let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText;
        //   const index = plainText.abstract //获取的下标
        //   // const value = JSON.parse(plainText.textContent) as 数据类型 //移动的数据
        // })
      })
    }.width('100%').height('100%').padding({ top: 20 }).margin({ top: 20 })
  }
}
