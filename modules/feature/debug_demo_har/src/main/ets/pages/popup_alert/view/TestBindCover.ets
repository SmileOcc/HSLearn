import { hsLog } from "@learn/logger_har";
import { curves } from "@kit.ArkUI";

const TAG = "TestCoverSheet"

@Component
export struct  TestCoverSheet {

  @Consume isShow: boolean

  build() {
    Column(){

    }.bindContentCover(this.isShow, this.myBuilder2(),{
      modalTransition: ModalTransition.NONE,
      // backgroundColor: Color.Pink,
      onWillAppear: () => {
        hsLog.d(TAG,"BindContentCover onWillAppear.");
      },
      onAppear: () => {
        hsLog.d(TAG,"BindContentCover onAppear.");
      },
      onWillDisappear: () => {
        hsLog.d(TAG,"BindContentCover onWillDisappear.");
      },
      onDisappear: () => {
        hsLog.d(TAG,"BindContentCover onDisappear.");
        this.isShow = false
      }
    })
  }

  @Builder
  myBuilder2() {
    CoverContent()
      .width('100%')
      .height('100%')
  }

}


@Component
export struct CoverContent {
  @Consume isShow: boolean
  @State isShow2: boolean = false;

  @State heightSize: string = '75%';
  @State opacityNum: number = 1;

  @State dragItem?: Chat = undefined
  @State scaleItem?: Chat = undefined

  @State neighborItem?: Chat = undefined
  @State neighborScale: number = -1
  private dragRefOffset: number = 0
  @State offsetX: number = 0
  @State offsetY: number = 0
  private ITEM_INTV: number = 120

  @State private chatList:Array<Chat> = new Array()

  aboutToAppear(): void {
    this.chatList = [{cid:"cid_1", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"123213213123"},
      {cid:"cid_2", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"bbbbbb 大家哦殴打巨大简欧大家记得京东数科JOJO"},
      {cid:"cid_3", profile:$r('app.media.user_avatar'),nickname:"bbbb",content:"ccccccc 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
      {cid:"cid_4", profile:$r('app.media.user_avatar'),nickname:"cccc",content:"ddddd 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
      {cid:"cid_5", profile:$r('app.media.user_avatar'),nickname:"dddd",content:"44444444 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
      {cid:"cid_6", profile:$r('app.media.user_avatar'),nickname:"eeee",content:"3333333 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
      {cid:"cid_7", profile:$r('app.media.user_avatar'),nickname:"ffff",content:"123213213123"}]
  }


  @Builder
  centerList(){
    List({ space: 20, initialIndex: 0 }) {
      ForEach(this.chatList, (item: Chat) => {
        ListItem() {
          Row({space:10}) {
            Image(item.profile)
              .width(40)
              .height(40)
              .borderRadius(40)
            Column({ space: 10 }) {
              Text(item.nickname)
                .fontSize(16)
                .fontColor('#999999')
              Text(item.content)
                .fontSize(16)
                .fontColor('#333333')
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Start)
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .borderRadius(10)
          .backgroundColor(0xFFFFFF)
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Top)
          .shadow(this.scaleItem == item ? { radius: 70, color: '#15000000', offsetX: 0, offsetY: 0 } :
            { radius: 0, color: '#15000000', offsetX: 0, offsetY: 0 })
          .animation({ curve: Curve.Sharp, duration: 300 })
        }
        .backgroundColor(Color.Green)
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
                  hsLog.d(TAG,`===开始长按 缩放 ${item.nickname} _ ${item.cid}`)
                })
              })
              .onActionEnd(() => {
                animateTo({ curve: Curve.Friction, duration: 300 }, () => {
                  this.scaleItem = undefined
                  hsLog.d(TAG,`===结束长按 ${item.nickname} _ ${item.cid}`)

                })
              }),
            PanGesture({ fingers: 1, direction: null, distance: 0 })
              .onActionStart(() => {
                this.dragItem = item
                this.dragRefOffset = 0

                hsLog.d(TAG,`===开始移动 ${item.nickname} _ ${item.cid}`)

              })
              .onActionUpdate((event: GestureEvent) => {
                this.offsetY = event.offsetY - this.dragRefOffset
                // console.log('Y:' + this.offsetY.toString())
                this.neighborItem = undefined
                let index = this.chatList.indexOf(item)
                let curveValue = curves.initCurve(Curve.Sharp) /////
                let value: number = 0
                //根据位移计算相邻项的缩放
                if (this.offsetY < 0) {
                  value = curveValue.interpolate(-this.offsetY / this.ITEM_INTV)
                  this.neighborItem = this.chatList[index-1]
                  this.neighborScale = 1 - value / 20;
                  hsLog.d(TAG,'neighborScale:' + this.neighborScale.toString())
                } else if (this.offsetY > 0) {
                  value = curveValue.interpolate(this.offsetY / this.ITEM_INTV)
                  this.neighborItem = this.chatList[index+1]
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
                  this.dragItem = undefined
                  this.neighborItem = undefined
                })
                animateTo({
                  curve: curves.interpolatingSpring(14, 1, 170, 17), delay: 150
                }, () => {
                  this.scaleItem = undefined
                })
              })
          )
            .onCancel(() => {
              animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
                this.dragItem = undefined
                this.neighborItem = undefined
              })
              animateTo({
                curve: curves.interpolatingSpring(14, 1, 170, 17), delay: 150
              }, () => {
                this.scaleItem = undefined
              })
            })
        )
      }, (item:Chat) => item.cid)
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .backgroundColor(Color.Yellow)
    .layoutWeight(1)
  }

  @Builder
  testB() {
    Stack({ alignContent: Alignment.Bottom }) {

      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor('rgba(0,0,0,0.5)')
      .opacity(this.opacityNum)
      .transition(
        TransitionEffect.OPACITY.animation({
          duration: 500,
          curve: Curve.Friction
        })
      )
      .onClick(() => {
        animateTo({
          duration: 500,
          curve: Curve.Friction,
          onFinish: () => {
            this.isShow = false
          }
        }, () => {
          this.heightSize = '0%'
          this.opacityNum = 0
        })
      })
      .expandSafeArea()

      Column() {
        Row() {
          Text('评论')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Blank()
          Button() {
            Image($r('app.media.ic_close'))
              .width(18)
          }
          .padding(10)
          .backgroundColor('rgba(0,0,0,0.05)')
          .onClick(() => {
            this.isShow = true
          })

        }
        .padding(15)
        .width('100%')

        this.centerList()

        TextInput({ placeholder: '写评论' })
          .height(40)
          .width('100%')
        Button(){
          Text("二次弹窗调试")
        }
        .padding(10)
        .backgroundColor('rgba(0,0,0,0.05)')
        .onClick(() => {
          this.isShow2 = true
        })
        .bindContentCover(this.isShow2, this.myBuilder2(), {
          modalTransition: ModalTransition.NONE,
          // backgroundColor: Color.Orange,
          onWillAppear: () => {
            hsLog.d(TAG,"2 BindContentCover onWillAppear.");
          },
          onAppear: () => {
            hsLog.d(TAG,"2 BindContentCover onAppear.");
          },
          onWillDisappear: () => {
            hsLog.d(TAG,"2 BindContentCover onWillDisappear.");
          },
          onDisappear: () => {
            hsLog.d(TAG,"2 BindContentCover onDisappear.");
            this.isShow2 = false
          }
        })
      }
      .borderRadius({
        topLeft: 32,
        topRight: 32
      })
      .expandSafeArea()
      .backgroundColor(Color.White)
      .height(this.heightSize)
      .width('100%')
      .padding(10)
      .transition(
        TransitionEffect.move(TransitionEdge.BOTTOM)
          .animation({
            duration: 500,
            curve: Curve.Friction
          })
      )
    }
    .height('100%')
    .width('100%')
    .opacity(this.opacityNum)
    .backgroundColor('rgba(0,0,0,0.2)')
  }

  scaleSelect(item: Chat): number {
    if (this.scaleItem?.cid == item.cid) {
      hsLog.d(TAG,`===放大 ${item.nickname}_${item.cid}`)
      return 1.05
    } else if (this.neighborItem?.cid == item.cid) {
      hsLog.d(TAG,`===缩小 ${item.nickname}_${item.cid}`)
      return this.neighborScale
    } else {
      return 1
    }
  }
  itemMove(index: number, newIndex: number): void {
    hsLog.d(TAG,`开始移动： ${index} --> ${newIndex}`)
    let tmp = this.chatList.splice(index, 1)
    this.chatList.splice(newIndex, 0, tmp[0])
  }

  ///

  @Builder
  myBuilder2() {
    Column() {
      Button("close modal 2")
        .margin(10)
        .fontSize(20)
        .onClick(() => {
          this.isShow2 = false;
        })
    }
    .backgroundColor('rgba(0,0,0,0.2)')
    .justifyContent(FlexAlign.End)
    .width('100%')
    .height('100%')
  }


  build() {
    this.testB()
  }
}

interface Chat {
  cid: string,
  profile: Resource,
  nickname: string,
  content: string,
}