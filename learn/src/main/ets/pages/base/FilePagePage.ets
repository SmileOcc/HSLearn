import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs'; // 导入文件管理模块
import { hsLog } from '@learn/logger_har';


@Entry
@Component
struct FilePagePage {
  @State message: string = 'Hello File';

  private context:common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  aboutToAppear(): void {
    let tempPath = 'file:/data/storage/el2/base/haps/entry/files/zhimg/zhimg.jpg'
    let tempPath2 = this.context.filesDir + "/zhimg/zhimg.jpg";

    hsLog.d(tempPath2)
    let isRes = fs.accessSync(tempPath2)
    if (isRes) {
      AlertDialog.show({message:'存在图片路径'})
    } else {
      AlertDialog.show({message:'不存在图片路径'})
    }

  }

  createDir() {
    let dirPath =this.context.filesDir + "/testDir";
    let isRes = fs.accessSync(dirPath)

    if (isRes) {
      this.message = 'file exists'
      hsLog.d('file exists')
      //删除
      //fs.rmdirSync(dirPath);
    } else {
      fs.mkdirSync(dirPath);//创建目录
      hsLog.d('file not exists')
      this.message = 'file not exists 创建目录'

    }
  }


  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Button('创建文件及判断')
          .onClick(()=>{
            this.createDir()
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}