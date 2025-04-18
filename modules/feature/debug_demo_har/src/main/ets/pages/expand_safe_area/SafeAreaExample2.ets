
@Builder
export function SafeAreaExample2Builder() {

  NavDestination() {
    SafeAreaExample2()
  }
  .hideTitleBar(true)

}

@Entry
@Component
struct SafeAreaExample2 {
  build() {
    Column() {
      Text("实现沉浸式效果:[SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]")
    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.testbg'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundColor(Color.Yellow)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
