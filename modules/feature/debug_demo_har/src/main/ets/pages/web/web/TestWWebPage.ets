import { ywDebugGlobal } from "../../../core/DebugGlobal"
import { webview } from "@kit.ArkWeb";


@Builder
export function TestWWebPageBuilder(url:string) {

  NavDestination(){
    TestWWebPage({url:url})
  }
  // .onBackPressed(()=>{
  //   ywDebugGlobal.getMainNav().pop(true)
  //   return true
  // })

}

@Entry
@Component
struct TestWWebPage {

  url:string = ""


  controller: WebviewController = new webview.WebviewController();

  aboutToAppear(): void {
    let kk = ""
  }


  build() {
    Column() {
      Web({ src: 'https://zhuanlan.zhihu.com/p/719287092', controller: this.controller })

    }.backgroundColor(Color.Yellow)
    .height('100%')
    .width('100%')
  }
}
