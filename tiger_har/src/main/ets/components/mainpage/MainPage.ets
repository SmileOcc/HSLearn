import { OsRouterUrls } from '@learn/common_har/Index';

@Entry({routeName:OsRouterUrls.TIGER_APP})
@Component
export struct MainPage {
  @State message: string = 'Hello Tiger';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}
