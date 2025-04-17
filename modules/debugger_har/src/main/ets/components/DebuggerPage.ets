import { AppConfig } from "@learn/app_config_har";
import {
  getAvoidPadding,
  getDefaultAvoidAreas,
  osRouter,
  OsRouterUrls,
  YWAvoidAreas
} from "@learn/common_har";
import { YWConstants } from "@learn/constants_har";
import { router } from "@kit.ArkUI";

@Entry({ routeName: OsRouterUrls.DEBUGGER_APP })
@Component
export struct DebuggerPage {
  @State message: string = 'Debugger 调试界面';
  @StorageProp(YWConstants.kStorageAreas) avoidAreas: YWAvoidAreas = getDefaultAvoidAreas()

  @Builder
  defaultBack() {
    Image($r('app.media.arrow_left'))
      .width(20)
      .height(20)
      .onClick(() => {
        router.back()
      })
  }

  build() {
    Stack() {
      Row() {
        this.defaultBack()
        Text("调试界面").layoutWeight(1).textAlign(TextAlign.Center)
      }
      .zIndex(2)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .backgroundColor(Color.White)
      .height(44)
      .width('100%')
      .padding({ left: 16, right: 16 })

      Column({ space: 20 }) {


        Text(this.message)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = 'Welcome';
          })
        Button("切换环境-dev")
          .type(ButtonType.Normal)
          .height(30)
          .onClick(() => {
            AppConfig.getInstance().init(getContext(this), 'app_config_dev.json')
            this.message = '测试环境dev';

          })
        Button("切换环境-prd")
          .type(ButtonType.Normal)
          .height(30)
          .onClick(() => {
            AppConfig.getInstance().init(getContext(this), 'app_config_prd.json')
            this.message = '测试环境prd';

          })
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .padding({ top: 55 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.White)
    // .expandSafeArea(
    //   [SafeAreaType.SYSTEM, SafeAreaType.CUTOUT, SafeAreaType.KEYBOARD],
    //   [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM, SafeAreaEdge.START, SafeAreaEdge.END]
    // )
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.TopStart)
    .padding(getAvoidPadding(this.avoidAreas))
  }
}
