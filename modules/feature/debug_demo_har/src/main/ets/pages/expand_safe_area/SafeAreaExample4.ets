import { KeyboardAvoidMode } from '@kit.ArkUI';

@Builder
export function SafeAreaExample4Builder() {

  NavDestination() {
    MailPage()
  }
  .hideTitleBar(true)

}

@Entry
@Component
struct MailPage {

  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
  }

  aboutToDisappear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
  }

  build() {
    Column() {
      // 标题栏
      this.NavigationTitle()
      // 内容区域
      this.EmailContent()
      // 操作栏
      this.BottomToolbar()
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#f1f3f5')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  @Builder
  NavigationTitle() {
    Row() {
      Image($r('app.media.arrow_left'))
        .width(24)
        .height(24)
        .margin({ right: 16 })

      Text('新建电子邮件')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)

      Blank()

      Image($r('app.media.user_avatar'))
        .width(24)
        .height(24)

    }
    .width('100%')
    .height(56)
    .padding({
      left: 24,
      right: 24
    })
  }

  @Builder
  EmailContent() {
    Column() {
      this.RowInfo('发件人')
      this.RowInfo('收件人')
      this.RowInfo('主题')
      Row() {
        TextArea({ placeholder: '请输入邮件正文' })
          .height('100%')
          .backgroundColor('#f1f3f5')
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)
      .width('100%')
      .margin({ top: 12 })
    }.width('100%')
    .layoutWeight(1)
    .padding({ left: 24, right: 24 })
    .margin({ top: 8 })
  }

  @Builder
  RowInfo(param: string) {
    Row() {
      Text(`${param}`)
        .fontColor('#6f7780')
        .fontSize(16)
      TextInput({ placeholder: `请输入${param}` })
        .width('100%')
        .backgroundColor('#f1f3f5')
    }
    .width('100%')
    .height(48)
    .border({
      width: { top: 1 },
      color: '#e8ebed'
    })
  }

  @Builder
  BottomToolbar() {
    Row({ space: 24 }) {
      Image($r('app.media.user_avatar'))
        .ImageSize()
      Image($r('app.media.scan'))
        .ImageSize()
      Image($r('app.media.search_close'))
        .ImageSize()
      Image($r('app.media.address_company'))
        .ImageSize()
    }
    .width('100%')
    .height(56)
    .padding({ left: 24, right: 24 })
    .border({
      width: { top: 1 },
      color: '#E8EBED'
    })
  }

  @Styles
  ImageSize() {
    .height(24)
    .width(24)
  }
}
