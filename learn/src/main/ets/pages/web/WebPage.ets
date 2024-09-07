import web_webview from '@ohos.web.webview'

@Entry
@Component
struct WebPage {

  @State mode: WebDarkMode = WebDarkMode.On
  @State access: boolean = true


  controller: web_webview.WebviewController = new web_webview.WebviewController()

  testObj = new WebHandleObj();


  build() {
    Column() {
      Web({ src: 'https://www.baidu.com', controller: this.controller })

      // 隐私模式
      // Web({ src: 'www.example.com', controller: this.controller, incognitoMode: true })

      // 通过$rawfile加载本地资源文件。
      // Web({ src: $rawfile("testWeb.html"), controller: this.controller })
        // .javaScriptAccess(true)
        // .javaScriptProxy({
        //   object: this.testObj,
        //   name: "objName",
        //   methodList: ["test", "toString"],
        //   controller: this.controller,
        // })
        // .defaultFontSize(24)
        // .darkMode(this.mode)
        // .forceDarkAccess(this.access)


      // 通过resource协议加载本地资源文件。
      //Web({ src: "resource://rawfile/index.html", controller: this.controller })

    }
  }
}



//加载本地沙盒路径
// xxx.ets
// import web_webview from '@ohos.web.webview'
// import { Constants } from '../../common/Constants'
// import { GlobalContext } from '../../common/GlobalContext'
//
// let url = 'file://' + GlobalContext.getContext().getObject("filesDir") + '/testWeb.html'
//
// @Entry
// @Component
// struct WebComponent {
//   controller: web_webview.WebviewController = new web_webview.WebviewController()
//   build() {
//     Column() {
//       // 加载沙箱路径文件。
//       Web({ src: url, controller: this.controller })
//     }
//     .backgroundColor(Constants.RandomColor())
//   }
// }



class WebHandleObj {
  constructor() {
  }

  test(data1: string, data2: string, data3: string): string {
    console.log("data1:" + data1)
    console.log("data2:" + data2)
    console.log("data3:" + data3)
    return "AceString"
  }

  toString(): void {
    console.log('toString' + "interface instead.")
  }
}
