import { zlib, BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { buffer } from '@kit.ArkTS';

@Builder
export function TestZipFileBuilder() {

  NavDestination() {
    ZipTestPage()
  }
  .hideTitleBar(true)

}

@Entry
@Component
struct ZipTestPage {

  private TAG: string = "ZipTestPage";
  @State mZipTestContent: string = "";

  // 指定的待解压缩文件的文件路径，文件后缀需要以.zip结尾。文件路径必须为沙箱路径，沙箱路径可以通过context获取
  private inFile = '/xx/xxx.zip';
  // 指定的解压后的文件夹路径，文件夹目录路径需要在系统中存在，不存在则会解压失败。
  // 路径必须为沙箱路径，沙箱路径可以通过context获取
  // 如果待解压的文件或文件夹在解压后的路径下已经存在，则会直接覆盖同名文件或同名文件夹中的同名文件。多个线程同时解压文件时，outFile不能相同。
  private outFileDir = '/xxx';
  // 解压的配置参数。
  private options: zlib.Options = {
    // 压缩率 默认压缩等级。
    level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION
  };

  aboutToAppear(): void {
    // 准备zip到沙箱路径下
    this.copyRawFileToLocal();
    // 填充待解压文件路径和解压后的文件路径
    this.setting();
  }

  private setting(){
    let pathDir: string = getContext().filesDir;
    console.info(this.TAG, "setting pathDir: " + pathDir);

    this.inFile = pathDir + '/testA.zip';
    console.info(this.TAG, "setting inFile: " + this.inFile);

    this.outFileDir =  pathDir;
    console.info(this.TAG, "setting outFileDir: " + this.outFileDir);
  }

  /**
   * 点击解压
   */
  onUnZip = async ()=>{
    try {
      console.info(this.TAG, "onUnZip start");
      // 解压文件，解压的结果回调
      zlib.decompressFile(this.inFile, this.outFileDir, this.options, (errData: BusinessError) => {
        if (errData !== null) {
          console.error(this.TAG, `errData is errCode:${errData.code}  message:${errData.message}`);
        }
        console.info(this.TAG, "onUnZip done");
        // 解压成功后，则去输出的路径下outFileDir，读取文件
        let destFilePath = this.outFileDir + "/testA" + "/text.txt"
        let fileTarget = fs.openSync(destFilePath,  fs.OpenMode.READ_ONLY);
        let size = fs.statSync(fileTarget.fd).size;
        console.info(this.TAG, "onUnZip size: " + size);
        let bufferRes = new ArrayBuffer(size);
        let readLen = fs.readSync(fileTarget.fd, bufferRes);
        fs.closeSync(fileTarget);
        console.info(this.TAG, "onUnZip readLen: " + readLen);

        let decoder = util.TextDecoder.create('utf-8');
        let temp = new Uint8Array(bufferRes);
        let result = decoder.decodeToString(temp);
        console.info(this.TAG, "onUnZip text: " + result);
        this.mZipTestContent = result;

        // let pathDir: string = getContext().filesDir;
        // let filePath = pathDir + "/test.txt";
        // let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
        // let arrayBuffer = new ArrayBuffer(4096);
        // fs.read(file.fd, arrayBuffer, (err: BusinessError, readLen: number) => {
        //   if (err) {
        //     console.error(this.TAG,"read failed with error message: " + err.message + ", error code: " + err.code);
        //   } else {
        //     console.info(this.TAG, "read file data succeed");
        //     let buf = buffer.from(arrayBuffer, 0, readLen);
        //     console.info(this.TAG, `The content of file: ${buf.toString()}`);
        //   }
        //   fs.closeSync(file);
        // });
      })
    } catch (errData) {
      let code = (errData as BusinessError).code;
      let message = (errData as BusinessError).message;
      console.error(this.TAG, `errData is errCode:${code}  message:${message}`);
    }
  }

  private copyRawFileToLocal() {
    let context = getContext(this) as common.UIAbilityContext; // 获取设备A的UIAbilityContext信息
    try {
      let val: Uint8Array = context.resourceManager.getRawFileContentSync("testA.zip");
      console.info(this.TAG, "getRawFileContentSync done");
      let pathDir: string = context.filesDir; // /data/storage/el2/base/haps/entry/files
      console.info(this.TAG, "pathDir: " + pathDir);
      // 待拷贝文件沙箱路径
      let filePath: string = pathDir + '/testA.zip';
      console.info(this.TAG, "filePath: " + filePath);
      // 若文件不存在，则创建文件。
      let fileTarget = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      console.info(this.TAG, "file done");
      let writeLen = fs.writeSync(fileTarget.fd, val.buffer as ArrayBuffer);
      console.info(this.TAG, "write data to file succeed and size is:" + writeLen);
      fs.closeSync(fileTarget);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      console.error(this.TAG,`getRawFileContentSync failed, error code: ${code}, message: ${message}.`);
    }
  }

  build() {
    RelativeContainer() {
      Text("点击解压，先copy到沙盒，在解压内容： " + this.mZipTestContent)
        .id('ZipTestPageHelloWorld')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(this.onUnZip)
    }
    .height('100%')
    .width('100%')
  }
}
