import worker, { MessageEvents } from '@ohos.worker';
import { common } from '@kit.AbilityKit';
import fileuri from '@ohos.file.fileuri';
import KLogger from '../../../../../../modules/common_har/src/main/ets/common/KLogger';
import { FileConstants } from '../../../../../../modules/common_har/src/main/ets/common/FileConstants';


@Entry
@Component
struct WorkerTestPage {
  @State message: string = 'Hello worker';
  isImageData: boolean = false
  mediaData: string | undefined
  //文件路径
  @State localImage: string | undefined = ''

  workerInstance = new worker.ThreadWorker('entry/ets/workers/Worker.ets');

  aboutToAppear(): void {

    let tempFile = 'file://com.example.hmos_learn/data/storage/el2/base/haps/entry/files/1718945609812.jpg'

    //file://com.example.hmos_learn/data/storage/el2/base/haps/entry/files/zhimg/zhimg.jpg
    //Image组件不能直接传入应用沙箱路径，需要传入应用沙箱uri
    this.localImage =  fileuri.getUriFromPath('/data/storage/el2/base/haps/entry/files/1718945609812.jpg')
    KLogger.debug(this.localImage)

    let isFile = FileConstants.isExitFile(this.localImage)

    KLogger.debug(`===是否存在：${isFile} === ${this.localImage}`)

    this.downImageFile()


  }

  aboutToDisappear(): void {
    if (this.workerInstance) {
      this.workerInstance.terminate()
    }

  }

  downImageFile(){
    //不每次创建了，在销毁页面时释放
    //this.workerInstance = new worker.ThreadWorker('entry/ets/workers/Worker.ets');

    // 接收Worker子线程的结果
    this.workerInstance.onmessage = (e: MessageEvents) => {
      // data：Worker线程发送的信息
      let data: object = e.data;
      console.debug(`==== ${JSON.stringify(data)}`)
      console.debug('==== MyWorker.ts onmessage');

      if (e.data) {
        let isComplete: boolean = e.data['isComplete'];
        //{"isComplete":true,"filePath":"/data/storage/el2/base/haps/entry/files/zhimg/zhimg.jpg"}

        let filePath:string = e.data.filePath ?? ''
        let isFile = FileConstants.isExitFile(filePath)

        this.localImage = fileuri.getUriFromPath(filePath)
        KLogger.debug(this.localImage)

        KLogger.debug(`===${isFile} === ${filePath} \n ${this.localImage}`)

        //每次移除，就要重新创建，在销毁地方释放吧
        //this.workerInstance.terminate();

        let isFile2 = FileConstants.isExitFile(this.localImage)

        KLogger.debug(`===${isFile} === ${isFile2}`)


      }
    }

    this.workerInstance.onmessageerror = (e: MessageEvents) => {
      // 接收Worker子线程的错误信息
      console.debug('==== MyWorker.ts onmessageerror');

    }

    // Worker线程销毁后，执行onexit回调方法
    this.workerInstance.onexit = () => {
      console.info("main thread terminate");
    }
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Image(this.localImage)
          .alt($r('app.media.placeholder'))
          .width(100)
          .height(100)
          .backgroundColor(Color.Green)

        Image('https://pic2.zhimg.com/v2-8b0c96b18f5342f6254eb06c9f6f0cf1_r.jpg')
          .width(100)
          .height(100)
          .backgroundColor(Color.Gray)

        Button('test worke1')
          .onClick(() => {

            // 向Worker子线程发送训练消息
           // workerInstance.postMessage({ 'type': 0 });
          })
        Button('test worke2')
          .onClick(() => {

            // 向Worker子线程发送预测消息
            //workerInstance.postMessage({ 'type': 1, 'value': [90, 5] });
          })

        Button('test worke 下载图片 ok')
          .onClick(() => {

            //每次重新创建
            //this.downImageFile()
            //Worker instance is not running, maybe worker is terminated when PostMessage
            this.isImageData = true
            this.mediaData = 'https://pic2.zhimg.com/v2-8b0c96b18f5342f6254eb06c9f6f0cf1_r.jpg'
            // 请求网络数据
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            // 参数中mediaData和isImageData是根据开发者自己的业务需求添加的，其中mediaData为数据路径、isImageData为判断图片或视频的标识
            this.workerInstance.postMessage({ context, mediaData: this.mediaData, isImageData: this.isImageData });

          })
      }
      .width('100%')
    }
    .height('100%')
  }
}