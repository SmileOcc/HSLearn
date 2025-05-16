import { curves, KeyboardAvoidMode, window } from '@kit.ArkUI';
import { YWAppUtils, YWWindowUtils } from '@learn/common_har';
// import Curves from '@ohos.curves'
import { YWConstants } from '@learn/constants_har';
import { hsLog } from '@learn/logger_har';
import { TestAlertModel } from './view/teatAlert';
import { TestCoverSheet, TestCoverSheetBBB } from './view/TestBindCover';
import { BusinessError } from '@kit.BasicServicesKit';
import TestShowDialogModel, { Chat, TestSheetManager, TestSheetModel,
  TestSheetUIState } from './model/TestShowDialogModel';
import { TestCoverSheetTwo, TestCoverSheetTwoBBB } from './view/TestBindCoverTwo';

@Builder
export function TestAlertViewBuilder() {

  NavDestination() {
    TestAlertViewPage()
  }
  .hideTitleBar(true)

}

const TAG = "TestAlertViewPage"

@Entry
@Component
struct TestAlertViewPage {
  private TAG: string = "TestAlertViewPage";

  @Provide('NavPathStackKK') pageStackAAA: NavPathStack = new NavPathStack()

  testManager:TestSheetManager = new TestSheetManager()

  testMModel:TestSheetModel = new TestSheetModel()

  @State mainSheetUIState: TestSheetUIState = this.testManager.sheetUIState

  @Provide isShow: boolean = false

  @State isBindShow: boolean = false;
  @State sheetHeight: number = 300;

  @State isBindShow2: boolean = false;

  private testAlertModel?: TestAlertModel

  private sub_windowClass: window.Window | null = null;


  @State isShowA: boolean = false
  @State isShowB: boolean = false
  @State chatList:Array<Chat> = []

  @State testAAMModel: TestSheetModel = new TestSheetModel()




  @Provide("TestSheetUIAA")
  testUIAModel?: TestSheetModel = this.mainSheetUIState.testUIAModel

  @Provide("TestSheetUIBB")
  testUIBModel?: TestSheetModel = this.mainSheetUIState.testUIBModel
  /////
  private logic: TestShowDialogModel = new TestShowDialogModel();
  private showDialog: boolean = false;
  private dialogMessage: string = '';


  @Builder
  PagesMap(name: string) {
    if (name === 'DialogPage') {
      DialogPage()
    }
  }

  changeModel(id: string) {
    if (id === "isShowA") {
      this.testMModel = new TestSheetModel()

      let testAAAM =  new TestSheetModel()
      this.testManager.testAModel = testAAAM

      testAAAM.showXAlert = (id)=> {
        if (id === "isShowA") {
          this.isShowA = true
        } else if (id === "isShowB") {
          this.isShowB = true
        }
      }

      testAAAM.showBAlert = () => {
        this.isShowA = false
        this.isShowB = true
      }
      this.testAAMModel = testAAAM
      let list = this.testAAMModel.modeListA
      let kk = ""
    } else if (id === "isShowB") {
      this.testMModel = new TestSheetModel()
      this.testMModel.modeListA = [{cid:"cid_1", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"change == bbbbbbbb setb"},
        {cid:"cid_2", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"bbbbbb 大家哦殴打巨大简欧大家记得京东数科JOJO"},
        {cid:"cid_3", profile:$r('app.media.user_avatar'),nickname:"bbbb",content:"ccccccc 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
        {cid:"cid_4", profile:$r('app.media.user_avatar'),nickname:"cccc",content:"ddddd 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
        {cid:"cid_5", profile:$r('app.media.user_avatar'),nickname:"dddd",content:"44444444 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
        {cid:"cid_6", profile:$r('app.media.user_avatar'),nickname:"eeee",content:"3333333 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
        {cid:"cid_7", profile:$r('app.media.user_avatar'),nickname:"ffff",content:"123213213123"}]

    }
    this.testMModel.showXAlert = (id)=> {
      if (id === "isShowA") {
        this.isShowA = true
      } else if (id === "isShowB") {
        this.isShowB = true
      }
    }

    this.testMModel.showBAlert = () => {
      this.isShowA = false
      this.isShowB = true
    }
    this.testMModel.dissBlack = (id) => {
      hsLog.d(TAG,`alert === dismiss ${id}`)

    }

    this.chatList = this.testMModel.modeListB

  }


  changeUIAModel(id: string) {
    let tempModel = new TestSheetModel()
    if (id === "isShowA") {
      this.testManager.sheetUIState.testUIAModel = tempModel
      this.testUIAModel = this.mainSheetUIState.testUIAModel

    } else if (id === "isShowB") {
      tempModel.modeListB = [{cid:"cid_1", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"change == bbbbbbbb setb"},
        {cid:"cid_2", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"bbbbbb 大家哦殴打巨大简欧大家记得京东数科JOJO"},
        {cid:"cid_3", profile:$r('app.media.user_avatar'),nickname:"bbbb",content:"ccccccc 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
        {cid:"cid_4", profile:$r('app.media.user_avatar'),nickname:"cccc",content:"ddddd 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
        {cid:"cid_5", profile:$r('app.media.user_avatar'),nickname:"dddd",content:"44444444 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
        {cid:"cid_6", profile:$r('app.media.user_avatar'),nickname:"eeee",content:"3333333 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
        {cid:"cid_7", profile:$r('app.media.user_avatar'),nickname:"ffff",content:"123213213123"}]

      this.testManager.sheetUIState.testUIBModel = tempModel
      this.testUIBModel = this.mainSheetUIState.testUIBModel

    }
    tempModel.showXAlert = (id)=> {
      if (id === "isShowA") {
        if (this.testManager.sheetUIState.testUIAModel) {
          this.testManager.sheetUIState.testUIAModel.isShowA = true
          this.testUIAModel = this.testManager.sheetUIState.testUIAModel
        }
      } else if (id === "isShowB") {
        if (this.testManager.sheetUIState.testUIBModel) {
          this.testManager.sheetUIState.testUIBModel.isShowB = true
          this.testUIBModel = this.testManager.sheetUIState.testUIBModel
        }
      }
    }

    tempModel.showBAlert = () => {
      if (this.testManager.sheetUIState.testUIBModel) {
        this.testManager.sheetUIState.testUIBModel.isShowB = true
        this.testUIBModel = this.testManager.sheetUIState.testUIBModel
      }

      if (this.testManager.sheetUIState.testUIAModel) {
        this.testManager.sheetUIState.testUIAModel.isShowA = false
        this.testUIAModel = this.testManager.sheetUIState.testUIAModel
      }
    }
    tempModel.dissBlack = (id) => {
      hsLog.d(TAG,`alert === dismiss ${id}`)
      // this.isShowA = false
      // this.isShowB = false
      // if (id === "isShowA") {
      //   this.isShowA = false
      // } else if (id === "isShowB") {
      //   this.isShowB = false
      // } else {
      //   this.isShowA = false
      //   this.isShowA = false
      // }
    }
  }

  aboutToAppear(): void {
    // 设置虚拟键盘抬起时压缩页面大小为减去键盘的高度
    // YWAppUtils.getWindowStage().getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)


    this.testMModel.showXAlert = (id)=> {
      // if (id === "isShowA") {
      //   this.isShowA = true
      // } else if (id === "isShowB") {
      //   this.isShowB = true
      // }
    }

    this.testMModel.showBAlert = () => {
      this.isShowA = false
      this.isShowB = true
      this.testMModel.isShowA = false
      this.testMModel.isShowB = true
    }
    this.testMModel.dissBlack = (id) => {
      // if (id === "isShowA") {
      //   this.isShowA = false
      // } else if (id === "isShowB") {
      //   this.isShowB = false
      // } else {
      //   this.isShowA = false
      //   this.isShowA = false
      // }
    }
    this.chatList = this.testMModel.modeListB
    let kkk = this.testMModel.testMessage

    this.testManager.testAModel = this.testMModel



      // 设置回调函数
    this.logic.setShowDialogCallback({operateBlock:(message)=>{
      this.dialogMessage = message;
      this.showDialog = true;

      AlertDialog.show({ message: message })

    }});

    this.testAlertModel = new TestAlertModel(this.getUIContext())

    this.showSubWindow()
    setTimeout(()=>{
      try {
        this.destroySubWindow();
        // window.getLastWindow(getContext()).then((win)=>{
        //   console.error(this.TAG, 'win:' + JSON.stringify(win));
        //   let height = win.getWindowDecorHeight();
        //   console.error(this.TAG, 'height:' + height);
        // })

        let windowStage_:  window.WindowStage = globalThis.mWindowStage;
        let win = windowStage_.getMainWindowSync();
        let height = win.getWindowDecorHeight();
      }catch (e){
        console.error(this.TAG, 'e:' + JSON.stringify(e));
      }
    },1000)
  }

  private showSubWindow() {
    console.log(this.TAG, 'showSubWindow start');
    let windowStage_:  window.WindowStage = YWWindowUtils.getWindowStage()//globalThis.mWindowStage;
    // 1.创建应用子窗口。
    if (windowStage_ == null) {
      console.error(this.TAG, 'Failed to create the subwindow. Cause: windowStage_ is null');
    }
    else {
      windowStage_.createSubWindow("mySubWindowAA", (err: BusinessError, data) => {
        let errCode: number = err.code;
        if (errCode) {
          console.error(this.TAG, 'Failed to create the subwindow. Cause: ' + JSON.stringify(err));
          return;
        }
        this.sub_windowClass = data;
        console.info(this.TAG, 'Succeeded in creating the subwindow. Data: ' + JSON.stringify(data));
        // 2.子窗口创建成功后，设置子窗口的位置、大小及相关属性等。
        this.sub_windowClass.moveWindowTo(300, 300, (err: BusinessError) => {
          let errCode: number = err.code;
          if (errCode) {
            console.error(this.TAG, 'Failed to move the window. Cause:' + JSON.stringify(err));
            return;
          }
          console.info(this.TAG, 'Succeeded in moving the window.');
        });
        this.sub_windowClass.resize(500, 500, (err: BusinessError) => {
          let errCode: number = err.code;
          if (errCode) {
            console.error(this.TAG, 'Failed to change the window size. Cause:' + JSON.stringify(err));
            return;
          }
          console.info(this.TAG, 'Succeeded in changing the window size.');
        });
        // 3.为子窗口加载对应的目标页面。
        this.sub_windowClass.setUIContent("pages/accountInfo/ScrollListPage", (err: BusinessError) => {
          let errCode: number = err.code;
          if (errCode) {
            console.error(this.TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
            return;
          }
          console.info(this.TAG, 'Succeeded in loading the content.');
          // 3.显示子窗口。
          (this.sub_windowClass as window.Window).showWindow((err: BusinessError) => {
            let errCode: number = err.code;
            if (errCode) {
              console.error(this.TAG, 'Failed to show the window. Cause: ' + JSON.stringify(err));
              return;
            }
            console.info(this.TAG, 'Succeeded in showing the window.');
          });
        });
      })
    }
    console.log(this.TAG, 'showSubWindow end');
  }

  destroySubWindow() {
    // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
    (this.sub_windowClass as window.Window).destroyWindow((err: BusinessError) => {
      let errCode: number = err.code;
      if (errCode) {
        console.error(this.TAG, 'Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info(this.TAG, 'Succeeded in destroying the window.');
    });
  }



  @Builder
  myBuilder() {
    Column() {
      Button("change height")
        .margin(10)
        .fontSize(20)
        .onClick(() => {
          this.sheetHeight = 500;
        })

      Button("Set Illegal height")
        .margin(10)
        .fontSize(20)
        .onClick(() => {
          this.sheetHeight = -1;
        })

      Button("close modal 1")
        .margin(10)
        .fontSize(20)
        .onClick(() => {
          this.isShow = false;
        })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  myBuilder22() {
    Column() {
      Button("content1")
        .margin(10)
        .fontSize(20)

      Button("content2")
        .margin(10)
        .fontSize(20)
    }
    .width('100%')
  }

  build() {
    Navigation(this.pageStackAAA) {
      Scroll(){
        Column() {
          Text(this.testMModel.testMessage)
          Button('路由 模态 底部动画弹窗Alert，长按移动cell')
            .onClick(() => {
              this.pageStackAAA.pushPathByName('DialogPage', '');
            })

          // TestCoverSheet({isShowA:this.testMModel.isShowA})
          TestCoverSheet({isShowA:this.isShowA, testAAMModel:this.testAAMModel, testMModel: this.testMModel})

          TestCoverSheetBBB({isShowB:this.isShowB, chatList:this.chatList, testMModel: this.testMModel})

          Button('bindContentCoverl show A')
            .onClick(() => {
              // this.testMModel.isShowA = true
              this.isShowA = true
            })

          Button('bindContentCoverl model show A')
            .onClick(() => {
              // this.testMModel.isShowA = true
              // this.isShowA = true
              this.testMModel.showBAlert?.()
            })

          Button('bindContentCoverl show B')
            .onClick(() => {
              // this.testMModel.isShowB = true
              this.isShowB = true
            })

          Button('bindContentCoverl model show B')
            .onClick(() => {
              this.testMModel.showXAlert?.('isShowB')
            })

          Button('changeA list数据')
            .onClick(() => {
              this.testMModel.modeListA = [{cid:"cid_1", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"change == aaaaaaa"},
                {cid:"cid_2", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"bbbbbb 大家哦殴打巨大简欧大家记得京东数科JOJO"},
                {cid:"cid_3", profile:$r('app.media.user_avatar'),nickname:"bbbb",content:"ccccccc 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
                {cid:"cid_4", profile:$r('app.media.user_avatar'),nickname:"cccc",content:"ddddd 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
                {cid:"cid_5", profile:$r('app.media.user_avatar'),nickname:"dddd",content:"44444444 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
                {cid:"cid_6", profile:$r('app.media.user_avatar'),nickname:"eeee",content:"3333333 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
                {cid:"cid_7", profile:$r('app.media.user_avatar'),nickname:"ffff",content:"123213213123"}]

            })

          Button('changeAAA list数据')
            .onClick(() => {

              this.changeModel('isShowA')
            })
          Button('changeB list数据')
            .onClick(() => {

              this.changeModel('isShowB')
            })

          Blank().width('100%').height(1).backgroundColor(Color.Black)

          TestCoverSheetTwo()
          TestCoverSheetTwoBBB()

          Button('测试开始初始化数据')
            .onClick(() => {
              this.changeUIAModel("isShowA")
              this.changeUIAModel("isShowB")
            })

          Button('show uiState AAA')
            .onClick(() => {
              if (this.testUIAModel) {
                this.testUIAModel.isShowA = true
              }
            })

          Button('show uiState BBB')
            .onClick(() => {
              if (this.testUIBModel) {
                this.testUIBModel.isShowB = true
              }
            })

          Blank().width('100%').height(1).backgroundColor(Color.Black)

          Button('bindContentCover底部半弹窗，长按移动cell')
            .onClick(() => {
              this.isShow = true
            })

          Button('bindSheet底部半弹窗')
            .onClick(() => {
              this.isBindShow = true
            })
            .bindSheet($$this.isBindShow, this.myBuilder(), {
              height: this.sheetHeight,
              backgroundColor: Color.Green,
              onWillAppear: () => {
                console.log("BindSheet onWillAppear.");
              },
              onAppear: () => {
                console.log("BindSheet onAppear.");
              },
              onWillDisappear: () => {
                console.log("BindSheet onWillDisappear.");
              },
              onDisappear: () => {
                console.log("BindSheet onDisappear.");
                this.isBindShow = false
              }
            })

          Button('bindSheet底部半弹窗 多个高度，可以拖动调整')
            .onClick(() => {
              this.isBindShow2 = true
            })
            .bindSheet($$this.isBindShow2, this.myBuilder22(), {
              detents: [SheetSize.MEDIUM, SheetSize.LARGE, 200],
              backgroundColor: Color.Green,
              onWillAppear: () => {
                console.log("BindSheet onWillAppear.");
              },
              onAppear: () => {
                console.log("BindSheet onAppear.");
              },
              onWillDisappear: () => {
                console.log("BindSheet onWillDisappear.");
              },
              onDisappear: () => {
                console.log("BindSheet onDisappear.");
                this.isBindShow2 = false
              }
            })

          Button('数据Model 里触发弹窗')
            .onClick(() => {
              this.testAlertModel?.showAlert()
            })

          Button('数据Model 回调返回到UI触发弹窗')
            .onClick(() => {
              this.logic.doBusinessLogic()
              // AlertDialog.show({ message: '获取数据成功' })

            })

          Text("点击创建子窗口 显示")
            .id('SubWinPageHelloWorld')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .onClick(()=>{
              this.showSubWindow();
            })

          Text("点击销毁子窗口")
            .id('SubWinPageHelloWorld')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .onClick(()=>{
              this.destroySubWindow();
            })


          // 显示弹框
          // if (this.showDialog) {
          //
          //
          // }
        }
        .height('100%')
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }

    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PagesMap)
  }
}

// @Component
// export struct DialogPage {
//   @Consume('NavPathStack') pageStack: NavPathStack;
//   @State heightSize: string = '75%';
//   @State opacityNum: number = 1;
//
//   @State dragItem?: Chat = undefined
//   @State scaleItem?: Chat = undefined
//
//   @State neighborItem?: Chat = undefined
//   @State neighborScale: number = -1
//   private dragRefOffset: number = 0
//   @State offsetX: number = 0
//   @State offsetY: number = 0
//   private ITEM_INTV: number = 120
//
//   @State private chatList:Array<Chat> = new Array()
//
//   aboutToAppear(): void {
//     this.chatList = [{cid:"cid_1", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"123213213123"},
//       {cid:"cid_2", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"bbbbbb 大家哦殴打巨大简欧大家记得京东数科JOJO"},
//       {cid:"cid_3", profile:$r('app.media.user_avatar'),nickname:"bbbb",content:"ccccccc 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
//       {cid:"cid_4", profile:$r('app.media.user_avatar'),nickname:"cccc",content:"ddddd 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
//       {cid:"cid_5", profile:$r('app.media.user_avatar'),nickname:"dddd",content:"44444444 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
//       {cid:"cid_6", profile:$r('app.media.user_avatar'),nickname:"eeee",content:"3333333 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
//       {cid:"cid_7", profile:$r('app.media.user_avatar'),nickname:"ffff",content:"123213213123"}]
//   }
//
//   @Builder
//   testA() {
//     NavDestination() {
//       Stack({ alignContent: Alignment.Bottom }) {
//         Column() {
//           Row() {
//             Text('评论')
//               .fontSize(20)
//               .fontWeight(FontWeight.Bold)
//             Blank()
//             Button() {
//               Image($r('app.media.ic_close'))
//                 .width(18)
//             }
//             .padding(10)
//             .backgroundColor('rgba(0,0,0,0.05)')
//             .onClick(() => {
//               this.pageStack.pop();
//             })
//           }
//           .padding(15)
//           .width('100%')
//
//           List({space:20}) {
//             ForEach(this.chatList, (item: Chat) => {
//               ListItem() {
//                 Row({space:10}) {
//                   Image(item.profile)
//                     .width(40)
//                     .height(40)
//                     .borderRadius(40)
//                   Column({ space: 10 }) {
//                     Text(item.nickname)
//                       .fontSize(16)
//                       .fontColor('#999999')
//                     Text(item.content)
//                       .fontSize(16)
//                       .fontColor('#333333')
//                   }
//                   .width('100%')
//                   .justifyContent(FlexAlign.Start)
//                   .alignItems(HorizontalAlign.Start)
//                 }
//                 .width('100%')
//                 .justifyContent(FlexAlign.Start)
//                 .alignItems(VerticalAlign.Top)
//               }
//             })
//           }
//           .scrollBar(BarState.Off)
//           .width('100%')
//           .layoutWeight(1)
//
//           TextInput({ placeholder: '写评论' })
//             .height(40)
//             .width('100%')
//         }
//         .borderRadius({
//           topLeft: 32,
//           topRight: 32
//         })
//         .backgroundColor(Color.White)
//         .height(this.heightSize)
//         .width('100%')
//         .padding(10)
//         .transition(
//           TransitionEffect.OPACITY.animation({
//             duration: 500,
//             curve: Curve.Friction
//           })
//         )
//       }
//       .height('100%')
//       .width('100%')
//       .onClick(()=>{
//         animateTo({
//           duration: 500,
//           curve: Curve.Friction,
//           onFinish: () => {
//             this.pageStack.pop()
//           }
//         }, () => {
//           this.heightSize = '0%'
//           this.opacityNum = 0
//         })
//       })
//     }
//     .opacity(this.opacityNum)
//     .backgroundColor('rgba(0,0,0,0.2)')
//     .hideTitleBar(true)
//     .mode(NavDestinationMode.DIALOG)
//   }
//
//   @Builder
//   centerList(){
//     List({ space: 20, initialIndex: 0 }) {
//       ForEach(this.chatList, (item: Chat) => {
//         ListItem() {
//           Row({space:10}) {
//             Image(item.profile)
//               .width(40)
//               .height(40)
//               .borderRadius(40)
//             Column({ space: 10 }) {
//               Text(item.nickname)
//                 .fontSize(16)
//                 .fontColor('#999999')
//               Text(item.content)
//                 .fontSize(16)
//                 .fontColor('#333333')
//             }
//             .layoutWeight(1)
//             .justifyContent(FlexAlign.Start)
//             .alignItems(HorizontalAlign.Start)
//           }
//           .width('100%')
//           .borderRadius(10)
//           .backgroundColor(0xFFFFFF)
//           .justifyContent(FlexAlign.Start)
//           .alignItems(VerticalAlign.Top)
//           .shadow(this.scaleItem == item ? { radius: 70, color: '#15000000', offsetX: 0, offsetY: 0 } :
//             { radius: 0, color: '#15000000', offsetX: 0, offsetY: 0 })
//           .animation({ curve: Curve.Sharp, duration: 300 })
//         }
//         // .backgroundColor(YWConstants.RandomColor())
//         .backgroundColor(Color.Green)
//         .margin({ left: 12, right: 12 })
//         .scale({ x: this.scaleSelect(item), y: this.scaleSelect(item) })
//         .zIndex(this.dragItem == item ? 1 : 0)
//         .translate(this.dragItem == item ? { y: this.offsetY } : { y: 0 })
//         .gesture(
//           // 以下组合手势为顺序识别，当长按手势事件未正常触发时则不会触发拖动手势事件
//           GestureGroup(GestureMode.Sequence,
//             LongPressGesture({ repeat: true })
//               .onAction((event?: GestureEvent) => {
//                 animateTo({ curve: Curve.Friction, duration: 300 }, () => {
//                   this.scaleItem = item
//                   hsLog.d(TAG,`===开始长按 缩放 ${item.nickname} _ ${item.cid}`)
//                 })
//               })
//               .onActionEnd(() => {
//                 animateTo({ curve: Curve.Friction, duration: 300 }, () => {
//                   this.scaleItem = undefined
//                   hsLog.d(TAG,`===结束长按 ${item.nickname} _ ${item.cid}`)
//
//                 })
//               }),
//             PanGesture({ fingers: 1, direction: null, distance: 0 })
//               .onActionStart(() => {
//                 this.dragItem = item
//                 this.dragRefOffset = 0
//
//                 hsLog.d(TAG,`===开始移动 ${item.nickname} _ ${item.cid}`)
//
//               })
//               .onActionUpdate((event: GestureEvent) => {
//                 this.offsetY = event.offsetY - this.dragRefOffset
//                 // console.log('Y:' + this.offsetY.toString())
//                 this.neighborItem = undefined
//                 let index = this.chatList.indexOf(item)
//                 let curveValue = curves.initCurve(Curve.Sharp) /////
//                 let value: number = 0
//                 //根据位移计算相邻项的缩放
//                 if (this.offsetY < 0) {
//                   value = curveValue.interpolate(-this.offsetY / this.ITEM_INTV)
//                   this.neighborItem = this.chatList[index-1]
//                   this.neighborScale = 1 - value / 20;
//                   hsLog.d(TAG,'neighborScale:' + this.neighborScale.toString())
//                 } else if (this.offsetY > 0) {
//                   value = curveValue.interpolate(this.offsetY / this.ITEM_INTV)
//                   this.neighborItem = this.chatList[index+1]
//                   this.neighborScale = 1 - value / 20;
//                 }
//                 //根据位移交换排序
//                 if (this.offsetY > this.ITEM_INTV / 2) {
//                   animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
//                     this.offsetY -= this.ITEM_INTV
//                     this.dragRefOffset += this.ITEM_INTV
//                     this.itemMove(index, index + 1)
//                   })
//                 } else if (this.offsetY < -this.ITEM_INTV / 2) {
//                   animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
//                     this.offsetY += this.ITEM_INTV
//                     this.dragRefOffset -= this.ITEM_INTV
//                     this.itemMove(index, index - 1)
//                   })
//                 }
//               })
//               .onActionEnd((event: GestureEvent) => {
//                 animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
//                   this.dragItem = undefined
//                   this.neighborItem = undefined
//                 })
//                 animateTo({
//                   curve: curves.interpolatingSpring(14, 1, 170, 17), delay: 150
//                 }, () => {
//                   this.scaleItem = undefined
//                 })
//               })
//           )
//             .onCancel(() => {
//               animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
//                 this.dragItem = undefined
//                 this.neighborItem = undefined
//               })
//               animateTo({
//                 curve: curves.interpolatingSpring(14, 1, 170, 17), delay: 150
//               }, () => {
//                 this.scaleItem = undefined
//               })
//             })
//         )
//       }, (item:Chat) => item.cid)
//     }
//     .scrollBar(BarState.Off)
//     .width('100%')
//     .backgroundColor(Color.Yellow)
//     .layoutWeight(1)
//   }
//
//   @Builder
//   testB() {
//     NavDestination() {
//       Stack({ alignContent: Alignment.Bottom }) {
//
//         Column() {
//         }
//         .width('100%')
//         .height('100%')
//         .backgroundColor('rgba(0,0,0,0.5)')
//         .opacity(this.opacityNum)
//         .transition(
//           TransitionEffect.OPACITY.animation({
//             duration: 500,
//             curve: Curve.Friction
//           })
//         )
//         .onClick(() => {
//           animateTo({
//             duration: 500,
//             curve: Curve.Friction,
//             onFinish: () => {
//               this.pageStack.pop()
//             }
//           }, () => {
//             this.heightSize = '0%'
//             this.opacityNum = 0
//           })
//         })
//         .expandSafeArea()
//
//         Column() {
//           // Row() {
//           //   Text('评论')
//           //     .fontSize(20)
//           //     .fontWeight(FontWeight.Bold)
//           //   Blank()
//           //   Button() {
//           //     Image($r('app.media.ic_close'))
//           //       .width(18)
//           //   }
//           //   .padding(10)
//           //   .backgroundColor('rgba(0,0,0,0.05)')
//           //   .onClick(() => {
//           //     this.pageStack.pop();
//           //   })
//           // }
//           // .padding(15)
//           // .width('100%')
//
//           Row() {
//             Stack({alignContent: Alignment.End}){
//               Text('评论')
//                 .fontSize(20)
//                 .fontWeight(FontWeight.Bold)
//                 .width('100%')
//                 .textAlign(TextAlign.Center)
//                 .backgroundColor(Color.White)
//
//               Button() {
//                 Image($r('app.media.ic_close'))
//                   .width(18)
//               }
//               .padding(10)
//               // .backgroundColor('rgba(0,0,0,0.05)')
//               .backgroundColor(YWConstants.RandomColor())
//               .onClick(() => {
//                 this.pageStack.pop();
//               })
//             }
//             .height('60vp')
//             .backgroundColor(YWConstants.RandomColor())
//           }
//           .padding(15)
//           .width('100%')
//
//           this.centerList()
//
//           TextInput({ placeholder: '写评论' })
//             .height(40)
//             .width('100%')
//         }
//         .borderRadius({
//           topLeft: 32,
//           topRight: 32
//         })
//         .expandSafeArea()
//         .backgroundColor(Color.White)
//         .height(this.heightSize)
//         .width('100%')
//         .padding(10)
//         .transition(
//           TransitionEffect.move(TransitionEdge.BOTTOM)
//             .animation({
//               duration: 500,
//               curve: Curve.Friction
//             })
//         )
//       }
//       .height('100%')
//       .width('100%')
//     }
//     .opacity(this.opacityNum)
//     .backgroundColor('rgba(0,0,0,0.2)')
//     .hideTitleBar(true)
//     .mode(NavDestinationMode.DIALOG)
//   }
//
//   scaleSelect(item: Chat): number {
//     if (this.scaleItem?.cid == item.cid) {
//       hsLog.d(TAG,`===放大 ${item.nickname}_${item.cid}`)
//       return 1.05
//     } else if (this.neighborItem?.cid == item.cid) {
//       hsLog.d(TAG,`===缩小 ${item.nickname}_${item.cid}`)
//       return this.neighborScale
//     } else {
//       return 1
//     }
//   }
//   itemMove(index: number, newIndex: number): void {
//     hsLog.d(TAG,`开始移动： ${index} --> ${newIndex}`)
//     let tmp = this.chatList.splice(index, 1)
//     this.chatList.splice(newIndex, 0, tmp[0])
//   }
//
//   build() {
//     this.testB()
//   }
// }
//
// interface Chat {
//   cid: string,
//   profile: Resource,
//   nickname: string,
//   content: string,
// }


@Component
export struct DialogPage {
  @Consume('NavPathStackKK') pageStack: NavPathStack;
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
  testA() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
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
              this.pageStack.pop();
            })
          }
          .padding(15)
          .width('100%')

          List({space:20}) {
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
                  .width('100%')
                  .justifyContent(FlexAlign.Start)
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
                .alignItems(VerticalAlign.Top)
              }
            })
          }
          .scrollBar(BarState.Off)
          .width('100%')
          .layoutWeight(1)

          TextInput({ placeholder: '写评论' })
            .height(40)
            .width('100%')
        }
        .borderRadius({
          topLeft: 32,
          topRight: 32
        })
        .backgroundColor(Color.White)
        .height(this.heightSize)
        .width('100%')
        .padding(10)
        .transition(
          TransitionEffect.OPACITY.animation({
            duration: 500,
            curve: Curve.Friction
          })
        )
      }
      .height('100%')
      .width('100%')
      .onClick(()=>{
        animateTo({
          duration: 500,
          curve: Curve.Friction,
          onFinish: () => {
            this.pageStack.pop()
          }
        }, () => {
          this.heightSize = '0%'
          this.opacityNum = 0
        })
      })
    }
    .opacity(this.opacityNum)
    .backgroundColor('rgba(0,0,0,0.2)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
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
        // .backgroundColor(YWConstants.RandomColor())
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
    NavDestination() {
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
              this.pageStack.pop()
            }
          }, () => {
            this.heightSize = '0%'
            this.opacityNum = 0
          })
        })
        .expandSafeArea()

        Column() {
          // Row() {
          //   Text('评论')
          //     .fontSize(20)
          //     .fontWeight(FontWeight.Bold)
          //   Blank()
          //   Button() {
          //     Image($r('app.media.ic_close'))
          //       .width(18)
          //   }
          //   .padding(10)
          //   .backgroundColor('rgba(0,0,0,0.05)')
          //   .onClick(() => {
          //     this.pageStack.pop();
          //   })
          // }
          // .padding(15)
          // .width('100%')

          Row() {
            Stack({alignContent: Alignment.End}){
              Text('评论')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .width('100%')
                .textAlign(TextAlign.Center)
                .backgroundColor(Color.White)

              Button() {
                Image($r('app.media.ic_close'))
                  .width(18)
              }
              .padding(10)
              // .backgroundColor('rgba(0,0,0,0.05)')
              .backgroundColor(YWConstants.RandomColor())
              .onClick(() => {
                this.pageStack.pop();
              })
            }
            .height('60vp')
            .backgroundColor(YWConstants.RandomColor())
          }
          .padding(15)
          .width('100%')

          this.centerList()

          TextInput({ placeholder: '写评论' })
            .height(40)
            .width('100%')
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
    }
    .opacity(this.opacityNum)
    .backgroundColor('rgba(0,0,0,0.2)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
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

  build() {
    this.testB()
  }
}
