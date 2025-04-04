import { webview } from "@kit.ArkWeb";
import { getPreWeb } from "./PreWebNodeManager";
import { hiTraceMeter } from "@kit.PerformanceAnalysisKit";


@Builder
export function TestPreWebPageBuilder(url: string) {

  NavDestination() {
    TestPreWebPage({ url: url })
  }

  // .onBackPressed(()=>{
  //   ywDebugGlobal.getMainNav().pop(true)
  //   return true
  // })

}

@Entry
@Component
struct TestPreWebPage {
  url: string = ""
  controller: WebviewController = new webview.WebviewController();

  aboutToAppear(): void {
    // 输出Web页面开始加载时间
    console.info(`load page start time: ${Date.now()}  url:${this.url}`);

    // 性能打点
    hiTraceMeter.startTrace('getMessageData', 1);
  }

  build() {
    Stack() {
      Row() {
        Column() {
          // url请替换为真实地址
          NodeContainer(getPreWeb(this.url))
            .height('100%')
            .width('100%')
        }
        .width('100%')
      }
      .height('100%')

      Text("aaaaa" + this.url)
    }.backgroundColor(Color.Red)
  }
}
