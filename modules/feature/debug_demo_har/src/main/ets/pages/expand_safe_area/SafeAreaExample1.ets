
@Builder
export function SafeAreaExample1Builder() {

  NavDestination() {
    SafeAreaExample1()
  }
  .hideTitleBar(true)

}

@Entry
@Component
struct SafeAreaExample1 {
  build() {
    Column() {
      // ......
    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.testbg'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundColor(Color.Yellow)
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
