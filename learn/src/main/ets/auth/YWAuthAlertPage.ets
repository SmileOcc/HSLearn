import { YWAuthPage } from "@learn/main_har";

@Entry
@Component
export struct YWAuthAlertPage {

  build() {
    Column(){
      YWAuthPage()
    }
    .width('100%')
    .height('100%')
  }
}
