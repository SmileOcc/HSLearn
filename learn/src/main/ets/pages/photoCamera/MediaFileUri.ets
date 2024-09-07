import { fileIo } from '@kit.CoreFileKit';
// import console from '../common/console';
import { bufferToString } from '../../../../../../modules/common_har/src/main/ets/common/Common';

const TAG = 'MediaFileUri';
const BUFFER_SIZE = 4096;
const COMMON_FD = -1;
const MODE_READ_ONLY = 0;
const MODE_WRITE_ONLY = 1;
const MODE_READ_WRITE = 2;

export default class MediaFileUri {
  content: string = '';
  private commonFd: number = COMMON_FD;
  private fileSizeList: Array<number> = [];
  private fileNameList: Array<string> = [];
  private fileUriList: Array<string> = [];

  constructor() {

  }

  getMode(openFlag: number): number {
    let mode: number = 0;
    switch (openFlag) {
      case MODE_READ_ONLY:
        mode = fileIo.OpenMode.READ_ONLY; // r
        break;
      case MODE_WRITE_ONLY:
        mode = fileIo.OpenMode.WRITE_ONLY; // w
        break;
      case MODE_READ_WRITE:
        mode = fileIo.OpenMode.READ_WRITE; // rw
        break;
    }
    return mode;
  }

  myWriteSync(fd: number, content: string, isClose: boolean): void {
    try {
      let result = fileIo.writeSync(fd, content);
      console.info(TAG, 'myWriteSync: write result = ' + result);
    } catch (err) {
      console.error(TAG, 'myWriteSync： write failed with error:' + err);
    }
    if (isClose) {
      this.closeSync(fd);
      this.commonFd = COMMON_FD;
    } else {
      this.commonFd = fd;
    }
  }

  // sync-close
  closeSync(fd: number): void {
    try {
      fileIo.closeSync(fd);
      console.info(TAG, 'closeSync file finish.');
    } catch (err) {
      console.error(TAG, 'closeSync file error = ' + err);
    }
  }

  readFileContent(uri: string, isRead: boolean = true, isClose: boolean = true): string {
    let content = '';
    console.info(TAG, 'open path = ' + uri);
    let file: fileIo.File;
    if (isClose || this.commonFd === COMMON_FD) {
      try {
        file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
        console.info(TAG, 'openReadSync: get fd success. fd = ' + file.fd);
        this.commonFd = file.fd;
      } catch (err) {
        console.error(TAG, 'openReadSync: open file failed. error = ' + err);
        return content;
      }
      if (file === undefined) {
        console.error(TAG, 'openReadSync: open file failed. file = undefined.');
        return content;
      }
    }
    if (isRead) {
      try {
        let buffer = new ArrayBuffer(BUFFER_SIZE);
        let readOut = fileIo.readSync(this.commonFd, buffer, {
          offset: 0
        });
        content = bufferToString(buffer);
      } catch (err) {
        console.error(TAG, 'myReadSync: read error: ' + err);
        return content;
      }

      if (isClose) {
        this.closeSync(this.commonFd);
        this.commonFd = COMMON_FD;
      } else {
        this.commonFd = this.commonFd;
      }
    }
    return content;
  }

  myGetFileSize(uri: string, mode: number): number {
    let file = fileIo.openSync(uri, mode); // fs.OpenMode.READ_ONLY
    console.info(TAG, 'file fd: ' + file.fd);
    let stat = fileIo.statSync(file.fd);
    console.info(TAG, 'get file info succeed, the size of file is ' + stat.size);
    return stat.size;
  }

  writeFileContent(uri: string, content: string): void {
    console.info(TAG, 'writeFileContent begin');
    let file = fileIo.openSync(uri, fileIo.OpenMode.READ_WRITE);
    console.info(TAG, 'writeFileContent file fd: ' + file.fd);
    let writeLen = fileIo.writeSync(file.fd, content);
    console.info(TAG, 'writeFileContent write data to file succeed and size is:' + writeLen);
    fileIo.closeSync(file);
  }

  async getAllFiles(context:Context): Promise<void> {
    console.info(TAG, 'getAllFiles begin');
    AppStorage.setOrCreate('fileNameList', this.fileNameList);
    AppStorage.setOrCreate('fileSizeList', this.fileSizeList);
    AppStorage.setOrCreate('fileUriList', this.fileUriList);
  }
}