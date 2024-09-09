
@Component
export struct LaunchLoadingView {

  build() {
    Column(){
      Text("启动中...")
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}