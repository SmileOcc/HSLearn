import { pasteboard } from '@kit.BasicServicesKit';
import Emitter from '@ohos.events.emitter';
import Logger from '../common/KLogger';


export enum MYEmitterType{
  one,
  two,
  three
}

export class MyEmitterUtil {
  private static readonly LOG_TAG = 'MyEmitterUtil';

  private readonly eventId: number;

  constructor(type:MYEmitterType) {
    this.eventId = type
    Logger.debug(`事件ID: ${this.eventId}`);
  }

  // 定义业务状态标识常量
  static readonly UPDATE_LIST = "UPDATE_LIST";
  static readonly UPDATE_LIST_2 = "UPDATE_LIST_2";
  static readonly UPDATE_DETAIL = "UPDATE_DETAIL";

  /**
   * 在组件的`aboutToAppear`生命周期钩子中调用，监听父组件事件
   * @param callback 事件回调函数，接受一个`EmitterData`对象作为参数
   */
  onEmitter(callback: (eventData: EmitterData) => void) {
    Emitter.on({ eventId: this.eventId }, (event) => {
      if (callback) {
        callback(new EmitterData(event.data?.flag, event.data?.data));
      }
    });
  }

  /**
   * 在组件的`aboutToDisappear`生命周期钩子中调用，解除父组件事件监听
   */
  offEmitter() {
    Emitter.off(this.eventId);
  }

  // /**
  //  * 在组件的`aboutToAppear`生命周期钩子中调用，监听子组件事件
  //  * @param callback 事件回调函数，接受一个`EmitterData`对象作为参数
  //  */
  // onChild(callback: (eventData: EmitterData) => void) {
  //   Emitter.on({ eventId: this.eventId }, (event) => {
  //     if (callback) {
  //       callback(new EmitterData(event.data?.flag, event.data?.data));
  //     }
  //   });
  // }
  //
  // /**
  //  * 在组件的`aboutToDisappear`生命周期钩子中调用，解除子组件事件监听
  //  */
  // offChild() {
  //   Emitter.off(this.eventId);
  // }

  /**
   * 向父组件发送事件
   * @param flag 事件类型标识
   * @param data 事件携带的数据
   */
  static emitEvent(type:MYEmitterType, flag: string, data: string) {
    Emitter.emit(
      { eventId: type, priority: Emitter.EventPriority.IMMEDIATE },
      { data: { flag, data } }
    );
  }

  /**
   * 向子组件发送事件
   * @param flag 事件类型标识
   * @param data 事件携带的数据
   */
  // emitChild(flag: string, data: string) {
  //   Emitter.emit(
  //     { eventId: this.eventIdChild, priority: Emitter.EventPriority.IMMEDIATE },
  //     { data: { flag, data } }
  //   );
  // }
}

/**
 * 用于封装事件数据的类
 */
export class EmitterData {
  flag: string = "";
  data: string = "";

  constructor(flag: string, data: string) {
    this.flag = flag;
    this.data = data;
  }
}

/**
 * 获取剪贴板内容的辅助函数
 */
export async function getPasteboardContent(): Promise<void> {
  try {
    const systemPasteboard = pasteboard.getSystemPasteboard();
    const pasteData = await systemPasteboard.getData();
    const text = pasteData.getPrimaryText();
    console.info('剪贴板内容: ', text);
  } catch (e) {
    console.error('获取剪贴板内容失败: ', JSON.stringify(e));
  }
}
