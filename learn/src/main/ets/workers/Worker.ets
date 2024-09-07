import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { BusinessError, request, zlib } from '@kit.BasicServicesKit';
import KLogger from '../../../../../modules/common_har/src/main/ets/common/KLogger';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = (e: MessageEvents) => {
  let data:object = e.data;
  console.debug(`==== ${JSON.stringify(data)}`)
  console.debug('========== workerPort.onmessage')

  // 下载视频文件
  let context: common.UIAbilityContext = e.data.context;
  let filesDir: string = context.filesDir;
  let time: number = new Date().getTime();
  let inFilePath: string = `${filesDir}/${time.toString()}.zip`;

  if (e.data.isImageData) {//简单判断
    inFilePath = `${filesDir}/${time.toString()}.jpg`;
  }
  let mediaDataUrl: string = e.data.mediaData;
  let urlPart: string = mediaDataUrl.split('.')[1];
  let length: number = urlPart.split('/').length;
  let fileName: string = urlPart.split('/')[length-1];
  let options: zlib.Options = {
    level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION
  };
  request.downloadFile(context, {
    url: mediaDataUrl,
    filePath: inFilePath
  }).then((downloadTask) => {
    downloadTask.on('progress', (receivedSize: number, totalSize: number) => {
      KLogger.debug(`==== receivedSize:${receivedSize},totalSize:${totalSize}`);
    });
    downloadTask.on('complete', () => {
      if  (inFilePath.endsWith('.zip')) {
        // 下载完成之后执行解压操作
        zlib.decompressFile(inFilePath, filesDir, options, (errData: BusinessError) => {
          // zlib.decompressFile(inFilePath, videoPath, options, (errData: BusinessError) => {
          if (errData !== null) {

            // 异常处理
            KLogger.debug(`====decompressFile error`);
            KLogger.debug(`====decompressFile error:${JSON.stringify(errData)}`);
          }

          let videoPath: string = `${filesDir}/${fileName}/${fileName}.mp4`;
          if (e.data.isImageData) {
            videoPath = `${filesDir}/${fileName}/${fileName}.jpg`;
          }

          workerPort.postMessage({ 'isComplete': true, 'filePath': videoPath });
        })
      } else {
        workerPort.postMessage({ 'isComplete': true, 'filePath': inFilePath });
      }

    });
    downloadTask.on('fail', () => {

      KLogger.debug(`====downloadTask fail`);
      workerPort.postMessage({ 'isComplete': false, 'filePath': '' });

      // 异常处理
    });
  }).catch((err:BusinessError) => {

    KLogger.debug(`====catch`);
    KLogger.debug(`====catch ${JSON.stringify(err)}`);
    workerPort.postMessage({ 'isComplete': false, 'filePath': 'err' });

    // 异常处理
  });

}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {
  console.debug('========== workerPort.onmessageerror')

}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
}