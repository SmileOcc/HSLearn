/*
 * @Desc: 网络数据的回调
 */
import { NetMagicResp } from './NetMagicResp';

export class NetCallback<T> {
  /**
   * 成功的回调
   * @param data 回到泛型数据
   */
  onSuccess?: (data: T, magic?: NetMagicResp<T>) => void;
  /**
   * 失败的回到
   * @param code   错误码
   * @param message 错误内容
   */
  onFail?: (code: number, message: string) => void;
  /**
   * 成功或者失败最后都会执行，适合关闭流、loading等
   */
  onFinally?: () => void;
}
