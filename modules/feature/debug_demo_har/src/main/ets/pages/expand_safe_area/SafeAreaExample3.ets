@Builder
export function SafeAreaExample3Builder() {

  NavDestination() {
    FaqListPage()
  }
  .hideTitleBar(true)

}


@Entry
@Component
struct FaqListPage {
  listData: string[] = ['问题1', '问题2', '问题3', '问题4', '问题5', '问题6', '问题7', '问题8', '问题9'];

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('常见问题')
          .fontSize(22)
      }
      .height(100)

      List({ space: 10 }) {
        ForEach(this.listData, (item: string) => {
          ListItem() {
            Column({ space: 10 }) {
              Text(item)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
              Text(item + '内容')
                .fontSize(16)
                .fontColor('#999999')
            }
            .alignItems(HorizontalAlign.Start)
            .padding(15)
            .width('100%')
            .height(150)
            .borderRadius(10)
            .backgroundColor(Color.White)
          }
        }, (item: string) => item)
        ListItem() {
          Text('已加载全部')
            .width('100%')
            .textAlign(TextAlign.Center)
            .opacity(0.6)
            .padding(10)
        }
      }
      .padding(10)
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .backgroundImage($r('app.media.testbg'))
    .backgroundImageSize(ImageSize.Cover)
    .height('100%')
    .width('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
