import { curves, ComponentContent, OverlayManager } from '@kit.ArkUI';
import { YWConstants } from '@learn/constants_har';
import { hsLog } from '@learn/logger_har';


// 定义图片信息接口
interface PictureInfo {
  name: string;
  picNum: string;
}

// 定义借阅人信息接口
interface BorrowerInfo {
  name: string;
  cardNum: string;
}

class Params {
  context: UIContext;
  offset: Position;
  constructor(context: UIContext, offset: Position) {
    this.context = context;
    this.offset = offset;
  }
}

@Builder
function builderOverlay(params: Params) {
  Column() {
    Stack() {
    }.width(50).height(50).backgroundColor(Color.Yellow).position(params.offset).borderRadius(50)
    .onClick(() => {
      params.context.showAlertDialog(
        {
          title: 'title',
          message: 'Text',
          autoCancel: true,
          alignment: DialogAlignment.Center,
          gridCount: 3,
          confirm: {
            value: 'Button',
            action: () => { }
          },
          cancel: () => { }
        }
      );
    });
  }.focusable(false).width('100%').height('100%').hitTestBehavior(HitTestMode.Transparent);
}

const TAG = "PictureLibraryDemo"
@Builder
export function TestPictureLibraryBuilder() {

  NavDestination() {
    PictureLibraryDemo()
  }
  .onAppear(()=>{
    hsLog.i(TAG,"=======触发 onAppear")
  })
  .onDisAppear(()=>{
    hsLog.i(TAG,"=======触发 onDisAppear")

  })
  .onWillDisappear(()=>{
    hsLog.i(TAG,"=======触发 onWillDisappear")

  })
  .onShown(()=>{
    hsLog.i(TAG,"=======触发 onShown")


  })
  .onHidden(()=>{
    hsLog.i(TAG,"=======触发 onHidden")


  })

}


@Entry
@Component
struct PictureLibraryDemo {
  // 图片馆的图片列表
  private pictureList: Array<PictureInfo> = [
    { name: '图片1', picNum: 'PIC001' },
    { name: '图片2', picNum: 'PIC002' },
    { name: '图片3', picNum: 'PIC003' },
    { name: '图片4', picNum: 'PIC004' }
  ];
  // 借阅人列表
  private borrowerList: Array<BorrowerInfo> = [
    { name: '张三', cardNum: '123456789' },
    { name: '李四', cardNum: '987654321' },
    { name: '王五', cardNum: '555555555' },
    { name: '赵六', cardNum: '666666666' }
  ];

  // 半模态转场控制变量
  @State isSheetShow: boolean = false;
  // 全模态转场控制变量，用于选择借阅人
  @State isPresentForBorrower: boolean = false;
  // 全模态转场控制变量，用于选择图片
  @State isPresentForPicture: boolean = false;

  // 用于存储当前选择的图片信息
  @State currentPicture: PictureInfo | null = null;
  // 用于存储当前选择的借阅人信息
  @State currentBorrower: BorrowerInfo | null = null;

  private uiContext: UIContext = this.getUIContext();
  private overlayNode: OverlayManager = this.uiContext.getOverlayManager();
  private overlayContent: ComponentContent<Params>[] = [];
  controller: TextInputController = new TextInputController();

  aboutToAppear(): void {
    let uiContext = this.getUIContext();
    let componentContent = new ComponentContent(
      this.uiContext, wrapBuilder<[Params]>(builderOverlay),
      new Params(uiContext, { x: 0, y: 100 })
    );
    this.overlayNode.addComponentContent(componentContent, 0);
    this.overlayContent.push(componentContent);

    hsLog.i(TAG,"=======触发 aboutToAppear")

  }

  aboutToDisappear(): void {
    let componentContent = this.overlayContent.pop();
    this.overlayNode.removeComponentContent(componentContent);

    hsLog.i(TAG,"=======触发 aboutToDisappear")

  }

  onPageShow(): void {
    hsLog.i(TAG,"=======不会触发  onPageShow")
  }

  onPageHide(): void {
    hsLog.i(TAG,"=======不会触发 onPageHide")
  }

  @Builder
  PictureSelectionBuilder() {
    Column() {
      Row() {
        Text('选择图片')
          .fontSize(20)
          .fontColor(Color.White)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 30, bottom: 15 });
      }
      .backgroundColor(0x007dfe);

      Row() {
        Text('+ 添加图片')
          .fontSize(16)
          .fontColor(0x333333)
          .margin({ top: 10 })
          .padding({ top: 20, bottom: 20 })
          .width('92%')
          .borderRadius(10)
          .textAlign(TextAlign.Center)
          .backgroundColor(Color.White);
      }

      Column() {
        ForEach(this.pictureList, (item: PictureInfo, index: number) => {
          Row() {
            Column() {
              if (index % 2 == 0) {
                Column()
                  .width(20)
                  .height(20)
                  .border({ width: 1, color: 0x007dfe })
                  .backgroundColor(0x007dfe);
              } else {
                Column()
                  .width(20)
                  .height(20)
                  .border({ width: 1, color: 0x007dfe });
              }
            }
            .width('20%');

            Column() {
              Text(item.name)
                .fontColor(0x333333)
                .fontSize(18);
              Text(item.picNum)
                .fontColor(0x666666)
                .fontSize(14);
            }
            .width('60%')
            .alignItems(HorizontalAlign.Start);

            Column() {
              Text('选择')
                .fontColor(0x007dfe)
                .fontSize(16)
                .onClick(() => {
                  this.currentPicture = item;
                  this.isPresentForBorrower = true;
                });
            }
            .width('20%');
          }
          .padding({ top: 10, bottom: 10 })
          .border({ width: { bottom: 1 }, color: 0xf1f1f1 })
          .width('92%')
          .backgroundColor(Color.White);
        });
      }
      .padding({ top: 20, bottom: 20 });

      Text('确认选择图片')
        .width('90%')
        .height(40)
        .textAlign(TextAlign.Center)
        .borderRadius(10)
        .fontColor(Color.White)
        .backgroundColor(0x007dfe)
        .onClick(() => {
          // 这里可以添加确认选择图片后的逻辑，比如关闭模态等
          this.isPresentForPicture = false;
        });
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor(0xf5f5f5);
  }

  @Builder
  BorrowerSelectionBuilder() {
    Column() {
      Row() {
        Text('选择借阅人')
          .fontSize(20)
          .fontColor(Color.White)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 30, bottom: 15 });
      }
      .backgroundColor(0x007dfe);

      Row() {
        Text('+ 添加借阅人')
          .fontSize(16)
          .fontColor(0x333333)
          .margin({ top: 10 })
          .padding({ top: 20, bottom: 20 })
          .width('92%')
          .borderRadius(10)
          .textAlign(TextAlign.Center)
          .backgroundColor(Color.White);
      }

      Column() {
        ForEach(this.borrowerList, (item: BorrowerInfo, index: number) => {
          Row() {
            Column() {
              if (index % 2 == 0) {
                Column()
                  .width(20)
                  .height(20)
                  .border({ width: 1, color: 0x007dfe })
                  .backgroundColor(0x007dfe);
              } else {
                Column()
                  .width(20)
                  .height(20)
                  .border({ width: 1, color: 0x007dfe });
              }
            }
            .width('20%');

            Column() {
              Text(item.name)
                .fontColor(0x333333)
                .fontSize(18);
              Text(item.cardNum)
                .fontColor(0x666666)
                .fontSize(14);
            }
            .width('60%')
            .alignItems(HorizontalAlign.Start);

            Column() {
              Text('选择')
                .fontColor(0x007dfe)
                .fontSize(16)
                .onClick(() => {
                  this.currentBorrower = item;
                  // 这里可以添加选择借阅人后的逻辑，比如记录借阅信息等
                  console.log(`借阅人 ${this.currentBorrower.name} 选择了图片 ${this.currentPicture?.name}`);
                  this.isPresentForBorrower = false;
                });
            }
            .width('20%');
          }
          .padding({ top: 10, bottom: 10 })
          .border({ width: { bottom: 1 }, color: 0xf1f1f1 })
          .width('92%')
          .backgroundColor(Color.White);
        });
      }
      .padding({ top: 20, bottom: 20 });

      Text('确认选择借阅人')
        .width('90%')
        .height(40)
        .textAlign(TextAlign.Center)
        .borderRadius(10)
        .fontColor(Color.White)
        .backgroundColor(0x007dfe)
        .onClick(() => {
          // 这里可以添加确认选择借阅人后的逻辑，比如关闭模态等
          this.isPresentForBorrower = false;
        });
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor(0xf5f5f5);
  }

  @Builder
  PictureLibraryMain() {
    Column() {
      Row() {
        Text('图片馆借阅系统')
          .fontSize(20)
          .fontColor(Color.White)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 30, bottom: 15 });
      }
      .backgroundColor(0x007dfe);

      Row() {
        Text('+ 借阅图片')
          .fontSize(16)
          .fontColor(0x333333)
          .margin({ top: 10 })
          .padding({ top: 20, bottom: 20 })
          .width('92%')
          .borderRadius(10)
          .textAlign(TextAlign.Center)
          .backgroundColor(Color.White)
          .onClick(() => {
            this.isPresentForPicture = true;
          });
      }

      // 可以在这里显示当前借阅的信息等

    }
    .size({ width: '100%', height: '80%' })
    .backgroundColor(0xf5f5f5);
  }

  // 第二步：定义半模态展示界面
  // 通过@Builder构建模态展示界面
  @Builder
  MySheetBuilder() {
    Column() {
      Column() {
        // 这里可以添加一些图片馆的基本信息或其他相关内容
        Text('图片馆信息')
          .fontSize(18)
          .fontColor(0x333333)
          .padding({ top: 10, bottom: 10 });
      }
      .width('92%')
      .margin(15)
      .backgroundColor(Color.White)
      .shadow({ radius: 30, color: '#aaaaaa' })
      .borderRadius(10);

      Column() {
        Text('+ 选择图片/借阅人')
          .fontSize(18)
          .fontColor(Color.Orange)
          .fontWeight(FontWeight.Bold)
          .padding({ top: 10, bottom: 10 })
          .width('60%')
          .textAlign(TextAlign.Center)
          .borderRadius(15)
          .onClick(() => {
            // 这里可以根据具体情况决定是先选择图片还是借阅人，或者同时选择等逻辑
            this.isPresentForPicture = true;
          })
            // 通过全模态接口，绑定模态展示界面MyContentCoverBuilder。transition属性支持自定义转场效果，此处定义了x轴横向入场
          .bindContentCover($$this.isPresentForPicture, this.PictureSelectionBuilder(), {
            transition: TransitionEffect.translate({ x: 500 }).animation({ curve: curves.springMotion(0.6, 0.8) })
          });
      }
      .padding({ top: 60 });
    }
  }

  build() {
    Column() {
      Row() {
        // 这里可以添加一些页面顶部的信息，比如图片馆的标志等
        Text('图片馆')
          .fontSize(20)
          .fontColor(Color.White)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 20, bottom: 10 });
      }
      .backgroundColor(0x007dfe);

      this.PictureLibraryMain();

      Row() {
        Text("点击显示图片馆信息")
      }
      .width('100%')
      // .margin({ top: 200, bottom: 30 })
      .borderRadius(10)
      .backgroundColor(YWConstants.RandomColor())
      .onClick(() => {
        this.isSheetShow = !this.isSheetShow;
      })
      // 第一步：定义半模态转场效果
      .bindSheet($$this.isSheetShow, this.MySheetBuilder(), {
        height: SheetSize.MEDIUM,
        title: { title: "图片馆操作" },
      });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#30aaaaaa');
  }
}
