import fs from '@ohos.file.fs'; // 导入文件管理模块

export class FileConstants {

  static pathFile = ''

  static isExitFile(filePath:string){
    let isRes = fs.accessSync(filePath)
    if (isRes) {
      return true
    }
    return false

  }
}