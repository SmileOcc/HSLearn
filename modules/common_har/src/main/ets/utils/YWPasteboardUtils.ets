import { pasteboard } from '@kit.BasicServicesKit';
import { YWStrUtils } from './YWStrUtils';

/**
 * 剪贴板工具类
 */
export class YWPasteboardUtils {

  private constructor() {}


  /**
   * 将纯文本数据写入系统剪贴板，使用Promise异步回调。
   * @param data
   * @returns
   */
  static setDataText(text: string): Promise<void> {
    let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    return YWPasteboardUtils.getSystemPasteboard().setData(pasteData);
  }


  /**
   * 将Htm数据写入系统剪贴板，使用Promise异步回调。
   * @param data
   * @returns
   */
  static setDataHtml(html: string): Promise<void> {
    let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_HTML, html);
    return YWPasteboardUtils.getSystemPasteboard().setData(pasteData);
  }


  /**
   * 将Uri数据写入系统剪贴板，使用Promise异步回调。
   * @param data
   * @returns
   */
  static setDataUri(uri: string): Promise<void> {
    let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_URI, uri);
    return YWPasteboardUtils.getSystemPasteboard().setData(pasteData);
  }


  /**
   * 读取系统剪贴板内容，使用Promise异步回调。
   * @returns
   */
  static getData(): Promise<pasteboard.PasteData> {
    return YWPasteboardUtils.getSystemPasteboard().getData()
  }


  /**
   * 读取系统剪贴板里的字符串，使用Promise异步回调。
   * @returns
   */
  static async getDataStr(): Promise<string> {
    let text = '';
    if (YWPasteboardUtils.hasDataSync()) {
      let data = await YWPasteboardUtils.getData()
      text = data.getPrimaryText();
      if (YWStrUtils.isEmpty(text)) {
        text = data.getPrimaryHtml();
      }
      if (YWStrUtils.isEmpty(text)) {
        text = data.getPrimaryUri();
      }
      if (YWStrUtils.isEmpty(text)) {
        text = '';
      }
    }
    return text
  }


  /**
   * 读取系统剪贴板里的字符串。
   * @returns
   */
  static getDataSyncStr(): string {
    let text = '';
    if (YWPasteboardUtils.hasDataSync()) {
      let data = YWPasteboardUtils.getSystemPasteboard().getDataSync()
      text = data.getPrimaryText();
      if (YWStrUtils.isEmpty(text)) {
        text = data.getPrimaryHtml();
      }
      if (YWStrUtils.isEmpty(text)) {
        text = data.getPrimaryUri();
      }
      if (YWStrUtils.isEmpty(text)) {
        text = '';
      }
    }
    return text
  }


  /**
   * 清空系统剪贴板内容，使用Promise异步回调。
   * @returns
   */
  static clearData(): Promise<void> {
    return YWPasteboardUtils.getSystemPasteboard().clearData()
  }


  /**
   * 判断系统剪贴板中是否有内容，使用Promise异步回调。
   * @returns
   */
  static hasData(): Promise<boolean> {
    return YWPasteboardUtils.getSystemPasteboard().hasData()
  }

  /**
   * 判断系统剪贴板中是否有内容。
   * @returns
   */
  static hasDataSync(): boolean {
    return YWPasteboardUtils.getSystemPasteboard().hasDataSync()
  }

  /**
   * 获取系统剪贴板对象
   * @returns
   */
  private static getSystemPasteboard(): pasteboard.SystemPasteboard {
    let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
    return systemPasteboard;
  }
}