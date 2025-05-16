import { KeyboardAvoidMode } from '@kit.ArkUI';
import { YWAppUtils } from '@learn/common_har';
import { YWConstants } from '@learn/constants_har';

@Builder
export function SafeAreaExample7Builder() {

  NavDestination() {
    NavDestinationModeDemo()
  }
  .hideTitleBar(true)

}


@Entry
@Component
struct NavDestinationModeDemo {
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()

  @Builder
  PagesMap(name: string) {
    if (name === 'DialogPage') {
      DialogPage()
    }
  }

  aboutToAppear(): void {
    // 设置虚拟键盘抬起时压缩页面大小为减去键盘的高度
    // YWAppUtils.getWindowStage().getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    // this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Row() { // 顶部自定义标题栏
          Text("标题不避让：SafeAreaType.KEYBOARD")
        }
        .height('12%')
        .width('100%')
        .backgroundColor(YWConstants.RandomColor())
        .expandSafeArea([SafeAreaType.KEYBOARD]) // 标题组件不避让键盘
        .zIndex(1)
        DialogPage().layoutWeight(1)
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PagesMap)
  }
}

@Component
export struct DialogPage {
  @Consume('NavPathStack') pageStack: NavPathStack;

  private chatList:Array<Chat> = new Array()

  aboutToAppear(): void {
    this.chatList = [{profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"123213213123"},
      {profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"bbbbbb 大家哦殴打巨大简欧大家记得京东数科JOJO"},
      {profile:$r('app.media.user_avatar'),nickname:"bbbb",content:"ccccccc 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
      {profile:$r('app.media.user_avatar'),nickname:"cccc",content:"ddddd 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
      {profile:$r('app.media.user_avatar'),nickname:"dddd",content:"44444444 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
      {profile:$r('app.media.user_avatar'),nickname:"eeee",content:"3333333 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
      {profile:$r('app.media.user_avatar'),nickname:"ffff",content:"123213213123"}]
  }

  build() {
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
        .height('75%')
        .width('100%')
        .padding(10)
      }
      .height('100%')
      .width('100%')
    }
    .backgroundColor('rgba(0,0,0,0.2)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
  }
}

interface Chat {
  profile: Resource,
  nickname: string,
  content: string,
}
