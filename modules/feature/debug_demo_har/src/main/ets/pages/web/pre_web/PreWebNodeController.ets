import { BuilderNode, FrameNode, NodeController } from "@kit.ArkUI";
import { webview } from "@kit.ArkWeb";
import { picker } from "@kit.CoreFileKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { hiTraceMeter } from "@kit.PerformanceAnalysisKit";

const TAG = "PreWebNodeController"
// @Builder中为动态组件的具体组件内容
// Data为入参封装类
class Data {
  url: string = 'https://www.example.com';
  controller: WebviewController = new webview.WebviewController();
}


@Builder
function webBuilder(data: Data) {
  Column() {
    Web({ src: data.url, controller: data.controller })
      .domStorageAccess(true)
      .zoomAccess(true)
      .fileAccess(true)
      .mixedMode(MixedMode.All)
      .width('100%')
      .height('100%')
      .onPageBegin((event) => {
        if (event) {
          console.log(TAG + ' ' + 'url:' + event.url);
        }
      })
      .onPageEnd((event) => {
        // 输出Web页面加载完成时间
        console.info(TAG + ' ' + `load page end time: ${Date.now()}`);
        // 性能打点
        hiTraceMeter.finishTrace('getMessageData', 1);
      })
      .onProgressChange((event) => {
        if (event) {
          console.log(TAG + ' ' + 'newProgress:' + event.newProgress);
        }
      })
      .onTitleReceive((event) => {
        if (event) {
          console.log(TAG + ' ' + 'title:' + event.title);
        }
      })
      .onRefreshAccessedHistory((event) => {
        if (event) {
          console.log(TAG + ' ' + 'url:' + event.url + ' isReload:' + event.isRefreshed);
        }
      })
      .onConsole((event) => {
        if (event) {
          console.log(TAG + ' ' + 'getMessage:' + event.message.getMessage());
          console.log(TAG + ' ' + 'getSourceId:' + event.message.getSourceId());
          console.log(TAG + ' ' + 'getLineNumber:' + event.message.getLineNumber());
          console.log(TAG + ' ' + 'getMessageLevel:' + event.message.getMessageLevel());
        }
        return false;
      })
      .onHttpErrorReceive((event) => {
        if (event) {
          console.log(TAG + ' ' + 'url:' + event.request.getRequestUrl());
          console.log(TAG + ' ' + 'isMainFrame:' + event.request.isMainFrame());
          console.log(TAG + ' ' + 'isRedirect:' + event.request.isRedirect());
          console.log(TAG + ' ' + 'isRequestGesture:' + event.request.isRequestGesture());
          console.log(TAG + ' ' + 'getResponseData:' + event.response.getResponseData());
          console.log(TAG + ' ' + 'getResponseEncoding:' + event.response.getResponseEncoding());
          console.log(TAG + ' ' + 'getResponseMimeType:' + event.response.getResponseMimeType());
          console.log(TAG + ' ' + 'getResponseCode:' + event.response.getResponseCode());
          console.log(TAG + ' ' + 'getReasonMessage:' + event.response.getReasonMessage());
          let result = event.request.getRequestHeader();
          console.log(TAG + ' ' + 'The request header result size is ' + result.length);
          for (let i of result) {
            console.log(TAG + ' ' + 'The request header key is : ' + i.headerKey + ' , value is : ' + i.headerValue);
          }
          let resph = event.response.getResponseHeader();
          console.log(TAG + ' ' + 'The response header result size is ' + resph.length);
          for (let i of resph) {
            console.log(TAG + ' ' + 'The response header key is : ' + i.headerKey + ' , value is : ' + i.headerValue);
          }
        }
      })
      .onErrorReceive((event) => {
        if (event) {
          console.log(TAG + ' ' + 'getErrorInfo:' + event.error.getErrorInfo());
          console.log(TAG + ' ' + 'getErrorCode:' + event.error.getErrorCode());
          console.log(TAG + ' ' + 'url:' + event.request.getRequestUrl());
          console.log(TAG + ' ' + 'isMainFrame:' + event.request.isMainFrame());
          console.log(TAG + ' ' + 'isRedirect:' + event.request.isRedirect());
          console.log(TAG + ' ' + 'isRequestGesture:' + event.request.isRequestGesture());
          console.log(TAG + ' ' + 'getRequestHeader_headerKey:' + event.request.getRequestHeader().toString());
          let result = event.request.getRequestHeader();
          console.log(TAG + ' ' + 'The request header result size is ' + result.length);
          for (let i of result) {
            console.log(TAG + ' ' + 'The request header key is : ' + i.headerKey + ', value is : ' + i.headerValue);
          }
        }
      })
      .onSslErrorEventReceive((event) => {
        AlertDialog.show({
          title: 'onSslErrorEventReceive',
          message: 'text',
          primaryButton: {
            value: 'confirm',
            action: () => {
              event.handler.handleConfirm();
            }
          },
          secondaryButton: {
            value: 'cancel',
            action: () => {
              event.handler.handleCancel();
            }
          },
          cancel: () => {
            event.handler.handleCancel();
          }
        })
      })
      .onShowFileSelector((event) => {
        console.log(TAG + ' ' + 'MyFileUploader onShowFileSelector invoked')
        const documentSelectOptions = new picker.DocumentSelectOptions();
        let uri: string | null = null;
        const documentViewPicker = new picker.DocumentViewPicker();
        documentViewPicker.select(documentSelectOptions).then((documentSelectResult) => {
          uri = documentSelectResult[0];
          console.info(TAG + ' ' + 'documentViewPicker.select to file succeed and uri is:' + uri);
          if (event) {
            event.result.handleFileList([uri]);
          }
        }).catch((err: BusinessError) => {
          console.error(`Invoke documentViewPicker.select failed, code is ${err.code},  message is ${err.message}`);
        })
        return true;
      })
      .onRenderExited((event) => {

        // 应用渲染进程异常退出时触发该回调。
        // 多个Web组件可能共享单个渲染进程，每个受影响的Web组件都会触发该回调。
        if (event) {
          console.log(TAG + ' ' + 'reason:' + event.renderExitReason);
        }
      })
      .onRenderProcessNotResponding((data) => {
        // 渲染进程无响应时触发该回调函数。
        console.log(TAG + ' ' + "onRenderProcessNotResponding: [jsStack]= " + data.jsStack +
          ", [process]=" + data.pid + ", [reason]=" + data.reason);
      })
      .onRenderProcessResponding(() => {
        // 渲染进程由无响应状态变回正常运行状态时触发该回调函数,该回调表明该网页并非真正卡死。
        console.log(TAG + ' ' + "onRenderProcessResponding again");
      })
      // .onInterceptRequest((event) => {
    // 当Web组件加载url之前触发该回调，用于拦截url并返回响应数据。
    //   if (event) {
    //       console.log(TAG + ' ' + 'url:' + event.request.getRequestUrl());
      //   }
      //   let head1: Header = {
      //     headerKey: "Connection",
      //     headerValue: "keep-alive"
      //   }
      //   let head2: Header = {
      //     headerKey: "Cache-Control",
      //     headerValue: "no-cache"
      //   }
      //   // 将新元素追加到数组的末尾，并返回数组的新长度。
      //   let length = this.heads.push(head1);
      //   length = this.heads.push(head2);
      //   console.log(TAG + ' ' + 'The response header result length is :' + length);
      //   const promise: Promise<String> = new Promise((resolve: Function, reject: Function) => {
      //     this.responseWeb.setResponseHeader(this.heads);
      //     this.responseWeb.setResponseData(this.webData);
      //     this.responseWeb.setResponseEncoding('utf-8');
      //     this.responseWeb.setResponseMimeType('text/html');
      //     this.responseWeb.setResponseCode(200);
      //     this.responseWeb.setReasonMessage('OK');
      //     resolve("success");
      //   })
      //   promise.then(() => {
      //     console.log(TAG + ' ' + "prepare response ready");
      //     this.responseWeb.setResponseIsReady(true);
      //   })
      //   this.responseWeb.setResponseIsReady(false);
      //   return this.responseWeb;

      // })
  }
}

let preWebBuilder = wrapBuilder<Data[]>(webBuilder)



// 用于控制和反馈对应的NodeContainer上的节点的行为，需要与NodeContainer一起使用
export class PreWebNodeController extends NodeController {
  private rootnode: BuilderNode<Data[]> | null = null;
  private root: FrameNode | null = null;
  private rootWebviewController: webview.WebviewController | null = null;

  // 必须要重写的方法，用于构建节点数、返回节点挂载在对应NodeContainer中
  // 在对应NodeContainer创建的时候调用、或者通过rebuild方法调用刷新
  makeNode(uiContext: UIContext): FrameNode | null {
    console.info(TAG + ' ' + ' uicontext is undifined : ' + (uiContext === undefined));
    if (this.rootnode != null) {
      const parent = this.rootnode.getFrameNode()?.getParent();
      if (parent) {
        console.info(TAG + ' ' + JSON.stringify(parent.getInspectorInfo()));
        parent.removeChild(this.rootnode.getFrameNode());
        this.root = null;
      }
      this.root = new FrameNode(uiContext);
      this.root.appendChild(this.rootnode.getFrameNode());
      // 返回FrameNode节点
      return this.root;
    }
    // 返回null控制动态组件脱离绑定节点
    return null;
  }

  // 当布局大小发生变化时进行回调
  aboutToResize(size: Size) {
    console.info(TAG + ' ' + 'aboutToResize width : ' + size.width + ' height : ' + size.height);
  }

  // 当controller对应的NodeContainer在Appear的时候进行回调
  aboutToAppear() {
    console.info(TAG + ' ' + 'aboutToAppear');
  }

  // 当controller对应的NodeContainer在Disappear的时候进行回调
  aboutToDisappear() {
    console.info(TAG + ' ' + 'aboutToDisappear');
  }

  // 此函数为自定义函数，可作为初始化函数使用
  // 通过UIContext初始化BuilderNode，再通过BuilderNode中的build接口初始化@Builder中的内容
  initWeb(url: string, uiContext: UIContext, control: WebviewController) {
    if (this.rootnode != null) {
      return;
    }
    // 绑定预创建的WebviewController
    this.rootWebviewController = control;
    // 创建节点，需要uiContext
    this.rootnode = new BuilderNode(uiContext);
    // 创建动态Web组件
    this.rootnode.build(preWebBuilder, { url: url, controller: control });
  }

  // 此函数为自定义函数，可作为初始化函数使用
  loadUrl(url: string) {
    if (this.rootWebviewController !== null) {
      // 复用预创建组件，重新加载url
      this.rootWebviewController.loadUrl(url);
    }
  }
}
