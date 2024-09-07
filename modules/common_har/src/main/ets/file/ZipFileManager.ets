import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';

async function write(data: string, file: fs.File): Promise<void> {
  fs.write(file.fd, data).then((writeLen: number) => {
    console.info('write data length is: ' + writeLen)
  }).catch((err:Error) => {
    console.error(`Failed to write data. Code is ${JSON.stringify(err)}, message is ${err.message}`);
  })
}

async function testFunc(): Promise<void> {
  let context = getContext() as common.UIAbilityContext;
  let filePath: string = context.filesDir + "/test.txt"; // 应用文件路径
  let file: fs.File = await fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  write('Hello World!', file).then(() => {
    console.info('Succeeded in writing data.');
  }).catch((err:Error) => {
    console.error(`Failed to write data. Code is ${JSON.stringify(err)}, message is ${err.message}`);
  })
  fs.close(file);
}