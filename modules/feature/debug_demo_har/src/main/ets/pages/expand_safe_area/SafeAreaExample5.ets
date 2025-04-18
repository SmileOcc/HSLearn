@Builder
export function SafeAreaExample5Builder() {

  NavDestination() {
    ContactPage()
  }
  .hideTitleBar(true)

}

@Component
export struct ContactPage {
  build() {
    Column() {
      Row() { // 顶部自定义标题栏
        // ...
      }
      .height('12%')
      .backgroundColor(Color.Blue)
      .expandSafeArea([SafeAreaType.KEYBOARD]) // 标题组件不避让键盘
      .zIndex(1)

      List() { // 聊天消息区域
        // ...
      }
      .backgroundColor(Color.Green)
      .height('76%')

      Column(){ // 底部消息输入框
        // ...
      }
      .backgroundColor(Color.Pink)
      .height('12%')
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

  }
}